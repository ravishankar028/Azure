<#
 .SYNOPSIS
    Provision a resource group.

 .DESCRIPTION
    Creates a new resource group if it does not exist.
#>

$ResourceGroupInfo = Get-AzResourceGroup -Name $ResourceGroupName -ErrorVariable ResourceGroupNotExists -ErrorAction SilentlyContinue

# Create a resource group (if it does not exists)
if($ResourceGroupNotExists)
{
	Write-Host "$nl********** Creating resource group $ResourceGroupName **********"
	New-AzResourceGroup -Name $ResourceGroupName -Location $Location
}
else
{
	Write-Host "$nl********** Resourcegroup already exists **********"
}