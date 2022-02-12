# vars
variable "resource_group_name" {
    type    = list(string)
}

variable "location" {
    type    = list(string)
}

variable "vnet_cidr_range" {
    type    = string

}

variable "vnet_cidr_range_2" {
    type    = string
}

variable "vnet_cidr_range_3" {
    type    = string
}


variable "subnet_prefixes" {
    type    = list(string)
}

variable "subnet_names" {
    type = list(string)
}



variable "prefix" {
  default = "tfvmex"
}

variable "secret" {
    type = string
    sensitive = true
}
