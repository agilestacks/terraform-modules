data "template_file" "kubeconfig" {
  template = "${file("${path.module}/configure.sh")}"

  vars {
    cluster     = "${element(split(":", element(split("://", "${var.server}"), 1)), 0)}"
    server      = "${var.server}"
    ca_pem      = "${local_file.ca_pem.filename}"
    client_key  = "${local_file.client_key.filename}"
    client_pem  = "${local_file.client_pem.filename}"
    namespace   = "${var.namespace}"
    use_context = "${var.use_context}"
  }
}

data "template_file" "kubeconfig_delete" {
  template = "${file("${path.module}/unconfigure.sh")}"

  vars {
    cluster = "${element(split(":", element(split("://", "${var.server}"), 1)), 0)}"
  }
}

resource "local_file" "client_pem" {
  content  = "${var.client_pem}"
  filename = "${path.cwd}/.terraform/${replace(element(split(":", element(split("://", "${var.server}"), 1)), 0), ".", "-")}-client.pem"

  lifecycle {
    create_before_destroy = true
  }
}

resource "local_file" "client_key" {
  content  = "${var.client_key}"
  filename = "${path.cwd}/.terraform/${replace(element(split(":", element(split("://", "${var.server}"), 1)), 0), ".", "-")}-client-key.pem"
}

resource "local_file" "ca_pem" {
  content  = "${var.ca_pem}"
  filename = "${path.cwd}/.terraform/${replace(element(split(":", element(split("://", "${var.server}"), 1)), 0), ".", "-")}-ca.pem"

  lifecycle {
    create_before_destroy = true
  }
}

resource "local_file" "configure" {
  content  = "${data.template_file.kubeconfig.rendered}"
  filename = "${path.cwd}/.terraform/${replace(element(split(":", element(split("://", "${var.server}"), 1)), 0), ".", "-")}-kubeconfig.sh"
  provisioner "local-exec" {
    command = "chmod +x ${self.filename}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "local_file" "unconfigure" {
  content  = "${data.template_file.kubeconfig_delete.rendered}"
  filename = "${path.cwd}/.terraform/${replace(element(split(":", element(split("://", "${var.server}"), 1)), 0), ".", "-")}-unkubeconfig.sh"
  provisioner "local-exec" {
    command = "chmod +x ${self.filename}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "null_resource" "configure" {
  depends_on = ["local_file.configure",
                "local_file.unconfigure"]

  provisioner "local-exec" {
    command = "[ \"${var.apply}\" = \"true\" ] && sh ${local_file.configure.filename}"
  }

  provisioner "local-exec" {
    on_failure = "continue"
    when = "destroy"
    # this is originally `sh ${local_file.unconfigure.filename}`, but
    # * module.kubeconfig.null_resource.configure (destroy): 1 error(s) occurred:
    # * Resource 'local_file.unconfigure' not found for variable 'local_file.unconfigure.filename'
    command = "[ \"${var.apply}\" = \"true\" ] && sh ${path.cwd}/.terraform/${replace(element(split(":", element(split("://", "${var.server}"), 1)), 0), ".", "-")}-unkubeconfig.sh"
  }
}

resource "local_file" "dummy_kubeconf" {
  filename = "${path.cwd}/.terraform/${replace(element(split(":", element(split("://", "${var.server}"), 1)), 0), ".", "-")}-kubeconf.dummy"
  content = "${file("${path.module}/kubeconfig.dummy")}"

  lifecycle {
    create_before_destroy = true
  }
}
