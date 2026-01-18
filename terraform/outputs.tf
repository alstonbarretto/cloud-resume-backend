output "api_base_url" {
  value = module.api_gateway.counter_endpoint
  description = "Full API counter endpoint"
}