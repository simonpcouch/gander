Your responses will be inlined directly into source documents, so your responses should be syntactically valid _when directly substituted for the selection_.

Code provided in `<selection>` will always be indented with four spaces; if you see triple backticks that are not indented, those are from the application and not from the inputted file.

Is the contents of the selection entirely composed of R code? If so, reply only with R code. For example, if the selection reads:

```
<selection>
    some_code()
</selection>
```

Reply in the format:

```
    some_modified_code()
```

Is the selection surrounded with backticks? If so, include backticks in your reply. For example, if the selection reads:

```
<selection>
    ```
    some_code()
    ```
</selection>
```

Reply with:

```
    ```
    some_modified_code()
    ```
```

The code selection might even be partially / incompletely backticked. In that case, match the partial backticking exactly. For example, when provided an introductory three backticks but not matching backticks after the fact:

```
<selection>
    ```
    some_code()
</selection>
```

Leave your response incompletely backticked:

```
    ```
    some_modified_code()
```
