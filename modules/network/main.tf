/**
 * # OCI Network Module
 * Este módulo cria uma VCN com subnets públicas e privadas, além de gateways necessários
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

# Lista de segurança para a subnet pública
resource "oci_core_security_list" "public_security_list" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.vcn_name}-public-seclist"
  
  # Permitir tráfego HTTPS de entrada
  ingress_security_rules {
    protocol  = "6" # TCP
    source    = "0.0.0.0/0"
    stateless = false
    
    tcp_options {
      min = 443
      max = 443
    }
  }
  
  # Permitir tráfego HTTP de entrada
  ingress_security_rules {
    protocol  = "6" # TCP
    source    = "0.0.0.0/0"
    stateless = false
    
    tcp_options {
      min = 80
      max = 80
    }
  }
  
  # Permitir comunicação dentro da VCN
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

# Lista de segurança para a subnet privada
resource "oci_core_security_list" "private_security_list" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.vcn_name}-private-seclist"
  
  # Permitir toda comunicação dentro da VCN
  ingress_security_rules {
    protocol  = "all"
    source    = var.vcn_cidr
    stateless = false
  }
  
  # Permitir SSH de entrada apenas da subnet pública
  ingress_security_rules {
    protocol  = "6" # TCP
    source    = var.public_subnet_cidr
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

# Network Security Group para serviços públicos
resource "oci_core_network_security_group" "public_nsg" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.vcn_name}-public-nsg"
  
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

# Network Security Group para serviços privados
resource "oci_core_network_security_group" "private_nsg" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.vcn_name}-private-nsg"
  
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

# Regra NSG para permitir HTTPS para serviços públicos
resource "oci_core_network_security_group_security_rule" "public_nsg_https_rule" {
  network_security_group_id = oci_core_network_security_group.public_nsg.id
  protocol                  = "6" # TCP
  direction                 = "INGRESS"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  
  tcp_options {
    destination_port_range {
      min = 443
      max = 443
    }
  }
}

# Regra NSG para permitir HTTP para serviços públicos
resource "oci_core_network_security_group_security_rule" "public_nsg_http_rule" {
  network_security_group_id = oci_core_network_security_group.public_nsg.id
  protocol                  = "6" # TCP
  direction                 = "INGRESS"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  
  tcp_options {
    destination_port_range {
      min = 80
      max = 80
    }
  }
}

# Regra NSG para permitir comunicação interna para serviços privados
resource "oci_core_network_security_group_security_rule" "private_nsg_internal_rule" {
  network_security_group_id = oci_core_network_security_group.private_nsg.id
  protocol                  = "all"
  direction                 = "INGRESS"
  source                    = var.vcn_cidr
  source_type               = "CIDR_BLOCK"
}

# Subnet pública
resource "oci_core_subnet" "public_subnet" {
  cidr_block     = var.public_subnet_cidr
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.vcn_name}-public-subnet"
  
  route_table_id             = oci_core_route_table.public_route_table.id
  security_list_ids          = [oci_core_security_list.public_security_list.id]
  prohibit_public_ip_on_vnic = false
  dns_label                  = "${var.vcn_dns_label}pub"
  
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

# Subnet privada
resource "oci_core_subnet" "private_subnet" {
  cidr_block     = var.private_subnet_cidr
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.vcn_name}-private-subnet"
  
  route_table_id             = oci_core_route_table.private_route_table.id
  security_list_ids          = [oci_core_security_list.private_security_list.id]
  prohibit_public_ip_on_vnic = true
  dns_label                  = "${var.vcn_dns_label}priv"
  
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
} 