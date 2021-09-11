<#
 .SYNOPSIS
    Provision a sql server.

 .DESCRIPTION
    Creates a new sql server instance and configures it.

 .PARAMETER FunctionAppName
    Mandatory, a globally unique sql server name.
#>

param (
    [Parameter(Mandatory = $true)]
    [string]
    $FunctionAppName,

    [Parameter(Mandatory = $true)]
    [ParameterType]
    $ParameterName
)