<#
	SYNOPSIS
		Deploy Azure resources
#>

# Load configuration file to read settings
$ConfigFilePath = ".\config\config.ini";
Get-Content $ConfigFilePath | foreach-object -begin {$h=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $h.Add($k[0], $k[1]) } }

#Define global parameters
$nl = "`r`n";

# Display the settings config
$h;

# Connect to Azure account
# Connect-AzAccount -Subscription $h.SubscriptionId

# Get resource groups info within the subscription
Write-Host "$nl********** Getting resource group information **********"
Get-AzResourceGroup

# Get a specific resource group within the subscrption
Write-Host "$nl********** Getting resource group information - $h.ResourceGroupName **********"
Get-AzResourceGroup -Name $h.ResourceGroupName -ErrorVariable ResourceGroupNotExists -ErrorAction SilentlyContinue

# Create a resource group (if it does not exists)
if($ResourceGroupNotExists)
{
	Write-Host "$nl********** Creating resource group $ResourceGroupName **********"
	New-AzResourceGroup -Name $h.ResourceGroupName -Location $h.ResourceGroupLocation
}
else
{
	Write-Host "$nl********** Resource group already exists **********"
}

# Create a virtual machine using powershell

## VM Account
# Credentials for Local Admin account you created in the sysprepped (generalized) vhd image
$VMPassword = ConvertTo-SecureString $h.VMPassword -AsPlainText -Force

$VMCredential = New-Object System.Management.Automation.PSCredential ($h.VMUserName, $VMPassword);

$VirtualMachineConfig = New-AzVMConfig -VMName $h.VMName -VMSize $h.VMSize
$VirtualMachineConfig = Set-AzVMOperatingSystem -VM $VirtualMachineConfig -Windows -ComputerName $h.ComputerName -Credential $VMCredential -ProvisionVMAgent -EnableAutoUpdate

# Create a virtual machine
New-AzVM -ResourceGroupName $h.ResourceGroupName -Location $h.ResourceGroupLocation -VM $VirtualMachineConfig -Verbose
