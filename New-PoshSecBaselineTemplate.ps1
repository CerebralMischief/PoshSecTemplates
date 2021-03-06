function New-PoshSecBaselineTemplate {
	[CmdletBinding()]
	param(
        ## Baseline Parmerter Set
        [Parameter(ParameterSetName='Baseline')]
		[switch]$Baseline,
		[Parameter(ParameterSetName='Baseline')]
		[string]$BaselinePath
	)
    
    begin{
        ## Script Variables
        $local:BaselinePrefix = "Processes"
        $local:BaselineFileErrorMessage = "The path specified does not exist. The baseline was not saved."
    }
    process{
        $local:object = Get-CimInstance -ClassName Win32_Process

    }
    end{
        if($Baseline) {
            $local:Filename = Get-DateISO8601 -Prefix $local:BaselinePrefix -Suffix ".xml"
             
    	    if ($BaselinePath) {
                if (Test-Path -Path $BaselinePath) {
                    $local:FilePath = Join-Path -Path $BaselinePath -ChildPath $local:Filename 
                } else {
                    Write-Warning -Message $local:BaselineFileErrorMessage
                    break
                }
    	    } elseif ($global:PoshSecBaselinePath) {
                if (Test-Path -Path $global:PoshSecBaselinePath) {
                    $local:FilePath = Join-Path -Path $global:PoshSecBaselinePath -ChildPath $local:Filename 
                } else {
                    Write-Warning -Message $local:BaselineFileErrorMessage
                    break
                }
    	    } else {
                if ([System.Environment]::OSVersion.Version.Major -le 5){
					$local:FilePath = Join-Path -Path "$env:USERPROFILE\My Documents" -ChildPath $local:Filename
				} else {
					$local:FilePath = Join-Path -Path $env:USERPROFILE\Documents -ChildPath $local:Filename
				} 
            } 

           $local:object | Export-Clixml $local:FilePath
            
        } else {
            Write-Output $local:object
        }
    }
}