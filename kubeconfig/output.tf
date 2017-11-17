output "context" {
  value = "${element(split(":", element(split("://", "${var.server}"), 1)), 0)}"
}

output "ca_filename" {
  value = "${local_file.ca_crt.filename}"
}

output "client_crt_filename" {
  value = "${local_file.client_crt.filename}"
}

output "client_key_filename" {
  value = "${local_file.client_key.filename}"
}

output "dummy_config_filename" {
  value = "${local_file.dummy_kubeconf.filename}"
}
