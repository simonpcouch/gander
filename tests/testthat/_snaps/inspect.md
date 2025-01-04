# describe_selected_variables works

    Code
      describe_relevant_variables("a\nbop <- 1", env)
    Output
      [1] "Here's some context on relevant variables: "
      [2] ""                                           
      [3] "```"                                        
      [4] "a"                                          
      [5] "#> 'data.frame':\t1 obs. of  1 variable:"   
      [6] "#>  $ boop: num 1"                          
      [7] "bop"                                        
      [8] "#>  num 2"                                  
      [9] "```"                                        

---

    Code
      describe_relevant_variables("bop <- 1", env)
    Output
      [1] "Here's some context on relevant variables: "
      [2] ""                                           
      [3] "```"                                        
      [4] "bop"                                        
      [5] "#>  num 2"                                  
      [6] "```"                                        

---

    Code
      describe_relevant_variables("a\nmtcars", env)
    Output
      [1] "Here's some context on relevant variables: "
      [2] ""                                           
      [3] "```"                                        
      [4] "a"                                          
      [5] "#> 'data.frame':\t1 obs. of  1 variable:"   
      [6] "#>  $ boop: num 1"                          
      [7] "```"                                        

---

    Code
      describe_relevant_variables("", env)
    Output
      [1] "Here's some context on relevant variables: "
      [2] ""                                           
      [3] "```"                                        
      [4] "a"                                          
      [5] "#> 'data.frame':\t1 obs. of  1 variable:"   
      [6] "#>  $ boop: num 1"                          
      [7] "```"                                        

---

    Code
      describe_relevant_variables("", env2)
    Output
       [1] "Here's some context on relevant variables: "
       [2] ""                                           
       [3] "```"                                        
       [4] "bop"                                        
       [5] "#> 'data.frame':\t1 obs. of  1 variable:"   
       [6] "#>  $ b: num 2"                             
       [7] "a"                                          
       [8] "#> 'data.frame':\t1 obs. of  1 variable:"   
       [9] "#>  $ boop: num 1"                          
      [10] "```"                                        

# describe_variable works

    Code
      describe_variable(10, "boop")
    Output
      [1] "boop"       "#>  num 10"

---

    Code
      describe_variable(data.frame(a = 1, b = 2), "boop")
    Output
      [1] "boop"                                     
      [2] "#> 'data.frame':\t1 obs. of  2 variables:"
      [3] "#>  $ a: num 1"                           
      [4] "#>  $ b: num 2"                           

