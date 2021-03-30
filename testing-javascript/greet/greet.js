function greet(name) { 
    if(!name) name = "my friend"
    return(`Hello, ${name}.`)
}

module.exports = greet;
