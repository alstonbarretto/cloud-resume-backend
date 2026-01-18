output "api_base_url" {
  value = "${module.api_gateway.api_endpoint}/prod"
}