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
</style>
<script type="text/javascript">
    function OnlogSelectedIndexChanged(s, e) {
        var selectedItems = cbCateLogClient.GetSelectedItems();
        ddlCateLogClient.SetText(GetSelectedItemsText(selectedItems));

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

    function ApproveNewLead(logID)
    {
        gridTrackingClient.PerformCallback("ApproveNewLead|" + logID);

        if (typeof gridLeads != 'undefined')
            gridLeads.Refresh();
    }

    function DeclineNewLead(logID)
    {
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
    // ]]>
</script>
<dx:ASPxPageControl Width="100%" Height="100%" EnableViewState="false" ID="pageActivitylog" runat="server" ActiveTabIndex="0" TabSpacing="2px">
    <Paddings Padding="0px" />
    <TabStyle Width="80px" Paddings-PaddingLeft="10px">
        <Paddings PaddingLeft="10px"></Paddings>
    </TabStyle>
    <TabPages>
        <dx:TabPage Text="Activity Log" Name="tabActivityLog">
            <ContentCollection>
                <dx:ContentControl runat="server">
                    <dx:ASPxFormLayout ID="formLayoutActivityLog" ClientInstanceName="formlayoutActivityLogClient" runat="server" Width="100%" Styles-LayoutGroupBox-Caption-Font-Bold="true">
                        <Items>
                            <dx:LayoutGroup Caption="Activity Logs" GroupBoxDecoration="None" GroupBoxStyle-Caption-BackColor="Transparent" Width="100%" GroupBoxStyle-Caption-ForeColor="Black" SettingsItemCaptions-Location="Top">
                                <GroupBoxStyle>
                                    <Caption BackColor="Transparent" ForeColor="Black"></Caption>
                                </GroupBoxStyle>
                                <Items>
                                    <dx:LayoutItem Caption="Notes" ShowCaption="False">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer>
                                                <div style="float: right">
                                                    <table style="margin-bottom: 5px;">
                                                        <tr>
                                                            <td style="width: 50px;">Filter By:</td>
                                                            <td>
                                                                <dx:ASPxDropDownEdit ClientInstanceName="ddlCateLogClient" ID="ASPxDropDownEdit1" Width="210px" AllowUserInput="False" runat="server" AnimationType="None">
                                                                    <DropDownWindowStyle BackColor="#EDEDED" />
                                                                    <DropDownWindowTemplate>
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
                                                                    </DropDownWindowTemplate>
                                                                </dx:ASPxDropDownEdit>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                                <div style="width: 100%; padding: 0px; display: block;">
                                                    <asp:HiddenField ID="hfBBLE" runat="server" />
                                                    <dx:ASPxGridView ID="gridTracking" Width="100%" SettingsCommandButton-UpdateButton-ButtonType="Image" Visible="true" SettingsEditing-Mode="EditForm" ClientInstanceName="gridTrackingClient" runat="server" AutoGenerateColumns="False" KeyFieldName="LogID" SettingsBehavior-AllowSort="false" OnAfterPerformCallback="gridTracking_AfterPerformCallback">
                                                        <Templates>
                                                            <EditForm>
                                                                <table style="width: 100%; margin: 0;">
                                                                    <tr>
                                                                        <td style="width: 140px;">
                                                                            <dx:ASPxDateEdit ID="dateActivity" ClientInstanceName="dateActivityClient" Width="135px" Date="<%# DateTime.Now %>" runat="server" DisplayFormatString="d"></dx:ASPxDateEdit>
                                                                        </td>
                                                                        <td>
                                                                            <dx:ASPxMemo ID="txtComments" Width="100%" ClientInstanceName="txtCommentsClient" runat="server" Text="<%# String.Empty %>" Height="13px">
                                                                                <ClientSideEvents KeyDown="OnLogMemoKeyDown" Init="function(s,e){
                                                                                        s.GetInputElement().style.overflowY='hidden';
                                                                                    }" />
                                                                            </dx:ASPxMemo>
                                                                        </td>
                                                                        <td style="width: 20px; padding: 2px; vertical-align: middle">
                                                                            <dx:ASPxGridViewTemplateReplacement ID="AddButton" ReplacementType="EditFormUpdateButton" runat="server" ValidateRequestMode="Enabled" />
                                                                        </td>
                                                                        <td style="width: 20px; padding: 2px; padding-top: 0px; vertical-align: top">
                                                                            <dx:ASPxButton ID="btnTask" runat="server" Image-ToolTip="Set as Task" AutoPostBack="false" RenderMode="Link" Image-Url="~/images/upcomming.jpg" Image-Height="18" Image-Width="18" Visible="true" VerticalAlign="Middle">
                                                                                <ClientSideEvents Click="function(s,e){
                                                                ASPxPopupSetAsTaskControl.ShowAtElement(s.GetMainElement());
                                                                }" />
                                                                            </dx:ASPxButton>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </EditForm>
                                                        </Templates>
                                                        <Columns>
                                                            <dx:GridViewDataTextColumn FieldName="Comments" PropertiesTextEdit-EncodeHtml="false" VisibleIndex="2" FilterCellStyle-Wrap="Default" EditCellStyle-Wrap="False">
                                                                <PropertiesTextEdit EncodeHtml="False"></PropertiesTextEdit>
                                                                <EditCellStyle Wrap="False"></EditCellStyle>
                                                                <DataItemTemplate>
                                                                    <asp:Panel runat="server" Visible='<%# Eval("Category").ToString.StartsWith("Task") Or Eval("Category").ToString.StartsWith("Appointment") or Eval("Category").ToString.StartsWith("Approval")%>' ID="panelTask">
                                                                        <table style="width: 100%">
                                                                            <thead>
                                                                                <tr>
                                                                                    <td style="font-weight: bold"><%# Eval("Category")%> </td>
                                                                                    <td style="text-align: right; width: 80px;">
                                                                                        <div style="float: right">
                                                                                            <dx:ASPxCheckBox Text="Completed" runat="server" TextAlign="Left" ID="chkComplete" Visible="false"></dx:ASPxCheckBox>
                                                                                            <dx:ASPxCheckBox Text="Accepted" runat="server" TextAlign="Left" ID="chkAccepted" Visible="false"></dx:ASPxCheckBox>
                                                                                            <dx:ASPxCheckBox Text="Declined&nbsp;" runat="server" TextAlign="Left" ID="chkDeclined" Visible="false"></dx:ASPxCheckBox>
                                                                                            <dx:ASPxCheckBox Text="Scheduled" runat="server" TextAlign="Left" ID="chkReschedule" Visible="false"></dx:ASPxCheckBox>
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
                                                            <dx:GridViewDataTextColumn Caption="Comment by" VisibleIndex="3" Width="100" FieldName="EmployeeName">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn Caption="Category" VisibleIndex="4" FieldName="Category" Width="100">
                                                            </dx:GridViewDataTextColumn>
                                                            <dx:GridViewDataTextColumn FieldName="ActivityDate" Width="140" Caption="Date" VisibleIndex="1" PropertiesTextEdit-DisplayFormatString="d">
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
                                                        <SettingsBehavior AllowFocusedRow="true" AllowClientEventsOnLoad="false"
                                                            EnableRowHotTrack="True" ColumnResizeMode="NextColumn" />
                                                        <ClientSideEvents EndCallback="function(){txtCommentsClient.SetText('');txtCommentsClient.SetHeight(15);dateActivityClient.SetDate(new Date());}" />
                                                    </dx:ASPxGridView>

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
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                                <SettingsItemCaptions Location="Top"></SettingsItemCaptions>
                            </dx:LayoutGroup>
                            <dx:LayoutGroup Caption="Lead Info" ShowCaption="False" Visible="false">
                                <Items>
                                </Items>
                            </dx:LayoutGroup>
                        </Items>
                        <Styles>
                            <LayoutGroupBox>
                                <Caption Font-Bold="True"></Caption>
                            </LayoutGroupBox>
                        </Styles>
                    </dx:ASPxFormLayout>
                </dx:ContentControl>
            </ContentCollection>
        </dx:TabPage>
    </TabPages>
</dx:ASPxPageControl>
