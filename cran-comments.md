## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.

## Resubmission

This submission is a resubmission. The first submission received the following comments:

> If there are references describing the methods in your package, ...

Unfortunately, formal references are not available for the methods implemented in this package. Relevant softwares are mentioned in single-quotes in the Description.

> We see unexecutable code in man/gander_options.Rd.

Apologies---this has been resolved.

> Please add small executable examples in your Rd-files... The best solution might be to write tests for your not exported function

The examples for the submission's two functions are wrapped in `\dontrun{}` as they require an API, interactivity, or both, as noted in .Rd comments. I've introduced further mocking in tests so as to test as much functionality as possible in tests to increase coverage.

Thank you for your work!
