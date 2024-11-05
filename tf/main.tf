terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.5.0"
    }
  }

  backend "gcs" {
    bucket = "bar-gutman-wideops-project"
    prefix = "tfstate.json"
  }

  required_version = "~> 1.7, < 2.0"
}

provider "google" {
  credentials = file(var.key)
  project     = var.project_name
  region      = var.region
}



module "vpc"{
  source  = "./module/vpc"
  region  = var.region
  project_name  = var.project_name
}

module "gke"{
  source  = "./module/gke"
  region  = var.region
  project_name  = var.project_name
  vpc_name  = module.vpc.vpc_name
  subnet_name = module.vpc.subnet_name
  service_account = var.service_account
}

module "sql"{
  source  = "./module/sql"
  region  = var.region
  project_name  = var.project_name
  vpc_name  = module.vpc.vpc_name
  db_usr  = var.db_usr
  db_pws  = var.db_pws
  vpc_network_self_link  = module.vpc.network_self_link
  subnet_name = module.vpc.subnet_name
}
