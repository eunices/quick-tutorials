setwd("2021-04-01-flower-class")

library(tidyverse)
library(keras)
library(tensorflow)
library(reticulate)


# Prep
label_list <- dir("data/")
output_n <- length(label_list)
save(label_list, file="label_list.RData")

# Parameters
width <- 224
height<- 224
target_size <- c(width, height)
rgb <- 3 # color channels

# Training
path_train <- "train/"

train_data_gen <- image_data_generator(
    rescale = 1/255, validation_split = .2
)

train_images <- flow_images_from_directory(
  path_train,
  train_data_gen,
  subset='training',
  target_size=target_size,
  class_mode='categorical',
  shuffle=F,
  classes=label_list,
  seed = 2021
)

validation_images <- flow_images_from_directory(
  path_train,
  train_data_gen, 
  subset = 'validation',
  target_size = target_size,
  class_mode = "categorical",
  classes = label_list,
  seed = 2021
)

# Check
table(train_images$classes)
plot(as.raster(train_images[[1]][[1]][17,,,]))

# Load base model
mod_base <- application_xception(
  weights = 'imagenet', 
  include_top = FALSE, input_shape = c(width, height, 3)
)

freeze_weights(mod_base) 


model_function <- function(
  learning_rate = 0.001, dropoutrate=0.2, n_dense=1024
){
  
  k_clear_session()
  
  model <- keras_model_sequential() %>%
    mod_base %>% 
    layer_global_average_pooling_2d() %>% 
    layer_dense(units = n_dense) %>%
    layer_activation("relu") %>%
    layer_dropout(dropoutrate) %>%
    layer_dense(units=output_n, activation="softmax")
  
  model %>% compile(
    loss = "categorical_crossentropy",
    optimizer = optimizer_adam(lr = learning_rate),
    metrics = "accuracy"
  )
  
  return(model)
  
}

model <- model_function()
model


batch_size <- 32
epochs <- 6

hist <- model %>% fit_generator(
  train_images,
  steps_per_epoch = train_images$n %/% batch_size, 
  epochs = epochs, 
  validation_data = validation_images,
  validation_steps = validation_images$n %/% batch_size,
  verbose = 2
)


# Testing the model
test_image <- image_load(
  "test/46/image_01122.jpg",
  target_size = target_size
)

x <- image_to_array(test_image)
x <- array_reshape(x, c(1, dim(x)))
x <- x/255
pred <- model %>% predict(x)
pred <- data.frame("Flower" = label_list, "Probability" = t(pred))
pred <- pred[order(pred$Probability, decreasing=T),][1:5,]
pred$Probability <- paste(format(100*pred$Probability,2),"%")
pred

# Calculating accuracy 
path_test <- "test/"

test_data_gen <- image_data_generator(rescale = 1/255)

test_images <- flow_images_from_directory(
  path_test,
  test_data_gen,
  target_size = target_size,
  class_mode = "categorical",
  classes = label_list,
  shuffle = F,
  seed = 2021
)

model %>% evaluate_generator(
  test_images, 
  steps = test_images$n
)

predictions <- model %>% 
  predict_generator(
    generator = test_images,
    steps = test_images$n
  ) %>% as.data.frame

names(predictions) <- names <- paste0("Class",0:(length(names(predictions))-1))

predictions$predicted_class <- 
  paste0("Class",apply(predictions,1,which.max)-1)

predictions$true_class <- paste0("Class",test_images$classes)

predictions %>% group_by(true_class) %>% 
  summarise(percentage_true = 100*sum(predicted_class == true_class)/n()) %>% 
  left_join(data.frame(
      plant= names(test_images$class_indices), 
      true_class=names
    ),by="true_class"
  ) %>%
  select(plant, percentage_true) %>% 
  mutate(plant = fct_reorder(plant,percentage_true)) %>%
  ggplot(aes(x=plant,y=percentage_true,fill=percentage_true, 
    label=percentage_true)) +
  geom_col() + theme_minimal() + coord_flip() +
  geom_text(nudge_y = 3) + 
  ggtitle("Percentage correct classifications by plant species")

# Model tuning
tune_grid <- data.frame("learning_rate" = c(0.001,0.0001),
                        "dropoutrate" = c(0.3,0.2),
                        "n_dense" = c(1024,256))

tuning_results <- NULL
set.seed(2021)

for (i in 1:length(tune_grid$learning_rate)){
  for (j in 1:length(tune_grid$dropoutrate)){
      for (k in 1:length(tune_grid$n_dense)){
        
        model <- model_function(
          learning_rate = tune_grid$learning_rate[i],
          dropoutrate = tune_grid$dropoutrate[j],
          n_dense = tune_grid$n_dense[k])
        
        hist <- model %>% fit_generator(
          train_images,
          steps_per_epoch = train_images$n %/% batch_size, 
          epochs = epochs, 
          validation_data = validation_images,
          validation_steps = validation_images$n %/% 
            batch_size,
          verbose = 2
        )
        
        #Save model configurations
        tuning_results <- rbind(
          tuning_results,
          c("learning_rate" = tune_grid$learning_rate[i],
            "dropoutrate" = tune_grid$dropoutrate[j],
            "n_dense" = tune_grid$n_dense[k],
            "val_accuracy" = hist$metrics$val_accuracy))
        
    }
  }
}

tuning_results


# Best results
best_results <- tuning_results[which( 
  tuning_results[,ncol(tuning_results)] == 
  max(tuning_results[,ncol(tuning_results)])),]


# Training best model again to save
model <- model_function(learning_rate = 
  best_results["learning_rate"],
  dropoutrate = best_results["dropoutrate"],
  n_dense = best_results["n_dense"])

hist <- model %>% fit_generator(
  train_images,
  steps_per_epoch = train_images$n %/% batch_size, 
  epochs = epochs, 
  validation_data = validation_images,
  validation_steps = validation_images$n %/% batch_size,
  verbose = 2
)

# If you’re still not satisfied with the performance, you can try 
# unfreezing the pre-trained weights from the xception model and 
# fine-tune the whole model using a very low learning rate (i.e. 
# don’t drastically change the parameters that worked well so far) 
# and a small number of epochs (since this part is both slow and 
# prone to over-fitting). The first line in the following code chunk 
# unfreezes the pre-trained weights and the rest should look familiar by now.


mod_base$trainable <- T

model %>% compile(
  loss = "categorical_crossentropy",
  optimizer = optimizer_adam(lr = 1e-5),
  metrics = "accuracy")

hist <- model %>% fit_generator(
  train_images,
  steps_per_epoch = train_images$n %/% batch_size, 
  epochs = 5, 
  validation_data = validation_images,
  validation_steps = validation_images$n %/% batch_size,
  verbose = 2
)

model %>% save_model_tf("plant_mod")
