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