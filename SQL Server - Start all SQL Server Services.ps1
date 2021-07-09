#function to start all the sql server services on a given server
 
function Start-AllSQLServerServices {
    [cmdletbinding()]
    Param([string]$Server
        , [bool]$StartSQL = $true
        , [bool]$StartAgent = $true
        , [bool]$StartSSRS = $true
        , [bool]$StartBrowser = $true
        , [bool]$StartSSIS = $true
        , [bool]$StartTextDaemon = $true
        , [bool]$StartSSAS = $true)
 
    #Get all the services on the server
    $Services = get-service -ComputerName $Server
 
    if ($StartSQL -eq $true) {
        #check the SQL Server Engine services
        write-verbose &quot; Checking SQL Server Engine Services&quot;
 
        #get all named instances and the default instance
        foreach ($SQLService in $Services | where-object { $_.Name -match &quot; MSSQLSERVER&quot; -or $_.Name -like &quot; MSSQL$*&quot; }) {
            #Check the service running status
            if ($SQLService.status -eq &quot; Stopped&quot; )
            {
                #if stopped start the SQL Server service
                write-verbose &quot; Starting SQL Server Service $($SQLService.Name)&quot;
                $SQLService.Start()
            }
            else
            {
                #Write comfort message that the service is already running
                write-verbose &quot; SQL Server Service $($SQLService.Name) already running&quot;
            }
        }
    }
    else
    {
        write-verbose &quot; Skipping checking SQL Engine services&quot;
    }
 
    if ($StartAgent -eq $true) {
        #check the SQL Server Agent services
        write-verbose &quot; Checking Agent Services&quot;
 
        #get all named agent instances and the default instance
        ForEach ($SQLAgentService in $Services | where-object { $_.Name -match &quot; SQLSERVERAGENT&quot; -or $_.Name -like &quot; SQLAgent$*&quot; }) {
            #check the servcie running status
            if ($SQLAgentService.status -eq &quot; Stopped&quot; )
            {
                #if stopped, start the agent
                write-verbose &quot; Starting SQL Server Agent $($SQLAgentService.Name)&quot;
                $SQLAgentService.Start()
            }
            else
            {
                #write comfort message that the service is already running
                write-verbose &quot; SQL Agent Service $($SQLAgentService.Name) already running&quot;
            }
        }
    }
    else
    {
        write-verbose &quot; Skipping checking Agent services&quot;
    }
 
    if ($StartSSRS -eq $true) {
        #check the SSRS services
        write-verbose &quot; Checking SSRS Services&quot;
 
        #get all reporting service services
        ForEach ($SSRSService in $Services | where-object { $_.Name -match &quot; ReportServer&quot; }) {
            #check the status of the service
            if ($SSRSService.status -eq &quot; Stopped&quot; )
            {
                #if stopped, start the agent
                write-verbose &quot; Starting SSRS Service $($SSRSService.Name)&quot;
                $SSRSService.Start()
            }
            else
            {
                #write comfort message that the service is already running
                write-verbose &quot; SQL Agent Service $($SSRSService.Name) already running&quot;
            }
        }
    }
    else
    {
        write-verbose &quot; Skipping checking SSRS services&quot;
    }
 
    if ($StartSSIS -eq $True) {
 
        #get the SSIS service (should only be one)
        write-verbose &quot; Checking SSIS Service&quot;
 
        #get all services, even though there should only be one
        ForEach ($SSISService in $Services | where-object { $_.Name -match &quot; MsDtsServer*&quot; }) {
            #check the status of the service
            if ($SSISService.Status -eq &quot; Stopped&quot; )
            {
                #if its stopped, start it
                write-verbose &quot; Starting SSIS Service $($SSISService.Name)&quot;
                $SSISService.Start()
            }
            else
            {
                #write comfort message
                write-verbose &quot; SSIS $($SSISService.Name) already running&quot;
            }
        }
    }
    else
    {
        write-verbose &quot; Skipping checking SSIS services&quot;
    }
 
    if ($StartBrowser -eq $true) {
 
        #Check the browser, start it if there are named instances on the box
        write-verbose &quot; Checking SQL Browser service&quot;
 
        #check if there are named services
        if (($services.name -like &quot; MSSQL$*&quot; ) -ne $null)
        {
            #get the browser service
            $BrowserService = $services | where-object { $_.Name -eq &quot; SQLBrowser&quot; }
 
            if ($BrowserService.Status -eq &quot; Stopped&quot; )
            {
                #if its stopped start it
                write-verbose &quot; Starting Browser Server $($BrowserService.Name)&quot;
                $BrowserService.Start()
            }
            else
            {
                #write comfort message
                write-verbose &quot; Browser service $($BrowserService.Name) already running&quot;
            }
        }
        else
        {
            #if no named instances, we don't care about the browser
            write-verbose &quot; No named instances so ignoring Browser&quot;
        }
    }
    else
    {
        write-verbose &quot; Skipping checking Browser service&quot;
    }
 
    if ($StartTextDaemon -eq $True) {
 
        # Start the full text daemons
        write-verbose &quot; Checking SQL Full Text Daemons&quot;
 
        ForEach ($TextService in $Services | where-object { $_.Name -match &quot; MSSQLFDLauncher&quot; }) {
            #check the service status
            if ($TextService.Status -eq &quot; Stopped&quot; )
            {
                #start the service
                write-verbose &quot; Starting Full Text Service $($TextService.Name)&quot;
                $TextService.Start()
            }
            else
            {
                write-verbose &quot; Text service $($TextService.Name) already running.&quot;
            }
        }
    }
    else
    {
        write-verbose &quot; Skipping checking Text Daemon services&quot;
    }
 
    if ($StartSSAS -eq $True) {
 
        # start the SSAS service
        write-verbose &quot; Checking SSAS services&quot;
 
        ForEach ($SSASService in $Services | where-object { $_.Name -match &quot; MSSQLServerOLAP&quot; }) {
            #check the service status
            if ($SSASService.Status -eq &quot; Stopped&quot; )
            {
                #start the service
                Write-verbose &quot; Starting SSAS Service $($SSASService.Name)&quot;
                $SSASService.Start()
            }
            else
            {
                write-verbose &quot; SSAS Service $($SSASService.Name) already running.&quot;
            }
        }
    }
    else
    {
        write-verbose &quot; Skipping checking SSAS services&quot;
    }
}
 
export-modulemember -function Start-AllSQLServerServices