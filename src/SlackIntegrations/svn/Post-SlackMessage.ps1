[CmdletBinding()]
Param ( 
	[Parameter(Mandatory=$True,Position=0)]
    [string]$repo =  $(throw "-repo is required."),

	[Parameter(Mandatory=$True,Position=1)]
	[string]$rev =  $(throw "-rev is required.")
 )

 $opt_domain = ""
 $opt_token = ""

 $log = (svnlook log $repo -r $rev)
 $who = (svnlook author $repo -r $rev)
 $url = "https://svn.rgbplus.nl/viewvc/TMS?view=revision&revision=$rev"

 $payload = @{ 
	revision = $rev;
	url = $url;
	author = $who;
	log = $log;
 } 

 $json = ConvertTo-Json $payload -Compress
 $body = "payload=$json";
 Invoke-RestMethod -Method "POST" -Uri "https://$opt_domain/services/hooks/subversion?token=$opt_token"  -Body $body -Verbose
 
 