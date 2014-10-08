function OpenFile($fileName) {
	try {
		$fullPath = Join-Path $installPath $fileName;
		$DTE.ItemOperations.OpenFile($fullPath);
	}
	catch{}
}

function TextToRegex($text) {
	$replaces = @(
		@('[[\\^$.|?*+(){}]','\$0'),
		@('\s+','\s+')
	);
	$replaces |% { $text = $text -replace $_[0], $_[1]; }
	return $text;
}

Function GetProjectItem($path)
{
	try {
		$parts = $path.split("\");
		if ($parts.length -eq 1) { return $project.ProjectItems.Item($parts[0]); }
		if ($parts.length -eq 2) { return $project.ProjectItems.Item($parts[0]).ProjectItems.Item($parts[1]); }
		if ($parts.length -eq 3) { return $project.ProjectItems.Item($parts[0]).ProjectItems.Item($parts[1]).ProjectItems.Item($parts[2]); }
		if ($parts.length -eq 4) { return $project.ProjectItems.Item($parts[0]).ProjectItems.Item($parts[1]).ProjectItems.Item($parts[2]).ProjectItems.Item($parts[3]); }
	}
	catch {
	}
	return $null;
}

Function GetProjectFile($path) {
	$item = GetProjectItem($path);
	if ($item -eq $null) { 
		return $null; 
	}
	
	try {
		$file = $item.Open().Document.FullName;
	}
	catch {
		$file = $null;
	}
	return $file;
}

function GetRegistryBranch() {
	$registryKey = Get-Item -Path "HKCU:\Software\Active Database Software\Active Query Builder 2 ASP.NET" -ErrorAction SilentlyContinue
	return $registryKey;
}

function GetUninstallKey() {
	$registryKey = Get-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Active Query Builder 2 ASP.NET Edition_is1" -ErrorAction SilentlyContinue
	if ($registryKey -eq $null) { $registryKey = Get-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Active Query Builder 2 ASP.NET Trial Edition_is1" -ErrorAction SilentlyContinue }
	
	return $registryKey;
}

function GetCurrentVersion() {
	#$registryKey = GetUninstallKey	
	if ($registryKey -ne $null) {
		$version = $registryKey | Get-Item | Get-ItemProperty -Name "DisplayVersion" -ErrorAction SilentlyContinue;
		return $version.DisplayVersion;
	} else {
		$version = GetValueFromRegistryThruWMI "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Active Query Builder 2 ASP.NET Edition_is1" "DisplayVersion";
		if ($version -eq $null) { $version = GetValueFromRegistryThruWMI "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Active Query Builder 2 ASP.NET Trial Edition_is1" "DisplayVersion"; }
	return $version;
	}
	return $null;
}

function GetInstallLocation() {
	$registryKey = GetUninstallKey	
	if ($registryKey -ne $null) {
		$version = $registryKey | Get-Item | Get-ItemProperty -Name "InstallLocation" -ErrorAction SilentlyContinue;
		return $version.InstallLocation;
	} else {
		$version = GetValueFromRegistryThruWMI "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Active Query Builder 2 ASP.NET Edition_is1" "InstallLocation";
		if ($version -eq $null) { $version = GetValueFromRegistryThruWMI "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Active Query Builder 2 ASP.NET Trial Edition_is1" "InstallLocation"; }
		return $version;
	}
	return $null;
}

function GetRegistrarName($registryKey) {
	if ($registryKey -eq $null) { $registryKey = GetRegistryBranch }
	if ($registryKey -eq $null) { return $false; }
	
	$licenseName = $registryKey | Get-Item | Get-ItemProperty -Name "Name" -ErrorAction SilentlyContinue
	if ($licenseName -eq "") {
		$licenseName = $null;
	}
	return $licenseName.Name;
}

function IsTrialInstalled() {
	$registryKey = GetRegistryBranch
	if ($registryKey -eq $null) { return $false; }
	
	$licenseName = GetRegistrarName($registryKey)
	
	if ($licenseName -ne $null) {
		return $false;
	}
	return $true;
}

function IsFullInstalled() {
	$registryKey = GetRegistryBranch
	if ($registryKey -eq $null) { return $false; }
	
	$licenseName = GetRegistrarName($registryKey)
	
	if ($licenseName -eq $null) {
		return $false;
	}
	return $true;
}


function UpdateReferences {
	$project.Object.References |% { 
		if ($_.Name -match 'log4net') {$_.CopyLocal = $true;}
		if ($_.Name -match 'Newtonsoft') {$_.CopyLocal = $true;}
		if ($_.Name -match 'ActiveDatabaseSoftware') {$_.CopyLocal = $true;}
	}
	
	try {
		$installLocation = GetInstallLocation
		Write-Host "Install location is [$installLocation]"
		if ($installLocation)
		{
			$refToAdd = @();
			$project.Object.References | Where {$_.Name -match 'ActiveDatabaseSoftware'} |% { 
				$refToAdd += $_.Name;
				$_.Remove();					
			}
			$newPath = (Join-Path $installLocation "assemblies\.NET 2.0");
			$refToAdd |% { 
				$r = $project.Object.References.Add((Join-Path $newPath ("$_.dll"))); 
				$r.CopyLocal = $true;
			}
		}
	}
	catch {}
}

function Get-Checksum($file) {
    $cryptoProvider = New-Object "System.Security.Cryptography.MD5CryptoServiceProvider"
	
    $fileInfo = Get-Item $file
	trap { ;
	continue } $stream = $fileInfo.OpenRead()
    if ($? -eq $false) {
		# Couldn't open file for reading
        return $null
	}
    
    $bytes = $cryptoProvider.ComputeHash($stream)
    $checksum = ''
	foreach ($byte in $bytes) {
		$checksum += $byte.ToString('x2')
	}
    
	$stream.Close() | Out-Null
    
    return $checksum
}

function AddOrUpdate-Reference($scriptsFolderProjectItem, $fileNamePattern, $newFileName) {
    try {
        $referencesFileProjectItem = $scriptsFolderProjectItem.ProjectItems.Item("_references.js")
    }
    catch {
        # _references.js file not found
        return
    }

    if ($referencesFileProjectItem -eq $null) {
        # _references.js file not found
        return
    }

    $referencesFilePath = $referencesFileProjectItem.FileNames(1)
    $referencesTempFilePath = Join-Path $env:TEMP "_references.tmp.js"

    if ((Select-String $referencesFilePath -pattern $fileNamePattern).Length -eq 0) {
        # File has no existing matching reference line
        # Add the full reference line to the beginning of the file
        "/// <reference path=""$newFileName"" />" | Add-Content $referencesTempFilePath -Encoding UTF8
         Get-Content $referencesFilePath | Add-Content $referencesTempFilePath
    }
    else {
        # Loop through file and replace old file name with new file name
        Get-Content $referencesFilePath | ForEach-Object { $_ -replace $fileNamePattern, $newFileName } > $referencesTempFilePath
    }

    # Copy over the new _references.js file
    Copy-Item $referencesTempFilePath $referencesFilePath -Force
    Remove-Item $referencesTempFilePath -Force
}

function Remove-Reference($scriptsFolderProjectItem, $fileNamePattern) {
    try {
        $referencesFileProjectItem = $scriptsFolderProjectItem.ProjectItems.Item("_references.js")
    }
    catch {
        # _references.js file not found
        return
    }

    if ($referencesFileProjectItem -eq $null) {
        return
    }

    $referencesFilePath = $referencesFileProjectItem.FileNames(1)
    $referencesTempFilePath = Join-Path $env:TEMP "_references.tmp.js"

    if ((Select-String $referencesFilePath -pattern $fileNamePattern).Length -eq 1) {
        # Delete the line referencing the file
        Get-Content $referencesFilePath | ForEach-Object { if (-not ($_ -match $fileNamePattern)) { $_ } } > $referencesTempFilePath

        # Copy over the new _references.js file
        Copy-Item $referencesTempFilePath $referencesFilePath -Force
        Remove-Item $referencesTempFilePath -Force
    }
}

function Delete-ProjectItem($item) {
    $itemDeleted = $false
    for ($1=1; $i -le 5; $i++) {
        try {
            $item.Delete()
            $itemDeleted = $true
            break
        }
        catch {
            # Try again in 200ms
            [System.Threading.Thread]::Sleep(200)
        }
    }
    if ($itemDeleted -eq $false) {
        throw "Unable to delete project item after five attempts."
    }
}

Function GetValueFromRegistryThruWMI($regkey, $value)     {
	try {
		$computername = "localhost";
	    $HKLM = "&h80000002";
	    $objNamedValueSet = New-Object -COM "WbemScripting.SWbemNamedValueSet";
	    $objNamedValueSet.Add("__ProviderArchitecture", 64) | Out-Null;
	    $objLocator = New-Object -COM "Wbemscripting.SWbemLocator";
	    $objServices = $objLocator.ConnectServer($computername,"root\default","","","","","",$objNamedValueSet);
	    $objStdRegProv = $objServices.Get("StdRegProv");
	    $Inparams = ($objStdRegProv.Methods_ | where {$_.name -eq "GetStringValue"}).InParameters.SpawnInstance_();
	    ($Inparams.Properties_ | where {$_.name -eq "Hdefkey"}).Value = $HKLM;
	    ($Inparams.Properties_ | where {$_.name -eq "Ssubkeyname"}).Value = $regkey;
	    ($Inparams.Properties_ | where {$_.name -eq "Svaluename"}).Value = $value;
	    $Outparams = $objStdRegProv.ExecMethod_("GetStringValue", $Inparams, "", $objNamedValueSet);
	       
	    if (($Outparams.Properties_ | where {$_.name -eq "ReturnValue"}).Value -eq 0) {    
	       $result = ($Outparams.Properties_ | where {$_.name -eq "sValue"}).Value;
	       return $result;   
	    }
    } 
	catch {}
	return $null;
}  