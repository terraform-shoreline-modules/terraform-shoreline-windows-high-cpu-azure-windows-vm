
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# High CPU Usage on Azure Windows VM
---

This incident type refers to a situation where a Windows Virtual Machine (VM) running on Microsoft Azure cloud platform is utilizing an abnormally high amount of CPU resources. This can cause performance issues and impact the overall functionality of the VM. The cause of high CPU usage can be due to various factors such as running resource-intensive applications, misconfigured VM settings, or insufficient resources allocated to the VM. Resolving this incident requires identifying the root cause and taking appropriate actions such as optimizing the VM settings, adjusting resource allocation, or optimizing the application code.

### Parameters
```shell
export SUBSCRIPTION_ID="PLACEHOLDER"

export RESOURCE_GROUP_NAME="PLACEHOLDER"

export VM_NAME="PLACEHOLDER"

export CPU_THRESHOLD="PLACEHOLDER"

export NEW_PRIORITY_CLASS="PLACEHOLDER"
```

## Debug

### Look at the processes using the most CPU
```shell
powershell

# Verify CPU usage of all processes running on the VM

Get-Process | Sort-Object CPU -Descending | Select-Object -First 10
```

### Verify if the VM is undersized or oversized for the workload
```shell
(Get-CimInstance -ClassName Win32_Processor).NumberOfCores

(Get-CimInstance -ClassName Win32_Processor).NumberOfLogicalProcessors

(Get-CimInstance -ClassName Win32_ComputerSystem).TotalPhysicalMemory / 1GB
```

### Check if any resource-intensive application is running on the VM
```shell
Get-Process | Select-Object -Property Name, CPU, Responding
```

### Check if any scheduled tasks or scripts are running on the VM
```shell
Get-ScheduledTask

Get-ScheduledTaskLog
```

### Verify if the VM is running with the latest version of the Azure VM agent
```shell
(Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows Azure Guest Agent').Version
```

## Repair

### Use azure cli to resize the VM and give it more resources
```shell
# Define variables

$resourceGroupName = "YourResourceGroup"

$vmName = "YourVMName"

$newVmSize = "Standard_DS2_v2"  # Replace with the desired VM size



# Authenticate to Azure (if not already authenticated)

Connect-AzAccount



# Set the active subscription (if you have multiple subscriptions)

# Set-AzContext -SubscriptionName "YourSubscriptionName"



# Get the current VM size

$currentVmSize = (Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName).HardwareProfile.VmSize



# Check if the current VM size is the same as the desired size

if ($currentVmSize -eq $newVmSize) {

    Write-Output "The VM is already using the desired size ($newVmSize). No action needed."

} else {

    # Resize the VM

    Resize-AzVM -ResourceGroupName $resourceGroupName -Name $vmName -Size $newVmSize



    Write-Output "VM size upgraded from $currentVmSize to $newVmSize."

}


```

### Lower the priority class of processes which are using high cpu using powershell commands
```shell
PROCESS_NAME="PLACEHOLDER"



# Get the process ID for each process consuming high CPU

$processes = Get-Process | Where-Object { $_.CPU -gt ${CPU_THRESHOLD} }



# Lower the priority class of each process

foreach ($process in $processes) {

    $process.PriorityClass = ${NEW_PRIORITY_CLASS}

}



# Output a message indicating that the priority class has been lowered

echo "Priority class lowered for CPU intensive processes."


```

### Use powershell to kill a specific process which is using high cpu 
```shell
export $ProcessName = "${PROCESS_NAME}"

$Threshold = ${CPU_THRESHOLD}



$Process = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue



if ($Process) {

    $CPUUsage = $Process.CPU

    if ($CPUUsage -gt $Threshold) {

        Stop-Process -Name $ProcessName -Force

        Write-Host "The process $ProcessName was stopped because it was using $CPUUsage% of CPU."

    } else {

        Write-Host "The process $ProcessName is not using more than $Threshold% of CPU."

    }

} else {

    Write-Host "The process $ProcessName was not found."

}

```