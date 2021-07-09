# install the IIS packages and dependencies
import-module ServerManager
Install-WindowsFeature -name Web-Server, Web-ASP-Net -IncludeManagementTools