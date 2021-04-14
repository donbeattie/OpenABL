# System Library

The __system__ library adds operating system level functionality to the ABL language.

---

## Computer

The Computer class adds computer/host level functionality to the ABL language.

### Hostname
Returns the current computer/host name.
``` abl
abl.system.Computer:Hostname()
```

## File

The File class adds file level functionality to the ABL language.

### OpenFile
Opens the file using the default application __(Windows only)__.
``` abl
abl.system.File:OpenFile(session:temp-directory + "LogFile.log":u).
```

## Process

The Process class adds process level functionality to the ABL language.

### CurrentPID
Returns the Process ID for the current ABL session.
``` abl
abl.system.Process:CurrentPID()
```

### Nap
Cause the current process to sleep for a specific number of milliseconds.
``` abl
abl.system.Process:Nap(500).
```




