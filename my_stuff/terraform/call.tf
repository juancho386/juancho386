provider "aws" {}
module "rooms" {
  source    = "./module_meet_rooms"
  region    = "us-west-2"
  subdomain = "rooms"
  domain    = "goats.to"
  salas = [
    ["ninjas",       "fmn-roms-jcn", "Where the ninjas meet"],
    ["dragons",      "mju-mwjs-vyx", "Here would be dragons"],
    ["secret-place", "mhf-axet-dae", "Nobody know you are here"]
  ]
}

