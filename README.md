# Azure

Executing azure-deployment.ps1 in powershell will create the following resources.
1. Create a new resource group (if it does not already exists) in an Azure subscription specified in config.ini file.
2. Azure SQL server with specified settings in the config.ini file.
3. Azure SQL database in the created sql server with additional properties specified in the config.ini file.

Note: Make sure to update the config.ini file in the root folder prior to executing the azure-master.ps1 script.
