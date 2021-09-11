<#
	SYNOPSIS
		Deploy Azure resources
#>

# Load configuration file to read settings
$ConfigFilePath = "config.ini";
Get-Content $ConfigFilePath | foreach-object -begin {$h=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $h.Add($k[0], $k[1]) } }

#Define global parameters
$nl = "`r`n";
$Location = $h.Location;
$ResourceGroupName = $h.ResourceGroupName;
$EnvironmentPrefix = $h.EnvironmentPrefix;
$SqlServerName = $EnvironmentPrefix + "-" + $h.SqlServerName;

Write-Host "$nl********* Please login to continue *********"
# Connect to Azure account
# Connect-AzAccount -Subscription $h.SubscriptionId;

clear;

$nl;
Write-Host "$nl********** Provisioning resource group $ResourceGroupName in $Location"
./base/provision-resourcegroup.ps1;
Write-Host "Done..."

# Create SQL Server
Write-Host "$nl********** Provisioning SQL Server **********"
./base/provision-sql-server.ps1 -SqlServerName $SqlServerName `
                                -AutosetServerFirewallRule $true `
                                -AllowAllAzureIps $true;

./base/provision-database.ps1 -SqlServerName $SqlServerName `
                                -DatabaseName $h.DatabaseName `
                                -Edition $h.Edition;
