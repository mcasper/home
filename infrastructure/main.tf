variable "digitalocean_token" {}

provider "digitalocean" {
  token = "${var.digitalocean_token}"
}

resource "digitalocean_droplet" "home-web" {
  image  = "ubuntu-18-04-x64"
  name   = "home-web"
  region = "sfo2"
  size   = "s-1vcpu-1gb" # Smallest size, $5/mo
  backups = true
  ssh_keys = ["${digitalocean_ssh_key.home-web.fingerprint}"]
}

resource "digitalocean_ssh_key" "home-web" {
  name       = "Home Web"
  public_key = "${file("/Users/mattcasper/.ssh/id_rsa.pub")}"
}

resource "digitalocean_floating_ip" "home-web" {
  droplet_id = "${digitalocean_droplet.home-web.id}"
  region     = "${digitalocean_droplet.home-web.region}"
}
