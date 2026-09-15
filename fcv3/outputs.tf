output "function_names" {
  description = "FC 3.0 function names"
  value       = { for k, v in alicloud_fcv3_function.this : k => v.function_name }
}

output "function_ids" {
  description = "FC 3.0 function IDs"
  value       = { for k, v in alicloud_fcv3_function.this : k => v.function_id }
}

output "function_arns" {
  description = "FC 3.0 function ARNs"
  value       = { for k, v in alicloud_fcv3_function.this : k => v.function_arn }
}

output "trigger_ids" {
  description = "FC 3.0 trigger IDs"
  value       = { for k, v in alicloud_fcv3_trigger.this : k => v.trigger_id }
}

output "trigger_http_urls" {
  description = "HTTP trigger URLs when present"
  value = {
    for k, v in alicloud_fcv3_trigger.this : k => try(v.http_trigger[0], null)
  }
}

output "custom_domain_ids" {
  description = "Custom domain IDs"
  value       = { for k, v in alicloud_fcv3_custom_domain.this : k => v.id }
}

output "zzz_reminders" {
  description = "Reminders for Function Compute 3.0"
  value = {
    next_steps = [
      "Good fit for LLM proxy glue, async jobs, and event-driven pipelines",
      "Pair with PAI (model serving) and CR (container images) for AI workloads",
      "Use OSS zip or container image for production code packages",
    ]
    security_notes = [
      "Prefer vpc_config for private data access",
      "Attach least-privilege RAM role to each function",
      "Enable log_config to SLS for auditability",
    ]
    important_resources = {
      function_count = length(alicloud_fcv3_function.this)
      trigger_count  = length(alicloud_fcv3_trigger.this)
      domain_count   = length(alicloud_fcv3_custom_domain.this)
    }
  }
}
