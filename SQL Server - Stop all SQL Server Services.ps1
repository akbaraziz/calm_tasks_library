#function to stop all the sql server services on a given server
 
function Stop-AllSQLServerServices {
    [cmdletbinding()]
    Param([string]$Server
        , [bool]$StopSQL = $true
        , [bool]$StopAgent = $true
        , [bool]$StopSSRS = $true
        , [bool]$StopBrowser = $true
        , [bool]$StopSSIS = $true
        , [bool]$StopTextDaemon = $true
        , [bool]$StopSSAS = $true)
 
    #Get all the services on the server
    $Services = get-service -ComputerName $Server
 
    if ($StopAgent -eq $true) {
        #check the SQL Server Agent services
        write-verbose &quot; Checking Agent Services&quot;
 
        #get all named agent instances and the default instance
        ForEach ($SQLAgentService in $Services | where-object { $_.Name -match &quot; SQLSERVERAGENT&quot; -or $_.Name -like &quot; SQLAgent$*&quot; }) {
            #check the servcie running status
            if ($SQLAgentService.status -eq &quot; Running&quot; )
            {
                #if stopped, start the agent
                write-verbose &quot; Stopping SQL Server Agent $($SQLAgentService.Name)&quot;
                $SQLAgentService.Stop()
            }
            else
            {
                #write comfort message that the service is already running
                write-verbose &quot; SQL Agent Service $($SQLAgentService.Name) is already stopped.&quot;
            }
        }
    }
    else
    {
        write-verbose &quot; Skipping checking Agent services&quot;
    }
 
    if ($StopSSRS -eq $true) {
        #check the SSRS services
        write-verbose &quot; Checking SSRS Services&quot;
 
        #get all reporting service services
        ForEach ($SSRSService in $Services | where-object { $_.Name -match &quot; ReportServer&quot; }) {
            #check the status of the service
            if ($SSRSService.status -eq &quot; Running&quot; )
            {
                #if stopped, start the agent
                write-verbose &quot; Stopping SSRS Service $($SSRSService.Name)&quot;
                $SSRSService.Stop()
            }
            else
            {
                #write comfort message that the service is already running
                write-verbose &quot; SSRS Service $($SSRSService.Name) is already stopped.&quot;
            }
        }
    }
    else
    {
        write-verbose &quot; Skipping checking SSRS services&quot;
    }
 
    if ($StopSSIS -eq $True) {
 
        #get the SSIS service (should only be one)
        write-verbose &quot; Checking SSIS Service&quot;
 
        #get all services, even though there should only be one
        ForEach ($SSISService in $Services | where-object { $_.Name -match &quot; MsDtsServer*&quot; }) {
            #check the status of the service
            if ($SSISService.Status -eq &quot; Running&quot; )
            {
                #if its stopped, start it
                write-verbose &quot; Stopping SSIS Service $($SSISService.Name)&quot;
                $SSISService.Stop()
            }
            else
            {
                #write comfort message
                write-verbose &quot; SSIS $($SSISService.Name) already stopped&quot;
            }
        }
    }
    else
    {
        write-verbose &quot; Skipping checking SSIS services&quot;
    }
 
    if ($StopBrowser -eq $true) {
 
        #Check the browser, start it if there are named instances on the box
        write-verbose &quot; Checking SQL Browser service&quot;
 
        #get the browser service
        $BrowserService = $services | where-object { $_.Name -eq &quot; SQLBrowser&quot; }
 
        if ($BrowserService.Status -eq &quot; Running&quot; )
        {
            #if its stopped start it
            write-verbose &quot; Stopping Browser Server $($BrowserService.Name)&quot;
            $BrowserService.Stop()
        }
        else
        {
            #write comfort message
            write-verbose &quot; Browser service $($BrowserService.Name) is already stopped&quot;
        }
    }
    else
    {
        write-verbose &quot; Skipping checking Browser service&quot;
    }
 
    if ($StopTextDaemon -eq $True) {
 
        # Start the full text daemons
        write-verbose &quot; Checking SQL Full Text Daemons&quot;
 
        ForEach ($TextService in $Services | where-object { $_.Name -match &quot; MSSQLFDLauncher&quot; }) {
            #check the service status
            if ($TextService.Status -eq &quot; Running&quot; )
            {
                #start the service
                write-verbose &quot; Stopping Full Text Service $($TextService.Name)&quot;
                $TextService.Stop()
            }
            else
            {
                write-verbose &quot; Text service $($TextService.Name) is already stopped.&quot;
            }
        }
    }
    else
    {
        write-verbose &quot; Skipping checking Text Daemon services&quot;
    }
 
    if ($StopSSAS -eq $True) {
 
        # start the SSAS service
        write-verbose &quot; Checking SSAS services&quot;
 
        ForEach ($SSASService in $Services | where-object { $_.Name -match &quot; MSSQLServerOLAP&quot; }) {
            #check the service status
            if ($SSASService.Status -eq &quot; Running&quot; )
            {
                #start the service
                Write-verbose &quot; Stopping SSAS Service $($SSASService.Name)&quot;
                $SSASService.Stop()
            }
            else
            {
                write-verbose &quot; SSAS Service $($SSASService.Name) is already stopped.&quot;
            }
        }
    }
    else
    {
        write-verbose &quot; Skipping checking SSAS services&quot;
    }
 
    if ($StopSQL -eq $true) {
        #check the SQL Server Engine services
        write-verbose &quot; Checking SQL Server Engine Services&quot;
 
        #get all named instances and the default instance
        foreach ($SQLService in $Services | where-object { $_.Name -match &quot; MSSQLSERVER&quot; -or $_.Name -like &quot; MSSQL$*&quot; }) {
            #Check the service running status
            if ($SQLService.status -eq &quot; Running&quot; )
            {
                #if stopped start the SQL Server service
                write-verbose &quot; Stoppin SQL Server Service $($SQLService.Name)&quot;
                $SQLService.Stop()
            }
            else
            {
                #Write comfort message that the service is already running
                write-verbose &quot; SQL Server Service $($SQLService.Name) is already stopped&quot;
            }
        }
    }
    else
    {
        write-verbose &quot; Skipping checking SQL Engine services&quot;
    }
 
}
 
export-modulemember -function Stop-AllSQLServerServices