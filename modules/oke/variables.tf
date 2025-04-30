variable "compartment_id" {
  description = "ID do compartimento onde o cluster OKE será criado"
  type        = string
}

variable "kubernetes_version" {
  description = "Versão do Kubernetes para o cluster OKE"
  type        = string
}

variable "cluster_name" {
  description = "Nome do cluster OKE"
  type        = string
}

variable "vcn_id" {
  description = "ID da VCN onde o cluster OKE será criado"
  type        = string
}

variable "cluster_options_add_ons_is_kubernetes_dashboard_enabled" {
  description = "Habilitar dashboard do Kubernetes"
  type        = bool
  default     = false
}

variable "cluster_options_add_ons_is_tiller_enabled" {
  description = "Habilitar Tiller"
  type        = bool
  default     = false
}

variable "cluster_options_admission_controller_options_is_pod_security_policy_enabled" {
  description = "Habilitar política de segurança de pods"
  type        = bool
  default     = false
}

variable "cluster_options_kubernetes_network_config_pods_cidr" {
  description = "CIDR para pods do Kubernetes"
  type        = string
  default     = "10.244.0.0/16"
}

variable "cluster_options_kubernetes_network_config_services_cidr" {
  description = "CIDR para serviços do Kubernetes"
  type        = string
  default     = "10.96.0.0/16"
}

variable "load_balancer_subnet_ids" {
  description = "IDs das subnets para load balancers"
  type        = list(string)
}

variable "cluster_endpoint_config_is_public_ip_enabled" {
  description = "Habilitar IP público para o endpoint do cluster"
  type        = bool
  default     = false
}

variable "endpoint_subnet_id" {
  description = "ID da subnet para o endpoint do cluster"
  type        = string
}

variable "endpoint_nsg_ids" {
  description = "IDs dos grupos de segurança de rede para o endpoint do cluster"
  type        = list(string)
  default     = []
}

variable "nodepool_name" {
  description = "Nome do nodepool"
  type        = string
}

variable "node_shape" {
  description = "Shape das VMs do nodepool"
  type        = string
  default     = "VM.Standard.E3.Flex"  # Shape mais econômico com Flex
}

variable "node_shape_config" {
  description = "Configuração do shape das VMs do nodepool"
  type = object({
    ocpus         = number
    memory_in_gbs = number
  })
  default = {
    ocpus         = 1  # Configuração mínima para economizar
    memory_in_gbs = 8
  }
}

variable "node_image_id" {
  description = "ID da imagem para as VMs do nodepool"
  type        = string
}

variable "node_count" {
  description = "Número de nós no nodepool"
  type        = number
  default     = 1  # Mínimo de nós para economizar
}

variable "availability_domain" {
  description = "Availability Domain para os nós do nodepool"
  type        = string
}

variable "nodepool_subnet_id" {
  description = "ID da subnet para o nodepool"
  type        = string
}

variable "ssh_public_key" {
  description = "Chave SSH pública para acesso aos nós"
  type        = string
  default     = ""
}

variable "defined_tags" {
  description = "Tags definidas para recursos do OKE"
  type        = map(string)
  default     = {}
}

variable "freeform_tags" {
  description = "Tags livres para recursos do OKE"
  type        = map(string)
  default     = {}
} 