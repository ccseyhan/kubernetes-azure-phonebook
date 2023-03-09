output "aks_name" {
    value = azurerm_kubernetes_cluster.aks.name
}

output "rg_name" {
    value = azurerm_resource_group.rg.name
}

output "public_ip" {
  value = data.azurerm_public_ips.example.public_ips[0]
}