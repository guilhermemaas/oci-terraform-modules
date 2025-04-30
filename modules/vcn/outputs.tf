output "vcn_id" {
  description = "ID da VCN criada"
  value       = oci_core_vcn.vcn.id
}

output "vcn_name" {
  description = "Nome da VCN"
  value       = oci_core_vcn.vcn.display_name
}

output "vcn_cidr" {
  description = "CIDR da VCN"
  value       = oci_core_vcn.vcn.cidr_block
}

output "internet_gateway_id" {
  description = "ID do Internet Gateway"
  value       = oci_core_internet_gateway.internet_gateway.id
}

output "nat_gateway_id" {
  description = "ID do NAT Gateway"
  value       = oci_core_nat_gateway.nat_gateway.id
}

output "service_gateway_id" {
  description = "ID do Service Gateway"
  value       = oci_core_service_gateway.service_gateway.id
}

output "kubernetes_api_endpoint_subnet_id" {
  description = "ID da subnet para o endpoint do Kubernetes API"
  value       = oci_core_subnet.kubernetes_api_endpoint_subnet.id
}

output "node_subnet_id" {
  description = "ID da subnet para os nós do Kubernetes"
  value       = oci_core_subnet.node_subnet.id
}

output "lb_subnet_id" {
  description = "ID da subnet para os balanceadores de carga"
  value       = oci_core_subnet.lb_subnet.id
}

output "public_route_table_id" {
  description = "ID da tabela de rotas pública"
  value       = oci_core_route_table.public_route_table.id
}

output "private_route_table_id" {
  description = "ID da tabela de rotas privada"
  value       = oci_core_route_table.private_route_table.id
} 