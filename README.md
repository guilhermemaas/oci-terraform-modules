# OCI Terraform Modules

Este repositório contém módulos Terraform para criar e gerenciar recursos na Oracle Cloud Infrastructure (OCI).

## Módulos Disponíveis

### Compartment

O módulo Compartment permite criar compartimentos no OCI, com suporte a compartimentos aninhados.

### Network

O módulo Network cria uma infraestrutura de rede completa com:
- Virtual Cloud Network (VCN)
- Internet Gateway
- NAT Gateway
- Service Gateway
- Route Tables
- Security Lists
- Network Security Groups (NSGs)
- Subnet pública e privada

### VCN

O módulo VCN cria uma Virtual Cloud Network completa com:
- Internet Gateway
- NAT Gateway
- Service Gateway
- Route Tables
- Security Lists
- Subnets para Kubernetes API, Nodes e Load Balancers

### OKE (Oracle Kubernetes Engine)

O módulo OKE cria um cluster Kubernetes gerenciado com:
- Cluster Kubernetes
- Node Pool
- Configurações de rede

## Como usar

### Exemplo de uso do módulo Compartment

```hcl
module "compartment" {
  source              = "git::https://github.com/seu-usuario/oci-terraform-modules.git//modules/compartment?ref=v1.0.0"
  parent_compartment_id = var.tenancy_ocid
  compartment_name    = "platform"
  compartment_description = "Compartimento para plataforma"
  
  freeform_tags = {
    "environment" = "production"
    "managed-by"  = "terraform"
  }
}

# Criar um compartimento aninhado
module "child_compartment" {
  source              = "git::https://github.com/seu-usuario/oci-terraform-modules.git//modules/compartment?ref=v1.0.0"
  parent_compartment_id = module.compartment.compartment_id
  compartment_name    = "dev-platform"
  compartment_description = "Compartimento de desenvolvimento da plataforma"
  
  freeform_tags = {
    "environment" = "development"
    "managed-by"  = "terraform"
  }
}
```

### Exemplo de uso do módulo Network

```hcl
module "network" {
  source              = "git::https://github.com/seu-usuario/oci-terraform-modules.git//modules/network?ref=v1.0.0"
  compartment_id      = var.compartment_id
  vcn_name            = "production-vcn"
  vcn_dns_label       = "prodvcn"
  vcn_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.0.0/24"
  private_subnet_cidr = "10.0.1.0/24"
  
  freeform_tags = {
    "environment" = "production"
    "managed-by"  = "terraform"
  }
}
```

### Exemplo de uso do módulo VCN

```hcl
module "vcn" {
  source         = "git::https://github.com/seu-usuario/oci-terraform-modules.git//modules/vcn?ref=v1.0.0"
  compartment_id = var.compartment_id
  vcn_name       = "my-vcn"
  vcn_dns_label  = "myvcn"
  vcn_cidr       = "10.0.0.0/16"
}
```

### Exemplo de uso do módulo OKE

```hcl
module "oke" {
  source         = "git::https://github.com/seu-usuario/oci-terraform-modules.git//modules/oke?ref=v1.0.0"
  compartment_id = var.compartment_id
  cluster_name   = "my-cluster"
  vcn_id         = module.vcn.vcn_id
  
  kubernetes_version = "v1.26.2"
  
  # Endpoint do cluster
  endpoint_subnet_id = module.vcn.kubernetes_api_endpoint_subnet_id
  cluster_endpoint_config_is_public_ip_enabled = true
  
  # Node Pool
  nodepool_name      = "my-nodepool"
  node_shape         = "VM.Standard.E3.Flex"
  node_image_id      = "ocid1.image.oc1..example"
  node_count         = 1
  availability_domain = "EXAMPLE-AD-1"
  nodepool_subnet_id = module.vcn.node_subnet_id
  
  # Load Balancer
  load_balancer_subnet_ids = [module.vcn.lb_subnet_id]
  
  node_shape_config = {
    ocpus         = 1
    memory_in_gbs = 8
  }
}
```

## Versionamento

É recomendado usar a referência específica ao importar os módulos (por exemplo `?ref=v1.0.0`) para garantir a estabilidade da infraestrutura.
