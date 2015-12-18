<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ViewAcris.aspx.vb" Inherits="IntranetPortal.ViewAcris" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script>
        function GoToAcris()
        {
            var bble = String(document.getElementById('txtBBLE').value)
            if(bble)
            {
                var boro = bble.substr(0, 1);
                var block = bble.substr(1, 5)
                var lot = bble.substr(6, bble.length-6)
                window.open('http://a836-acris.nyc.gov/bblsearch/bblsearch.asp?max_rows=99&borough=' + boro + '&block=' + block + "&lot=" + lot);
            }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
       BBLE: <input  type="text" id="txtBBLE"/>
        <button type="button" onclick="GoToAcris()">GoToAcris</button>
    </div>
    </form>
</body>
</html>
