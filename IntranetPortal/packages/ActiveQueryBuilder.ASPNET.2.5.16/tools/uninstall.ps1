param($installPath, $toolsPath, $package, $project)

. (Join-Path ($toolsPath -replace "\\net\d\d\\*", "") common.ps1)
. (Join-Path ($toolsPath -replace "\\net\d\d\\*", "") process.ps1)

$ver = $package.Version -replace "\.", "_";

function Uninstall() {
	if (ProcessMvc4Razor($true)) { return $true; }
	if (ProcessMvc4($true)) { return $true; }
	if (ProcessMvc3Razor($true)) { return $true; }
	if (ProcessMvc3($true)) { return $true; }
	return $false;
}

Uninstall
