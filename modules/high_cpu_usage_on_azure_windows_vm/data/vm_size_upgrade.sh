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