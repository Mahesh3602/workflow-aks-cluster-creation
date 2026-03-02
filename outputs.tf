output "aks_cluster_name" {
  value = module.app.aks_name
}

output "kubernetes_cluster_host" {
  value     = module.app.host
  sensitive = true
}

output "resource_group_name" {
  value = data.azurerm_resource_group.main.name
}