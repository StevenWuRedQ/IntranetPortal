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


You can simply add the following content to your web-page:

<%@ Register Assembly="ActiveDatabaseSoftware.ActiveQueryBuilder2.Web.Control" Namespace="ActiveDatabaseSoftware.ActiveQueryBuilder.Web.Control" TagPrefix="AQB" %>
<html>
    <head runat="server">
        <title></title>
    </head>
    <body>
        <form id="Form1" runat="server">
            <AQB:QueryBuilderControl ID="QueryBuilderControl1" runat="server" OnInit="QueryBuilderControl1_Init" />
            <div id="all">
                <div id="content-container">
                    <div id="qb-ui">
                        <AQB:ObjectTree ID="ObjectTree1" runat="server" ShowFields="true" />
                        <div id="center">
                            <AQB:Canvas ID="Canvas1" runat="server" />
                            <AQB:Grid ID="Grid1" runat="server" />
                            <AQB:StatusBar ID="StatusBar1" runat="server" />
                        </div>
                        <div class="clear"></div>
                    </div>
                </div>
                <AQB:SqlEditor ID="SQLEditor1" runat="server"></AQB:SqlEditor>
            </div>
        </form>

    </body>
</html>

Place your initialization code in the QueryBuilderControl.Init event handler. 
There you should create Metadata and Syntax provider components and link these 
providers to the QueryBuilder object by setting the MetadataProvider and 
SyntaxProvider properties. Define a proper database connection object as a 
source for the Metadata provider or load metadata from the XML file.

private void QueryBuilderControl1_Init(object sender, EventArgs e)
{
    // Get instance of the QueryBuilder object
    QueryBuilder queryBuilder = QueryBuilderControl1.QueryBuilder;

    // create an instance of the proper syntax provider for your database server. 
    // - use AutoSyntaxProvider if you want to detect your database server automatically 
    //   (autodetection works in case of live database connection only);
    // - use ANSI or Universal syntax provider only if you can't find the right syntax 
    //   provider for your database server.
    MSSQLSyntaxProvider syntaxProvider = new MSSQLSyntaxProvider(); 

    queryBuilder.SyntaxProvider = syntaxProvider;

    // ===========================================================
    // a) you can load metadata from the database connection using live database connection
    
    OleDbConnection connection = new OleDbConnection();
    connection.ConnectionString = "<your connection string here>";

    OLEDBMetadataProvider metadataProvider = new OLEDBMetadataProvider();
    metadataProvider.Connection = connection;

    queryBuilder.MetadataProvider = metadataProvider;

    // call the RefreshMetadata to load metadata from a database connection 
    queryBuilder.MetadataStructure.Refresh();


    // ===========================================================
    // b) or you can load metadata from the pre-generated XML file
        
	// queryBuilder.MetadataContainer.ImportFromXML(Server.MapPath("PATH_TO_XML_FILE"));
	// queryBuilder.MetadataStructure.Refresh();
}