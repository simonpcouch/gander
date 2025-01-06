# construct_turn_impl formats message with file extension

    Code
      cat(result)
    Output
      Up to this point, the contents of my R file reads: 
      
      mtcars
      
      plot it.

# construct_turn_impl formats input with punctuation

    Code
      cat(result)
    Output
      Up to this point, the contents of my R file reads: 
      
      mtcars
      
      plot it.

# construct_turn_impl includes selection when present

    Code
      cat(result)
    Output
      Up to this point, the contents of my R file reads: 
      
      x <- 1
      
      plot this: 
      
      mtcars

# construct_turn_impl includes after context when present

    Code
      cat(result)
    Output
      Up to this point, the contents of my R file reads: 
      
      x <- 1
      
      plot this.
      
      For context, the rest of the file reads: 
      
      z <- 3

# construct_turn_impl includes env context when present

    Code
      cat(result)
    Output
      Up to this point, the contents of my R file reads: 
      
      mtcars
      
      plot this.
      
      Here's some information about the objects in my R environment: 
      
      obj details

