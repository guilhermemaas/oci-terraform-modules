/**
 * # OCI Compartment Module
 * Este módulo cria compartimentos no OCI, com suporte a compartimentos aninhados
 */

# Criar compartimento
resource "oci_identity_compartment" "compartment" {
  compartment_id = var.parent_compartment_id
  name           = var.compartment_name
  description    = var.compartment_description
  enable_delete  = var.enable_delete

  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
} 