# describe_selected_variables works

    Code
      describe_relevant_variables("a\nbop <- 1", env)
    Output
      [1] "Here's some context on relevant variables: \n```r\na\n#> 'data.frame':\t1 obs. of  1 variable:\n#>  $ boop: num 1\n\nbop\n#>  num 2\n\n```"

---

    Code
      describe_relevant_variables("bop <- 1", env)
    Output
      [1] "Here's some context on relevant variables: \n```r\nbop\n#>  num 2\n\n```"

---

    Code
      describe_relevant_variables("a\nmtcars", env)
    Output
      [1] "Here's some context on relevant variables: \n```r\na\n#> 'data.frame':\t1 obs. of  1 variable:\n#>  $ boop: num 1\n\n```"

---

    Code
      describe_relevant_variables("", env)
    Output
      [1] "Here's some context on relevant variables: \n```r\na\n#> 'data.frame':\t1 obs. of  1 variable:\n#>  $ boop: num 1\n\n```"

---

    Code
      describe_relevant_variables("", env2)
    Output
      [1] "Here's some context on relevant variables: \n```r\nbop\n#> 'data.frame':\t1 obs. of  1 variable:\n#>  $ b: num 2\n\na\n#> 'data.frame':\t1 obs. of  1 variable:\n#>  $ boop: num 1\n\n```"

# describe_variable works

    Code
      describe_variable(10, "boop")
    Output
      [1] "boop"       "#>  num 10" ""          

---

    Code
      describe_variable(data.frame(a = 1, b = 2), "boop")
    Output
      [1] "boop"                                     
      [2] "#> 'data.frame':\t1 obs. of  2 variables:"
      [3] "#>  $ a: num 1"                           
      [4] "#>  $ b: num 2"                           
      [5] ""                                         

