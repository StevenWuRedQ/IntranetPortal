# Underwriting Service Deployment Instruction

## 1. Get Latest release compiled package
- Method 2: Download zipped package from [link](https://bitbucket.org/myidealkings/intranetportal), and unzip it to a temporary folder on your local machine.

## 2. Setup Deployment tools and environment.
1. Make sure Microsoft **Web Deploy** Tools is installed both on your computer and your target IIS Server. 
    * If not, download [here](https://www.iis.net/downloads/microsoft/web-deploy). 
    * When Install on server, select Completed so that install *Web Deployment Agent Service*.
    * After installation, add *msdeploy.exe* to your environment PATH.
2. Make sure *"Web Deployment Agent Service"* service is opened on your target IIS server.

## 3. Change Connection String
1. Use text editor open 'UnderwritingService.SetParameters.xml'.
2. Replace `UnderwritingEntity-Web.config Connection String` with database connection string of your database.
3. Replace `UnderwritingEntity_DatabasePublish-Web.config Connection String` with database connection string of your database.

## 4. Create Site
1. Connect to your IIS web server. Make sure IIS have web socket, and .net 4.5 framework enabled.
1. In IIS manmagement tools, create a site named "underwritingservice". In application pool, make it .net4.0 Intergration.
2. Start the site.
3. Please remember this sites URL, let's name it as **UnderwritingURL** (eg. http://www.underwriting.com)

## 5. Execute Deploy Command
1. In the fold your create in Step 1, Execute
```cmd
UnderwritingService.deploy.cmd /Y /M:{IIS Server Address} /U:{IIS Server UserName} /P:{IIS Server Password}
```

2. *"msdeploy.exe"* should upload package to your IIS automatically and created related database.

## 6. Configure Portal
1. Log on to the server hosting portal service.
2. Under Portal site root folder, modify `Webconfig.json`. Change `UnderwritingServiceServer` to **UnderwritingURL** mentioned in Step 4.

## 7. Testing
1. There is a swagger end point under http://yoursite/swagger, check it out for api infomation.