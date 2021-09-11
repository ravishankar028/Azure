<#
 .SYNOPSIS
    Provision a sql server database.

 .DESCRIPTION
    Creates a new sql server database instance and configures it.

 .PARAMETER SqlServerName
    Mandatory, a globally unique sql server name.

 .PARAMETER DatabaseName
    Mandatory, name of the database.

 .PARAMETER Edition
    Optional, edition or pricing tier of the database to be created.

#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $SqlServerName,

    [Parameter(Mandatory = $true)]
    [string]
    $DatabaseName,

    [Parameter(Mandatory = $true)]
    [string]
    $Edition
)

Write-Host "$nl********** Creating database $DatabaseName **********"
New-AzSqlDatabase -ResourceGroupName $ResourceGroupName -ServerName $SqlServerName -DatabaseName $DatabaseName -Edition $Edition
Write-Host "Done"

