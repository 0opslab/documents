# nfsstat



You can use **nfsstat** to display or reset counts of calls made to Server for NFS.

## Syntax

```
nfsstat [-z]
```

## Description

When used without the **-z** option, the **nfsstat** command-line utility displays the number of NFS V2, NFS V3, and Mount V3 calls made to the server since the counters were set to 0, either when the service started or when the counters were reset using **nfsstat -z**.