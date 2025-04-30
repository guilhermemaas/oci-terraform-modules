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

output "public_subnet_id" {
  description = "ID da subnet pública"
  value       = oci_core_subnet.public_subnet.id
}

output "private_subnet_id" {
  description = "ID da subnet privada"
  value       = oci_core_subnet.private_subnet.id
}

output "public_subnet_cidr" {
  description = "CIDR da subnet pública"
  value       = oci_core_subnet.public_subnet.cidr_block
}

output "private_subnet_cidr" {
  description = "CIDR da subnet privada"
  value       = oci_core_subnet.private_subnet.cidr_block
}

output "public_route_table_id" {
  description = "ID da tabela de rotas pública"
  value       = oci_core_route_table.public_route_table.id
}

output "private_route_table_id" {
  description = "ID da tabela de rotas privada"
  value       = oci_core_route_table.private_route_table.id
}

output "public_security_list_id" {
  description = "ID da lista de segurança pública"
  value       = oci_core_security_list.public_security_list.id
}

output "private_security_list_id" {
  description = "ID da lista de segurança privada"
  value       = oci_core_security_list.private_security_list.id
}

output "public_nsg_id" {
  description = "ID do Network Security Group público"
  value       = oci_core_network_security_group.public_nsg.id
}

output "private_nsg_id" {
  description = "ID do Network Security Group privado"
  value       = oci_core_network_security_group.private_nsg.id
} 