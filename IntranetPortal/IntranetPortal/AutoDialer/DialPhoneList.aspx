<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DialPhoneList.aspx.vb" Inherits="IntranetPortal.DialPhoneList" MasterPageFile="~/Content.Master" %>

<asp:Content ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <script>
        function callPhoneNumber(phone) {
            //$.getJSON('/api/AutoDialer/' + phone).success(function () {
            //    gvDailPhoneListClient.Refresh();
            //}).error(function () {
            //    alert("some error happen gvDailPhoneListClient");
            //})
        }
        var timeout;
        function scheduleGridUpdate(grid) {
            window.clearTimeout(timeout);
            timeout = window.setTimeout(
                function () {
                    gvDailPhoneListClient.PerformCallback("");

                },
                2000
            );
        }
        function grid_Init(s, e) {
            scheduleGridUpdate(s);
        }
        function grid_BeginCallback(s, e) {
            window.clearTimeout(timeout);
        }
        function grid_EndCallback(s, e) {
            scheduleGridUpdate(s);
        }
    </script>
    <div class="container">
        <div align="center" style="padding-top: 50px">
            <div>
                <div>

                    <dx:ASPxGridView ID="gvDailPhoneList" runat="server" OnInit="gvDailPhoneList_Init" OnCustomCallback="gvDailPhoneList_CustomCallback" KeyFieldName="Phone" ClientInstanceName="gvDailPhoneListClient" Theme="Moderno">
                        <Columns>
                            <dx:GridViewDataColumn FieldName="LeadName">
                            </dx:GridViewDataColumn>
                            <dx:GridViewDataColumn FieldName="Phone">
                            </dx:GridViewDataColumn>
                            <dx:GridViewDataColumn FieldName="OwnerName">
                            </dx:GridViewDataColumn>
                            <dx:GridViewDataColumn FieldName="CallStatus">
                            </dx:GridViewDataColumn>
                            <%--<dx:GridViewDataColumn FieldName="Call">
                        <DataItemTemplate>
                            <i class="fa fa-phone" onclick="callPhoneNumber(<%#Container.KeyValue %>)"></i>
                        </DataItemTemplate>
                    </dx:GridViewDataColumn>--%>
                        </Columns>
                        <ClientSideEvents Init="grid_Init" BeginCallback="grid_BeginCallback" EndCallback="grid_EndCallback" />
                        <SettingsLoadingPanel Mode="ShowOnStatusBar" />
                    </dx:ASPxGridView>
                </div>
                <div class="pull-right">

                    <asp:Button ID="callAll" runat="server" Text="Dial All" OnClick="callAll_Click" CssClass="btn btn-primary" />
                </div>
            </div>
            <%--<asp:ObjectDataSource ID="callingListDataSource" ></asp:ObjectDataSource>--%>
        </div>
    </div>

</asp:Content>
