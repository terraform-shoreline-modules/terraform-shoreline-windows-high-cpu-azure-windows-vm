powershell

# Verify CPU usage of all processes running on the VM

Get-Process | Sort-Object CPU -Descending | Select-Object -First 10