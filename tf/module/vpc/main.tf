module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.3.0"  


  project_id   = var.project_name
  network_name = "wideops-vpc"
  routing_mode = "REGIONAL"

  subnets = [
    {
      subnet_name           = "private"
      subnet_ip             = "10.0.0.0/20"
      subnet_region         = var.region
      subnet_private_access = "true"
      subnet_flow_logs      = "false"
    }

  ]
  secondary_ranges = {
        private = [
            {
                range_name    = "pod-secondary-01"
                ip_cidr_range = "10.1.0.0/24"
            },

            {
                range_name    = "service-secondary-02"
                ip_cidr_range = "10.2.0.0/24"
            }
        ]
  }

}

#----------------------------------------------------------------------------------#

module "cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = ">=0.3.0"

  name    = "router"
  project = var.project_name
  region  = var.region
  network = module.vpc.network_name
  depends_on = [module.vpc]

  nats = [{
    name                               = "nat"
    nat_ip_allocate_option             = "AUTO_ONLY"
    source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  }]
}

#----------------------------------------------------------------------------------#




