resource "google_sql_database_instance" "sql_instance" {
  name             = "wordpress-db"
  database_version = "MYSQL_5_7"
  region           = var.region

  deletion_protection = false

  settings {
    tier = "db-n1-standard-1"

    ip_configuration {
      ipv4_enabled = false  
      private_network = "projects/${var.project_name}/global/networks/${var.vpc_name}"
    }
  }
  
  depends_on = [google_service_networking_connection.mysql_connection]
}


resource "google_sql_database" "db_mysql" {
  name     = "db_mysql"
  instance = google_sql_database_instance.sql_instance.name
}


resource "google_sql_user" "my_sql_user" {
  name     = var.db_usr
  instance = google_sql_database_instance.sql_instance.name
  password = var.db_pws 
}


#--------------------------------------------------------------------------

resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.vpc_name
}

resource "google_service_networking_connection" "mysql_connection" {
    network = "${var.vpc_name}"
    service = "servicenetworking.googleapis.com"
    reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}



