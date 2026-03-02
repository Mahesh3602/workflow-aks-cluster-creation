provider "azurerm" {
  features {}
  
  # Often required in restricted sandboxes to prevent 
  # errors when Terraform tries to register Azure resource providers.
  skip_provider_registration = true
}