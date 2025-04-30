output "cluster_id" {
  description = "ID do cluster OKE"
  value       = oci_containerengine_cluster.oke_cluster.id
}

output "cluster_name" {
  description = "Nome do cluster OKE"
  value       = oci_containerengine_cluster.oke_cluster.name
}

output "cluster_kubernetes_version" {
  description = "Versão do Kubernetes utilizada no cluster"
  value       = oci_containerengine_cluster.oke_cluster.kubernetes_version
}

output "cluster_state" {
  description = "Estado atual do cluster OKE"
  value       = oci_containerengine_cluster.oke_cluster.state
}

output "cluster_endpoints" {
  description = "Endpoints do cluster OKE"
  value       = oci_containerengine_cluster.oke_cluster.endpoints
}

output "nodepool_id" {
  description = "ID do nodepool do OKE"
  value       = oci_containerengine_node_pool.oke_node_pool.id
}

output "nodepool_name" {
  description = "Nome do nodepool do OKE"
  value       = oci_containerengine_node_pool.oke_node_pool.name
}

output "nodepool_kubernetes_version" {
  description = "Versão do Kubernetes utilizada no nodepool"
  value       = oci_containerengine_node_pool.oke_node_pool.kubernetes_version
}

output "nodepool_node_shape" {
  description = "Shape dos nós no nodepool"
  value       = oci_containerengine_node_pool.oke_node_pool.node_shape
}

output "kubeconfig_command" {
  description = "Comando para obter o kubeconfig do cluster OKE"
  value       = "oci ce cluster create-kubeconfig --cluster-id ${oci_containerengine_cluster.oke_cluster.id} --file $HOME/.kube/config --region ${data.oci_identity_region.current.name} --token-version 2.0.0"
} 