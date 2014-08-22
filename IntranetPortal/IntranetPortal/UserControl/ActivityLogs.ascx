<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ActivityLogs.ascx.vb" Inherits="IntranetPortal.ActivityLogs" %>
<style type="text/css">
    .TaskLogStyle {
        background-color: #FFC5C5;
        color: black;
        padding: 2px;
    }

    .AppointLogStyle {
        background-color: #CCFFC8;
        color: black;
        padding: 2px;
        margin: 2px;
    }

    .CommentTextBoxStyle {
        border-radius: 5px;
        width: 100%;
        height: 90px;
        border: 2px solid #dde0e7;
    }
</style>
<script type="text/javascript">
    function OnlogSelectedIndexChanged(s, e) {
        var selectedItems = cbCateLogClient.GetSelectedItems();
        //ddlCateLogClient.SetText(GetSelectedItemsText(selectedItems));

        var filterCondition = "";

        for (var i = 0; i < cbCateLogClient.GetItemCount() ; i++) {

            var cate = cbCateLogClient.GetItem(i);

            if (cate.selected) {
                if (filterCondition == "")
                    filterCondition = "[Category] = '" + cate.value + "'";
                else
                    filterCondition += " OR [Category] = '" + cate.value + "'";
            }
        }

        if (filterCondition == "")
            gridTrackingClient.ClearFilter();
        else
            gridTrackingClient.ApplyFilter(filterCondition);
    }

    var empTextBox = null;

    function OnSelectedEmpComplete() {
        var emps = "";
        for (var i = 0; i < lbEmployeesClient.GetItemCount() ; i++) {
            emps += lbEmployeesClient.GetItem(i).text + ";";
        }
        txtEmpsClient.SetText(emps);
    }

</script>

<script type="text/javascript">
    // <![CDATA[
    var textSeparator = "; ";
    function OnEmpComboBoxSelectionChanged(listBox, args) {

        UpdateText();
        SynchronizeRecentlyComboBox();
    }

    function SynchronizeRecentlyComboBox() {
        empRecentlyListbox.UnselectAll();
        var selectedItems = empListBox.GetSelectedItems();
        for (var i = 0; i < selectedItems.length; i++) {
            var item = empRecentlyListbox.FindItemByText(selectedItems[i].text);
            if (item != null)
                empRecentlyListbox.SetSelectedItem(item);
        }
    }

    function OnEmpRecentlyComboBoxSelectionChanged(listbox, args) {
        //var empSelectedItems = empListBox.GetSelectedItems();
        var selectedItems = empRecentlyListbox.GetSelectedItems();

        empCheckComboBox.SetText(GetSelectedItemsText(selectedItems));
        //for (var i = 0; i < selectedItems.length; i++) {
        //    var item = empListBox.FindItemByText(selectedItems[i].text);
        //    alert(item.value);
        //    if (item != null)
        //        empListBox.SetSelectedItem(item);
        //}
        SynchronizeEmpListBoxValues(empCheckComboBox);
    }

    function OnEmplistSearch(key) {
        var firstIndex = 0;

        for (var i = 0; i < empListBox.GetItemCount() ; i++) {
            var text = empListBox.GetItem(i).text;

            if (text.toLowerCase().search(key.toLowerCase()) == 0) {
                firstIndex = i;
                break;
            }

        }
        //alert(firstIndex);
        empListBox.MakeItemVisible(firstIndex);
    }

    //function UpdateSelectAllItemState() {
    //    IsAllSelected() ? empListBox.SelectIn  s([0]) : empListBox.UnselectIndices([0]);
    //}
    //function IsAllSelected() {
    //    var selectedDataItemCount = empListBox.GetItemCount() - (empListBox.GetItem(0).selected ? 0 : 1);
    //    return empListBox.GetSelectedItems().length == selectedDataItemCount;
    //}
    function UpdateText() {
        var selectedItems = empListBox.GetSelectedItems();
        empCheckComboBox.SetText(GetSelectedItemsText(selectedItems));

    }
    function SynchronizeEmpListBoxValues(dropDown, args) {
        empListBox.UnselectAll();
        var texts = dropDown.GetText().split(textSeparator);
        var values = GetValuesByTexts(texts);
        empListBox.SelectValues(values);
        //UpdateSelectAllItemState();
        UpdateText(); // for remove non-existing texts

        empRecentlyListbox.UnselectAll();
        empRecentlyListbox.SelectValues(values);
    }
    function GetSelectedItemsText(items) {
        var texts = [];
        for (var i = 0; i < items.length; i++)
            if (items[i].index >= 0)
                texts.push(items[i].text);
        return texts.join(textSeparator);
    }
    function GetValuesByTexts(texts) {
        var actualValues = [];
        var item;
        for (var i = 0; i < texts.length; i++) {
            item = empListBox.FindItemByText(texts[i]);
            if (item != null)
                actualValues.push(item.value);
        }
        return actualValues;
    }

    function CompleteTask(logID) {
        gridTrackingClient.PerformCallback("CompleteTask|" + logID);

        if (typeof gridLeads != 'undefined')
            gridLeads.Refresh();
    }

    function ApproveNewLead(logID) {
        gridTrackingClient.PerformCallback("ApproveNewLead|" + logID);

        if (typeof gridLeads != 'undefined')
            gridLeads.Refresh();
    }

    function DeclineNewLead(logID) {
        gridTrackingClient.PerformCallback("DeclineNewLead|" + logID);

        if (typeof gridLeads != 'undefined')
            gridLeads.Refresh();
    }

    var lastIndexofAppointmentAction = null;
    function AppointmentAction(s, logID) {
        var item = s.GetSelectedItem();

        if (lastIndexofAppointmentAction == item.index || item.text == "")
            return;

        if (!confirm("Are your sure to " + item.text + "?")) {
            s.SetText("");
            return;
        }
        else {
            lastIndexofAppointmentAction = item.index;
        }

        if (item.index == 0) {
            AcceptAppointment(logID);
        }

        if (item.index == 1)
            DeclineAppointment(logID);

        if (item.index == 2) {
            if (typeof ASPxPopupScheduleClient != 'undefined') {
                ASPxPopupScheduleClient.Show();
                appointmentCallpanel.PerformCallback(logID);
            }

        }
    }

    function AcceptAppointment(logID) {
        gridTrackingClient.PerformCallback("AcceptAppointment|" + logID);
        if (typeof gridLeads != 'undefined')
            gridLeads.Refresh();
    }

    function DeclineAppointment(logID) {
        gridTrackingClient.PerformCallback("DeclineAppointment|" + logID);
        if (typeof gridLeads != 'undefined')
            gridLeads.Refresh();
    }

    function ReScheduledAppointment(logID) {
        gridTrackingClient.PerformCallback("ReScheduleAppointment|" + logID);
        if (typeof gridLeads != 'undefined')
            gridLeads.Refresh();
    }

    function OnCbTaskScheduleSelectedIndexChanged(s, e) {
        if (s.GetSelectedIndex() == 3)
            ASPxPopupScheduleSelectDateControl.ShowAtElement(s.GetMainElement());
    }
    function OnLogMemoKeyDown(s, e) {
        var textArea = s.GetInputElement();
        if (e.htmlEvent.keyCode == 13) {
            //alert(textArea.scrollHeight + "|" + s.GetHeight());
            var text = txtCommentsClient.GetText();
            if (text.trim() == "") {
                alert("Please input comments.");
            }
            else
                gridTrackingClient.UpdateEdit();

            e.htmlEvent.preventDefault();
            return;
        }

        if (textArea.scrollHeight + 2 > s.GetHeight()) {
            //alert(textArea.scrollHeight + "|" + s.GetHeight());
            s.SetHeight(textArea.scrollHeight + 2);
        }

        if (textArea.scrollHeight + 2 < s.GetHeight()) {
            //alert(textArea.scrollHeight + "|" + s.GetHeight());
            s.SetHeight(textArea.scrollHeight + 2);
        }
    }

    function InsertNewComments() {
        var comments = document.getElementById("txtComments");

        if (comments.value == "") {
            alert("Comments can not be empty.")
            return;
        }

        var addDate = dateActivityClient.GetDate();
        if (addDate == null)
            addDate = new Date();

        addCommentsCallbackClient.PerformCallback(addDate.toJSON() + "|" + comments.value);
    }
    // ]]>
</script>

<div style="font-size: 12px; color: #9fa1a8; font-family: 'Source Sans Pro'; width: 100%">
    <!-- Nav tabs -->
    <%--comment box filters--%>
    <div style="padding: 20px; background: #f5f5f5" class="clearfix">
        <%--comment box and text--%>

        <div style="float: left; height: 110px; width: 460px; margin-top: 10px;">
            <div class="clearfix">
                <span style="color: #295268;" class="upcase_text">Add Comment&nbsp;&nbsp;<i class="fa fa-comment" style="font-size: 14px"></i></span>
                <input type="radio" id="sex12" name="sex" value="Fannie" class="font_12" />
                <label for="sex12" class="font_12">
                    <span class="upcase_text">Internal update</span>
                </label>
                <input type="radio" id="sexf11" name="sex" value="FHA" class="font_12" />
                <label for="sexf11" class="font_12">
                    <span class="upcase_text">Public update</span>
                </label>
            </div>
            <textarea style="border-radius: 5px; width: 100%; height: 90px; border: 2px solid #dde0e7;" id="txtComments"></textarea>
        </div>
        <div class="clearfix" style="width: 100%">
            <div style="float: right">
                <div style="color: #2e2f31; float: right">
                    FILTER BY:&nbsp;&nbsp<i class="fa fa-filter acitivty_short_button" style="color: #444547; font-size: 14px;" onclick="popupFilterControl.ShowAtElement(this)"></i>
                </div>
                <dx:ASPxPopupControl runat="server" ID="popupFilters">
                </dx:ASPxPopupControl>
                <div style="margin-top: 50px">
                    <div class="border_under_line">
                        <dx:ASPxDateEdit ID="dateActivity" ClientInstanceName="dateActivityClient" Width="135px" runat="server" DisplayFormatString="d"></dx:ASPxDateEdit>
                    </div>
                </div>
                <div style="margin-top: 15px; float: right">
                    <i class="fa fa-plus-circle activity_add_buttons" style="margin-right: 15px; cursor: pointer" onclick="InsertNewComments()"></i>
                    <i class="fa fa-tasks activity_add_buttons" style="cursor: pointer" onclick="ASPxPopupSetAsTaskControl.ShowAtElement(this)"></i>
                </div>
            </div>
        </div>
    </div>
    <dx:ASPxCallback runat="server" ID="addCommentsCallback" ClientInstanceName="addCommentsCallbackClient" OnCallback="addCommentsCallback_Callback">
        <ClientSideEvents EndCallback="function(s,e){gridTrackingClient.Refresh(); document.getElementById('txtComments').value='';}" />
    </dx:ASPxCallback>
    <%-------end-----%>
    <%-- log tables--%>
    <div style="width: 100%; padding: 0px; display: block;">
        <asp:HiddenField ID="hfBBLE" runat="server" />
        <dx:ASPxGridView ID="gridTracking" Width="100%" SettingsCommandButton-UpdateButton-ButtonType="Image" Visible="true" SettingsEditing-Mode="EditForm" ClientInstanceName="gridTrackingClient" runat="server" AutoGenerateColumns="False" KeyFieldName="LogID" SettingsBehavior-AllowSort="false" OnAfterPerformCallback="gridTracking_AfterPerformCallback" Styles-FilterBuilderHeader-BackColor="Gray">
            <Styles>
                <Cell VerticalAlign="Top"></Cell>
                
            </Styles>
            <Templates>
                <EditForm>
                    <table style="width: 100%; margin: 0;">
                        <tr>
                            <td style="width: 140px;"></td>
                            <td></td>
                            <td style="width: 20px; padding: 2px; vertical-align: middle">
                                <dx:ASPxGridViewTemplateReplacement ID="AddButton" ReplacementType="EditFormUpdateButton" runat="server" ValidateRequestMode="Enabled" />
                            </td>
                            <td style="width: 20px; padding: 2px; padding-top: 0px; vertical-align: top"></td>
                        </tr>
                    </table>
                </EditForm>
               
            </Templates>
            
            <Columns>
                <dx:GridViewDataColumn FieldName="ActionType" VisibleIndex="0" Caption="" Width="40px">
                    <HeaderTemplate>
                    </HeaderTemplate>
                    <DataItemTemplate>                     
                          <%# GetCommentsIconClass(Eval("ActionType"))%>                      
                    </DataItemTemplate>
                    <CellStyle VerticalAlign="Top"></CellStyle>
                </dx:GridViewDataColumn>
                <dx:GridViewDataTextColumn FieldName="Comments" PropertiesTextEdit-EncodeHtml="false" VisibleIndex="1" FilterCellStyle-Wrap="Default" EditCellStyle-Wrap="False">
                    <HeaderTemplate>
                        What Happended
                    </HeaderTemplate>
                    <PropertiesTextEdit EncodeHtml="False"></PropertiesTextEdit>
                    <EditCellStyle Wrap="False"></EditCellStyle>
                    <DataItemTemplate>
                        <asp:Panel runat="server" ID="pnlAppointment" Visible='<%# Eval("Category").ToString.StartsWith("Appointment")%>'>
                            <div class="log_item_col1">
                                <div class="font_black color_balck clearfix">
                                    <table style="width: 100%">
                                        <tr>
                                            <td style="width: 200px">Appointment with
                                                <asp:Label runat="server" ID="lblOwnerName"></asp:Label></td>
                                            <td>
                                                <div style="float: right; font-size: 18px">
                                                    <dx:ASPxCheckBox Text="Accepted" runat="server" TextAlign="Left" ID="chkAptAccept" Visible="false"></dx:ASPxCheckBox>
                                                    <dx:ASPxCheckBox Text="Declined&nbsp;" runat="server" TextAlign="Left" ID="chkAptDecline" Visible="false"></dx:ASPxCheckBox>
                                                    <dx:ASPxCheckBox Text="Scheduled" runat="server" TextAlign="Left" ID="chkAptReschedule" Visible="false"></dx:ASPxCheckBox>
                                                    <i class="fa fa-check-circle-o log_item_hl_buttons tooltip-examples" runat="server" id="btnAccept" title="Accept" onclick='<%# String.Format("AcceptAppointment(""{0}"")", Eval("LogID"))%>'></i>
                                                    <i class="fa fa-times-circle-o log_item_hl_buttons" title="Decline" runat="server" id="btnDecline" onclick='<%# String.Format("DeclineAppointment(""{0}"")", Eval("LogID"))%>'></i>
                                                    <i class="fa fa-history log_item_hl_buttons" title="Reschedule" runat="server" id="btnReschedule" onclick='<%# String.Format("ReScheduledAppointment(""{0}"")", Eval("LogID"))%>'></i>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <asp:Literal runat="server" ID="ltApt"></asp:Literal>
                                <table style="margin-top: 5px;" runat="server" id="tblApt">
                                    <tr>
                                        <td><i class="fa fa-info-circle log_item_icon"></i></td>
                                        <td>
                                            <asp:Literal runat="server" ID="ltAptType"></asp:Literal></td>
                                    </tr>
                                    <tr>
                                        <td><i class="fa fa-clock-o log_item_icon"></i></td>
                                        <td>
                                            <asp:Literal runat="server" ID="ltStartTime"></asp:Literal>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><i class="fa fa-clock-o log_item_icon"></i></td>
                                        <td>
                                            <asp:Literal runat="server" ID="ltEndTime"></asp:Literal></td>
                                    </tr>
                                    <tr>
                                        <td><i class="fa fa-map-marker log_item_icon"></i></td>
                                        <td>
                                            <asp:Literal runat="server" ID="ltAptLocation"></asp:Literal></td>
                                    </tr>
                                    <tr>
                                        <td><i class="fa fa-hand-o-right log_item_icon"></i></td>
                                        <td>
                                            <asp:Literal runat="server" ID="ltAptMgr"></asp:Literal></td>
                                    </tr>
                                    <tr>
                                        <td><i class="fa fa-comment log_item_icon"></i></td>
                                        <td>
                                            <asp:Literal runat="server" ID="ltAptComments"></asp:Literal></td>
                                    </tr>
                                </table>
                            </div>
                        </asp:Panel>

                        <asp:Panel runat="server" ID="pnlTask" Visible='<%# Eval("Category").ToString.StartsWith("Task")%>'>
                            <div class="log_item_col1">
                                <div class="font_black color_balck clearfix">
                                    <table style="width: 100%">
                                        <tr>
                                            <td style="width: 200px">Task</td>
                                            <td>
                                                <div style="float: right; font-size: 18px">
                                                    <dx:ASPxCheckBox Text="Completed" runat="server" TextAlign="Left" ID="chkTaskComplete" Visible="false"></dx:ASPxCheckBox>
                                                    <i class="fa fa-check-circle-o log_item_hl_buttons tooltip-examples" onclick='<%# String.Format("CompleteTask(""{0}"")", Eval("LogID"))%>' title="Completed" runat="server" id="btnTaskComplete" visible="false"></i>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <asp:Literal runat="server" ID="ltTasklogData"></asp:Literal>
                                <table style="margin-top: 5px;" runat="server" id="tblTask">
                                    <tr>
                                        <td><i class="fa fa-group log_item_icon"></i></td>
                                        <td>
                                            <asp:Literal runat="server" ID="ltTaskEmp"></asp:Literal></td>
                                    </tr>
                                    <tr>
                                        <td><i class="fa fa-hand-o-right log_item_icon"></i></td>
                                        <td>
                                            <asp:Literal runat="server" ID="ltTaskAction"></asp:Literal></td>
                                    </tr>
                                    <tr>
                                        <td><i class="fa fa-sort-numeric-asc log_item_icon"></i></td>
                                        <td>
                                            <asp:Literal runat="server" ID="ltTaskImpt"></asp:Literal></td>
                                    </tr>

                                    <tr>
                                        <td><i class="fa fa-comment log_item_icon"></i></td>
                                        <td>
                                            <asp:Literal runat="server" ID="ltTaskComments"></asp:Literal></td>
                                    </tr>
                                </table>
                            </div>
                        </asp:Panel>


                        <asp:Panel runat="server" Visible='<%# Eval("Category").ToString.StartsWith("Approval")%>' ID="panelTask">
                            <table style="width: 100%">
                                <thead>
                                    <tr>
                                        <td style="font-weight: bold"><%# Eval("Category")%> </td>
                                        <td style="text-align: right; width: 120px;">
                                            <div style="float: right">
                                                <dx:ASPxCheckBox Text="Completed" runat="server" TextAlign="Left" ID="chkComplete" Visible="false"></dx:ASPxCheckBox>
                                                <dx:ASPxCheckBox Text="Accepted" runat="server" TextAlign="Left" ID="chkAccepted" Visible="false"></dx:ASPxCheckBox>
                                                <dx:ASPxCheckBox Text="Declined&nbsp;" runat="server" TextAlign="Left" ID="chkDeclined" Visible="false"></dx:ASPxCheckBox>
                                                <dx:ASPxCheckBox Text="Scheduled" runat="server" TextAlign="Left" ID="chkReschedule" Visible="false"></dx:ASPxCheckBox>

                                                <asp:Panel runat="server" ID="pnlAptButton" Visible="false">
                                                    <div style="float: right; font-size: 18px">
                                                        <i class="fa fa-check-circle-o log_item_hl_buttons tooltip-examples" title="Accept" onclick='<%# String.Format("AcceptAppointment(""{0}"")", Eval("LogID"))%>'></i>
                                                        <i class="fa fa-times-circle-o log_item_hl_buttons" title="Decline" onclick='<%# String.Format("DeclineAppointment(""{0}"")", Eval("LogID"))%>'></i>
                                                        <i class="fa fa-history log_item_hl_buttons" title="Reschedule" onclick='<%# String.Format("ReScheduledAppointment(""{0}"")", Eval("LogID"))%>'></i>
                                                    </div>
                                                </asp:Panel>

                                                <dx:ASPxComboBox runat="server" ID="cbAppointAction" Visible="false" Width="85px">
                                                    <Items>
                                                        <dx:ListEditItem Text="Accepted" Value="Accepted" />
                                                        <dx:ListEditItem Text="Declined" Value="Declined" />
                                                        <dx:ListEditItem Text="ReSchedule" Value="ReSchedule" />
                                                    </Items>
                                                </dx:ASPxComboBox>
                                            </div>
                                        </td>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td colspan="2">
                                            <%# Eval("Comments")%>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </asp:Panel>
                        <asp:Literal runat="server" Visible='<%# Not (Eval("Category").ToString.StartsWith("Task") Or Eval("Category").ToString.StartsWith("Appointment") or  Eval("Category").ToString.StartsWith("Approval"))%>' Text='<%# Eval("Comments")%>'>                                                
                        </asp:Literal>
                    </DataItemTemplate>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="by" VisibleIndex="2" Width="120" FieldName="EmployeeName">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="Category" VisibleIndex="3" FieldName="Category" Width="100" Visible="false">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="ActivityDate" Width="140" Caption="Date" VisibleIndex="4" PropertiesTextEdit-DisplayFormatString="d">
                    <PropertiesTextEdit DisplayFormatString="g"></PropertiesTextEdit>
                    <EditItemTemplate>
                    </EditItemTemplate>
                </dx:GridViewDataTextColumn>
            </Columns>
            <SettingsEditing Mode="EditForm"></SettingsEditing>
            <SettingsText CommandUpdate="Add" />
            <SettingsPager Mode="ShowAllRecords" />
            <SettingsCommandButton>
                <UpdateButton ButtonType="Image">
                    <Image Url="~/images/add-button-hi.png" Width="16" Height="16">
                    </Image>
                </UpdateButton>
            </SettingsCommandButton>
            <Styles>
                <EditForm Paddings-Padding="0">
                    <Paddings Padding="0px"></Paddings>
                </EditForm>
                <Row Cursor="pointer" />
                <AlternatingRow CssClass="gridAlternatingRow"></AlternatingRow>
            </Styles>
            <Settings VerticalScrollBarMode="Auto" VerticalScrollableHeight="670" />
            <SettingsBehavior AllowFocusedRow="false" AllowClientEventsOnLoad="false"
                EnableRowHotTrack="false" ColumnResizeMode="NextColumn" />
            <ClientSideEvents EndCallback="function(){dateActivityClient.SetDate(new Date());}" />
        </dx:ASPxGridView>

        <dx:ASPxPopupControl ClientInstanceName="popupFilterControl" Width="160px" Height="200px"
            MaxWidth="800px" MaxHeight="800px" MinHeight="150px" MinWidth="150px" ID="ASPxPopupControl3" ShowCloseButton="false" ShowHeader="false" ShowFooter="false"
            runat="server" EnableViewState="false" PopupHorizontalAlign="RightSides" PopupVerticalAlign="Below">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                    <dx:ASPxCheckBoxList ID="cbCateLog" runat="server" ClientInstanceName="cbCateLogClient" Border-BorderStyle="None" OnSelectedIndexChanged="cbCateLog_SelectedIndexChanged">
                        <Items>
                            <dx:ListEditItem Text="Appointment" Value="Appointment" />
                            <dx:ListEditItem Text="Accounting" Value="Accounting" />
                            <dx:ListEditItem Text="Construction" Value="Construction" />
                            <dx:ListEditItem Text="Eviction" Value="Eviction" />
                            <dx:ListEditItem Text="Finder" Value="Finder" />
                            <dx:ListEditItem Text="Legal" Value="Legal" />
                            <dx:ListEditItem Text="Manager" Value="Manager" />
                            <dx:ListEditItem Text="Processing" Value="Processing" />
                            <dx:ListEditItem Text="Task" Value="Task" />
                            <dx:ListEditItem Text="Sales Agent" Value="SalesAgent" />
                            <dx:ListEditItem Text="Status" Value="Status" />
                        </Items>
                        <Border BorderStyle="None"></Border>
                        <ClientSideEvents SelectedIndexChanged="OnlogSelectedIndexChanged" />
                    </dx:ASPxCheckBoxList>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

        <dx:ASPxPopupControl ClientInstanceName="ASPxPopupScheduleSelectDateControl" Width="260px" Height="250px"
            MaxWidth="800px" MaxHeight="800px" MinHeight="150px" MinWidth="150px" ID="ASPxPopupControl2"
            HeaderText="Select Date" Modal="true"
            runat="server" EnableViewState="false" PopupHorizontalAlign="LeftSides" PopupVerticalAlign="Below" EnableHierarchyRecreation="True">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                    <asp:Panel ID="Panel1" runat="server">
                        <table>
                            <tr>
                                <td>
                                    <dx:ASPxCalendar ID="ASPxCalendar1" runat="server" ClientInstanceName="TaskScheduleCalendar" ShowClearButton="False" ShowTodayButton="False"></dx:ASPxCalendar>
                                </td>
                            </tr>
                            <tr>
                                <td style="color: #666666; font-family: Tahoma; font-size: 10px; align-content: center; text-align: center; padding-top: 2px;">
                                    <dx:ASPxButton ID="ASPxButton2" runat="server" Text="OK" AutoPostBack="false" ClientSideEvents-Click="function(){ASPxPopupSelectDateControl.Hide();}">
                                        <ClientSideEvents Click="function(){
                                                                                                                        cbTaskScheduleClient.SetText(TaskScheduleCalendar.GetSelectedDate().toLocaleDateString());
                                                                                                                        ASPxPopupScheduleSelectDateControl.Hide();                                                                                                                         
                                                                                                                        }"></ClientSideEvents>
                                    </dx:ASPxButton>
                                    &nbsp;
                                                            <dx:ASPxButton runat="server" Text="Cancel" AutoPostBack="false">
                                                                <ClientSideEvents Click="function(){
                                                                                                                        ASPxPopupScheduleSelectDateControl.Hide();                                                                                                                                                                                                                                               
                                                                                                                        }"></ClientSideEvents>

                                                            </dx:ASPxButton>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
        <dx:ASPxPopupControl ClientInstanceName="ASPxPopupSelectUserControl" Width="260px" Height="250px"
            MaxWidth="800px" MinWidth="150px" ID="pcMain"
            HeaderText="Select Employees:" Modal="true"
            runat="server" EnableViewState="false" PopupHorizontalAlign="RightSides" PopupVerticalAlign="Below" EnableHierarchyRecreation="True">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                    <table style="width: 100%">
                        <tr>
                            <td>
                                <dx:ASPxListBox runat="server" ID="lbEmployees" Width="100%" Height="240px" ClientInstanceName="lbEmployeesClient"></dx:ASPxListBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table style="width: 100%; border-collapse: separate; border-spacing: 0px;">
                                    <tr>
                                        <td>
                                            <dx:ASPxComboBox runat="server" Width="190px" ID="cbEmps" TextField="Name" ValueField="Name" ClientInstanceName="cbEmpsClient"></dx:ASPxComboBox>
                                        </td>
                                        <td>
                                            <dx:ASPxButton runat="server" ID="btnAddEmp" RenderMode="Link" Image-IconID="actions_add_16x16" AutoPostBack="false">
                                                <Image IconID="actions_add_16x16"></Image>
                                                <ClientSideEvents Click="function(s,e){
                                                                            var emp = cbEmpsClient.GetText();
                                                                            lbEmployeesClient.AddItem(emp);
                                                                            }" />
                                            </dx:ASPxButton>
                                            <dx:ASPxButton runat="server" ID="btnRemoveEmp" RenderMode="Link" AutoPostBack="false">
                                                <Image IconID="actions_removeitem_16x16"></Image>
                                                <ClientSideEvents Click="function(s, e){
                                                                            var index = lbEmployeesClient.GetSelectedIndex();
                                                                            lbEmployeesClient.RemoveItem(index);
                                                                            }" />
                                            </dx:ASPxButton>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td style="color: #666666; font-family: Tahoma; font-size: 10px; align-content: center; text-align: center; padding-top: 2px;">
                                <dx:ASPxButton ID="ASPxButton1" runat="server" Text="OK" AutoPostBack="false" ClientSideEvents-Click="function(){ASPxPopupSelectDateControl.Hide();}">
                                    <ClientSideEvents Click="function(){
                                                                                                                        OnSelectedEmpComplete();
                                                                                                                        ASPxPopupSelectUserControl.Hide();                                                                                                                        
                                                                                                                        }"></ClientSideEvents>
                                </dx:ASPxButton>
                                &nbsp;
                                                            <dx:ASPxButton runat="server" Text="Cancel" AutoPostBack="false">
                                                                <ClientSideEvents Click="function(){
                                                                                                                        ASPxPopupSelectUserControl.Hide();                                                                                                                                                                                                                                               
                                                                                                                        }"></ClientSideEvents>

                                                            </dx:ASPxButton>
                            </td>
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

        <dx:ASPxPopupControl ClientInstanceName="ASPxPopupSetAsTaskControl" Width="500px" Height="420px"
            MaxWidth="800px" MinWidth="150px" ID="ASPxPopupControl1"
            HeaderText="Set as Task" Modal="true"
            runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                    <dx:ASPxFormLayout ID="taskFormlayout" runat="server" Width="100%">
                        <Items>
                            <dx:LayoutItem Caption="Employees">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                        <dx:ASPxDropDownEdit ClientInstanceName="empCheckComboBox" ID="empsDropDownEdit" Width="100%" runat="server" AnimationType="None">
                                            <DropDownWindowStyle BackColor="#EDEDED" />
                                            <DropDownWindowTemplate>
                                                <dx:ASPxPageControl runat="server" TabPosition="Bottom" Width="100%" ID="tabPageEmpSelect" ActiveTabIndex="1">
                                                    <TabPages>
                                                        <dx:TabPage Text="Recently" Name="tabRecent">
                                                            <ContentCollection>
                                                                <dx:ContentControl runat="server">
                                                                    <dx:ASPxListBox Width="100%" ID="ASPxListBox1" Height="240px" ClientInstanceName="empRecentlyListbox" SelectionMode="CheckColumn"
                                                                        runat="server">
                                                                        <Items>
                                                                            <dx:ListEditItem Text="Ron Borovinsky" Value="Ron Borovinsky" />
                                                                            <dx:ListEditItem Text="Allen Glover" Value="Allen Glover" />
                                                                        </Items>
                                                                        <Border BorderStyle="None" />
                                                                        <BorderBottom BorderStyle="Solid" BorderWidth="1px" BorderColor="#DCDCDC" />
                                                                        <ClientSideEvents SelectedIndexChanged="OnEmpRecentlyComboBoxSelectionChanged" />
                                                                    </dx:ASPxListBox>
                                                                </dx:ContentControl>
                                                            </ContentCollection>
                                                        </dx:TabPage>
                                                        <dx:TabPage Text="Employees" Name="tabRecent">
                                                            <ContentCollection>
                                                                <dx:ContentControl runat="server">
                                                                    <table style="width: 100%">
                                                                        <tr>
                                                                            <td>
                                                                                <dx:ASPxTextBox runat="server" ID="txtTaskEmpSearch" ClientInstanceName="txtTaskEmpSearchClient" Width="100%" NullText="Type Employees Name">
                                                                                    <ClientSideEvents KeyDown="function(s,e){                                                                                                                                     
                                                                                                                                        OnEmplistSearch(s.GetText());                                                                                                                                    
                                                                                                                                    }" />

                                                                                </dx:ASPxTextBox>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                    <dx:ASPxListBox Width="100%" ID="lbEmps" Height="220px" ClientInstanceName="empListBox" SelectionMode="CheckColumn" TextField="Name" ValueField="Name"
                                                                        runat="server">
                                                                        <Border BorderStyle="None" />
                                                                        <BorderBottom BorderStyle="Solid" BorderWidth="1px" BorderColor="#DCDCDC" />
                                                                        <ClientSideEvents SelectedIndexChanged="OnEmpComboBoxSelectionChanged" />
                                                                    </dx:ASPxListBox>

                                                                </dx:ContentControl>
                                                            </ContentCollection>
                                                        </dx:TabPage>
                                                    </TabPages>
                                                </dx:ASPxPageControl>
                                                <div style="float: right; margin-top: -25px; display: block; margin-right: 3px;">
                                                    <dx:ASPxButton ID="ASPxButton1" AutoPostBack="False" runat="server" Text="Close" Style="float: right" Paddings-Padding="0">
                                                        <ClientSideEvents Click="function(s, e){ empCheckComboBox.HideDropDown(); }" />
                                                    </dx:ASPxButton>
                                                </div>
                                            </DropDownWindowTemplate>
                                            <ClientSideEvents TextChanged="SynchronizeEmpListBoxValues" DropDown="SynchronizeEmpListBoxValues" />
                                        </dx:ASPxDropDownEdit>

                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            <dx:LayoutItem Caption="Action">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                        <dx:ASPxComboBox runat="server" Width="100%" DropDownStyle="DropDown" ID="cbTaskAction">
                                            <Items>
                                                <dx:ListEditItem Text="" Value="" />
                                                <dx:ListEditItem Text="Documents Request" Value="Documents Request" />
                                                <dx:ListEditItem Text="Lookup Request" Value="Lookup Request" />
                                                <dx:ListEditItem Text="Incentive Offer Needed" Value="Incentive Offer Needed" />
                                            </Items>
                                        </dx:ASPxComboBox>
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
                            <dx:LayoutItem Caption="Reminder" Visible="false">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                        <dx:ASPxComboBox runat="server" DropDownStyle="DropDown" ID="cbTaskSchedule" ClientInstanceName="cbTaskScheduleClient">
                                            <Items>
                                                <dx:ListEditItem Text="None" Value="None" />
                                                <dx:ListEditItem Text="1 Day" Value="1 Day" />
                                                <dx:ListEditItem Text="2 Day" Value="2 Day" />
                                                <dx:ListEditItem Text="Custom" Value="Custom" />
                                            </Items>
                                            <ClientSideEvents SelectedIndexChanged="OnCbTaskScheduleSelectedIndexChanged" />
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
                                        <dx:ASPxButton ID="ASPxButton4" runat="server" Text="OK" AutoPostBack="false" ClientSideEvents-Click="function(){ASPxPopupSelectDateControl.Hide();}">
                                            <ClientSideEvents Click="function(){
                                                                                                                        gridTrackingClient.PerformCallback('Task');
                                                                                                                        ASPxPopupSetAsTaskControl.Hide();                                                                                                                                                                                                                                         
                                                                                                                        }"></ClientSideEvents>
                                        </dx:ASPxButton>
                                        &nbsp;
                                                            <dx:ASPxButton runat="server" Text="Cancel" AutoPostBack="false">
                                                                <ClientSideEvents Click="function(){
                                                                                                                        ASPxPopupSetAsTaskControl.Hide();                                                                                                                                                                                                                                               
                                                                                                                        }"></ClientSideEvents>

                                                            </dx:ASPxButton>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                        </Items>
                    </dx:ASPxFormLayout>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

    </div>


    <%------end-------%>
</div>
