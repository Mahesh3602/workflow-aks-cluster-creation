# 1. Reference the existing sandbox resource group
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

# 2. Networking Module
module "aks_vnet" {
  source  = "Azure/vnet/azurerm"
  version = "4.1.0"

  resource_group_name = data.azurerm_resource_group.main.name
  vnet_location       = data.azurerm_resource_group.main.location
  use_for_each        = true

  vnet_name       = "${var.prefix}-vnet"
  address_space   = var.vnet_address_space
  subnet_names    = keys(var.subnet_configuration)
  subnet_prefixes = values(var.subnet_configuration)

  tags = var.common_tags
}

# 3. AKS Cluster Module
module "app" {
  source  = "Azure/aks/azurerm"
  version = "9.0.0"

  # Cluster base config
  resource_group_name             = data.azurerm_resource_group.main.name
  location                        = data.azurerm_resource_group.main.location
  prefix                          = var.prefix
  cluster_name_random_suffix      = true
  sku_tier                        = "Standard"
  node_os_channel_upgrade         = "NodeImage"
  automatic_channel_upgrade       = "node-image"
  log_analytics_workspace_enabled = false

  # CRITICAL SANDBOX FIX: 
  # You don't have permission to create new RGs. 
  # This forces the AKS managed resources into your current sandbox RG.
  node_resource_group = data.azurerm_resource_group.main.name

  # Cluster system pool
  enable_auto_scaling = false
  agents_count        = 2
  agents_size         = "Standard_D2s_v3"
  agents_pool_name    = "systempool"

  # Cluster networking
  # Matches the 'nodes' key in your terraform.tfvars subnet_configuration
  vnet_subnet_id = module.aks_vnet.vnet_subnets_name_id["nodes"]
  network_plugin = "azure"
  network_policy = "azure"

  # Cluster node pools
  node_pools = {
    apppool1 = {
      name           = lower(substr(var.prefix, 0, 8)) 
      vm_size        = "Standard_D2s_v3"
      node_count     = 1
      vnet_subnet_id = module.aks_vnet.vnet_subnets_name_id["nodes"]
    }
  }

  # Cluster Authentication
  local_account_disabled            = false
  role_based_access_control_enabled = true
  rbac_aad                          = false
}