/**
 * # OCI OKE (Oracle Kubernetes Engine) Module
 * Este módulo cria um cluster OKE completo com nodepool
 */

# Data source para obter a região atual
data "oci_identity_region" "current" {}

# Recurso para criar o cluster OKE
resource "oci_containerengine_cluster" "oke_cluster" {
  compartment_id     = var.compartment_id
  kubernetes_version = var.kubernetes_version
  name               = var.cluster_name
  vcn_id             = var.vcn_id
  
  options {
    add_ons {
      is_kubernetes_dashboard_enabled = var.cluster_options_add_ons_is_kubernetes_dashboard_enabled
      is_tiller_enabled               = var.cluster_options_add_ons_is_tiller_enabled
    }
    
    admission_controller_options {
      is_pod_security_policy_enabled = var.cluster_options_admission_controller_options_is_pod_security_policy_enabled
    }
    
    kubernetes_network_config {
      pods_cidr     = var.cluster_options_kubernetes_network_config_pods_cidr
      services_cidr = var.cluster_options_kubernetes_network_config_services_cidr
    }
    
    service_lb_subnet_ids = var.load_balancer_subnet_ids
  }
  
  endpoint_config {
    is_public_ip_enabled = var.cluster_endpoint_config_is_public_ip_enabled
    subnet_id            = var.endpoint_subnet_id
    nsg_ids              = var.endpoint_nsg_ids
  }
  
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

# Recurso para criar nodepool
resource "oci_containerengine_node_pool" "oke_node_pool" {
  cluster_id         = oci_containerengine_cluster.oke_cluster.id
  compartment_id     = var.compartment_id
  kubernetes_version = var.kubernetes_version
  name               = var.nodepool_name
  node_shape         = var.node_shape
  
  node_source_details {
    image_id    = var.node_image_id
    source_type = "IMAGE"
  }
  
  node_config_details {
    size = var.node_count
    placement_configs {
      availability_domain = var.availability_domain
      subnet_id           = var.nodepool_subnet_id
    }
    freeform_tags = var.freeform_tags
    defined_tags  = var.defined_tags
  }
  
  initial_node_labels {
    key   = "name"
    value = var.nodepool_name
  }
  
  ssh_public_key = var.ssh_public_key

  dynamic "node_shape_config" {
    for_each = var.node_shape_config != null ? [1] : []
    content {
      ocpus         = var.node_shape_config.ocpus
      memory_in_gbs = var.node_shape_config.memory_in_gbs
    }
  }
} 