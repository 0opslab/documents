# dispdiag



Logs display information to a file.

## Syntax

```
dispdiag [-testacpi] [-d] [-delay <Seconds>] [-out <FilePath>]
```

### Parameters

|Parameter|Description|
|---------|-----------|
|- testacpi|Runs hotkey diagnostics test. Displays the key name, code and scan code for any key pressed during the test.|
|-d|Generates a dump file with test results.|
|-delay \<Seconds>|Delays the collection of data by specified time in *seconds*.|
|-out \<FilePath>|Specifies path and filename to save collected data. This must be the last parameter.|
|-?|Displays available command parameters and provides help for using them.|