<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LeadsList.ascx.vb" Inherits="IntranetPortal.LeadsList" %>

<%@ Register Src="~/UserControl/LeadsSubMenu.ascx" TagPrefix="uc1" TagName="LeadsSubMenu" %>

<script type="text/javascript">

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

    function ExpandOrCollapseGroupRow(rowIndex) {
        if (gridLeads.IsGroupRow(rowIndex)) {
            if (gridLeads.IsGroupRowExpanded(rowIndex)) {
                gridLeads.CollapseRow(rowIndex);
            } else {
                gridLeads.ExpandRow(rowIndex);
            }
            AddScrollbarOnLeadsList();
            return
        }
    }

    var IsAddNewLead = false;
    function OnGridLeadsEndCallback(s, e) {
        if (IsAddNewLead) {
            IsAddNewLead = false;
            OnGridFocusedRowChanged();
        }

        AddScrollbarOnLeadsList();
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

        InitScrollBar();
        init_currency();
        initToolTips();
        if (sortPhones) {
            sortPhones();
        }
    }

    function InitScrollBar() {
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

        $(".dxgvCSD").each(function (ind) {
            var is_list = $(this).parents("#leads_list_left").length > 0;

            var ladfucntion = {
                onScroll: function () {
                    var position = this.mcs.topPct;
                    if (position > 90) {
                        gridLeads.NextPage();
                    }
                }
            }

            if (is_list) {
                $(this).mCustomScrollbar(
                    {
                        theme: "minimal-dark",
                        callbacks: ladfucntion
                    }
                 );
            } else {
                //$(this).mCustomScrollbar(
                //    {
                //        theme: "minimal-dark",

                //    }
                //);
            }
        });


        /*init the center panle's scrollbar */
        $("#ctl00_MainContentPH_ASPxSplitter1_0i1_CC").mCustomScrollbar(
            {
                theme: "minimal-dark",
                axis: "yx"
            });
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


    var tempAddress = null;

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
        isSendRequest = false;
        if (ASPxPopupRequestUpdateControl.InCallback()) {

        }
        else {
            ASPxPopupRequestUpdateControl.SetHeaderText("Request Update - " + bble);
            ASPxPopupRequestUpdateControl.PerformCallback(bble);
        }
    }

    var isSendRequest = false;
    function OnEndCallbackPanelRequestUpdate(s, e) {
        if (isSendRequest) {
            gridLeads.CancelEdit();
            //gridLeads.Refresh();
            alert("Request update is send.");
        }
        else {
            s.Show();
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

    function AdjustPopupSize(popup) {
        if (popup.GetMaximized()) {
            //popup.SetWindowMaximized(false);
            popup.SetMaximized(false);
        }
        else {
            //popup.SetWindowMaximized(true);
            popup.SetMaximized(true);
        }

        popup.AdjustControl();
    }

    // to do by steven
    function SortLeadsList(s, field) {
        var classDesc = "fa fa-sort-amount-desc icon_btn tooltip-examples";
        var classAsc = "fa fa-sort-amount-asc icon_btn tooltip-examples";
        var sort = s.getAttribute("class");

        if (sort.indexOf("-desc") > 0) {
            s.setAttribute("class", classAsc);
            gridLeads.SortBy(field, "ASC");
        }
        else {
            if (sort.indexOf("-asc") > 0) {
                s.setAttribute("class", classDesc);
                gridLeads.SortBy(field, "DSC");
            }
        }
    }

    function OnSortMenuClick(s, e) {
        var icon = document.getElementById("btnSortIcon");
        if (e.item.index == 0) {
            SortLeadsList(icon, "LastUpdate");
        }

        if (e.item.index == 1) {
            SortLeadsList(icon, "LeadsName");
        }

        if (e.item.index == 2) {
            gridLeads.GroupBy("Neighborhood", 0);
        }

        if (e.item.index == 3) {
            gridLeads.GroupBy("EmployeeName", 0);
        }

        if (e.item.index == 4) {
        }

        if (e.item.index == 6) {
            SortLeadsList(icon, "MarkColor");

        }
    }

    function expandAllClick(s) {
        if (gridLeads.IsGroupRowExpanded(0)) {
            gridLeads.CollapseAll();
            $(s).attr("class", 'fa fa-compress icon_btn tooltip-examples');
        }
        else {
            gridLeads.ExpandAll();
            $(s).attr("class", 'fa fa-expand icon_btn tooltip-examples');
        }
    }

    function AddScrollbarOnLeadsList() {
        $("#leads_list_left .dxgvCSD").each(function (ind) {
            var is_list = $(this).parents("#leads_list_left").length > 0;

            var ladfucntion = {
                onScroll: function () {
                    var position = this.mcs.topPct;
                    if (position > 95) {
                        gridLeads.NextPage();
                    }
                }
            }

            if (is_list) {
                $(this).mCustomScrollbar(
                    {
                        theme: "minimal-dark",
                        callbacks: ladfucntion
                    }
                 );
            }
        });
    }

    $(document).ready(function () {
        //Handler for .ready() called.
        if (LeadCategory.GetText() != "Create") {//document.getElementById("leads_list_left").scrollHeight > leads_list_grid.height()) {
            AddScrollbarOnLeadsList();
        }
    });
    var temBBLE = null;
    function OnColorMark(s, e) {
        var index = e.item.index;
        onColoMarkClick(index);
    }
    function GetMarkColor(markColor)
    {
        if(markColor <= 0 || markColor == 1000){
            return "transparent";
        }
        colors = [

        ]
        colors[1] = '#a820e1'
        colors[2] = '#ec471b'
        colors[3] = '#7bb71b'
        var color = colors[markColor]
        if(color != null)
        {
            return color;
        }
        return "";
    }
    var temStar = null;
    function onColoMarkClick(index,e) {
        if (index == 0) {
            index = 1000;
        }
        $(temStar).css("color", GetMarkColor(index));
        debugger;
        //gridLeads.PerformCallback("MarkColor|" + temBBLE + "|" + index)
        MarkColorCallBack.PerformCallback("MarkColor|" + temBBLE + "|" + index)
    }
    function PopupColorMark(e, BBLE) {
        temBBLE = BBLE;
        AspPopupColorMark.ShowAtElement(e);
    }
    function click_item(e) {
        var index = $("li").index(e)
        index++;
        if (index == $(e).parent().children().length) {
            index = 0;
        }
        onColoMarkClick(index,e);
       
        $("#color_drop").css("top", "-1000px")
    }


</script>
<style>
    .diagonal {
        background: repeating-linear-gradient( 135deg, #fff, #fff 10px, #000 10px, #000 15px );
    }
    .color_list
    {
        width:15px;
        height:15px;
        border:none;
    }
</style>
<dx:ASPxCallback runat="server" ID="MarkColorCallBack" OnCallback="MarkColorCallBack_Callback" ClientInstanceName="MarkColorCallBack">  </dx:ASPxCallback>
<div id="color_drop" style="position: absolute; left: -100px; top: -1000px; z-index: 10000;width:15px;">

    <ul class="list-group" style="border:none;width:15px">
        <li class="list-group-item icon_btn color_list" onclick="click_item(this)" style="background: #a820e1">&nbsp;</li>
        <li class="list-group-item icon_btn color_list" onclick="click_item(this)" style="background: #ec471b">&nbsp;</li>
        <li class="list-group-item icon_btn color_list diagonal" onclick="click_item(this)"  >&nbsp;</li>
    </ul>
</div>



<%--id="leads_list_left"--%>
<div style="width: 100%; height: 100%;" class="color_gray">
    <div style="margin: 30px 10px 10px 10px; text-align: left;" class="clearfix">
        <div style="font-size: 24px;" class="clearfix">
            <div class="clearfix">
                <i class="fa fa-list-ol with_circle" style="width: 48px; height: 48px; line-height: 48px;"></i>&nbsp;
                <span style="color: #234b60; font-size: 30px;">
                    <dx:ASPxLabel Text="New Leads" ID="lblLeadCategory" Cursor="pointer" ClientInstanceName="LeadCategory" runat="server" Font-Size="30px"></dx:ASPxLabel>
                </span>
                <div class="icon_right_s">
                    <%--onclick="SortLeadsList(this)"--%>
                    <i class="fa fa-sort-amount-desc icon_btn tooltip-examples" title="Sort" style="cursor: pointer; font-size: 18px" id="btnSortIcon" onclick="aspxPopupSortMenu.ShowAtElement(this);"></i>
                    <i class="fa fa-compress icon_btn tooltip-examples" style="font-size: 18px;" title="Expand or Collapse All" onclick="expandAllClick(this)" runat="server" id="divExpand"></i>
                </div>
            </div>
        </div>

        <%--      <button type="button" onclick="gridLeads.CollapseAll()" value="Collapse">Collapse</button>
        <button type="button" onclick="gridLeads.ExpandAll()" value="Expand">Expand</button>--%>
    </div>
    <div style="height: 768px; padding: 0px 10px;" id="leads_list_left">
        <dx:ASPxGridView runat="server" EnableRowsCache="false" OnCustomCallback="gridLeads_CustomCallback" OnDataBinding="gridLeads_DataBinding" OnCustomGroupDisplayText="gridLeads_CustomGroupDisplayText"
            OnSummaryDisplayText="gridLeads_SummaryDisplayText"
            OnCustomDataCallback="gridLeads_CustomDataCallback"
            Settings-ShowColumnHeaders="false"
            SettingsBehavior-AutoExpandAllGroups="true"
            ID="gridLeads" Border-BorderStyle="None" ClientInstanceName="gridLeads" Width="100%" AutoGenerateColumns="False" KeyFieldName="BBLE">
            <Columns>
                <dx:GridViewCommandColumn ShowSelectCheckbox="True" VisibleIndex="0" Name="colSelect" Visible="false" Width="25px">
                </dx:GridViewCommandColumn>
                <dx:GridViewDataTextColumn FieldName="MarkColor"  VisibleIndex="0" Width="30px">
                    <DataItemTemplate>
                        <div>
                        </div>
                        <i class="fa fa-star color_star" onmouseenter="star_mouseenter(this,<%# Eval("BBLE") %>)" style="color: <%#  GetMarkColor(Eval("MarkColor"))%>">
                    </DataItemTemplate>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="LeadsName" Settings-AllowHeaderFilter="False" VisibleIndex="1">
                    <Settings AutoFilterCondition="Contains" />
                    <DataItemTemplate>
                        <div><%# Eval("LeadsName")%></div>
                    </DataItemTemplate>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="MarkColor" Visible="false">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="CallbackDate" Visible="false" PropertiesTextEdit-DisplayFormatString="d" VisibleIndex="2" Caption="Date">
                    <PropertiesTextEdit DisplayFormatString="d"></PropertiesTextEdit>
                    <Settings AllowHeaderFilter="False" GroupInterval="Date"></Settings>
                    <GroupRowTemplate>
                        <%-- Date: <%# GroupText(Container.GroupText) & Container.SummaryText.Replace("Count=","")%>--%>
                        <div>
                            <table style="height: 45px">
                                <tr onclick="ExpandOrCollapseGroupRow(<%# Container.VisibleIndex%>)" style="cursor: pointer">
                                    <td style="width: 80px;">
                                        <span class="font_black">
                                            <i class="fa fa-calendar-o font_16"></i><span class="group_text_margin"><%#  Container.GroupText  %> &nbsp;</span>
                                        </span>
                                    </td>
                                    <td style="padding-left: 10px">
                                        <span class="employee_lest_head_number_label"><%# Container.SummaryText.Replace("Count=", "").Replace("(", "").Replace(")","")%></span>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </GroupRowTemplate>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataColumn FieldName="Neighborhood" Visible="false" VisibleIndex="3">
                    <GroupRowTemplate>
                        <%-- Neighborhood: <%# Container.GroupText & Container.SummaryText.Replace("Count=", "")%>--%>
                        <div>
                            <table style="height: 45px">
                                <tr onclick="ExpandOrCollapseGroupRow(<%# Container.VisibleIndex%>)" style="cursor: pointer">
                                    <td style="width: 80px;">
                                        <span class="font_black">
                                            <i class="fa fa-university font_16"></i><span class="group_text_margin"><%#  Container.GroupText  %> &nbsp;</span>
                                        </span>
                                    </td>
                                    <td style="padding-left: 10px">
                                        <span class="employee_lest_head_number_label"><%# Container.SummaryText.Replace("Count=", "").Replace("(", "").Replace(")", "")%></span>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </GroupRowTemplate>
                </dx:GridViewDataColumn>
                <dx:GridViewDataColumn FieldName="EmployeeName" Visible="false" VisibleIndex="4">
                    <GroupRowTemplate>
                        <div>
                            <table style="height: 45px">
                                <tr onclick="ExpandOrCollapseGroupRow(<%# Container.VisibleIndex%>)" style="cursor: pointer">
                                    <td style="width: 80px;">
                                        <span class="font_black">
                                            <i class="fa fa-user font_16"></i><span class="group_text_margin"><%#  Container.GroupText  %> &nbsp;</span>
                                        </span>
                                    </td>
                                    <td style="padding-left: 10px">
                                        <span class="employee_lest_head_number_label"><%# Container.SummaryText.Replace("Count=", "").Replace("(", "").Replace(")", "")%></span>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </GroupRowTemplate>
                </dx:GridViewDataColumn>
                <dx:GridViewDataColumn FieldName="LastUpdate" Visible="false" VisibleIndex="5"></dx:GridViewDataColumn>
                <dx:GridViewDataColumn Width="40px" VisibleIndex="6">
                    <DataItemTemplate>
                        <div class="hidden_icon">
                            <i class="fa fa-list-alt employee_list_item_icon" style="width: 30px" onclick="<%#String.Format("ShowCateMenu(this,{0})", Eval("BBLE")) %>"></i>
                        </div>
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
                                            <tr style="margin-bottom: 3px; height: 45px" hidden="hidden">
                                                <td>BBLE</td>
                                                <td>
                                                    <dx:ASPxTextBox ID="txtNewBBLE" runat="server" Width="100%" ClientInstanceName="txtNewBBLEClient" CssClass="edit_drop"></dx:ASPxTextBox>
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
                                                          gridLeads.UpdateEdit();                                                                                                                                                                                                                                      
                                                        }" />
                                                    </dx:ASPxButton>
                                                    <dx:ASPxButton RenderMode="Button" Text="Cancel" CssClass="rand-button rand-button-gray" AutoPostBack="false" runat="server">
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
                                <dx:ASPxTextBox runat="server" ID="txtkeyword" Width="240" ClientInstanceName="txtkeyWordClient"></dx:ASPxTextBox>
                            </td>
                            <td>
                                <dx:ASPxButton runat="server" RenderMode="Button" Image-Url="/images/Search.png" Image-Height="16px" Text="Search" Image-Width="16px" AutoPostBack="false">
                                    <FocusRectPaddings PaddingLeft="2" PaddingRight="2" PaddingBottom="0" PaddingTop="0" />
                                    <ClientSideEvents Click="function(s,e){SearchGridLeads();}" />
                                </dx:ASPxButton>
                            </td>
                        </tr>
                    </table>
                </FilterRow>
            </Templates>
            <SettingsBehavior AllowFocusedRow="true" AllowClientEventsOnLoad="true" AllowGroup="true"
                EnableRowHotTrack="True" ColumnResizeMode="NextColumn" />
            <%--<SettingsPager Mode="ShowPager" PageSize="17" Position="Bottom" Summary-Visible="false" ShowDisabledButtons="false" NumericButtonCount="4"></SettingsPager>--%>
            <SettingsPager Mode="EndlessPaging" PageSize="16"></SettingsPager>
            <%--   <SettingsPager Mode="ShowAllRecords"></SettingsPager>--%>
            <Settings ShowColumnHeaders="False" VerticalScrollableHeight="767"></Settings>
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
    </div>

    <%--now is wrong place--%>
    <div style="position: absolute; bottom: 0; padding-left: 34px; margin-bottom: 20px">

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

    <uc1:LeadsSubMenu runat="server" ID="LeadsSubMenu" />

    <dx:ASPxPopupControl ClientInstanceName="ASPxPopupRequestUpdateControl" Width="500px" Height="420px"
        MaxWidth="800px" MinWidth="150px" ID="ASPxPopupControl3"
        HeaderText="Request Update" Modal="true" OnWindowCallback="ASPxPopupControl3_WindowCallback"
        runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server" Visible="false" ID="popContentRequestUpdate">
                <asp:HiddenField runat="server" ID="hfRequestUpdateBBLE" />
                <dx:ASPxFormLayout ID="requestUpdateFormlayout" runat="server" Width="100%">
                    <Items>
                        <dx:LayoutItem Caption="Leads Name">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                    <dx:ASPxTextBox runat="server" Width="100%" CssClass="edit_drop" ID="txtRequestUpdateLeadsName" ReadOnly="true"></dx:ASPxTextBox>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                        <dx:LayoutItem Caption="Create By">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                    <dx:ASPxTextBox runat="server" Width="100%" CssClass="edit_drop" ID="txtRequestUpdateCreateby" ReadOnly="true"></dx:ASPxTextBox>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                        <dx:LayoutItem Caption="Manager">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                    <dx:ASPxTextBox runat="server" Width="100%" CssClass="edit_drop" ID="txtRequestUpdateManager" ReadOnly="true"></dx:ASPxTextBox>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                        <dx:LayoutItem Caption="Importance">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer runat="server" Width="100%" SupportsDisabledAttribute="True">
                                    <dx:ASPxComboBox runat="server" Width="100%" CssClass="edit_drop" ID="cbTaskImportant">
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
                                    <dx:ASPxMemo runat="server" Width="100%" CssClass="edit_drop" Height="80px" ID="txtTaskDes"></dx:ASPxMemo>
                                </dx:LayoutItemNestedControlContainer>
                            </LayoutItemNestedControlCollection>
                        </dx:LayoutItem>
                        <dx:LayoutItem Caption="Description" ShowCaption="False" HorizontalAlign="Right">
                            <LayoutItemNestedControlCollection>
                                <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                    <dx:ASPxButton ID="ASPxButton4" runat="server" Text="Send Request" AutoPostBack="false">
                                        <ClientSideEvents Click="function(){                                                                                                                      
                                                                                                                        ASPxPopupRequestUpdateControl.Hide();
                                                                                                                        ASPxPopupRequestUpdateControl.PerformCallback('SendRequest');
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
            </dx:PopupControlContentControl>
        </ContentCollection>
        <ClientSideEvents EndCallback="OnEndCallbackPanelRequestUpdate" />
    </dx:ASPxPopupControl>

    <dx:ASPxPopupMenu ID="ASPxPopupMenu2" runat="server" ClientInstanceName="aspxPopupSortMenu"
        ShowPopOutImages="false" AutoPostBack="false"
        ForeColor="#3993c1" Font-Size="14px" CssClass="fix_pop_postion_s" Paddings-PaddingTop="15px" Paddings-PaddingBottom="18px"
        PopupHorizontalAlign="Center" PopupVerticalAlign="Below" PopupAction="LeftMouseClick">
        <ItemStyle Paddings-PaddingLeft="20px" />
        <Items>
            <dx:MenuItem Text="Date" Name="Date">
            </dx:MenuItem>
            <dx:MenuItem Text="Name" Name="Name">
            </dx:MenuItem>
            <dx:MenuItem Text="Borough" Name="Borough">
            </dx:MenuItem>
            <dx:MenuItem Text="Employee" Name="Employee">
            </dx:MenuItem>
            <dx:MenuItem Text="Zip" Name="Zip">
            </dx:MenuItem>
            <dx:MenuItem Text="Type" Name="LeadsType">
            </dx:MenuItem>
            <dx:MenuItem Text="Color" Name="MarkColor">
            </dx:MenuItem>
        </Items>
        <ClientSideEvents ItemClick="OnSortMenuClick" />
    </dx:ASPxPopupMenu>
</div>


<script>

    //mouse move function 
    function star_mouseenter(e, bble) {
        temBBLE = bble;
        var p = $(e).position();

        var color_drop = $("#color_drop");
       
        color_drop.css("left", p.left + "px");
        color_drop.css("top", (p.top) + 110 + 'px');
        temStar = e;
    }
    $(".color_star").mouseenter(function () {

    });
    $("#color_drop").mouseleave(function () {
        $(this).css("top", '-1000px')
    });
</script>
