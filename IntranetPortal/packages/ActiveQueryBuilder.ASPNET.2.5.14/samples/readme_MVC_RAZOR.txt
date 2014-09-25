Thank you for installing the Active Query Builder ASP.NET Edition package!      
                                                                                
The sample code below gives an example of the component's usage.                
This code loads metadata from live database connection. It is also possible to  
save metadata to the XML file, so you won't have to create a database connection
for each client session. To load metadata the pregenerated XML file, please     
uncomment the code of loading metadata from XML file and comment the code of    
loading metadata from live database connection in the Init event handler.       
You can learn about saving metadata to the XML file here: http://goo.gl/IzXfKx  
                                                                                
*** Where to find more demo projects and code samples? ***                      
There are many demo projects included in the full or trial installation package 
to illustrate each feature of the component. They are placed in your Documents  
folder under the "Active Query Builder ASP.NET Examples" sub-folder.            
                                                                                
*** I have a question. Where can I ask it? ***                                  
If you have any questions or suggestions on how to improve Active Query Builder 
please post them on the feedback forum at http://goo.gl/1gulol                  
If you cannot find the necessary solutions and answers to your questions using  
the resources below, please submit a support request at http://goo.gl/Smfupl    
                                                                                
You might be interested in the following resources to learn more about          
Active Query Builder:                                                           
                                                                                
Active Query Builder Quick Start Guides: http://goo.gl/e5FMY2                   
Active Query Builder Knowledge Book: http://goo.gl/DBVaXS                       
Active Query Builder ASP.NET Edition Property reference: http://goo.gl/a2oeZk   
Active Query Builder Product Information: http://goo.gl/b6KZSZ                  
Active Query Builder User's Guide: http://goo.gl/DnIggj                         


Add the following content to your \Views\SomeController\SomeAction.cshtml file. 

@using System.Data.OleDb
@using System.Data.SqlClient
@using ActiveDatabaseSoftware.ActiveQueryBuilder
@using ActiveDatabaseSoftware.ActiveQueryBuilder.Web.Mvc.UI
@using ActiveDatabaseSoftware.ActiveQueryBuilder.Web.Server

@Html.ActiveQueryBuilder(settings =>
	{
		settings.HttpCompressionEnabled = false;
		settings.PersistentConnection = false;
		settings.Language = "auto";
		settings.UseCustomLanguageFiles = false;
		settings.CustomLanguagePath = "~/Language Files/";

		settings.Init += (sender, e) =>
		{
			var sessionStoreItem = sender as SessionStoreItem;
			// Get instance of the QueryBuilder object
			var queryBuilder = sessionStoreItem.QueryBuilder;

			// create an instance of the proper syntax provider for your database server.
			// - use AutoSyntaxProvider if you want to detect your database server automatically
			//   (autodetection works in case of live database connection only);
			// - use ANSI or Universal syntax provider only if you can't find the right syntax
			//   provider for your database server.
			var syntaxProvider = new MSSQLSyntaxProvider();

			queryBuilder.SyntaxProvider = syntaxProvider;
			// ===========================================================
			// a) you can load metadata from the database connection using live database connection
			var connection = new SqlConnection {ConnectionString = @"YOUR_CONNECTION_STRING"};
			var metadataProvider = new MSSQLMetadataProvider {Connection = connection};
			queryBuilder.MetadataProvider = metadataProvider;

			// call the RefreshMetadata to load metadata from a database connection
			queryBuilder.MetadataStructure.Refresh();

			// ===========================================================
			// b) or you can load metadata from the pre-generated XML file
			// queryBuilder.OfflineMode = true;
			// queryBuilder.MetadataContainer.ImportFromXML(Server.MapPath("PATH_TO_XML_FILE"));
			// queryBuilder.MetadataStructure.Refresh();
		};
	}).GetHtml()


<div id="all">
	<div id="content-container">
		<div id="qb-ui">
			@Html.ActiveQueryBuilder().ObjectTree(settings =>
				{
					settings.ShowFields = false;
					settings.ShowDescriptons = false;
					settings.SortingType = ObjectsSortingType.None;
					settings.VisiblePaginationLinksCount = 6;
					settings.ItemsPerPage = 24;
					settings.PreloadedPagesCount = 3;
					settings.ShowAllItemInGroupingSelectLists = true;
				}).GetHtml()

			<div id="center">
				@Html.ActiveQueryBuilder().SubQueryNavigationBar(settings =>
					{
						settings.UnionNavBarVisible = true;
					}).GetHtml()
				@Html.ActiveQueryBuilder().Canvas(settings =>
					{
						settings.AllowLinkManipulations = ActiveDatabaseSoftware.ActiveQueryBuilder.Web.Server.Models.LinkManipulations.Allow;
						settings.DefaultDatasourceWidth = "auto";
						settings.DisableDatasourcePropertiesDialog = false;
						settings.DisableLinkPropertiesDialog = false;
						settings.DisableQueryPropertiesDialog = false;
						settings.MaxDefaultDatasourceHeight = "144";
						// settings.FieldListOptions
					}).GetHtml()
				@Html.ActiveQueryBuilder().Grid(settings =>
					{
						settings.OrColumnCount = 2;
					}).GetHtml()
				@Html.ActiveQueryBuilder().StatusBar().GetHtml()
			</div>
			<div class="clear">
			</div>
		</div>
	</div>
	@Html.ActiveQueryBuilder().SqlEditor().GetHtml()
</div>
