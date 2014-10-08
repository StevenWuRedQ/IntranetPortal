param($installPath, $toolsPath, $package, $project)
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

$version = $package.Version -replace '(\d+\.\d+\.\d+).*', '$1'
$ver = $version -replace "\.", "_";

. (Join-Path ($toolsPath -replace "\\net\d\d\\*", "") common.ps1)
. (Join-Path ($toolsPath -replace "\\net\d\d\\*", "") process.ps1)

function Check() {
	$oldVersion = GetCurrentVersion
	Write-Host "Package version is [$version]"
	Write-Host "Detect version is [$oldVersion]"
	$match = ($version -eq $oldVersion)
	Write-Host "Version is match [$match]"
	if ($oldVersion -ne $null) {
		return $match
	}
	return $true;
}

function Install() {
	if (ProcessMvc4Razor) { return $true; }
	if (ProcessMvc4) { return $true; }
	if (ProcessMvc3Razor) { return $true; }
	if (ProcessMvc3) { return $true; }
	if (ProcessWebApp) { return $true; }
	return $false;
}

if (Check) {
	Install
	UpdateReferences
	return $true
} else {
	$errorMsg = "An old version of Active Query Builder is installed in your system. Please update the component by downloading the new version from Active Query Builder web site and installing it. After that repeat installation of the package.";
	[System.Windows.Forms.MessageBox]::Show($errorMsg, "Error") 
	if (IsFullInstalled) { 
		[System.Diagnostics.Process]::Start("http://www.activequerybuilder.com/member/index.php");
	} else { 
		[System.Diagnostics.Process]::Start("http://www.activequerybuilder.com/trequest.html?request=asp");
	}
	throw $errorMsg
}