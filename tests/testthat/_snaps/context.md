# fetch_env_context works

    Code
      fetch_env_context(
        "a\nbop <- 1",
        env)
    Output
      [1] "```"                                    
      [2] "a"                                      
      [3] "#> 'data.frame': 1 obs. of  1 variable:"
      [4] "#>  $ boop: num 1"                      
      [5] ""                                       
      [6] "bop"                                    
      [7] "#>  num 2"                              
      [8] ""                                       
      [9] "```"                                    

---

    Code
      fetch_env_context(
        "bop <- 1",
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
        env)
    Output
      [1] "```"                                    
      [2] "a"                                      
      [3] "#> 'data.frame': 1 obs. of  1 variable:"
      [4] "#>  $ boop: num 1"                      
      [5] ""                                       
      [6] "```"                                    

---

    Code
      fetch_env_context(
        "", env)
    Output
      [1] "```"                                    
      [2] "a"                                      
      [3] "#> 'data.frame': 1 obs. of  1 variable:"
      [4] "#>  $ boop: num 1"                      
      [5] ""                                       
      [6] "```"                                    

---

    Code
      fetch_env_context(
        "",
        env2)
    Output
       [1] "```"                                    
       [2] "bop"                                    
       [3] "#> 'data.frame': 1 obs. of  1 variable:"
       [4] "#>  $ b: num 2"                         
       [5] ""                                       
       [6] "a"                                      
       [7] "#> 'data.frame': 1 obs. of  1 variable:"
       [8] "#>  $ boop: num 1"                      
       [9] ""                                       
      [10] "```"                                    

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
      [1] "boop"                                    
      [2] "#> 'data.frame': 1 obs. of  2 variables:"
      [3] "#>  $ a: num 1"                          
      [4] "#>  $ b: num 2"                          

