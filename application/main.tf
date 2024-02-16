# Create the resource group
resource "azurerm_resource_group" "rg" {
  name     = "myResourceGroup-${var.random_number.result}"
  location = "eastus"
}

locals {
  # linuxwebappname = azurerm_linux_web_app.webapp
  subscription_id = ""
  connection_string = azurerm_application_insights.application_insights.connection_string
  # instrumentation_key = azurerm_application_insights.application_insights.instrumentation_key
}

# Create the Linux App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = "webapp-asp-${var.random_number.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

# Create the web app, pass in the App Service Plan ID
resource "azurerm_linux_web_app" "webapp" {
  name                  = "webapp-${var.random_number.result}"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  service_plan_id       = azurerm_service_plan.appserviceplan.id
  https_only            = true
  site_config { 
    minimum_tls_version = "1.2"
  }
  app_settings = {
    # APPINSIGHTS_INSTRUMENTATIONKEY =  local.instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING = local.connection_string
    ApplicationInsightsAgent_EXTENSION_VERSION = "~3"
  }
}

#  Deploy code from a public GitHub repo
resource "azurerm_app_service_source_control" "sourcecontrol" {
  app_id             = azurerm_linux_web_app.webapp.id
  repo_url           = "https://github.com/Azure-Samples/nodejs-docs-hello-world"
  branch             = "master"
  use_manual_integration = true
  use_mercurial      = false
}

resource "azurerm_application_insights" "application_insights" {
  name                = "tf-test-appinsights"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"

}

# resource "azurerm_log_analytics_workspace" "example" {
#   name                = "workspace-test"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   sku                 = "PerGB2018"
#   retention_in_days   = 30
# }