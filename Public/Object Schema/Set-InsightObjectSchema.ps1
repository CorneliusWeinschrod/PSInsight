<#

.SYNOPSIS
Sets\Updates object schema
.EXAMPLE
Set-InsightObjectSchema -ID 3 -Name "MyObjectSchema" -ObjectSchemaKey "MOS" -Description "My New Object Schema - Updated" -InsightApiKey $InsightApiKey
.OUTPUTS
id              : 1
name            : MyObjectSchema
objectSchemaKey : MOS
status          : Ok
description     : My New Object Schema - Updated
created         : 2020-09-16T00:22:31.948Z
updated         : 2020-09-16T00:22:31.963Z
objectCount     : 0
objectTypeCount : 0
.LINK
https://documentation.mindville.com/display/INSCLOUD/REST+API+-+Object+schema

#>


function Set-InsightObjectSchema {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [int]$ID,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$ObjectSchemaKey,

        [Parameter(Mandatory = $false)]
        [string]$Description,

        [ValidateNotNullOrEmpty()]
        [string]$InsightApiKey
    )
    
    begin {
        #Generate Headers
        $headers = New-InsightHeaders -ApiKey $InsightApiKey
    }
    
    process {
        $Request = [System.UriBuilder]"https://insight-api.riada.io/rest/insight/1.0/objectschema/$($ID)"

        $RequestBody = @{
            'name'              = $Name
            'objectSchemaKey'   = $ObjectSchemaKey
            }
            If($Description){
            $RequestBody.Add('description',$Description)
            }
        
        $RequestBody = ConvertTo-Json $RequestBody -Depth 1
    }
    
    end {
        try {
            $response = Invoke-RestMethod -Uri $Request.Uri -Headers $headers -Body $RequestBody -Method PUT
        }
        catch {
            Write-Error -Message "$($_.Exception.Message)" -ErrorId $_.Exception.Code -Category InvalidOperation
        }
        
        Write-Output $response
        }
}