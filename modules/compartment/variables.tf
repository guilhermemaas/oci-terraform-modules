variable "parent_compartment_id" {
  description = "OCID do compartimento pai onde o compartimento será criado"
  type        = string
}

variable "compartment_name" {
  description = "Nome do compartimento"
  type        = string
}

variable "compartment_description" {
  description = "Descrição do compartimento"
  type        = string
}

variable "enable_delete" {
  description = "Se o compartimento pode ser excluído"
  type        = bool
  default     = false
}

variable "defined_tags" {
  description = "Tags definidas para o compartimento"
  type        = map(string)
  default     = {}
}

variable "freeform_tags" {
  description = "Tags livres para o compartimento"
  type        = map(string)
  default     = {}
} 