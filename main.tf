# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.0"
    }
  }
  required_version = ">= 0.14.9"
}

provider "azurerm" {
  subscription_id = ""
  client_id = ""
  client_secret = ""
  tenant_id = ""
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Generate a random integer to create a globally unique name
resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

module "app" {
  source = "./script"
  random_number = random_integer.ri
}