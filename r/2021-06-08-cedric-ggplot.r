# https://www.cedricscherer.com/2019/08/05/a-ggplot2-tutorial-for-beautiful-plotting-in-r/#themes

library(data.table)
chic <- fread("https://raw.githubusercontent.com/Z3tt/R-Tutorials/master/ggplot2/chicago-nmmaps.csv")

head(chic, 4)

library(ggplot2)

# Base
chic$temp_thres <- ifelse(chic$temp>37, "High", "Low")
g <- ggplot(chic, aes(x = date, y = temp))

# Plot types
g + geom_point()
g + geom_line()
g + geom_point() + geom_line()

g + geom_point(color = "firebrick", shape = "diamond", size = 2) +
  geom_line(color = "firebrick", linetype = "dotted", size = .3)

# Themes
# https://www.cedricscherer.com/2019/08/05/a-ggplot2-tutorial-for-beautiful-plotting-in-r/#themes
theme_set(theme_bw())

g + geom_point(color = "firebrick", shape = "diamond", size = 2) 

# Axes titles
f <- g + geom_point(color = "firebrick") + 
  labs(x = "Year", y = "Temperature (°F)")

exp <- expression(paste("Temperature (", degree ~ F, ")"^"(Hey, why should we use metric units?!)"))
g + geom_point(color = "firebrick") +
  labs(x = "Year", y = exp)

h <- f + 
  theme(axis.title = element_text(size = 15, color = "firebrick", face = "bold.italic"),
        axis.title.x = element_text(margin = margin(t = 10), size = 15),
        axis.title.y = element_text(margin = margin(r = 10), size = 15))

# Axes text
h + 
  theme(axis.text = element_text(color = "maroon", size = 10), 
        axis.text.x = element_text(face = "bold", angle = 90, size = 10))

h + theme(axis.ticks.x = element_blank(), axis.ticks.y = element_blank())

# Axes limits
h + scale_y_continuous(limits = c(0, 50)) # removes values outside range
h + coord_cartesian(ylim = c(0, 50))      # does not remove values outside range

ggplot(chic[temp > 25 & o3 > 20], aes(x = temp, y = o3)) +
  geom_point(color = "darkcyan") +
  expand_limits(x = 0, y = 0) +
  scale_x_continuous(expand = c(0, 0)) +   # really start at 0,0
  scale_y_continuous(expand = c(0, 0)) +   # really start at 0,0
  coord_cartesian(clip = "off")      # draw outside panel

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = NULL) +
  scale_y_continuous(label = function(x) {return(paste(x, "°F"))})

# Axes fixed
ggplot(chic, aes(x = temp, y = temp + rnorm(nrow(chic), sd = 20))) +
  geom_point(color = "sienna") +
  labs(x = "Temperature (°F)", y = "Temperature (°F) + random noise") +
  xlim(c(0, 100)) + ylim(c(0, 150)) +
  coord_fixed(ratio = 1/5)

# Titles
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = NULL,
       title = "Temperatures in Chicago",
       caption = "Data: NMMAPS") +
  theme(plot.title = element_text(hjust = 1, size = 16, face = "bold.italic"))

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  ggtitle("Temperatures in Chicago\nfrom 1997 to 2001") +
  theme(plot.title = element_text(lineheight = .8, size = 16)) # title spacing


# Legend position
ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(legend.position = "top")

ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)",
       color = NULL) +
  theme(legend.position = c(.15, .15),
        legend.background = element_rect(fill = "transparent"))

# Legend direction
ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(legend.position = c(.5, .97),
        legend.background = element_rect(fill = "transparent")) +
  guides(color = guide_legend(direction = "horizontal"))

library(showtext)
font_add_google("Playfair Display", ## name of Google font
                "Playfair")         ## name that will be used in R
font_add_google("Bangers", "Bangers")

font_add_google("Roboto Condensed", "Roboto Condensed")
theme_set(theme_bw(base_size = 12, base_family = "Roboto Condensed"))

# Legend style
ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(legend.key = element_rect(fill = "darkgoldenrod1"), # change legend bg
        legend.title = element_text(family = "Playfair",
                                    color = "chocolate",
                                    size = 14, face = "bold"))

# Legend direction
ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(legend.position = c(.5, .97),
        legend.background = element_rect(fill = "transparent"),
        legend.title = element_blank()) + # removes title
  guides(color = guide_legend(direction = "horizontal"))


# Legend labels
ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(legend.key = element_rect(fill = "darkgoldenrod1"),
        legend.title = element_text(family = "Playfair",
                                    color = "chocolate",
                                    size = 14, face = 2)) +
  scale_color_discrete(name = "Seasons:")

# Legend symbol size
ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  scale_color_discrete(name = "Seasons") +
  guides(color = guide_legend(override.aes = list(size = 6))) # very useful

# Turn off particular geoms in legend
ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  geom_rug(show.legend = FALSE)

# Modify line/point colours
ggplot(chic, aes(x = date, y = o3)) +
  geom_line(aes(color = "line")) +
  geom_point(aes(color = "points")) +
  labs(x = "Year", y = "Ozone") +
  scale_color_manual(name = NULL,
                     guide = "legend",
                     values = c("points" = "darkorange2",
                                "line" = "gray")) +
  guides(color = guide_legend(override.aes = list(linetype = c(1, 0),
                                                  shape = c(NA, 16))))
# but why do this?

# Legend styles
ggplot(chic, aes(x = date, y = temp, color = temp)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)", color = "Temperature (°F)") +
  guides(color = guide_legend()) # discrete

ggplot(chic, aes(x = date, y = temp, color = temp)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)", color = "Temperature (°F)") +
  guides(color = guide_bins()) # binned

ggplot(chic, aes(x = date, y = temp, color = temp)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)", color = "Temperature (°F)") +
  guides(color = guide_colorsteps()) # steps

# Plot background color
ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "#1D8565", size = 2) +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(
    panel.background = element_rect(                  # bg colour
      fill = "#64D2AA", color = "#64D2AA", size = 2
    ), 
    # panel.background = element_rect(fill = NA),    
    panel.border = element_rect(                      # above panel.background
      color = "#64D2AA", size = 2
    ),
    panel.grid.major = element_line(color = "gray10", size = .5), # major grid
    panel.grid.minor = element_line(color = "gray40", size = .25), # minor grid 
    # panel.grid.minor = element_blank() # or remove
    plot.background = element_rect(fill = "gray90", color = "gray10", size = 1),

  )


# Custom theme


# greyscale
theme_es_grey <- function (
  base_size = 11, base_family = "sans", legend.direction="horizontal"
) {

  theme(
    text = element_text(family = base_family),
    plot.title = element_text(
      hjust=.5, lineheight = .8, size = base_size+1, face = "bold"
    ),
    plot.subtitle = element_text(
      hjust=.5, lineheight = .8, size = base_size, margin = margin(t=5)
    ),
    panel.background = element_rect(fill = "white", color = NA), 
    panel.border = element_rect(fill = NA, color = NA),
    panel.grid.major = element_line(color = "gray90", size = .5),  # major grid
    panel.grid.minor = element_line(color = "gray95", size = .2),  # minor grid 
    axis.title = element_text(size = base_size, face="bold"),
    axis.title.y = element_text(margin=margin(r = 15), hjust=.5, angle = 90),
    axis.title.x = element_text(margin=margin(t = 15), hjust=.5),
    axis.ticks = element_blank(),
    axis.text = element_text(size = base_size-2, color="gray50"),
    axis.text.x = element_text(angle = 90, margin = margin(t=1), hjust=0.95),
    axis.text.y = element_text(angle = 0),
    legend.title = element_text(size=base_size-2),
    legend.text = element_text(size=base_size-2),
    legend.position = c(1, 0.98), 
    legend.direction = legend.direction,
    legend.justification = "right",
    legend.background = element_rect(fill = "grey98", color = NA),
    legend.box.background = element_blank(),
    legend.key = element_rect(fill = NA, color = NA),
    legend.margin = margin(t=2, b=2, l=6, r=6),
    plot.caption = element_text(
      hjust=-.1, vjust=1, size=base_size-2, margin = margin(t=15)
    )
  ) 
}

# https://ggplot2.tidyverse.org/reference/theme.html

theme_set(theme_es_grey())


t <- g + geom_point(aes(color=temp_thres)) + 
  labs(
    title="Test this is a title",  subtitle="Test subtitle\nhello!",
    x="Year", y="Temperature",
    caption="Source: This is a caption of the image. Please credit so and so."
  ) + scale_color_discrete(name = "Type"); t

t <- g + geom_point(aes(color=temp_thres)) + 
  labs(
    x="Year", y="Temperature",
    caption="Source: This is a caption of the image. Please credit so and so."
  ) + scale_color_discrete(name = "Type"); t

t + theme_minimal()

ggsave('r/test.png', plot=t, width=15.45, height=NA, dpi=300, units="cm") # a4 normal



