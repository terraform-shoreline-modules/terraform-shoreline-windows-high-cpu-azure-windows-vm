(Get-CimInstance -ClassName Win32_Processor).NumberOfCores

(Get-CimInstance -ClassName Win32_Processor).NumberOfLogicalProcessors

(Get-CimInstance -ClassName Win32_ComputerSystem).TotalPhysicalMemory / 1GB