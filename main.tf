provider "openstack" {
  user_name  = "${var.user_name}"
  tenant_name = "${var.tenant_name}"
  password  = "${var.password}"
  insecure = true
  auth_url  = "${var.auth_url}"
}

# Template for mco cloud-init bash
resource "template_file" "init_mco_middleware" {
    template = "${file("init_mco_middleware.tpl")}"
}

# Template for mco cloud-init bash
resource "template_file" "init_mco_client" {
    template = "${file("init_mco_client.tpl")}"
    vars {
        middleware_address = "${openstack_compute_instance_v2.mco_middleware.network.0.fixed_ip_v4}"
    }
}

# Template for mco cloud-init bash
resource "template_file" "init_mco_server" {
    template = "${file("init_mco_server.tpl")}"
    vars {
        middleware_address = "${openstack_compute_instance_v2.mco_middleware.network.0.fixed_ip_v4}"
    }
}

resource "openstack_compute_floatingip_v2" "mco_client" {
  region = "${var.region}"
  pool = "${var.pool}"
}

resource "openstack_compute_keypair_v2" "mco" {
  name = "SSH keypair for Terraform mco instances Customer ${var.customer} Environment ${var.environment}"
  region = "${var.region}"
  public_key = "${file("${var.ssh_key_file}.pub")}"
}

resource "openstack_compute_secgroup_v2" "mco" {
  name = "terraform_${var.customer}_${var.environment}"
  region = "${var.region}"
  description = "Security group for the Terraform mco instances"
  rule {
    from_port = 1
    to_port = 65535
    ip_protocol = "tcp"
    cidr = "0.0.0.0/0"
  }
  rule {
    from_port = 1
    to_port = 65535
    ip_protocol = "udp"
    cidr = "0.0.0.0/0"
  }
  rule {
    ip_protocol = "icmp"
    from_port = "-1"
    to_port = "-1"
    cidr = "0.0.0.0/0"
  }
}

resource "openstack_compute_instance_v2" "mco_middleware" {
  name = "mco_middleware"
  region = "${var.region}"
  image_name = "${var.image_ub}"
  flavor_name = "${var.flavor_mco}"
  key_pair = "${openstack_compute_keypair_v2.mco.name}"
  security_groups = [ "${openstack_compute_secgroup_v2.mco.name}" ]
  user_data = "${template_file.init_mco_middleware.rendered}"
  network {
    name = "zooi.network2"
  }
}

resource "openstack_compute_instance_v2" "mco_client" {
  name = "mco_client"
  region = "${var.region}"
  image_name = "${var.image_ub}"
  flavor_name = "${var.flavor_mco}"
  key_pair = "${openstack_compute_keypair_v2.mco.name}"
  security_groups = [ "${openstack_compute_secgroup_v2.mco.name}" ]
  floating_ip = "${openstack_compute_floatingip_v2.mco_client.address}"
  user_data = "${template_file.init_mco_client.rendered}"
  network {
    name = "zooi.network2"
  }
}

resource "openstack_compute_instance_v2" "mco_server" {
  name = "mco_server"
  region = "${var.region}"
  image_name = "${var.image_ub}"
  flavor_name = "${var.flavor_mco}"
  key_pair = "${openstack_compute_keypair_v2.mco.name}"
  security_groups = [ "${openstack_compute_secgroup_v2.mco.name}" ]
  user_data = "${template_file.init_mco_server.rendered}"
  network {
    name = "zooi.network2"
  }
  count = 2
}

