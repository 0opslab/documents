# bitsadmin monitor



Monitors jobs in the transfer queue that the current user owns.

## Syntax

```
bitsadmin /Monitor [/allusers] [/refresh <Seconds>]
```

## Parameters

|Parameter|Description|
|---------|-----------|
|Allusers|Optional—monitors jobs for all users|
|Refresh|Optional—refreshes the data at an interval specified by *Seconds*. The default refresh interval is five seconds.|

## Remarks

-   You must have administrator privileges to use the **Allusers** parameter.
-   Use CTRL+C to stop the refresh.

## <a name="BKMK_examples"></a>Examples

The following example monitors the transfer queue for jobs owned by the current user and refreshes the information every 60 seconds.
```
C:\>bitsadmin /Monitor /refesh 60
```

#### Additional references

[Command-Line Syntax Key](command-line-syntax-key.md)