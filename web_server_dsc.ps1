# Now, it's a little easier with powershell to install an IIS server and ensure it has the proper certificate.

Import-Module WebAdministration

$host_list = Read-Host -prompt 'what servers are you installing?'

$files_to_copy = Read-Host -prompt 'where are your source files?'


Configuration WebDeploy {
    Import-DSCResource - Modulename PsDesiredStateConfiguration

    Node $host_list {
        WindowsFeathure WebServer {
            Ensure = 'Present'
            Name = 'Web-Server'
            
        }

        File WebSite{
            Ensure = 'Present'
            SourcePath = $files_to_copy
            DestinationPath = 'c:\inetpub\wwwroot'
        }

        Script AddSSLCert {
            # this is where we can test the presence for a cert and install it.
            SetScript{
                $cert_location = Get-ChildItem -path #Location of certs
                Set-ItemProperty $IIS_variable_for_site
                # add the cert from the web server store.
                
            }

        }
    }
}