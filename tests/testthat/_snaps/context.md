# fetch_env_context works

    Code
      fetch_env_context(
        "a\nbop <- 1",
        "do something",
        env)
    Output
       [1] "```"                                 
       [2] "bop"                                 
       [3] "#>  num 2"                           
       [4] ""                                    
       [5] "# Just the first 1 row and 1 column:"
       [6] "a"                                   
       [7] "#> 'data.frame':"                    
       [8] "#>  $ boop: num 1"                   
       [9] ""                                    
      [10] "```"                                 

---

    Code
      fetch_env_context(
        "bop <- 1",
        "do something",
        env)
    Output
      [1] "```"      
      [2] "bop"      
      [3] "#>  num 2"
      [4] ""         
      [5] "```"      

---

    Code
      fetch_env_context(
        "a\nmtcars",
        "do something",
        env)
    Output
      [1] "```"                                 
      [2] "# Just the first 1 row and 1 column:"
      [3] "a"                                   
      [4] "#> 'data.frame':"                    
      [5] "#>  $ boop: num 1"                   
      [6] ""                                    
      [7] "```"                                 

---

    Code
      fetch_env_context(
        "not valid R code bop",
        "hey there",
        env)
    Output
      [1] "```"      
      [2] "bop"      
      [3] "#>  num 2"
      [4] ""         
      [5] "```"      

---

    Code
      fetch_env_context(
        "mtcars",
        "bop",
        env)
    Output
      [1] "```"      
      [2] "bop"      
      [3] "#>  num 2"
      [4] ""         
      [5] "```"      

---

    Code
      fetch_env_context(
        "",
        "boop",
        env)
    Output
      character(0)

# describe_variable works

    Code
      describe_variable(
        10,
        "boop")
    Output
      [1] "boop"      
      [2] "#>  num 10"

---

    Code
      describe_variable(
        data.frame(
          a = 1,
          b = 2),
        "boop")
    Output
      [1] "# Just the first 1 row and 2 columns:"
      [2] "boop"                                 
      [3] "#> 'data.frame':"                     
      [4] "#>  $ a: num 1"                       
      [5] "#>  $ b: num 2"                       

