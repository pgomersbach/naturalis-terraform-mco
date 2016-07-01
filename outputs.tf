output "customer" {
    value = "${var.customer}"
}

output "environment" {
    value = "${var.environment}"
}

output "mco server  address" {
    value = "${openstack_compute_floatingip_v2.mco_client.address}"
}


