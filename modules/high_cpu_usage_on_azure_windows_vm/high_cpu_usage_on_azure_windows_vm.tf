resource "shoreline_notebook" "high_cpu_usage_on_azure_windows_vm" {
  name       = "high_cpu_usage_on_azure_windows_vm"
  data       = file("${path.module}/data/high_cpu_usage_on_azure_windows_vm.json")
  depends_on = [shoreline_action.invoke_cpu_usage_verification,shoreline_action.invoke_cpu_info,shoreline_action.invoke_get_scheduled_task_log,shoreline_action.invoke_vm_resizer,shoreline_action.invoke_lower_cpu_priority,shoreline_action.invoke_process_cpu_threshold]
}

resource "shoreline_file" "cpu_usage_verification" {
  name             = "cpu_usage_verification"
  input_file       = "${path.module}/data/cpu_usage_verification.sh"
  md5              = filemd5("${path.module}/data/cpu_usage_verification.sh")
  description      = "Look at the processes using the most CPU"
  destination_path = "/tmp/cpu_usage_verification.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "cpu_info" {
  name             = "cpu_info"
  input_file       = "${path.module}/data/cpu_info.sh"
  md5              = filemd5("${path.module}/data/cpu_info.sh")
  description      = "Verify if the VM is undersized or oversized for the workload"
  destination_path = "/tmp/cpu_info.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "get_scheduled_task_log" {
  name             = "get_scheduled_task_log"
  input_file       = "${path.module}/data/get_scheduled_task_log.sh"
  md5              = filemd5("${path.module}/data/get_scheduled_task_log.sh")
  description      = "Check if any scheduled tasks or scripts are running on the VM"
  destination_path = "/tmp/get_scheduled_task_log.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "vm_resizer" {
  name             = "vm_resizer"
  input_file       = "${path.module}/data/vm_resizer.sh"
  md5              = filemd5("${path.module}/data/vm_resizer.sh")
  description      = "Use azure cli to resize the VM and give it more resources"
  destination_path = "/tmp/vm_resizer.sh"
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

resource "shoreline_file" "process_cpu_threshold" {
  name             = "process_cpu_threshold"
  input_file       = "${path.module}/data/process_cpu_threshold.sh"
  md5              = filemd5("${path.module}/data/process_cpu_threshold.sh")
  description      = "Use powershell to kill a specific process which is using high cpu"
  destination_path = "/tmp/process_cpu_threshold.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_cpu_usage_verification" {
  name        = "invoke_cpu_usage_verification"
  description = "Look at the processes using the most CPU"
  command     = "`chmod +x /tmp/cpu_usage_verification.sh && /tmp/cpu_usage_verification.sh`"
  params      = []
  file_deps   = ["cpu_usage_verification"]
  enabled     = true
  depends_on  = [shoreline_file.cpu_usage_verification]
}

resource "shoreline_action" "invoke_cpu_info" {
  name        = "invoke_cpu_info"
  description = "Verify if the VM is undersized or oversized for the workload"
  command     = "`chmod +x /tmp/cpu_info.sh && /tmp/cpu_info.sh`"
  params      = []
  file_deps   = ["cpu_info"]
  enabled     = true
  depends_on  = [shoreline_file.cpu_info]
}

resource "shoreline_action" "invoke_get_scheduled_task_log" {
  name        = "invoke_get_scheduled_task_log"
  description = "Check if any scheduled tasks or scripts are running on the VM"
  command     = "`chmod +x /tmp/get_scheduled_task_log.sh && /tmp/get_scheduled_task_log.sh`"
  params      = []
  file_deps   = ["get_scheduled_task_log"]
  enabled     = true
  depends_on  = [shoreline_file.get_scheduled_task_log]
}

resource "shoreline_action" "invoke_vm_resizer" {
  name        = "invoke_vm_resizer"
  description = "Use azure cli to resize the VM and give it more resources"
  command     = "`chmod +x /tmp/vm_resizer.sh && /tmp/vm_resizer.sh`"
  params      = []
  file_deps   = ["vm_resizer"]
  enabled     = true
  depends_on  = [shoreline_file.vm_resizer]
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

resource "shoreline_action" "invoke_process_cpu_threshold" {
  name        = "invoke_process_cpu_threshold"
  description = "Use powershell to kill a specific process which is using high cpu"
  command     = "`chmod +x /tmp/process_cpu_threshold.sh && /tmp/process_cpu_threshold.sh`"
  params      = ["CPU_THRESHOLD"]
  file_deps   = ["process_cpu_threshold"]
  enabled     = true
  depends_on  = [shoreline_file.process_cpu_threshold]
}

