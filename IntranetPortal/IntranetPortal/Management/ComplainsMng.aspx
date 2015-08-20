<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ComplainsMng.aspx.vb" Inherits="IntranetPortal.ComplainsMng" MasterPageFile="~/Content.Master" %>

<asp:Content runat="server" ContentPlaceHolderID="head">
    <script type="text/javascript">
        function SearchGrid() {
            var filterCondition = "";
            var key = document.getElementById("QuickSearch").value;

            if (key.trim() == "") {
                gdComplains.ClearFilter();
                return;
            }

            filterCondition = "[Address] LIKE '%" + key + "%'";
            gdComplains.ApplyFilter(filterCondition);
            return false;
        }

        function SearchComplains() {
            var key = document.getElementById("gdComplainKey").value;

            if (key.trim() == "") {
                gdComplainsResult.ClearFilter();
                return;
            }

            FilterComplaints(key);
        }

        function FilterComplaints(key) {
            var filterCondition = "";

            filterCondition = "[Address] LIKE '%" + key + "%'";
            filterCondition += " OR [BBLE] LIKE '%" + key + "%'";
            gdComplainsResult.ApplyFilter(filterCondition);
            return false;
        }

        function SetView() {
            var value = rbBBLE.GetChecked();
            txtBBLE.SetEnabled(value);
            txtNumber.SetEnabled(!value);
            txtStreet.SetEnabled(!value);
            txtCity.SetEnabled(!value);
        }
        var needRefreshResult = false;
        function RefreshProperty(bble) {
            needRefreshResult = true;
            gdComplains.PerformCallback("Refresh|" + bble);
        }

        function RemoveProperty(bble) {
            needRefreshResult = true;
            gdComplains.PerformCallback("Delete|" + bble);
        }

        function RefreshResult() {
            gdComplainsResult.Refresh();
            needRefreshResult = false;
        }

        function expandAllClick(s, content) {
            if (content.is(':visible')) {
                content.hide();
                $(s).attr("class", 'fa fa-expand icon_btn tooltip-examples grid_buttons');
            }
            else {
                content.show();
                $(s).attr("class", 'fa fa-compress icon_btn tooltip-examples grid_buttons');
            }
        }

        function ShowComplaintsHistory(bble)
        {
            popupComplaintHistory.PerformCallback(bble);
            popupComplaintHistory.Show();
        }
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <style type="text/css">
        .form_header {
            background-color: #efefef;
            line-height: 40px;
            padding-left: 15px;
            font-weight: 600;
        }

        a:hover {
            background-color: #045cad;
            font-weight: 600;
        }

        table tr td {
            padding-left: 5px;
        }

        .form_border {
            border: 1px solid #808080;
            padding: 0px;
            margin-top: 10px;
        }
    </style>
    <div class="container">
        <h3 style="text-align: center; line-height: 50px">DOB Complaints</h3>
        <div class="row form_border">
            <div class="form_header">
                Add Property to Watch &nbsp;<i class="fa fa-compress icon_btn tooltip-examples grid_buttons" style="font-size: 18px;" title="Collapse" onclick="expandAllClick(this, $('#tblAddProp'))"></i>
            </div>
            <table style="width: 550px; margin: 10px;" id="tblAddProp">
                <tr>
                    <th style="width: 200px">
                        <dx:ASPxRadioButton runat="server" ID="rbBBLE" GroupName="Test" ClientInstanceName="rbBBLE" Checked="true">
                            <ClientSideEvents CheckedChanged="function(s,e){
                                SetView();
                                }" />
                        </dx:ASPxRadioButton>
                        &nbsp;By BBLE
                    </th>
                    <th style="width: 240px">
                        <dx:ASPxRadioButton runat="server" ID="rbAddress" GroupName="Test"></dx:ASPxRadioButton>
                        &nbsp;By Address
                    </th>
                    <th></th>
                </tr>
                <tr>
                    <td style="vertical-align: top">
                        <dx:ASPxTextBox runat="server" ID="txtBBLE" ClientInstanceName="txtBBLE" Native="true" CssClass="form-control" Width="150px"></dx:ASPxTextBox>
                    </td>
                    <td>
                        <table style="line-height: 35px">
                            <tr>
                                <td>Number:
                                </td>
                                <td>
                                    <dx:ASPxTextBox runat="server" ID="txtNumber" ClientInstanceName="txtNumber" Native="true" CssClass="form-control" Width="150px"></dx:ASPxTextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>Street:
                                </td>
                                <td>
                                    <dx:ASPxTextBox runat="server" ID="txtStreet" ClientInstanceName="txtStreet" Native="true" CssClass="form-control" Width="150px"></dx:ASPxTextBox>
                                </td>

                            </tr>
                            <tr>
                                <td>City:
                                </td>
                                <td>
                                    <dx:ASPxTextBox runat="server" ID="txtCity" ClientInstanceName="txtCity" Native="true" CssClass="form-control" Width="150px"></dx:ASPxTextBox>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td>
                        <input type="button" value="Verify" runat="server" id="btnCheck" onserverclick="btnCheck_ServerClick" /><br />
                        <input type="button" value="Add to Watch" id="btnAdd" onclick="gdComplains.PerformCallback('Add')" style="margin-top: 10px;" runat="server" visible="false" />
                    </td>
                </tr>
            </table>
            <dx:ASPxLabel runat="server" ID="lblAddress" Visible="false"></dx:ASPxLabel>
        </div>
        <div class="row form_border" style="">
            <div class="form_header">
                Properties Watch List &nbsp;<i class="fa fa-compress icon_btn tooltip-examples grid_buttons" style="font-size: 18px;" title="Collapse" onclick="expandAllClick(this, $('#divComplains'))"></i>
                <div class="form-inline" style="float: right; font-weight: normal">
                    <input type="text" style="margin-right: 10px" id="QuickSearch" class="form-control" placeholder="Quick Search" onkeydown="javascript:if(event.keyCode == 13){ SearchGrid(); return false;}" />
                    <i class="fa fa-search icon_btn tooltip-examples  grid_buttons" style="margin-right: 20px; font-size: 19px" onclick="SearchGrid()" title="search"></i>
                </div>
            </div>
            <div id="divComplains">
                <dx:ASPxGridView ID="gdComplains" Width="100%" ClientInstanceName="gdComplains" runat="server" KeyFieldName="BBLE" Theme="Moderno" CssClass="table" OnDataBinding="gdCases_DataBinding" OnCustomCallback="gdComplains_CustomCallback">
                    <Columns>
                        <dx:GridViewDataColumn FieldName="BBLE" Width="120px">
                            <DataItemTemplate>
                                <a href="#" onclick="FilterComplaints('<%# Eval("BBLE")%>')"><%# Eval("BBLE")%></a>
                            </DataItemTemplate>
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="Address">
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataDateColumn FieldName="LastExecute" Width="150px" PropertiesDateEdit-DisplayFormatString="g">
                           
                        </dx:GridViewDataDateColumn>
                        <dx:GridViewDataColumn FieldName="CreateBy" Caption="CreateBy" Width="120px">
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn Width="80px">
                            <DataItemTemplate>
                                <i class="fa fa-refresh icon_btn tooltip-examples grid_buttons" style="margin-left: 10px; font-size: 19px" onclick="RefreshProperty('<%# Eval("BBLE")%>')" title="Refresh"></i>&nbsp;
                            <i class="fa fa-close icon_btn tooltip-examples grid_buttons" style="margin-left: 10px; font-size: 19px" onclick="RemoveProperty('<%# Eval("BBLE")%>')" title="Remove"></i>
                            </DataItemTemplate>
                        </dx:GridViewDataColumn>
                    </Columns>
                    <SettingsPager Mode="EndlessPaging" PageSize="20"></SettingsPager>
                    <Settings ShowHeaderFilterButton="true" VerticalScrollableHeight="400" />
                    <SettingsBehavior ConfirmDelete="true" />
                    <SettingsText ConfirmDelete="The follow up date will be cleared. Continue?" />
                    <ClientSideEvents EndCallback="function(s,e){ if(needRefreshResult){ RefreshResult();}}" />
                </dx:ASPxGridView>
            </div>
        </div>        
        <div class="row form_border">
            <div class="form_header">
                DOB Active Complaints &nbsp;<i class="fa fa-compress icon_btn tooltip-examples grid_buttons" style="font-size: 18px;" title="Collapse" onclick="expandAllClick(this, $('#divComplainResult'))"></i>
                <div class="form-inline" style="float: right; font-weight: normal">
                    <i class="fa fa-refresh icon_btn tooltip-examples  grid_buttons" style="margin-left: 10px;margin-right: 10px;font-size: 19px" onclick="RefreshResult()" title="Refresh"></i>                    
                    <input type="text" style="margin-right: 10px" id="gdComplainKey" class="form-control" placeholder="Quick Search" onkeydown="javascript:if(event.keyCode == 13){ SearchGrid(); return false;}" />
                    <i class="fa fa-search icon_btn tooltip-examples  grid_buttons" style="font-size: 19px;margin-right: 20px; " onclick="SearchComplains()" title="search"></i>                    
                </div>
            </div>
            <div id="divComplainResult">
                <dx:ASPxGridView ID="gdComplainsResult" ClientInstanceName="gdComplainsResult" runat="server" Theme="Moderno" CssClass="table"  Width="100%"
                    KeyFieldName="BBLE;ComplaintNumber" OnDataBinding="gdComplainsResult_DataBinding" OnCustomCallback="gdComplainsResult_CustomCallback">
                    <Columns>
                        <dx:GridViewDataColumn FieldName="Address">
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="ComplaintNumber">
                        </dx:GridViewDataColumn>  
                        <dx:GridViewDataColumn FieldName="AssignedTo">
                        </dx:GridViewDataColumn>                                               
                        <dx:GridViewDataDateColumn FieldName="LastUpdated" PropertiesDateEdit-DisplayFormatString="g">
                        </dx:GridViewDataDateColumn>                       
                        <dx:GridViewDataColumn FieldName="Status">
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn Width="50px" CellStyle-VerticalAlign="Middle">
                            <DataItemTemplate>
                                <i class="fa fa-history icon_btn tooltip-examples grid_buttons" style="margin-left: 10px; font-size: 19px" title="View History" onclick='ShowComplaintsHistory("<%#Eval("BBLE")%>")'></i>                            
                            </DataItemTemplate>
                        </dx:GridViewDataColumn>
                    </Columns>
                    <Templates>
                        <DetailRow>
                            <table class="" style="width:100%; border: 1px solid #808080; line-height: 25px">
                                <tr>
                                    <td colspan="4" class="form_header">Complaints Detail
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 150px;">Address
                                    </td>
                                    <td style="width: 35%">
                                        <%#Eval("Address")%>
                                    </td>
                                    <td style="width: 150px">BIN
                                    </td>
                                    <td style="width: 35%">
                                        <%#Eval("BIN")%>
                                    </td>
                                </tr>
                                 <tr>
                                    <td style="width: 150px">Comments
                                    </td>
                                    <td>
                                        <%#Eval("Comments")%>
                                    </td>
                                    <td>AssignedTo
                                    </td>
                                    <td>
                                        <%#Eval("AssignedTo")%>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 150px">Category
                                    </td>
                                    <td>
                                        <%#Eval("CategoryCode")%>
                                    </td>
                                    <td>ComplaintNumber
                                    </td>
                                    <td>
                                        <%#Eval("ComplaintNumber")%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Subject
                                    </td>
                                    <td>
                                        <%#Eval("Subject")%>
                                    </td>
                                    <td>Zip
                                    </td>
                                    <td>
                                        <%#Eval("Zip")%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>DOB Violation
                                    </td>
                                    <td>
                                        <%#Eval("DOBViolation")%>
                                    </td>
                                    <td>DateEntered
                                    </td>
                                    <td>
                                        <%#Eval("DateEntered")%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Disposition
                                    </td>
                                    <td>
                                        <%#Eval("Disposition")%>
                                    </td>
                                    <td>DispositionDetails
                                    </td>
                                    <td>
                                        <%#Eval("DispositionDetails")%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>LastInspection
                                    </td>
                                    <td>
                                        <%#Eval("LastInspection")%>
                                    </td>
                                    <td>LastUpdated
                                    </td>
                                    <td>
                                        <%#Eval("LastUpdated")%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Owner
                                    </td>
                                    <td>
                                        <%#Eval("Owner")%>
                                    </td>
                                    <td>Priority
                                    </td>
                                    <td>
                                        <%#Eval("Priority")%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>RE
                                    </td>
                                    <td>
                                        <%#Eval("ECBViolation")%>
                                    </td>
                                    <td>Reference311Number
                                    </td>
                                    <td>
                                        <%#Eval("Reference311Number")%>
                                    </td>
                                </tr>

                            </table>                            
                        </DetailRow>
                    </Templates>
                      <SettingsPager Mode="EndlessPaging" PageSize="20"></SettingsPager>
                    <SettingsDetail ShowDetailRow="true" />
                    <Settings ShowHeaderFilterButton="true" VerticalScrollableHeight="400" />                    
                </dx:ASPxGridView>
            </div>
        </div>
       
         <dx:ASPxPopupControl ClientInstanceName="popupComplaintHistory" Width="800px" Height="480px"
            ID="popupComplaintHistory" OnWindowCallback="popupComplaintHistory_WindowCallback"
            HeaderText="Previous Notes" Modal="true"
            runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
            <HeaderTemplate>
                <div class="clearfix">
                    <div class="pop_up_header_margin">
                        <i class="fa fa-history with_circle pop_up_header_icon"></i>
                        <span class="pop_up_header_text">Complaints History</span>
                    </div>
                    <div class="pop_up_buttons_div">
                        <i class="fa fa-times icon_btn" onclick="popupComplaintHistory.Hide()"></i>
                    </div>
                </div>
            </HeaderTemplate>
            <ContentCollection>
                <dx:PopupControlContentControl runat="server" Visible="false" ID="popCtrHistory">
                    <dx:ASPxGridView ID="gdComplainsHistory" ClientInstanceName="gdComplainsHistory" runat="server" Theme="Moderno" CssClass="table"  Width="100%"
                    KeyFieldName="ResultId">
                    <Columns>
                        <dx:GridViewDataColumn FieldName="Address">
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="ComplaintNumber">
                        </dx:GridViewDataColumn>  
                        <dx:GridViewDataColumn FieldName="AssignedTo">
                        </dx:GridViewDataColumn>                                               
                        <dx:GridViewDataDateColumn FieldName="LastUpdated" PropertiesDateEdit-DisplayFormatString="g">
                        </dx:GridViewDataDateColumn>                       
                        <dx:GridViewDataColumn FieldName="Status">
                        </dx:GridViewDataColumn>                        
                    </Columns>
                    <Templates>
                        <DetailRow>
                            <table class="" style="width:100%; border: 1px solid #808080; line-height: 25px">
                                <tr>
                                    <td colspan="4" class="form_header">Complaints Detail
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 150px;">Address
                                    </td>
                                    <td style="width: 35%">
                                        <%#Eval("Address")%>
                                    </td>
                                    <td style="width: 150px">BIN
                                    </td>
                                    <td style="width: 35%">
                                        <%#Eval("BIN")%>
                                    </td>
                                </tr>
                                 <tr>
                                    <td style="width: 150px">Comments
                                    </td>
                                    <td>
                                        <%#Eval("Comments")%>
                                    </td>
                                    <td>AssignedTo
                                    </td>
                                    <td>
                                        <%#Eval("AssignedTo")%>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 150px">Category
                                    </td>
                                    <td>
                                        <%#Eval("CategoryCode")%>
                                    </td>
                                    <td>ComplaintNumber
                                    </td>
                                    <td>
                                        <%#Eval("ComplaintNumber")%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Subject
                                    </td>
                                    <td>
                                        <%#Eval("Subject")%>
                                    </td>
                                    <td>Zip
                                    </td>
                                    <td>
                                        <%#Eval("Zip")%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>DOB Violation
                                    </td>
                                    <td>
                                        <%#Eval("DOBViolation")%>
                                    </td>
                                    <td>DateEntered
                                    </td>
                                    <td>
                                        <%#Eval("DateEntered")%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Disposition
                                    </td>
                                    <td>
                                        <%#Eval("Disposition")%>
                                    </td>
                                    <td>DispositionDetails
                                    </td>
                                    <td>
                                        <%#Eval("DispositionDetails")%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>LastInspection
                                    </td>
                                    <td>
                                        <%#Eval("LastInspection")%>
                                    </td>
                                    <td>LastUpdated
                                    </td>
                                    <td>
                                        <%#Eval("LastUpdated")%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Owner
                                    </td>
                                    <td>
                                        <%#Eval("Owner")%>
                                    </td>
                                    <td>Priority
                                    </td>
                                    <td>
                                        <%#Eval("Priority")%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>RE
                                    </td>
                                    <td>
                                        <%#Eval("ECBViolation")%>
                                    </td>
                                    <td>Reference311Number
                                    </td>
                                    <td>
                                        <%#Eval("Reference311Number")%>
                                    </td>
                                </tr>

                            </table>                                                                            
                        </DetailRow>
                    </Templates>
                      <SettingsPager Mode="EndlessPaging" PageSize="20"></SettingsPager>
                    <SettingsDetail ShowDetailRow="true" />
                    <Settings ShowHeaderFilterButton="true" VerticalScrollableHeight="400" />                    
                </dx:ASPxGridView>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

        <br />
    </div>
    <script type="text/javascript">
        $(function () { SetView() });
        $(function () {
            setTimeout(RefreshResult(), 1000);
        });
    </script>
</asp:Content>
