<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="CreateNew.ascx.vb" Inherits="IntranetPortal.CreateNew" %>

<script type="text/javascript">

    var streets = null;
    function BindStreetValues(result) {
        cbStreetlookupClient.SetEnabled(false);
        streets = result.split(';');
        //alert(cbStreetlookupClient.GetEnabled());
        cbStreetlookupClient.BeginUpdate();
        cbStreetlookupClient.ClearItems();
        for (var i = 0; i < streets.length - 1; i++)
            cbStreetlookupClient.AddItem(streets[i], streets[i]);
        cbStreetlookupClient.EndUpdate();
        cbStreetlookupClient.SetEnabled(true);
        //alert(cbStreetlookupClient.GetEnabled());
    }

    var lastBorough = null;
    var loadedBorough = null;
    function OnBoroughChanged(cbBorough) {
        if (cbStreetlookupClient.InCallback())
            lastBorough = cbBorough.GetValue().toString();
        else {
            loadedBorough = cbBorough.GetValue().toString();
            cbStreetlookupClient.PerformCallback(loadedBorough);
        }
    }

    function OnStreetlookupEndCallback(s, e) {
        if (lastBorough) {
            loadedBorough = lastBorough;
            cbStreetlookupClient.PerformCallback(lastBorough);
            lastBorough = null;
        }
    }

</script>


<dx:ASPxPopupControl ClientInstanceName="popupCreateNew" Width="600px" Height="400px" ID="popupCreateNew" HeaderText="Create New" Modal="true" ShowOnPageLoad="true" OnWindowCallback="popupCreateNew_WindowCallback"
    runat="server" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter">
    <HeaderTemplate>
        <div class="clearfix">
            <div class="pop_up_header_margin">
                <i class="fa fa-clock-o with_circle pop_up_header_icon"></i>
                <span class="pop_up_header_text">Create New</span>
            </div>
            <div class="pop_up_buttons_div">
                <i class="fa fa-times icon_btn" onclick="popupCreateNew.Hide()"></i>
            </div>
        </div>
    </HeaderTemplate>
    <ContentCollection>
        <dx:PopupControlContentControl runat="server">
            <dx:ASPxPageControl Width="100%" EnableViewState="false" ID="pageControlNewLeads" ClientInstanceName="pageControlNewLeads"
                runat="server" ActiveTabIndex="0" TabSpacing="0px" EnableHierarchyRecreation="True" ShowTabs="false">
                <TabPages>
                    <dx:TabPage Text="First" Name="tabStreet">
                        <ContentCollection>
                            <dx:ContentControl runat="server">
                                <table style="width: 490px; margin: 10px; border-spacing: 2px;">
                                    <tr style="margin-bottom: 3px; height: 45px" hidden="hidden">
                                        <td>BBLE</td>
                                        <td>
                                            <dx:ASPxTextBox ID="txtNewBBLE" runat="server" Width="100%" ClientInstanceName="txtNewBBLEClient" CssClass="edit_drop"></dx:ASPxTextBox>
                                            <dx:ASPxButton runat="server" ID="txtAddAll" AutoPostBack="false" Text="Batch Import">
                                                <ClientSideEvents Click="function(s,e){popupCreateNew.PerformCallback('Add|' + txtNewBBLEClient.GetText()); }" />
                                            </dx:ASPxButton>
                                        </td>
                                    </tr>
                                    <tr style="margin-bottom: 3px" hidden="hidden">
                                        <td>Leads Name</td>
                                        <td>
                                            <dx:ASPxTextBox runat="server" ID="txtNewLeadsName" Width="100%" ClientInstanceName="txtNewLeadsName" CssClass="edit_drop"></dx:ASPxTextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <dx:ASPxPageControl Width="100%" EnableViewState="false" ID="pageControlInputData" Height="260px"
                                                runat="server" ActiveTabIndex="0" TabSpacing="3px" EnableHierarchyRecreation="True">
                                                <TabPages>
                                                    <dx:TabPage Text="Address" Name="tabStreet">
                                                        <ContentCollection>
                                                            <dx:ContentControl runat="server">
                                                                <table style="width: 100%;">
                                                                    <tr style="height: 45px">
                                                                        <td>Borough:</td>
                                                                        <td>
                                                                            <dx:ASPxComboBox runat="server" ID="cbStreetBorough" ClientInstanceName="cbStreetBoroughClient" CssClass="edit_drop" Width="100%">
                                                                                <Items>
                                                                                    <dx:ListEditItem Text="Manhattan" Value="1" />
                                                                                    <dx:ListEditItem Text="Bronx" Value="2" />
                                                                                    <dx:ListEditItem Text="Brooklyn" Value="3" />
                                                                                    <dx:ListEditItem Text="Queens" Value="4" />
                                                                                    <dx:ListEditItem Text="Staten Island" Value="5" />
                                                                                </Items>
                                                                                <ClientSideEvents SelectedIndexChanged="function(s, e){ OnBoroughChanged(s); }" />
                                                                            </dx:ASPxComboBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr style="margin-bottom: 3px; height: 45px">
                                                                        <td>Number:</td>
                                                                        <td>
                                                                            <dx:ASPxTextBox runat="server" ID="txtHouseNum" CssClass="edit_drop" Width="100%"></dx:ASPxTextBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr style="margin-bottom: 3px; height: 45px">
                                                                        <td>Street:</td>
                                                                        <td>
                                                                            <dx:ASPxComboBox runat="server" Width="100%" ID="cbStreetlookup" CssClass="edit_drop" ClientInstanceName="cbStreetlookupClient" DropDownStyle="DropDown" FilterMinLength="2" IncrementalFilteringMode="StartsWith" OnCallback="cbStreetlookup_Callback" TextField="st_name" ValueField="st_name" EnableCallbackMode="true" CallbackPageSize="10">
                                                                                <ClientSideEvents EndCallback="OnStreetlookupEndCallback" />
                                                                            </dx:ASPxComboBox>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </dx:ContentControl>
                                                        </ContentCollection>
                                                    </dx:TabPage>
                                                    <dx:TabPage Text="Legal" Name="tabLegal">
                                                        <ContentCollection>
                                                            <dx:ContentControl runat="server">
                                                                <table style="width: 100%;">
                                                                    <tr style="height: 45px">
                                                                        <td>Borough:</td>
                                                                        <td>
                                                                            <dx:ASPxComboBox CssClass="edit_drop" runat="server" ID="cblegalBorough" Width="100%">
                                                                                <Items>
                                                                                    <dx:ListEditItem Text="Manhattan" Value="1" />
                                                                                    <dx:ListEditItem Text="Bronx" Value="2" />
                                                                                    <dx:ListEditItem Text="Brooklyn" Value="3" />
                                                                                    <dx:ListEditItem Text="Queens" Value="4" />
                                                                                    <dx:ListEditItem Text="Staten Island" Value="5" />
                                                                                </Items>
                                                                            </dx:ASPxComboBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr style="margin-bottom: 3px; height: 45px">
                                                                        <td>Block:</td>
                                                                        <td>
                                                                            <dx:ASPxTextBox CssClass="edit_drop" runat="server" ID="txtLegalBlock" Width="100%"></dx:ASPxTextBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr style="margin-bottom: 3px; height: 45px">
                                                                        <td>Lot:</td>
                                                                        <td>
                                                                            <dx:ASPxTextBox runat="server" CssClass="edit_drop" ID="txtLegalLot" Width="100%"></dx:ASPxTextBox>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </dx:ContentControl>
                                                        </ContentCollection>
                                                    </dx:TabPage>
                                                    <dx:TabPage Text="Name" Name="tabName">
                                                        <ContentCollection>
                                                            <dx:ContentControl runat="server">
                                                                <table style="width: 100%;">
                                                                    <tr style="height: 45px">
                                                                        <td>Borough:</td>
                                                                        <td>
                                                                            <dx:ASPxComboBox CssClass="edit_drop" runat="server" ID="cbNameBorough" Width="100%">
                                                                                <Items>
                                                                                    <dx:ListEditItem Text="Manhattan" Value="1" />
                                                                                    <dx:ListEditItem Text="Bronx" Value="2" />
                                                                                    <dx:ListEditItem Text="Brooklyn" Value="3" />
                                                                                    <dx:ListEditItem Text="Queens" Value="4" />
                                                                                    <dx:ListEditItem Text="Staten Island" Value="5" />
                                                                                </Items>
                                                                            </dx:ASPxComboBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr style="height: 45px">
                                                                        <td>First:</td>
                                                                        <td>
                                                                            <dx:ASPxTextBox CssClass="edit_drop" ID="txtNameFirst" runat="server" Width="100%"></dx:ASPxTextBox>
                                                                        </td>
                                                                    </tr>
                                                                    <tr style="margin-bottom: 3px; height: 45px">
                                                                        <td>Last:</td>
                                                                        <td>
                                                                            <dx:ASPxTextBox runat="server" CssClass="edit_drop" ID="txtNameLast" Width="100%"></dx:ASPxTextBox>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </dx:ContentControl>
                                                        </ContentCollection>
                                                    </dx:TabPage>
                                                </TabPages>
                                            </dx:ASPxPageControl>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" style="text-align: right; height: 45px;">
                                            <dx:ASPxButton RenderMode="Button" Text="Next" AutoPostBack="false" CssClass="rand-button rand-button-blue" runat="server">
                                                <ClientSideEvents Click="function(){
                                                          var indexTab = (pageControlNewLeads.GetActiveTab()).index;
                                                            pageControlNewLeads.PerformCallback();
                                                        lbNewBBLEClient.PerformCallback();
                                                          pageControlNewLeads.SetActiveTab(pageControlNewLeads.GetTab(indexTab + 1));
                                                        }" />
                                            </dx:ASPxButton>
                                        </td>
                                    </tr>
                                </table>
                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>
                    <dx:TabPage Text="BBLE">
                        <ContentCollection>
                            <dx:ContentControl>
                                <table style="width: 490px; margin: 10px; border-spacing: 2px;">
                                    <tr style="margin-bottom: 3px;">
                                        <td colspan="2">
                                            <dx:ASPxListBox runat="server" Height="260px" Width="485px" ID="lbNewBBLE" ClientInstanceName="lbNewBBLEClient" OnCallback="lbNewBBLE_Callback">
                                                <Columns>
                                                    <dx:ListBoxColumn Name="BBLE" FieldName="BBLE" Caption="BBLE" Width="100px" />
                                                    <dx:ListBoxColumn Name="LeadsName" FieldName="LeadsName" Caption="Leads Name" Width="385px" />
                                                </Columns>
                                                <ClientSideEvents SelectedIndexChanged="function(s, e){
                                                        var item = s.GetSelectedItem();
                                                        txtNewBBLEClient.SetText(item.GetColumnText(0));
                                                        txtNewLeadsName.SetText(item.GetColumnText(1));
                                                        }" />
                                            </dx:ASPxListBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: left; height: 45px;">
                                            <dx:ASPxButton RenderMode="Button" Text="Back" CssClass="rand-button rand-button-gray" AutoPostBack="false" runat="server">
                                                <ClientSideEvents Click="function(){
                                                          var indexTab = (pageControlNewLeads.GetActiveTab()).index;                                                        
                                                          pageControlNewLeads.SetActiveTab(pageControlNewLeads.GetTab(indexTab - 1));
                                                          cbStreetlookupClient.PerformCallback(cbStreetBoroughClient.GetValue().toString());
                                                        }" />
                                            </dx:ASPxButton>
                                        </td>
                                        <td style="text-align: right; height: 45px;">
                                            <dx:ASPxButton RenderMode="Button" Text="OK" CssClass="rand-button rand-button-blue" AutoPostBack="false" runat="server">
                                                <ClientSideEvents Click="function(){
                                                          IsAddNewLead = true;
                                                          if(txtNewBBLEClient.GetText() == '')
                                                            {
                                                                 alert('please select address.');
                                                                 return;
                                                            }
                                                          popupCreateNew.PerformCallback('Add|' + txtNewBBLEClient.GetText());                                                                                                                                                                                                                                      
                                                          
                                                        }" />
                                            </dx:ASPxButton>
                                            <dx:ASPxButton RenderMode="Button" Text="Cancel" CssClass="rand-button rand-button-gray" AutoPostBack="false" runat="server">
                                                <ClientSideEvents Click="function(){
                                                           popupCreateNew.Hide();
                                                        }" />
                                            </dx:ASPxButton>
                                        </td>
                                    </tr>
                                </table>
                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>
                </TabPages>
            </dx:ASPxPageControl>

        </dx:PopupControlContentControl>
    </ContentCollection>
</dx:ASPxPopupControl>


