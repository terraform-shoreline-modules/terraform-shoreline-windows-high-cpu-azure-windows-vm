resource "shoreline_notebook" "high_cpu_usage_on_azure_windows_vm" {
  name       = "high_cpu_usage_on_azure_windows_vm"
  data       = file("${path.module}/data/high_cpu_usage_on_azure_windows_vm.json")
  depends_on = [shoreline_action.invoke_proc_cpu_usage,shoreline_action.invoke_get_hw_info,shoreline_action.invoke_get_scheduledtask,shoreline_action.invoke_vm_size_upgrade,shoreline_action.invoke_lower_cpu_priority,shoreline_action.invoke_cpu_process_threshold]
}

resource "shoreline_file" "proc_cpu_usage" {
  name             = "proc_cpu_usage"
  input_file       = "${path.module}/data/proc_cpu_usage.sh"
  md5              = filemd5("${path.module}/data/proc_cpu_usage.sh")
  description      = "Look at the processes using the most CPU"
  destination_path = "/tmp/proc_cpu_usage.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "get_hw_info" {
  name             = "get_hw_info"
  input_file       = "${path.module}/data/get_hw_info.sh"
  md5              = filemd5("${path.module}/data/get_hw_info.sh")
  description      = "Verify if the VM is undersized or oversized for the workload"
  destination_path = "/tmp/get_hw_info.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "get_scheduledtask" {
  name             = "get_scheduledtask"
  input_file       = "${path.module}/data/get_scheduledtask.sh"
  md5              = filemd5("${path.module}/data/get_scheduledtask.sh")
  description      = "Check if any scheduled tasks or scripts are running on the VM"
  destination_path = "/tmp/get_scheduledtask.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "vm_size_upgrade" {
  name             = "vm_size_upgrade"
  input_file       = "${path.module}/data/vm_size_upgrade.sh"
  md5              = filemd5("${path.module}/data/vm_size_upgrade.sh")
  description      = "Use azure cli to resize the VM and give it more resources"
  destination_path = "/tmp/vm_size_upgrade.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "lower_cpu_priority" {
  name             = "lower_cpu_priority"
  input_file       = "${path.module}/data/lower_cpu_priority.sh"
  md5              = filemd5("${path.module}/data/lower_cpu_priority.sh")
  description      = "Lower the priority class of processes which are using high cpu using powershell commands"
  destination_path = "/tmp/lower_cpu_priority.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "cpu_process_threshold" {
  name             = "cpu_process_threshold"
  input_file       = "${path.module}/data/cpu_process_threshold.sh"
  md5              = filemd5("${path.module}/data/cpu_process_threshold.sh")
  description      = "Use powershell to kill a specific process which is using high cpu"
  destination_path = "/tmp/cpu_process_threshold.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_proc_cpu_usage" {
  name        = "invoke_proc_cpu_usage"
  description = "Look at the processes using the most CPU"
  command     = "`chmod +x /tmp/proc_cpu_usage.sh && /tmp/proc_cpu_usage.sh`"
  params      = []
  file_deps   = ["proc_cpu_usage"]
  enabled     = true
  depends_on  = [shoreline_file.proc_cpu_usage]
}

resource "shoreline_action" "invoke_get_hw_info" {
  name        = "invoke_get_hw_info"
  description = "Verify if the VM is undersized or oversized for the workload"
  command     = "`chmod +x /tmp/get_hw_info.sh && /tmp/get_hw_info.sh`"
  params      = []
  file_deps   = ["get_hw_info"]
  enabled     = true
  depends_on  = [shoreline_file.get_hw_info]
}

resource "shoreline_action" "invoke_get_scheduledtask" {
  name        = "invoke_get_scheduledtask"
  description = "Check if any scheduled tasks or scripts are running on the VM"
  command     = "`chmod +x /tmp/get_scheduledtask.sh && /tmp/get_scheduledtask.sh`"
  params      = []
  file_deps   = ["get_scheduledtask"]
  enabled     = true
  depends_on  = [shoreline_file.get_scheduledtask]
}

resource "shoreline_action" "invoke_vm_size_upgrade" {
  name        = "invoke_vm_size_upgrade"
  description = "Use azure cli to resize the VM and give it more resources"
  command     = "`chmod +x /tmp/vm_size_upgrade.sh && /tmp/vm_size_upgrade.sh`"
  params      = []
  file_deps   = ["vm_size_upgrade"]
  enabled     = true
  depends_on  = [shoreline_file.vm_size_upgrade]
}

resource "shoreline_action" "invoke_lower_cpu_priority" {
  name        = "invoke_lower_cpu_priority"
  description = "Lower the priority class of processes which are using high cpu using powershell commands"
  command     = "`chmod +x /tmp/lower_cpu_priority.sh && /tmp/lower_cpu_priority.sh`"
  params      = ["CPU_THRESHOLD","NEW_PRIORITY_CLASS"]
  file_deps   = ["lower_cpu_priority"]
  enabled     = true
  depends_on  = [shoreline_file.lower_cpu_priority]
}

resource "shoreline_action" "invoke_cpu_process_threshold" {
  name        = "invoke_cpu_process_threshold"
  description = "Use powershell to kill a specific process which is using high cpu"
  command     = "`chmod +x /tmp/cpu_process_threshold.sh && /tmp/cpu_process_threshold.sh`"
  params      = ["CPU_THRESHOLD"]
  file_deps   = ["cpu_process_threshold"]
  enabled     = true
  depends_on  = [shoreline_file.cpu_process_threshold]
}

