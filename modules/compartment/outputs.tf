output "compartment_id" {
  description = "OCID do compartimento criado"
  value       = oci_identity_compartment.compartment.id
}

output "compartment_name" {
  description = "Nome do compartimento"
  value       = oci_identity_compartment.compartment.name
}

output "compartment_state" {
  description = "Estado atual do compartimento"
  value       = oci_identity_compartment.compartment.state
} 