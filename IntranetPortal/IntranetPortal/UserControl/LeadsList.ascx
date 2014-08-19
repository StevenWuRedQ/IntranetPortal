<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LeadsList.ascx.vb" Inherits="IntranetPortal.LeadsList" %>
<script type="text/javascript">
    // <![CDATA[         

    var postponedCallbackRequired = false;
    var leadsInfoBBLE = null;

    //function is called on changing focused row
    function OnGridFocusedRowChanged() {
        // The values will be returned to the OnGetRowValues() function 
        if (gridLeads.GetFocusedRowIndex() >= 0) {

            if (ContentCallbackPanel.InCallback()) {
                postponedCallbackRequired = true;
            }
            else {
                if (gridLeads.GetFocusedRowIndex() >= 0) {
                    //alert(gridLeads.GetFocusedRowIndex());
                    var rowKey = gridLeads.GetRowKey(gridLeads.GetFocusedRowIndex());
                    if (rowKey != null)
                        OnGetRowValues(rowKey);
                }
            }
        }
    }

    var IsAddNewLead = false;
    function OnGridLeadsEndCallback(s, e) {
        if (IsAddNewLead) {
            IsAddNewLead = false;
            OnGridFocusedRowChanged();
        }
    }

    function OnGetRowValues(values) {
        if (values == null) {
            gridLeads.GetValuesOnCustomCallback(gridLeads.GetFocusedRowIndex(), OnGetRowValues);
        }
        else {
            leadsInfoBBLE = values;
            ContentCallbackPanel.PerformCallback(values);
        }
    }

    function OnEndCallback(s, e) {
        if (postponedCallbackRequired) {
            gridLeads.GetRowValues(gridLeads.GetFocusedRowIndex(), 'BBLE', OnGetRowValues);
            postponedCallbackRequired = false;
        }
        $("#prioity_content").mCustomScrollbar(
               {
                   theme: "minimal-dark"
               }
               );
        $("#home_owner_content").mCustomScrollbar(
            {
                theme: "minimal-dark"
            }
         );
        $("#ctl00_MainContentPH_ASPxSplitter1_LeadsInfo_ASPxCallbackPanel2_contentSplitter_ownerInfoCallbackPanel").mCustomScrollbar(
            {
                theme: "minimal-dark"
            }
         );
    }

    var mapContentframeID = "MapContent";
    function OnGridLeadsSelectionChanged(s, e) {
        e.processOnServer = false;
        var bble = s.GetRowKey(e.visibleIndex);
        var mapWin = document.getElementById(mapContentframeID).contentWindow;

        if (e.isSelected) {
            mapWin.AddAddress(bble);
        }
        else {
            mapWin.RemoveAddress(bble);
        }
    }

    var tmpBBLE = null;
    function ShowCateMenu(s, bble) {
        ASPxPopupMenuCategory.Hide();
        tmpBBLE = bble;
        ASPxPopupMenuCategory.ShowAtElement(s);
    }

    function OnGetAddressCallbackError(s, e) {
        alert(e.message);
    }

    var tempAddress = null;
    function OnGetAddressCallbackComplete(s, e) {

        if (e.result == null) {
            alert("Property Address is empty!");
            return;
        }
        tempAddress = e.result;
        var streetViewFrm = "streetViewFrm";
        var streenViewWinFrm = document.getElementById(streetViewFrm);

        var streenViewWin = (streenViewWinFrm.contentWindow || streenViewWinFrm.contentDocument);


        if (streenViewWin != null) {
            //alert(streenViewWin);
            if (streenViewWin.showAddress) {
                //alert(streenViewWin);
                streenViewWin.showAddress(e.result);
            }
            else {
                //alert(streenViewWin.showAddress)
                setTimeout(function () { OnGetAddressCallbackComplete(s, e); }, 1000);
            }
        }

        ASPxPopupMapControl.Show();
    }

    function PopupControlMapTabChange(s, e) {
        if (e.tab.index == 0) {
            if (tmpBBLE != null) {
                if (getAddressCallback.InCallback()) {
                    alert("Server is busy, try later!");
                }
                else {
                    var streetViewFrm = "streetViewFrm";

                    var iframe = document.getElementById(streetViewFrm);
                    if (iframe.src != "/StreetView.aspx") {
                        iframe.src = "/StreetView.aspx";
                        iframe.onload = function () {
                            var mapDocument = (iframe.contentWindow || iframe.contentDocument);
                            if (mapDocument.showAddress) {
                                mapDocument.showAddress(tempAddress);
                            }
                        };
                    } else {
                        getAddressCallback.PerformCallback(tmpBBLE);
                    }
                }
            }
        }

        if (e.tab.index == 1) {
            if (tmpBBLE != null) {
                if (getAddressCallback.InCallback()) {
                    alert("Server is busy, try later!");
                }
                else {
                    var streetViewFrm = "streetViewFrm";

                    var iframe = document.getElementById(streetViewFrm);
                    if (iframe.src != "/StreetView.aspx?t=map") {
                        iframe.src = "/StreetView.aspx?t=map";
                        iframe.onload = function () {
                            var mapDocument = (iframe.contentWindow || iframe.contentDocument);
                            if (mapDocument.showAddress) {
                                mapDocument.showAddress(tempAddress);
                            }
                        };
                    } else {
                        getAddressCallback.PerformCallback(tmpBBLE);
                    }
                }
            }
        }

        if (e.tab.index == 2) {
            if (tmpBBLE != null) {
                if (getAddressCallback.InCallback()) {
                    alert("Server is busy, try later!");
                }
                else {
                    var streetViewFrm = "streetViewFrm";

                    var iframe = document.getElementById(streetViewFrm);
                    if (iframe.src != "/BingViewMap.aspx") {
                        iframe.src = "/BingViewMap.aspx";
                        iframe.onload = function () {
                            var mapDocument = (iframe.contentWindow || iframe.contentDocument);
                            if (mapDocument.showAddress) {
                                mapDocument.showAddress(tempAddress);
                            }
                        };

                    } else {
                        getAddressCallback.PerformCallback(tmpBBLE);
                    }
                }
            }
        }

        if (e.tab.index == 3) {
            if (tmpBBLE != null) {
                var url = "http://www.oasisnyc.net/map.aspx?zoomto=lot:" + tmpBBLE;
                window.open(url, "_blank");
            }
        }
    }

    function OnLeadsCategoryClick(s, e) {
        if (tmpBBLE != null) {
            if (e.item.index == 0) {
                if (tmpBBLE != null) {
                    if (getAddressCallback.InCallback()) {
                        alert("Server is busy, try later!");
                    }
                    else {
                        var streetViewFrm = "streetViewFrm";
                        var iframe = document.getElementById(streetViewFrm);
                        if (iframe.src == "") {
                            iframe.src = "/StreetView.aspx";
                            iframe.onload = function () {
                                getAddressCallback.PerformCallback(tmpBBLE);
                            };
                        } else {
                            getAddressCallback.PerformCallback(tmpBBLE);
                        }
                    }
                }
            }

            //if (e.item.index == 1) {
            //    if (tmpBBLE != null) {
            //        if (getAddressCallback.InCallback()) {
            //            alert("Server is busy, try later!");
            //        }
            //        else {

            //            var streetViewFrm = "streetViewFrm";
            //            if (ASPxPopupMapControl.GetHeaderText() != e.item.GetText()) {
            //                var iframe = document.getElementById(streetViewFrm);
            //                iframe.src = "/StreetView.aspx?t=map";
            //                iframe.onload = function () {
            //                    getAddressCallback.PerformCallback(tmpBBLE);
            //                };
            //                ASPxPopupMapControl.SetHeaderText(e.item.GetText());
            //            } else {
            //                getAddressCallback.PerformCallback(tmpBBLE);
            //            }
            //        }
            //    }
            //}

            //if (e.item.index == 2) {
            //    if (tmpBBLE != null) {
            //        if (getAddressCallback.InCallback()) {
            //            alert("Server is busy, try later!");
            //        }
            //        else {
            //            var streetViewFrm = "streetViewFrm";
            //            if (ASPxPopupMapControl.GetHeaderText() != e.item.GetText()) {
            //                var iframe = document.getElementById(streetViewFrm);
            //                iframe.src = "/BingViewMap.aspx";
            //                iframe.onload = function () {
            //                    getAddressCallback.PerformCallback(tmpBBLE);
            //                };
            //                ASPxPopupMapControl.SetHeaderText(e.item.GetText());
            //            } else {
            //                getAddressCallback.PerformCallback(tmpBBLE);
            //            }
            //        }
            //    }
            //}


            if (e.item.name == "Priority") {
                SetLeadStatus('5' + '|' + tmpBBLE);
            }

            if (e.item.name == "DoorKnock")
                SetLeadStatus('4' + '|' + tmpBBLE);

            if (e.item.name == "Callback")
                SetLeadStatus('Tomorrow' + '|' + tmpBBLE);

            if (e.item.name == "DeadLead")
                SetLeadStatus('6' + '|' + tmpBBLE);

            if (e.item.name == "InProcess")
                SetLeadStatus('7' + '|' + tmpBBLE)

            if (e.item.name == "Closed")
                SetLeadStatus('8' + '|' + tmpBBLE)

            if (e.item.name == "ViewLead") {
                var url = '/ViewLeadsInfo.aspx?id=' + tmpBBLE;
                window.showModalDialog(url, 'View Leads Info', 'dialogWidth:1350px;dialogHeight:810px');
            }

            if (e.item.name == "Delete") {
                SetLeadStatus('11' + '|' + tmpBBLE)
            }

            if (e.item.name == "Shared") {
                var url = '/PopupControl/ShareLeads.aspx?bble=' + tmpBBLE;
                AspxPopupShareleadClient.SetContentUrl(url);
                AspxPopupShareleadClient.Show();
            }

            if (e.item.name == "Reassign") {
                popupCtrReassignEmployeeListCtr.ShowAtElement(s.GetMainElement());
            }

            if (e.item.name == "Upload") {
                var url = '/UploadFilePage.aspx?b=' + tmpBBLE;
                window.showModalDialog(url, 'Upload Files', 'dialogWidth:640px;dialogHeight:400px');
            }
        }

        e.item.SetChecked(false);
    }

    function SearchGridLeads() {
        var filterCondition = "";
        var key = txtkeyWordClient.GetText();

        filterCondition = "[LeadsName] LIKE '%" + key + "%' OR [Neighborhood] LIKE '%" + key + "%'";
        filterCondition += " OR [EmployeeName] LIKE '%" + key + "%'";
        gridLeads.PerformCallback("Search|" + key);
        //gridLeads.ApplyFilter(filterCondition);
    }

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

    function OnRequestUpdate(bble) {
        // ASPxPopupSetAsTaskControl.ShowAtElement(s.GetMainElement());
        //if (typeof (ASPxPopupSetAsTaskControl) != "undefined") {
        //    ASPxPopupSetAsTaskControl.Show();
        //}
        isSendRequest = false;
        if (cbPanelRequestUpdate.InCallback()) {

        }
        else {
            ASPxPopupRequestUpdateControl.SetHeaderText("Request Update - " + bble);
            ASPxPopupRequestUpdateControl.Show();
            cbPanelRequestUpdate.PerformCallback(bble);
        }
    }

    var isSendRequest = false;
    function OnEndCallbackPanelRequestUpdate(s, e) {
        if (isSendRequest) {
            gridLeads.CancelEdit();
            //gridLeads.Refresh();
            alert("Request update is send.");
        }
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

    function SortLeadsList(s, e) {
        var sort = s.GetText();

        if (sort == "Newest") {
            s.SetText('Oldest');
            gridLeads.SortBy("LastUpdate", "ASC");
        }
        else {
            if (sort == "Oldest") {
                s.SetText("Newest");
                gridLeads.SortBy("LastUpdate", "DSC");
            }
        }
    }
    $(document).ready(function () {
        // Handler for .ready() called.
        $("#leads_list_left").mCustomScrollbar(
            {
                theme: "minimal-dark"
            }
        );
    });


    // ]]> 
</script>
<%--id="leads_list_left"--%>
<div style="width: 100%; height: 960px; overflow:auto"  class="color_gray">
    <div style="margin: 30px 20px 30px 10px; text-align: left; padding-left: 5px" class="clearfix">
        <div style="font-size: 24px;" class="clearfix">
            <i class="fa fa-list-ol with_circle" style="width: 48px; height: 48px; line-height: 48px;"></i>&nbsp;&nbsp;&nbsp;
            <span style="color: #234b60; font-size: 30px;">
                <dx:ASPxLabel Text="New Leads" ID="lblLeadCategory" Cursor="pointer" Font-Bold="true" ClientInstanceName="LeadCategory" runat="server" Font-Size="30px"></dx:ASPxLabel>
            </span>
            <i class="fa fa-sort-amount-desc icon_right_s" style="cursor: pointer" onclick="SortLeadsList"></i>
        </div>
    </div>
    <dx:ASPxGridView runat="server" EnableRowsCache="false" OnCustomCallback="gridLeads_CustomCallback" OnDataBinding="gridLeads_DataBinding" OnCustomGroupDisplayText="gridLeads_CustomGroupDisplayText" OnSummaryDisplayText="gridLeads_SummaryDisplayText" OnCustomDataCallback="gridLeads_CustomDataCallback" Settings-ShowColumnHeaders="false" SettingsBehavior-AutoExpandAllGroups="true" ID="gridLeads" Border-BorderStyle="None" ClientInstanceName="gridLeads" Width="100%" Settings-VerticalScrollableHeight="0" AutoGenerateColumns="False" KeyFieldName="BBLE" SettingsPager-Mode="ShowAllRecords">
        <Columns>
            <dx:GridViewCommandColumn ShowSelectCheckbox="True" VisibleIndex="0" Name="colSelect" Visible="false" Width="25px">
            </dx:GridViewCommandColumn>
            <dx:GridViewDataTextColumn FieldName="LeadsName" Settings-AllowHeaderFilter="False" VisibleIndex="1">
                <Settings AutoFilterCondition="Contains" />
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="CallbackDate" Visible="false" PropertiesTextEdit-DisplayFormatString="d" VisibleIndex="2" Caption="Date">
                <PropertiesTextEdit DisplayFormatString="d"></PropertiesTextEdit>
                <Settings AllowHeaderFilter="False" GroupInterval="Date"></Settings>
                <%--<GroupRowTemplate>
                    Date: <%# GroupText(Container.GroupText) & Container.SummaryText.Replace("Count=","")%>
                </GroupRowTemplate>--%>
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataColumn FieldName="Neighborhood" Visible="false" VisibleIndex="3">
                <%-- <GroupRowTemplate>
                    Neighborhood: <%# Container.GroupText & Container.SummaryText.Replace("Count=", "")%>
                </GroupRowTemplate>--%>
            </dx:GridViewDataColumn>
            <dx:GridViewDataColumn FieldName="EmployeeName" Visible="false" VisibleIndex="4">
                <%-- <GroupRowTemplate>
                    Employee Name: <%# Container.GroupText & Container.SummaryText.Replace("Count=", "")%>
                </GroupRowTemplate>--%>
            </dx:GridViewDataColumn>
            <dx:GridViewDataColumn FieldName="LastUpdate" Visible="false" VisibleIndex="5"></dx:GridViewDataColumn>
            <dx:GridViewDataColumn Width="25px" VisibleIndex="6">
                <DataItemTemplate>
                    <i class="fa fa-list-alt employee_list_item_icon" style="vertical-align: bottom" onclick="<%#String.Format("ShowCateMenu(this,{0})", Eval("BBLE")) %>"></i>
                    <%-- <img src="/images/flag1.png" style="width: 16px; height: 16px; vertical-align: bottom" onclick="<%#String.Format("ShowCateMenu(this,{0})", Eval("BBLE")) %>" />--%>
                </DataItemTemplate>
            </dx:GridViewDataColumn>
        </Columns>
        <Templates>
            <EditForm>
                <dx:ASPxPageControl Width="100%" EnableViewState="false" ID="pageControlNewLeads" ClientInstanceName="pageControlNewLeads"
                    runat="server" ActiveTabIndex="0" TabSpacing="0px" EnableHierarchyRecreation="True" ShowTabs="false" OnCallback="pageControlNewLeads_Callback">
                    <TabPages>
                        <dx:TabPage Text="First" Name="tabStreet">
                            <ContentCollection>
                                <dx:ContentControl runat="server">
                                    <table style="width: 490px; margin: 10px; border-spacing: 2px;">
                                        <tr style="margin-bottom: 3px; height: 30px" hidden="hidden">
                                            <td>BBLE</td>
                                            <td>
                                                <dx:ASPxTextBox ID="txtNewBBLE" runat="server" Width="100%" ClientInstanceName="txtNewBBLEClient"></dx:ASPxTextBox>
                                            </td>
                                        </tr>
                                        <tr style="margin-bottom: 3px" hidden="hidden">
                                            <td>Leads Name</td>
                                            <td>
                                                <dx:ASPxTextBox runat="server" ID="txtNewLeadsName" Width="100%" ClientInstanceName="txtNewLeadsName"></dx:ASPxTextBox>
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
                                                                        <tr style="height: 30px">
                                                                            <td>Borough:</td>
                                                                            <td>
                                                                                <dx:ASPxComboBox runat="server" ID="cbStreetBorough" ClientInstanceName="cbStreetBoroughClient" Width="100%">
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
                                                                        <tr style="margin-bottom: 3px; height: 30px">
                                                                            <td>Number:</td>
                                                                            <td>
                                                                                <dx:ASPxTextBox runat="server" ID="txtHouseNum" Width="100%"></dx:ASPxTextBox>
                                                                            </td>
                                                                        </tr>
                                                                        <tr style="margin-bottom: 3px; height: 30px">
                                                                            <td>Street:</td>
                                                                            <td>
                                                                                <dx:ASPxComboBox runat="server" Width="100%" ID="cbStreetlookup" ClientInstanceName="cbStreetlookupClient" DropDownStyle="DropDown" FilterMinLength="2" IncrementalFilteringMode="StartsWith" OnCallback="cbStreetlookup_Callback" TextField="st_name" ValueField="st_name" EnableCallbackMode="true" CallbackPageSize="10">
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
                                                                        <tr style="height: 30px">
                                                                            <td>Borough:</td>
                                                                            <td>
                                                                                <dx:ASPxComboBox runat="server" ID="cblegalBorough" Width="100%">
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
                                                                        <tr style="margin-bottom: 3px; height: 30px">
                                                                            <td>Block:</td>
                                                                            <td>
                                                                                <dx:ASPxTextBox runat="server" ID="txtLegalBlock" Width="100%"></dx:ASPxTextBox>
                                                                            </td>
                                                                        </tr>
                                                                        <tr style="margin-bottom: 3px; height: 30px">
                                                                            <td>Lot:</td>
                                                                            <td>
                                                                                <dx:ASPxTextBox runat="server" ID="txtLegalLot" Width="100%"></dx:ASPxTextBox>
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
                                                                        <tr style="height: 30px">
                                                                            <td>Borough:</td>
                                                                            <td>
                                                                                <dx:ASPxComboBox runat="server" ID="cbNameBorough" Width="100%">
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
                                                                        <tr style="height: 30px">
                                                                            <td>First:</td>
                                                                            <td>
                                                                                <dx:ASPxTextBox ID="txtNameFirst" runat="server" Width="100%"></dx:ASPxTextBox>
                                                                            </td>
                                                                        </tr>
                                                                        <tr style="margin-bottom: 3px; height: 30px">
                                                                            <td>Last:</td>
                                                                            <td>
                                                                                <dx:ASPxTextBox runat="server" ID="txtNameLast" Width="100%"></dx:ASPxTextBox>
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
                                            <td colspan="2" style="text-align: right; height: 30px;">
                                                <dx:ASPxButton RenderMode="Button" Text="Next" AutoPostBack="false" runat="server">
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
                                            <td style="text-align: left; height: 30px;">
                                                <dx:ASPxButton RenderMode="Button" Text="Back" AutoPostBack="false" runat="server">
                                                    <ClientSideEvents Click="function(){
                                                          var indexTab = (pageControlNewLeads.GetActiveTab()).index;                                                        
                                                          pageControlNewLeads.SetActiveTab(pageControlNewLeads.GetTab(indexTab - 1));
                                                          cbStreetlookupClient.PerformCallback(cbStreetBoroughClient.GetValue().toString());
                                                        }" />
                                                </dx:ASPxButton>
                                            </td>
                                            <td style="text-align: right; height: 30px;">
                                                <dx:ASPxButton RenderMode="Button" Text="OK" AutoPostBack="false" runat="server">
                                                    <ClientSideEvents Click="function(){
                                                          IsAddNewLead = true;
                                                          gridLeads.UpdateEdit();                                                                                                                                                                                                                                      
                                                        }" />
                                                </dx:ASPxButton>
                                                <dx:ASPxButton RenderMode="Button" Text="Cancel" AutoPostBack="false" runat="server">
                                                    <ClientSideEvents Click="function(){
                                                           gridLeads.CancelEdit();                                                           
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
            </EditForm>
            <FilterRow>
                <table>
                    <tr>
                        <td>
                            <dx:ASPxTextBox runat="server" ID="txtkeyword" Width="320" ClientInstanceName="txtkeyWordClient"></dx:ASPxTextBox>
                        </td>
                        <td>
                            <dx:ASPxButton runat="server" RenderMode="Button" Image-Url="/images/Search.png" Image-Height="16px" Text="Search" Image-Width="16px" AutoPostBack="false">
                                <FocusRectPaddings PaddingLeft="2" PaddingRight="2" PaddingBottom="0" PaddingTop="0" />
                                <ClientSideEvents Click="function(){SearchGridLeads();}" />
                            </dx:ASPxButton>
                        </td>
                    </tr>
                </table>
            </FilterRow>
        </Templates>
        <SettingsBehavior AllowFocusedRow="true" AllowClientEventsOnLoad="true" AllowGroup="true"
            EnableRowHotTrack="True" ColumnResizeMode="NextColumn" />
        <SettingsPager Mode="ShowAllRecords"></SettingsPager>
        <Settings ShowColumnHeaders="False" VerticalScrollableHeight="50"></Settings>
        <SettingsEditing Mode="PopupEditForm"></SettingsEditing>
        <SettingsCommandButton CancelButton-ButtonType="Button" UpdateButton-ButtonType="Button">
            <UpdateButton ButtonType="Button" Text="OK"></UpdateButton>
            <CancelButton ButtonType="Button"></CancelButton>
        </SettingsCommandButton>
        <SettingsText CommandUpdate="OK" PopupEditFormCaption="Create New Leads" />
        <SettingsPopup EditForm-Modal="true" EditForm-Width="300px">
            <EditForm HorizontalAlign="WindowCenter" VerticalAlign="WindowCenter" VerticalOffset="0" Width="500px" />
            <CustomizationWindow Width="400px" />
        </SettingsPopup>
        <Styles>
            <Table Border-BorderStyle="None">
                <Border BorderStyle="None"></Border>
            </Table>
            <Cell Border-BorderStyle="none">
                <Border BorderStyle="None"></Border>
            </Cell>
            <Row Cursor="pointer" />
            <AlternatingRow CssClass="gridAlternatingRow"></AlternatingRow>
        </Styles>
        <GroupSummary>
            <dx:ASPxSummaryItem FieldName="LeadsName" SummaryType="Count" />
        </GroupSummary>
        <ClientSideEvents FocusedRowChanged="OnGridFocusedRowChanged" EndCallback="OnGridLeadsEndCallback" />
        <Border BorderStyle="None"></Border>
    </dx:ASPxGridView>
    <%--now is wrong place--%>
    <div style="position: absolute; bottom: 0; padding-left: 32px; margin-bottom: 100px">

        <div style="position: relative; float: left">
            <table>
                <tbody>
                    <tr>
                        <td>
                            <div class="priority_info_label priority_info_lable_org">
                                <span class="font_black"><%= IntranetPortal.Utility.TotalLeadsCount.ToString %> </span><span class="font_extra_light">Leads</span>
                            </div>
                        </td>
                        <td>
                            <div class="priority_info_label priority_info_label_blue" style="float: left; margin-left: 5px;">
                                <span class="font_black"><%= IntranetPortal.Utility.TotalDealsCount.ToString%> </span><span class="font_extra_light">Deals</span>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    <asp:HiddenField ID="hfView" runat="server" EnableViewState="true" />
    <dx:ASPxPopupMenu ID="popupMenuLeads" runat="server" ClientInstanceName="ASPxPopupMenuCategory" PopupHorizontalAlign="Center" PopupVerticalAlign="Below" PopupAction="LeftMouseClick" ItemImage-Height="16" ItemImage-Width="16">
        <Items>
            <dx:MenuItem GroupName="Sort" Text="View Map" Name="GoogleStreet">
                <Image Url="/images/Street-view.png"></Image>
            </dx:MenuItem>
            <dx:MenuItem GroupName="Sort" Text="Google Map View" Name="GoogleMap" Image-Url="/images/Street-view.png" ClientVisible="false">
                <Image Url="/images/Street-view.png"></Image>
            </dx:MenuItem>
            <dx:MenuItem GroupName="Sort" Text="Bing Bird View" Name="BingBird" Image-Url="/images/Street-view.png" ClientVisible="false">
                <Image Url="/images/Street-view.png"></Image>
            </dx:MenuItem>
            <dx:MenuItem GroupName="Sort" Text="Priority" Name="Priority" Image-Url="/images/priority.jpg">
                <Image Url="/images/priority.jpg"></Image>
            </dx:MenuItem>
            <dx:MenuItem GroupName="Sort" Text="Door Knock" Name="DoorKnock" Image-Url="/images/door_knocks.png">
                <Image Url="/images/door_knocks.png"></Image>
            </dx:MenuItem>
            <dx:MenuItem GroupName="Sort" Text="Follow Up" Name="Callback" Image-Url="/images/callback.png">
                <Image Url="/images/callback.png"></Image>
            </dx:MenuItem>
            <dx:MenuItem GroupName="Sort" Text="Dead Lead" Name="DeadLead" Image-Url="/images/dead.png">
                <Image Url="/images/dead.png"></Image>
            </dx:MenuItem>
            <dx:MenuItem GroupName="Sort" Text="In Process" Name="InProcess" Image-Url="/images/process-icon2.jpg">
                <Image Url="/images/process-icon2.jpg"></Image>
            </dx:MenuItem>
            <dx:MenuItem GroupName="Sort" Text="View Lead" Name="ViewLead" Visible="false">
                <Image IconID="miscellaneous_viewonweb_16x16"></Image>
            </dx:MenuItem>
            <dx:MenuItem GroupName="Sort" Text="Closed" Name="Closed" Image-Url="/images/Closed.png">
                <Image Url="/images/Closed.png"></Image>
            </dx:MenuItem>
            <dx:MenuItem GroupName="Sort" Text="Shared" Name="Shared">
                <Image IconID="actions_add_16x16"></Image>
            </dx:MenuItem>
            <dx:MenuItem GroupName="Sort" Text="Delete" Name="Delete" Visible="false">
                <Image IconID="edit_delete_16x16"></Image>
            </dx:MenuItem>
            <dx:MenuItem GroupName="Sort" Text="Reassign" Name="Reassign" Visible="false">
                <Image Url="/images/assigned.png"></Image>
            </dx:MenuItem>
            <dx:MenuItem GroupName="Sort" Text="View Files" Name="ViewFiles">
                <Image IconID="mail_attach_16x16"></Image>
            </dx:MenuItem>
            <dx:MenuItem GroupName="Sort" Text="Upload Docs/Pics" Name="Upload">
                <Image IconID="print_preview_16x16"></Image>
            </dx:MenuItem>
        </Items>
        <ClientSideEvents ItemClick="OnLeadsCategoryClick" />
        <ItemImage Height="16px" Width="16px"></ItemImage>
        <ItemStyle Width="143px"></ItemStyle>
    </dx:ASPxPopupMenu>
    <dx:ASPxPopupControl ClientInstanceName="ASPxPopupMapControl" Width="500px" Height="500px"
        MaxWidth="800px" MaxHeight="800px" MinHeight="150px" MinWidth="150px" ID="ASPxPopupControl1"
        HeaderText="Street View" AutoUpdatePosition="true" Modal="true"
        runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
        <HeaderTemplate>
            <div>
                <div style="float: right; position: relative; margin-right: 10px; margin-bottom: -27px;">
                    <dx:ASPxImage ID="img" runat="server" ImageUrl="~/images/x_close.png" Height="15" Width="14" Cursor="pointer" AlternateText="[Close]">
                        <ClientSideEvents Click="function(s, e){
                        ASPxPopupMapControl.Hide();
                    }" />
                    </dx:ASPxImage>
                </div>
                <dx:ASPxTabControl ID="ASPxTabControl1" runat="server" Width="100%">
                    <Tabs>
                        <dx:Tab Text="Street View" Name="streetView" />
                        <dx:Tab Text="Map View" Name="mapView" />
                        <dx:Tab Text="Bing Bird" Name="BingBird" />
                        <dx:Tab Text="Oasis" Name="Oasis" />
                    </Tabs>
                    <ClientSideEvents ActiveTabChanged="PopupControlMapTabChange" />
                </dx:ASPxTabControl>
            </div>
        </HeaderTemplate>
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
                <iframe width="950" height="650" id="streetViewFrm" frameborder="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <dx:ASPxPopupControl ClientInstanceName="popupCtrReassignEmployeeListCtr" Width="300px" Height="300px"
        MaxWidth="800px" MaxHeight="800px" MinHeight="150px" MinWidth="150px" ID="ASPxPopupControl2"
        HeaderText="Select Employee" AutoUpdatePosition="true" Modal="true"
        runat="server" EnableViewState="false" EnableHierarchyRecreation="True">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
                <dx:ASPxListBox runat="server" ID="listboxEmployee" ClientInstanceName="listboxEmployeeClient" Height="270" TextField="Name" ValueField="EmployeeID"
                    SelectedIndex="0" Width="100%">
                </dx:ASPxListBox>
                <dx:ASPxButton Text="Assign" runat="server" ID="btnAssign" AutoPostBack="false">
                    <ClientSideEvents Click="function(s,e){
                                        var item = listboxEmployeeClient.GetSelectedItem();
                                        if(item == null)
                                        {
                                             alert('Please select employee.');
                                             return;
                                         }
                                        reassignCallback.PerformCallback(tmpBBLE + '|' + item.value + '|' + item.text);
                                        popupCtrReassignEmployeeListCtr.Hide();                                       
                                        }" />
                </dx:ASPxButton>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <dx:ASPxPopupControl ClientInstanceName="ASPxPopupRequestUpdateControl" Width="500px" Height="420px"
        MaxWidth="800px" MinWidth="150px" ID="ASPxPopupControl3"
        HeaderText="Request Update" Modal="true"
        runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
                <dx:ASPxCallbackPanel runat="server" ID="callbackPanelRequestUpdate" ClientInstanceName="cbPanelRequestUpdate" OnCallback="callbackPanelRequestUpdate_Callback">
                    <ClientSideEvents EndCallback="OnEndCallbackPanelRequestUpdate" />
                    <PanelCollection>
                        <dx:PanelContent>
                            <asp:HiddenField runat="server" ID="hfRequestUpdateBBLE" />
                            <dx:ASPxFormLayout ID="requestUpdateFormlayout" runat="server" Width="100%">
                                <Items>
                                    <dx:LayoutItem Caption="Leads Name">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                <dx:ASPxTextBox runat="server" Width="100%" ID="txtRequestUpdateLeadsName" ReadOnly="true"></dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Create By">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                <dx:ASPxTextBox runat="server" Width="100%" ID="txtRequestUpdateCreateby" ReadOnly="true"></dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Manager">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                <dx:ASPxTextBox runat="server" Width="100%" ID="txtRequestUpdateManager" ReadOnly="true"></dx:ASPxTextBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Importance">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server" Width="100%" SupportsDisabledAttribute="True">
                                                <dx:ASPxComboBox runat="server" Width="100%" ID="cbTaskImportant">
                                                    <Items>
                                                        <dx:ListEditItem Text="Normal" Value="Normal" />
                                                        <dx:ListEditItem Text="Important" Value="Important" />
                                                        <dx:ListEditItem Text="Urgent" Value="Urgent" />
                                                    </Items>
                                                </dx:ASPxComboBox>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Description">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                <dx:ASPxMemo runat="server" Width="100%" Height="80px" ID="txtTaskDes"></dx:ASPxMemo>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                    <dx:LayoutItem Caption="Description" ShowCaption="False" HorizontalAlign="Right">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                <dx:ASPxButton ID="ASPxButton4" runat="server" Text="Send Request" AutoPostBack="false">
                                                    <ClientSideEvents Click="function(){                                                                                                                      
                                                                                                                        ASPxPopupRequestUpdateControl.Hide();
                                                                                                                        cbPanelRequestUpdate.PerformCallback('SendRequest');
                                                                                                                        isSendRequest =true;                                                                                                                                                                                                                                         
                                                                                                                        }"></ClientSideEvents>
                                                </dx:ASPxButton>
                                                &nbsp;
                                                            <dx:ASPxButton runat="server" Text="Cancel" AutoPostBack="false">
                                                                <ClientSideEvents Click="function(){
                                                                                                                        ASPxPopupRequestUpdateControl.Hide();                                                                                                                                                                                                                                               
                                                                                                                        }"></ClientSideEvents>

                                                            </dx:ASPxButton>
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                            </dx:ASPxFormLayout>
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxCallbackPanel>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <dx:ASPxCallback runat="server" ClientInstanceName="reassignCallback" ID="reassignCallback" OnCallback="reassignCallback_Callback">
        <ClientSideEvents CallbackComplete="function(s,e){ gridLeads.Refresh();}" />
    </dx:ASPxCallback>
    <dx:ASPxCallback runat="server" ClientInstanceName="getAddressCallback" ID="getAddressCallback" OnCallback="getAddressCallback_Callback" ClientSideEvents-CallbackError="OnGetAddressCallbackError">
        <ClientSideEvents CallbackComplete="OnGetAddressCallbackComplete" />
    </dx:ASPxCallback>

</div>

