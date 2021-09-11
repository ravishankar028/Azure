<#
 .SYNOPSIS
    Provision a sql server.

 .DESCRIPTION
    Creates a new sql server instance and configures it.

 .PARAMETER SqlServerName
    Mandatory, a globally unique sql server name.

 .PARAMETER AutosetServerFirewallRule
    Optional, set machine IPV4 address in the server firewall rule. Default is false.

 .PARAMETER AllowAllAzureIps
    Optional, allow other azure services to access the Sql Server. Default is false.
#>

param(
    [Parameter(Mandatory = $true)]
    [string]
    $SqlServerName,

    [Parameter(Mandatory = $false)]
    [ValidateSet ("2.0", "12.0") ]
    [string]
    $SqlVersion = "12.0",

    
    [Parameter()]
    [boolean]
    $AutosetServerFirewallRule = $false,

    [Parameter()]
    [boolean]
    $AllowAllAzureIps = $false
)

$SqlServerInfo = Get-AzSqlServer -ResourceGroupName $ResourceGroupName -ServerName $SqlServerName -ErrorVariable SqlServerError -ErrorAction SilentlyContinue;

if($SqlServerError)
{
    Write-Host "$nl********** Creating SQL Server **********";
    New-AzSqlServer -ResourceGroupName $ResourceGroupName -Location $Location -ServerName $SqlServerName -ServerVersion $SqlVersion -SqlAdministratorCredentials (Get-Credential);
}
else 
{
    Write-Host "$nl********** SQL Server already exists **********"
}

if($AutosetServerFirewallRule)
{
    Write-Host "$nl********** Setting server firewall rule **********"
    $CurrentTimestamp = (Get-Date).ToUniversalTime().ToString("yyyyMMddhhmmss");
    $ServerFirewallRuleName = "Automation-Script-$CurrentTimestamp";

    $ServerFirewallStartIp = (Invoke-WebRequest https://myexternalip.com/raw).Content -replace "`n";
    $ServerFirewallEndIp = $ServerFirewallStartIp;

    $FirewallRule = New-AzSqlServerFirewallRule -ResourceGroupName $ResourceGroupName `
                             -ServerName $SqlServerName `
                             -FirewallRuleName $ServerFirewallRuleName `
                             -StartIpAddress $ServerFirewallStartIp `
                             -EndIpAddress $ServerFirewallEndIp
}

if($AllowAllAzureIps)
{
    Write-Host "$nl********** Setting firewall rule to allow all Azure IPs **********"
    $FirewallRule = New-AzSqlServerFirewallRule -ResourceGroupName $ResourceGroupName `
                             -ServerName $SqlServerName `
                             -AllowAllAzureIPs `
                             -ErrorAction SilentlyContinue;
}