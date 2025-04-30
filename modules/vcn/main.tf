/**
 * # OCI VCN Module
 * Este módulo cria uma VCN com as subnets necessárias para o OKE
 */

# Criação da VCN
resource "oci_core_vcn" "vcn" {
  compartment_id = var.compartment_id
  cidr_block     = var.vcn_cidr
  display_name   = var.vcn_name
  dns_label      = var.vcn_dns_label
  
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

# Internet Gateway
resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.compartment_id
  display_name   = "${var.vcn_name}-igw"
  vcn_id         = oci_core_vcn.vcn.id
  
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

# NAT Gateway
resource "oci_core_nat_gateway" "nat_gateway" {
  compartment_id = var.compartment_id
  display_name   = "${var.vcn_name}-natgw"
  vcn_id         = oci_core_vcn.vcn.id
  
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

# Service Gateway
resource "oci_core_service_gateway" "service_gateway" {
  compartment_id = var.compartment_id
  display_name   = "${var.vcn_name}-svcgw"
  vcn_id         = oci_core_vcn.vcn.id
  
  services {
    service_id = lookup(data.oci_core_services.all_oci_services.services[0], "id")
  }
  
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

# Data source para obter todos os serviços OCI
data "oci_core_services" "all_oci_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

# Tabela de rotas para a subnet pública
resource "oci_core_route_table" "public_route_table" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.vcn_name}-public-rt"
  
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
  }
  
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

# Tabela de rotas para a subnet privada
resource "oci_core_route_table" "private_route_table" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.vcn_name}-private-rt"
  
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat_gateway.id
  }
  
  route_rules {
    destination       = lookup(data.oci_core_services.all_oci_services.services[0], "cidr_block")
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.service_gateway.id
  }
  
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

# Lista de Security para Kubernetes API Endpoint
resource "oci_core_security_list" "api_endpoint_security_list" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.vcn_name}-api-endpoint-seclist"
  
  # Permitir tráfego de entrada para o endpoint do Kubernetes API
  ingress_security_rules {
    protocol  = "6" # TCP
    source    = "0.0.0.0/0"
    stateless = false
    
    tcp_options {
      min = 6443
      max = 6443
    }
  }
  
  # Permitir comunicação entre nós do Kubernetes
  ingress_security_rules {
    protocol  = "all"
    source    = var.vcn_cidr
    stateless = false
  }
  
  # Permitir todo tráfego de saída
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
    stateless   = false
  }
  
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

# Lista de segurança para nós do Kubernetes
resource "oci_core_security_list" "node_security_list" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.vcn_name}-node-seclist"
  
  # Permitir todo tráfego dentro da VCN
  ingress_security_rules {
    protocol  = "all"
    source    = var.vcn_cidr
    stateless = false
  }
  
  # Permitir SSH de entrada
  ingress_security_rules {
    protocol  = "6" # TCP
    source    = "0.0.0.0/0"
    stateless = false
    
    tcp_options {
      min = 22
      max = 22
    }
  }
  
  # Permitir todo tráfego de saída
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
    stateless   = false
  }
  
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

# Subnet para o endpoint do Kubernetes API
resource "oci_core_subnet" "kubernetes_api_endpoint_subnet" {
  cidr_block     = var.kubernetes_api_endpoint_subnet_cidr
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.vcn_name}-api-endpoint-subnet"
  
  route_table_id    = oci_core_route_table.public_route_table.id
  security_list_ids = [oci_core_security_list.api_endpoint_security_list.id]
  prohibit_public_ip_on_vnic = false
  
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

# Subnet para os nós do Kubernetes
resource "oci_core_subnet" "node_subnet" {
  cidr_block     = var.node_subnet_cidr
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.vcn_name}-node-subnet"
  
  route_table_id    = oci_core_route_table.private_route_table.id
  security_list_ids = [oci_core_security_list.node_security_list.id]
  prohibit_public_ip_on_vnic = true
  
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

# Subnet para os balanceadores de carga
resource "oci_core_subnet" "lb_subnet" {
  cidr_block     = var.lb_subnet_cidr
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.vcn_name}-lb-subnet"
  
  route_table_id    = oci_core_route_table.public_route_table.id
  prohibit_public_ip_on_vnic = false
  
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
} 