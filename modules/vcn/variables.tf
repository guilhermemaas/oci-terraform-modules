variable "compartment_id" {
  description = "ID do compartimento onde a VCN será criada"
  type        = string
}

variable "vcn_cidr" {
  description = "CIDR da VCN"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vcn_name" {
  description = "Nome da VCN"
  type        = string
}

variable "vcn_dns_label" {
  description = "DNS Label da VCN"
  type        = string
}

variable "kubernetes_api_endpoint_subnet_cidr" {
  description = "CIDR da subnet para o endpoint do Kubernetes API"
  type        = string
  default     = "10.0.0.0/24"
}

variable "node_subnet_cidr" {
  description = "CIDR da subnet para os nós do Kubernetes"
  type        = string
  default     = "10.0.1.0/24"
}

variable "lb_subnet_cidr" {
  description = "CIDR da subnet para os balanceadores de carga"
  type        = string
  default     = "10.0.2.0/24"
}

variable "defined_tags" {
  description = "Tags definidas para recursos de rede"
  type        = map(string)
  default     = {}
}

variable "freeform_tags" {
  description = "Tags livres para recursos de rede"
  type        = map(string)
  default     = {}
} 