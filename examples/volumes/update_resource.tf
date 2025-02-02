provider "oneview" {
  ov_username   = var.username
  ov_password   = var.password
  ov_endpoint   = var.endpoint
  ov_sslverify  = var.ssl_enabled
  ov_apiversion = 2800
  ov_ifmatch    = "*"
}

# Extracting required resource 
data "oneview_scope" "scope_obj" {
  name = "Auto-Scope"
}

data "oneview_storage_pool" "st_pool" {
  name = "CPG-SSD-AO"
}

data "oneview_storage_volume_template" "st_vt" {
  name = "RenameDemoStorageTemplate"
}

# Updates the volume resource created through main.tf
resource "oneview_volume" "volume" {
  properties {
    name              = "testvol"
    storage_pool      = data.oneview_storage_pool.st_pool.uri
    size              = 268435456
    provisioning_type = "Thin"
    is_deduplicated   = false
  }
  template_uri         = data.oneview_storage_volume_template.st_vt.uri
  is_permanent         = true
  name                 = "testvol"
  description          = "Test Volume"
  initial_scope_uris   = [data.oneview_scope.scope_obj.uri]
  provisioned_capacity = "268435456"
}

