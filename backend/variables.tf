variable "cluster_name" {  
}
variable "access_key" {  
}
variable "secret_key" {  
}
variable "cidr" {  
}
variable "azs" { 
  type = "list"  
}
variable "subnets" {
  type = "list" 
}
variable "node_size" { 
}
variable "master_size" { 
}
variable "kub_ver" { 
}
variable "node_q" { 
}
variable "network_p" { 
}
variable "image" { 
}
variable "api_a" {
  type = "list" 
}
variable "ssh_a" { 
  type = "list" 
}
variable "region" { 
}
