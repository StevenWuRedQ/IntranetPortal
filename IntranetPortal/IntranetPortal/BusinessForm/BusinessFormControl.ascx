<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="BusinessFormControl.ascx.vb" Inherits="IntranetPortal.BusinessFormControl" %>
<asp:Panel runat="server" ID="pnMain"></asp:Panel>
<script type="text/javascript">
    var controlName = '<%= CurrentControl.Name%>';
    
    var <%= Me.ID%> = {
        LoadData: function (tag) {           
            var url = "/api/BusinessForm/<%= CurrentControl.BusinessData %>/Tag/" + tag
            $.ajax({
                type: "GET",
                url: url,
                dataType: 'json',
                success: function (data) {
                    console.log(data);
                    angular.element(document.getElementById(controlName + 'Controller')).scope().Load(data);                   
                },
                error: function (data) {
                    alert("Failed to load data." + data)
                }
            });
        },
    }

</script>