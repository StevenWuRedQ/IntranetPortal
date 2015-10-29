<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Test.aspx.vb" Inherits="IntranetPortal.Test" %>

<%@ Register Src="~/UserControl/DocumentsUI.ascx" TagPrefix="uc1" TagName="DocumentsUI" %>
<%@ Register Src="~/UserControl/NavMenu.ascx" TagPrefix="uc1" TagName="NavMenu" %>
<%@ Register Src="~/EmailTemplate/TaskSummary.ascx" TagPrefix="uc1" TagName="TaskSummary" %>
<%@ Register Src="~/EmailTemplate/ActivitySummary.ascx" TagPrefix="uc1" TagName="ActivitySummary" %>
<%@ Register Src="~/UserControl/UserSummary.ascx" TagPrefix="uc1" TagName="UserSummary" %>
<%@ Register Src="~/UserControl/MySummary.ascx" TagPrefix="uc1" TagName="MySummary" %>



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
        <asp:Button ID="Button2" runat="server" OnClick="Button2_Click"/>
        <asp:ListBox ID="ListBox1" runat="server" AutoPostBack="true">
            <asp:ListItem Text="What is up" Value="wow"></asp:ListItem>
        </asp:ListBox>
         <asp:Label ID="UpdateStauts" runat="server"></asp:Label>
        <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
        <script>window.jQuery || document.write('<script src="/Scripts/js/vendor/jquery-1.11.0.min.js"><\/script>')</script>
        <script src="/Scripts/js/jquery.easing.1.3.js"></script>
        <script src="/Scripts/js/jquery.debouncedresize.js"></script>
        <script src="/Scripts/js/jquery.throttledresize.js"></script>
        <script src="/Scripts/js/jquery.mousewheel.js"></script>
        <script src="/Scripts/js/jquery.mCustomScrollbar/jquery.mCustomScrollbar.min.js"></script>
        <script src="/Scripts/js/main.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/3.10.1/lodash.js"></script>
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
                fileData = document.getElementById("fileUpload").files;
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
        Notes Josn
        <asp:TextBox ID="CropNotes" runat="server"></asp:TextBox>
        <dx:ASPxGridView ID="CropGrid" runat="server" OnDataBinding="CropGrid_DataBinding" EnableCallbackAnimation="True">
            <Templates>
            </Templates>
        </dx:ASPxGridView>
        <asp:Button ID="TestCrop" runat="server" Text="TestCrop" OnClick="TestCrop_Click" />

        <div>
            <input type="file" id="fileUpload" multiple="multiple" value="" />
            <br />
            <br />
            <button id="btnUpload" type="button">Upload</button>

        </div>
        <hr />

        <button id="updateConstructionFileModel" type="button" onclick="testController.updateFileModel()">update file model</button>


    </form>
</body>
<script>
    var testController = {
        models: ["InitialIntake.UploadDeed", "InitialIntake.UploadEIN", "InitialIntake.UploadFilingReceipt",
                "InitialIntake.UploadArticleOfOperation", "InitialIntake.UploadOperationAgreement", "InitialIntake.UploadGeoDataReport",
                "InitialIntake.UploadCO", "InitialIntake.UploadComps", "InitialIntake.WaterSearchUpload", "InitialIntake.UploadIntakeSheet",
                "InitialIntake.UploadSketchLayout", "InitialIntake.UploadInitialBudget", "InitialIntake.AsbestosUpload",
                "InitialIntake.SurveyUpload", "InitialIntake.ExhibitUpload", "InitialIntake.TRsUpload",
                "Utilities.DEP_PaymentAgreement", "Utilities.MissingMeter_PlumbersInvoice", "Utilities.Taxes_PaymentAgreement"],
        updateFileModel: function () {
            var cases = $.getJSON("/api/ConstructionCases").success(function (data) {

                _.each(data, function (dval, dindx) {
                    var changeFlag = false;
                    // if (dval.BBLE.trim() == '1004490003') {

                    _.each(testController.models, function (val, indx) {
                        var model = "CSCase." + testController.models[indx];
                        if (eval("dval.CSCase") && eval("dval.CSCase."+ testController.models[indx].split(".")[0]) && eval("dval." + model)) {
                            changeFlag = true;
                            var evaled = eval("dval." + model);
                            var evaled_parts = evaled.split('/');

                            var newModel = {};
                            newModel.name = evaled_parts[evaled_parts.length - 1];
                            newModel.path = evaled;
                            newModel.uploadTime = new Date();
                            eval("dval." + model + "=newModel");
                        }
                    })

                    if (changeFlag) {
                        var bble = dval.BBLE.trim();
                        var url = "/api/ConstructionCases/" + bble;
                        $.ajax(url, {
                            method: "PUT",
                            data: JSON.stringify(dval),
                            dataType: "json",
                            contentType: "application/json",
                            success: function () { console.log(dval.BBLE + "updated.") },
                            error: function () { console.log(dval.BBLE + "fails.") }
                        });

                    }

                    //                    }

                })

                console.log("all finished");
            })



        }
    }
</script>
</html>
