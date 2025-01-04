# constructs turns correctly with context

    Code
      construct_turn(input, mocked_selection())
    Output
      [1] "my input:\n\nsome context"

# returns input as-is when None is chosen

    Code
      construct_turn(input, mocked_empty_selection())
    Output
      [1] "hey there"

