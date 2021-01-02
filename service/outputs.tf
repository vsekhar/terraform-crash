output "self_link" {
    value = "http://${google_compute_forwarding_rule.fabula.ip_address}"
}
