variable "compartment_id" {
  description = "ID do compartimento onde a VCN será criada"
  type        = string
}

variable "vcn_cidr" {
  description = "CIDR da VCN"
  type        = string
}

variable "vcn_name" {
  description = "Nome da VCN"
  type        = string
}

variable "vcn_dns_label" {
  description = "DNS Label da VCN"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR da subnet pública"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR da subnet privada"
  type        = string
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