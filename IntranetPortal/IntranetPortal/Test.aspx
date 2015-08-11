<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Test.aspx.vb" Inherits="IntranetPortal.Test" %>

<%@ Register Src="~/UserControl/DocumentsUI.ascx" TagPrefix="uc1" TagName="DocumentsUI" %>
<%@ Register Src="~/UserControl/NavMenu.ascx" TagPrefix="uc1" TagName="NavMenu" %>
<%@ Register Src="~/EmailTemplate/TaskSummary.ascx" TagPrefix="uc1" TagName="TaskSummary" %>
<%@ Register Src="~/EmailTemplate/ActivitySummary.ascx" TagPrefix="uc1" TagName="ActivitySummary" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href='http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900,200italic,300italic,400italic,600italic,700italic,900italic' rel='stylesheet' type='text/css' />
    <link href="/css/font-awesome.css" type="text/css" rel="stylesheet" />
    <link rel="stylesheet" href="css/normalize.min.css" />
    <link rel="stylesheet" href="/Scripts/js/jquery.mCustomScrollbar/jquery.mCustomScrollbar.css" />
    <link rel="stylesheet" href="css/main.css" />
    <script src="/Scripts/js/vendor/modernizr-2.6.2-respond-1.1.0.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <%-- <uc1:TaskSummary runat="server" ID="TaskSummary" />--%>
        <%-- <input type="button" onclick="LoadData()" value="Test" />--%>

        <%-- <uc1:ActivitySummary runat="server" id="ActivitySummary" />--%>
        <asp:Button ID="Button1" runat="server" Text="UpdateCaseName" OnClick="Button1_Click" />
        <asp:Label ID="UpdateStauts" runat="server"></asp:Label>
        <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
        <script>window.jQuery || document.write('<script src="/Scripts/js/vendor/jquery-1.11.0.min.js"><\/script>')</script>
        <script src="/Scripts/js/jquery.easing.1.3.js"></script>
        <script src="/Scripts/js/jquery.debouncedresize.js"></script>
        <script src="/Scripts/js/jquery.throttledresize.js"></script>
        <script src="/Scripts/js/jquery.mousewheel.js"></script>
        <script src="/Scripts/js/jquery.mCustomScrollbar/jquery.mCustomScrollbar.min.js"></script>
        <script src="/Scripts/js/main.js"></script>
        <script src="/Scripts/jquery.collapse.js"></script>
        <script src="/Scripts/jquery.collapse_storage.js"></script>
        <script src="/Scripts/jquery.collapse_cookie_storage.js"></script>
        <script type="text/javascript">

            function LoadData() {
                var url = "https://api.cityofnewyork.us/geoclient/v1/address.json?houseNumber=123&street=main+st&borough=Queens&app_id=be97fb56&app_key=b51823efd58f25775df3b2956a7b2bef";

                $.getJSON(url, function (data) { alert(JSON.stringify(data)); });
            }
            //LoadData();

            function UploadFile() {
                // grab your file object from a file input
                fileData = document.getElementById("fileUpload").files[0];
                var data = new FormData();
                data.append("file", fileData);
                                       
                $.ajax({
                    url: '/api/ConstructionCases/UploadFiles?bble=1004490003&fileName=' + fileData.name,
                    type: 'POST',
                    data: data,
                    cache: false,
                    processData: false, // Don't process the files
                    contentType: false, // Set content type to false as jQuery will tell the server its a query string request
                    success: function (data) {
                        alert(data);
                        alert('successful..');
                    },
                    error: function (data) {
                        alert('Some error Occurred!');
                    }
                });
            }

        </script>
        <div>
            <input type="file" id="fileUpload" value="" />
            <br />
            <br />
            <button id="btnUpload" onclick="UploadFile()" type="button">
                Upload</button>
        </div>

    </form>
</body>
</html>
