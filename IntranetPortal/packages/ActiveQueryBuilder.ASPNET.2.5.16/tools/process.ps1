$jsFiles = @(
	"~/js/release/jquery.js", 
	"~/js/release/jquery-ui.js", 
	"~/js/release/usr_v$ver.js");

$cssFiles = @(
	"~/css/base.css",
	"~/css/qb/qb.ui.grid.css",
	"~/css/qb/qb.ui.table.css",
	"~/css/qb/qb.ui.tree.css",
	"~/css/jquery.contextMenu.css",
	"~/css/jquery.jPaginate.css",
	"~/css/themes/jquery-ui.css");

function GetJSBlock($pattern) {
	$result = @();
	$result += ($jsFiles | % { [regex]::Replace($pattern, "_FILE_", $_) })
	return $result;
}

function GetCSSBlock($pattern) {
	$result = @();
	$result += ($cssFiles | % { [regex]::Replace($pattern, "_FILE_", $_) })
	return $result;
}

function ProcessFile($file, $check, $replaces) {
	if ($file -eq $null) { return $false; }
	$content = Get-Content $file | Out-String	
	if ([regex]::IsMatch($content, $check, [System.Text.RegularExpressions.RegexOptions]::Multiline)) { 
		return $false; 
	}
	
	$content = ReplaceContent $content $replaces
	
	Set-Content $file $content
	return $true;
}

function ReplaceContent($content, $replaces){
		if ($replaces[0] -is [system.array]) {
			$replaces |% { 
				$content = ReplaceContent $content $_
			}
		} else {
			$content = $content -replace $replaces[0], $replaces[1] 
		}
	return $content;
}

function ClearFile($file, $replaces) {
	if ($file -eq $null) { return $false; }
	$content = Get-Content $file | Out-String	
	
	$content = ClearContent $content $replaces
	
	Set-Content $file $content
	return $true;
}

function ClearContent($content, $replaces){
		if ($replaces[0] -is [system.array]) {
			$replaces |% { 
				$content = ClearContent $content $_
			}
		} else {
			$content = $content -replace $replaces[0], $replaces[1] 
		}
	return $content;
}

function ProcessMvcRoute($uninstall) {
	Write-Host "Process MVC Route"
	$check = 'ActiveDatabaseSoftware.ActiveQueryBuilder.Web.Mvc.Routing.GetRoute';
	$part1 = 'routes.Add(ActiveDatabaseSoftware.ActiveQueryBuilder.Web.Mvc.Routing.GetRoute());';
	$replaces = @( 
		@('(RegisterRoutes\(RouteCollection[^{]*?{\s*?\n)(\s*)', 
			('$1' +
			'$2' + $part1 + "`r`n" + 
			'$2'))
		);
	$replacesUninstall = @('\s*' + (TextToRegex $part1), '');
	
	$file = GetProjectFile "App_Start\RouteConfig.cs"
	if ($file -eq $null) { 
		$file = GetProjectFile "Global.asax\Global.asax.cs"
	}
	if ($file -eq $null) { return; }
	
	if (!$uninstall) {
		ProcessFile $file $check $replaces;
	} else {
		ClearFile $file $replacesUninstall;
	}
}

function ProcessWebApp($uninstall) {
	Write-Host "Process WebApp"
	
	if (!$uninstall) {
		$project.Object.References.Add("System.Windows.Forms");
		OpenFile "samples\readme_WebApp.txt"
	}
	return $true;
}

function ProcessMvc3($uninstall) {
	Write-Host "Process MVC3"
	
	$check = '~/js/release/usr';
	
	$jsPattern = '<script src="<%: Url.Content("_FILE_") %>" type="text/javascript"></script>';
	$cssPattern = '<link href="<%: Url.Content("_FILE_") %>" rel="stylesheet" type="text/css" />';
	
	$jsBlock = '$1' + [string]::Join("`r`n", (GetJSBlock ('$2' + $jsPattern)) + '$2');
	$cssBlock = '$1' + [string]::Join("`r`n", (GetCSSBlock ('$2' + $cssPattern)) + '$2');

	$replaces = @( 
		,@('(<head(?!er).*?>(?:\s*\r\n)*)(\s*)', ($jsBlock)),
		,@('(<head(?!er).*?>(?:\s*\r\n)*)(\s*)', ($cssBlock))
	);
	
	$replacesUninstall = @();
	GetJSBlock ('\s*' + (TextToRegex $jsPattern)) |% { $replacesUninstall += ,@(($_ -replace $ver, '.*?'), '');}
	GetCSSBlock ('\s*' + (TextToRegex $cssPattern)) |% { $replacesUninstall += ,@($_, '');}

	$file = GetProjectFile "Views\Shared\Site.Master"
	
	if ($file -eq $null) { return $false; }
	
	ProcessMvcRoute($uninstall)

	if (!$uninstall) {
		ProcessFile $file $check $replaces;
		OpenFile "samples\readme_MVC.txt"
	} else {
		ClearFile $file $replacesUninstall
	}
	return $true;
}

function ProcessMvc3Razor($uninstall) {
	Write-Host "Process MVC3 Razor"
	
	$check = '~/js/release/usr';

	$jsPattern = '<script src="@Url.Content("_FILE_")" type="text/javascript"></script>';
	$cssPattern = '<link href="@Url.Content("_FILE_")" rel="stylesheet" type="text/css" />';
	
	$jsBlock = '$1' + [string]::Join("`r`n", (GetJSBlock ('$2' + $jsPattern)) + '$2');
	$cssBlock = '$1' + [string]::Join("`r`n", (GetCSSBlock ('$2' + $cssPattern)) + '$2');

	$replaces = @( 
		@('(<head(?!er).*?>(?:\s*\r\n)*)(\s*)', ($jsBlock)),
		@('(<head(?!er).*?>(?:\s*\r\n)*)(\s*)', ($cssBlock))
	);
	
	$replacesUninstall = @();
	GetJSBlock ('\s*' + (TextToRegex $jsPattern)) |% { $replacesUninstall += ,@(($_  -replace $ver, '.*?'), '');}
	GetCSSBlock ('\s*' + (TextToRegex $cssPattern)) |% { $replacesUninstall += ,@($_, '');}

	$file = GetProjectFile "Views\Shared\_Layout.cshtml"
	
	if ($file -eq $null) { return $false; }
	
	ProcessMvcRoute($uninstall)

	if (!$uninstall) {
		ProcessFile $file $check $replaces;
		OpenFile "samples\readme_MVC_RAZOR.txt"
	} else {
		ClearFile $file $replacesUninstall
	}
	return $true;
}

function ProcessMvc4($uninstall) {
	Write-Host "Process MVC4"
	
	$check = 'bundles/ActiveQueryBuilder';
	$bundleReplaces = 
		@('(RegisterBundles\(BundleCollection[^{]*?{\s*?\n)(\s*)', 
			('$1' +
			'$2bundles.Add(new StyleBundle("~/css/ActiveQueryBuilder").Include("' + [string]::Join('", "', $cssFiles) + '"));' + "`r`n" + 
			'$2bundles.Add(new ScriptBundle("~/bundles/ActiveQueryBuilder").Include("' + [string]::Join('", "', $jsFiles) + '"));' + "`r`n" + 
			'$2')
		);
	
	$bundleReplacesUninstall = @(
			@('\s*bundles.Add\(new StyleBundle\("~/css/ActiveQueryBuilder"\).Include\(.*\)\);', ''),
			@('\s*bundles.Add\(new ScriptBundle\("~/bundles/ActiveQueryBuilder"\).Include\(.*\)\);', '')
		);
		
	$siteMasterReplaces = 
		@('(<head(?!er).*?>(?:\s*\r\n)*)(\s*)', 
			('$1' + 
			'$2<%: Scripts.Render("~/bundles/ActiveQueryBuilder") %>' + "`r`n" + 
			'$2<%: Styles.Render("~/css/ActiveQueryBuilder") %>'+ "`r`n" + 
			'$2')
		);
			
	$siteMasterReplacesUninstall =  @(
			@(('\s*' + (TextToRegex '<%: Scripts.Render("~/bundles/ActiveQueryBuilder") %>')), ''),
			@(('\s*' + (TextToRegex '<%: Styles.Render("~/css/ActiveQueryBuilder") %>')), '')
		);

	$file1 = GetProjectFile "App_Start\BundleConfig.cs"
	if ($file1 -eq $null) { return $false; }
	$file2 = GetProjectFile "Views\Shared\Site.Master"
	if ($file2 -eq $null) { return $false; }
	
	ProcessMvcRoute($uninstall)

	if (!$uninstall) {
		ProcessFile $file1 $check $bundleReplaces	
		ProcessFile $file2 $check $siteMasterReplaces
		OpenFile "samples\readme_MVC.txt"
	} else {
		ClearFile $file1 $bundleReplacesUninstall
		ClearFile $file2 $siteMasterReplacesUninstall
	}
	return $true;
}

function ProcessMvc4Razor($uninstall) {
	Write-Host "Process MVC4 Razor"
	
	$check = 'Html.ActiveQueryBuilder';
	$layoutReplaces = @(
		@('^', ('@using ActiveDatabaseSoftware.ActiveQueryBuilder.Web.Mvc.UI' + "`r`n")),
		@('(<head(?!er).*?>(?:\s*\r\n)*)(\s*)', 
			('$1' + 
			'$2@Html.ActiveQueryBuilder().GetCSS()' + "`r`n" + 
			'$2@Html.ActiveQueryBuilder().GetScripts()'+ "`r`n" + 
			'$2' ))
		);	
		
	$layoutReplacesUninstall = @(
		@((TextToRegex '@using ActiveDatabaseSoftware.ActiveQueryBuilder.Web.Mvc.UI'), ''),
		@(('\s*' + (TextToRegex '@Html.ActiveQueryBuilder().GetCSS()')), ''),
		@(('\s*' + (TextToRegex '@Html.ActiveQueryBuilder().GetScripts()')), '')
	);
			
	$file = GetProjectFile "Views\Shared\_Layout.cshtml"
	if ($file -eq $null) { return $false; }
	
	ProcessMvcRoute($uninstall)

	if (!$uninstall) {
		ProcessFile $file $check $layoutReplaces	
		OpenFile "samples\readme_MVC_RAZOR.txt"
	} else {
		ClearFile $file $layoutReplacesUninstall	
	}
	return $true;
}