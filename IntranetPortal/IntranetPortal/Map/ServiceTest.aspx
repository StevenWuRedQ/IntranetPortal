<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ServiceTest.aspx.vb" Inherits="IntranetPortal.ServiceTest" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
     <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <script>
            //URL: BlockData/{neLat},{neLng},{swLat},{swLng}
            $.getJSON("/map/mapdataservice.svc/BlockData/40.75710752159198,-73.8365364074707,40.725470018092764,-73.9189338684082", function(data)
            {
                document.write(JSON.stringify(data))               
            })      
    </script>
    </div>
    </form>
</body>
</html>
