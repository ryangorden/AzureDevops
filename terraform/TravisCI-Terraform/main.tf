# terraform init -backend-config=backend-config.txt

# variables


variable "naming_prefix" {
    type    =  string
    default = "itma"
}

locals {
    full_rg_name = "${terraform.workspace}-${var.resource_group_name[2]}"
}

provider "azurerm" {
 features {}
 
}

# resources

resource "random_integer" "sa_num" {
    min = 10000
    max = 99999
}

resource "azurerm_resource_group" "setup" {
    name     = var.resource_group_name[2]
    location = var.location[0]
}

# create storage account
resource "azurerm_storage_account" "sa" {
    name                     = "${lower(var.naming_prefix)}${random_integer.sa_num.result}"
    resource_group_name      = azurerm_resource_group.setup.name
    location                 = var.location[0]
    account_tier             = "Standard"
    account_replication_type = "LRS"

}

# create storage container
resource "azurerm_storage_container" "ct" {
    name                 = "terraform-state"
    storage_account_name = azurerm_storage_account.sa.name
}

data "azurerm_storage_account_sas" "state" {
    connection_string = azurerm_storage_account.sa.primary_connection_string
    https_only        = true

    resource_types {
        service   = true
        container = true
        object    = true
    }

    services {
        blob  = true
        queue = false
        table = false
        file  = false
    }

    start  = timestamp()
    expiry = timeadd(timestamp(), "1750h")

    permissions {
        read = true
        write  = true
        delete  = true
        list    = true
        add     = true
        create  = true
        update  = false
        process = false
    } 
}

# provisionser

# will create a txt file for a record of the information
resource "null_resource" "post-config" {

    depends_on = [azurerm_storage_container.ct]

    provisioner "local-exec" {
        command = <<EOT
echo 'storage_account_name = "${azurerm_storage_account.sa.name}"' >> backend-config.txt
echo 'container_name = "terraform-state"' >> backend-config.txt
echo 'key = "terraform.tfstate"' >> backend-config.txt
echo 'sas_token = "${data.azurerm_storage_account_sas.state.sas}"' >>backend-config.txt
EOT
    }
}

# outputs
output "storage_account_name" {
    value = azurerm_storage_account.sa.name
}

output "resource_group_name" {
    value = azurerm_resource_group.setup.name
}
