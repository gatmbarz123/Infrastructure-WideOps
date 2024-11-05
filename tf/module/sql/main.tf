resource "google_sql_database_instance" "sql_instance" {
  name             = "wordpress-db"
  database_version = "MYSQL_8.4"
  region           = var.region

  deletion_protection = false

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled = false  
      private_network = var.vpc_name
    }
  }
}


resource "google_sql_user" "my_sql_user" {
  name     = var.db_usr
  instance = google_sql_database_instance.my_sql_instance.name
  password = var.db_pws 
}