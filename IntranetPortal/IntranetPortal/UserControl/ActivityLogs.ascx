<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ActivityLogs.ascx.vb" Inherits="IntranetPortal.ActivityLogs" %>

<style type="text/css">
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

    .filited {
        background: url(/images/ic_filtered_bg.png) no-repeat;
    }

    .TaskLogStyle {
        background-color: #FFC5C5;
        color: black;
        padding: 2px;
    }
    /* for fix the email message link color hover bug in activty log*/
    td.dxgv:hover a {
        color: black !important;
    }

    .dxpcLite_MetropolisBlue1.dxpclW {
        position: fixed !important;
    }

    #ctl00_MainContentPH_cbpLogs_ActivityLogs_gridTracking .dxgvHSDC {
        position: absolute;
        height: 22px;
        top: 0;
        padding-bottom: 1px;
    }

    #ctl00_MainContentPH_cbpLogs_ActivityLogs_gridTracking .dxgvCSD {
        position: absolute;
        top: 22px;
        bottom: 0;
        height: auto !important;
        overflow-y: auto !important;
        padding-bottom: 10px;
    }
</style>

<script type="text/javascript">
    var isFiltered= false; 
    var filterCategory = {'Task':6,'Appointment':3,'Email':4};
    var refreshCategory = ['SalesAgent','ShortSale','Legal','Title','Construction','Eviction'];
    var empTextBox = null;

    function OnlogSelectedIndexChanged(s, e) {
        var selectedItems = cbCateLogClient.GetSelectedItems();
        var categories = GetSelectedItemsValue(selectedItems);

        var filterCondition = "";
        var refreshGrid = false;       
        for(var i=0; i<selectedItems.length; i++)
        {
            var item = selectedItems[i].value;
            if(item in filterCategory)
            {
                var actionType = filterCategory[item];
                if (filterCondition == "")
                    filterCondition = "[ActionType]=" +  actionType;
                else
                    filterCondition += " OR [ActionType]=" + actionType;
            }
            else
            {
                refreshGrid = true;
            }
        }
        
        if (categories == "") {
            if(isFiltered)
            {
                gridTrackingClient.ClearFilter();
                isFiltered = false;
            }else
            {
                gridTrackingClient.Refresh();
            }
            $("#filter_btn").removeClass("filited");
        }
        else {
            if(refreshGrid)
            {
                gridTrackingClient.PerformCallback("Filter|" + categories);
                $("#filter_btn").addClass("filited");
            }
            else {
                //var filterCondition = "";
                //filterCondition = "[ActionType] = 6";
                gridTrackingClient.ApplyFilter(filterCondition);
                $("#filter_btn").addClass("filited");
                isFiltered = true;
            }
        }

        return;

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

        if (filterCondition == "") {
            gridTrackingClient.ClearFilter();
            $("#filter_btn").removeClass("filited");
        }
        else {
            gridTrackingClient.ApplyFilter(filterCondition);
            $("#filter_btn").addClass("filited");
        }
    }
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
    var NeedToRefreshList = false;
    var lastIndexofAppointmentAction = null;
    var needRefreshShortSale = false;
    var filter_popup_show = false;
    var refreshLogs = false;   
    var showAppointmentPopup = false;


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

    function GetSelectedItemsValue(items) {
        var texts = [];
        for (var i = 0; i < items.length; i++)
            if (items[i].index >= 0)
                texts.push(items[i].value);
        return texts.join(";");
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
        NeedToRefreshList = true;
        gridTrackingClient.PerformCallback("CompleteTask|" + logID);
    }

    function ResendTask(logID) {
        ASPxPopupSetAsTaskControl.PerformCallback("ResendTask|" + logID);
        ASPxPopupSetAsTaskControl.EndCallback.AddHandler(function (s, e) {
            //s.Show();
            s.ShowAtElement(document.getElementById('aspnetForm'))
            RefreshList();
        });
    }

    function ApprovalTask(logId, result)
    {
        if(result == "Declined")
        {
            var commentHtml = EmailBody.GetHtml();         

            if (commentHtml == "") {
                alert("The comments is required when you decline the task. Please input comments.")
                return;
            }
        }

        NeedToRefreshList = true;
        needRefreshShortSale= true;

        gridTrackingClient.EndCallback.AddHandler(function(s, e) { EmailBody.SetHtml(""); });
        gridTrackingClient.PerformCallback("ApprovalTask|" + logId + "|" + result);
    }


    function RefreshList() {
        debugger;
        if (typeof gridLeads != 'undefined')
            gridLeads.Refresh();

        if (window.parent && typeof window.parent.RefreshTaskList == 'function')
            window.parent.RefreshTaskList();

        NeedToRefreshList = false;
    }

    function ApproveNewLead(logID) {
        NeedToRefreshList = true;
        gridTrackingClient.PerformCallback("ApproveNewLead|" + logID);
    }

    function DeclineNewLead(logID) {
        NeedToRefreshList = true;
        gridTrackingClient.PerformCallback("DeclineNewLead|" + logID);

        //if (typeof gridLeads != 'undefined')
        //    gridLeads.Refresh();
    }
    
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

    function PostponeRecylce(logID, s) {
        if (confirm("Are you sure to postpone?")) {
            NeedToRefreshList = true;
            gridTrackingClient.PerformCallback("PostponeRecylce|" + logID + "|" + s.GetValue());
        }
        else
            s.SetText("Extend...");
    }

    function AcceptAppointment(logID) {
        NeedToRefreshList = true;
        gridTrackingClient.PerformCallback("AcceptAppointment|" + logID);
        //if (typeof gridLeads != 'undefined')
        //    gridLeads.Refresh();
    }

    function DeclineAppointment(logID) {
        NeedToRefreshList = true;
        gridTrackingClient.PerformCallback("DeclineAppointment|" + logID);
        //if (typeof gridLeads != 'undefined')
        //    gridLeads.Refresh();
    }

    function ShowAppointmentWindow(logId) {
        showAppointmentPopup = true;
        ASPxPopupScheduleClient.PerformCallback("BindAppointment|" + logId);
    }

    function ReScheduledAppointment(logID) {
        //ASPxPopupScheduleClient.PerformCallback("Reschedule|" + logID);
        //ASPxPopupSetAsTaskControl.EndCallback.AddHandler(function (s, e) {
        //    s.Show();         
        //});
        //return;
        NeedToRefreshList = true;
        gridTrackingClient.PerformCallback("ReScheduleAppointment|" + logID);
        //if (typeof gridLeads != 'undefined')
        //    gridLeads.Refresh();
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
        var commentHtml = EmailBody.GetHtml();
        var addDate = null;

        if(addCommentsCallbackClient.InCallback())
        {
            alert("The comments is adding. Please try later.");
            return;
        }
        if (typeof dateActivityClient != 'undefined') {
            addDate = dateActivityClient.GetDate();
        }
        if (addDate == null){
            addDate = new Date();
        }            

        if ($("#selCategory").attr("data-required") == "true" && $("#selCategory").val() == "") {
            alert("Please select Category");
            return;
        }       

        if ($("#selStatusUpdate").attr("data-required") == "true" && $("#selStatusUpdate").val() == "") {
            alert("Please select Status Update");
            return;
        }

        if (commentHtml == "") {
            alert("Comments can't be empty.")
            return
        }

        if(typeof ShortSale != 'undefined')
        {
            if(typeof dtClientFollowup != 'undefined' )
            {
                if($('#selType1').val()=="Title" || $('#selCategory').val() == "Dead" || $('#selCategory').val() == "Closed" || $('#selCategory').val() == "Assign")
                {
                    dtClientFollowup.SetText("");
                }
                else
                {
                    if(dtClientFollowup.GetDate() == null)
                    {
                        alert("Please select next FollowUp date.")
                        return;
                    }else
                    {
                        if(typeof UpDateFollowUpDate == 'function')
                        {
                            UpDateFollowUpDate(dtClientFollowup.GetDate());
                        }
                        
                    }                   
                }
            }
        }
      
        if ($("#selStatusUpdate").val() != null && $("#selStatusUpdate").val() != "")        {
            if(typeof UpdateMortgageStatus != "undefined")
                UpdateMortgageStatus($("#selType1").val(), $("#selStatusUpdate option:selected").text(), $("#selCategory").val());

        } else        {
            needRefreshShortSale = false;
        }

        var updateLevel = $("input:radio[name=is_public]:checked").val();
        addCommentsCallbackClient.PerformCallback(updateLevel + "|" + addDate.toJSON() + "|" + $("#selType1").val() + "|" + $("#selStatusUpdate option:selected").text() + "|" + $("#selCategory").val());
    }

    function AddActivityLog(comments)
    {
        addLogsCallbackClient.PerformCallback(comments);
    }

    function OnCommentsKeyDown(e) {
        if (e.ctrlKey && e.keyCode == 13) {
            // Ctrl-Enter pressed
            InsertNewComments();
        }
    }

    function clickfilterBtn(e) {

        if (!filter_popup_show) {
            popupFilterControl.ShowAtElement(e);
            filter_popup_show = true;
            return;
        }
        popupFilterControl.Hide();
        filter_popup_show = false;
    }

    function testaddKey() {
        $(".dxheDesignViewArea_MetropolisBlue1 dxheViewArea_MetropolisBlue1").keydown(function () {
            alert("test!!");
        })
    }

    function ExpandComments(btnExpand) {
        if ($(btnExpand).hasClass("fa-compress")) {
            $("DIV .divComments").each(function () {
                $(this).height(25);
            });

            $(btnExpand).attr("class", 'fa fa-expand tooltip-examples');
        }
        else {
            $("DIV .divComments").each(function () {
                $(this).height("auto");
            });
            $(btnExpand).attr("class", 'fa fa-compress tooltip-examples');
        }
    }


    function OnSaveAppointment(s, e) {
        if (ASPxClientEdit.ValidateGroup("Appointment")) {
            ASPxPopupScheduleClient.Hide();
            var logId = hfLogIDClient.Get('logId');
            if (logId != null && logId > 0) {
                ReScheduledAppointment(logId);
                //SetLeadStatus(9);
                ASPxPopupScheduleClient.PerformCallback("Schedule");
                ASPxPopupScheduleClient.Hide();
            }
            else {
                ASPxPopupScheduleClient.PerformCallback("Schedule");
            }
            showAppointmentPopup = false;
            gridTrackingClient.Refresh();
        }
    }
    

    $(document).ready(function () {
        //alert("called here>")
        $(".dxheDesignViewArea_MetropolisBlue1 dxheViewArea_MetropolisBlue1").keydown(function () {
            alert("test!!");
        })

    });
    // ]]>
</script>


<%Dim cssPostion = "position: absolute; top: 70px; bottom: 0; left:0px; right: 0;" %>
<%If Me.DisplayMode = Nothing OrElse Me.DisplayMode = ActivityLogMode.Leads %>
<%cssPostion = "height: 100%;" %>
<%--<div style="height: 100%; font-size: 12px; color: #9fa1a8; width: 100%">--%>
<%--<div style="position: absolute; top: 70px; bottom: 0; left:0px; right: 0; font-size: 12px; color: #9fa1a8">--%>
<% End if %>
<div style="<%=cssPostion%> font-size: 12px; color: #9fa1a8">
    <!-- Nav tabs -->
    <%--comment box filters--%>
    <div style="padding: 10px; background: #f5f5f5" class="clearfix">
        <%--comment box and text--%>
        <div style="float: left; width: 70%; min-width: 360px; margin-top: 10px; height: 270px">
            <div class="clearfix">
                <div>
                    <span style="color: #295268;" class="upcase_text">Add Comment&nbsp;&nbsp;<i class="fa fa-comment" style="font-size: 14px"></i></span>
                </div>
                <div style="float: right">
                    <span>
                        <input type="radio" id="is_public" name="is_public" value="Internal" class="font_12" checked="checked" />
                        <label for="is_public" class="font_12">
                            <span class="upcase_text">Internal update</span>
                        </label>
                    </span>
                    <span>
                        <input type="radio" id="is_publicf" name="is_public" value="Public" class="font_12" />
                        <label for="is_publicf" class="font_12">
                            <span class="upcase_text">Public update</span>
                        </label>
                    </span>
                </div>
            </div>
            <%-- 
            <button type="button" onclick="testaddKey()">Test</button>
            <textarea title="Press CTRL+ENTER to submit." class="edit_text_area" style="display: none; height: 148px;" id="txtComments" onkeydown="OnCommentsKeyDown(event);"></textarea>
            --%>
            <div class="html_edit_div" style="height: 80%">
                <dx:ASPxHtmlEditor ID="EmailBody2" runat="server" Height="148px" Width="100%" ClientInstanceName="EmailBody" OnLoad="EmailBody2_Load">
                    <Settings AllowHtmlView="false" AllowPreview="false" />
                </dx:ASPxHtmlEditor>
            </div>
        </div>
        <div style="width: 30%; float: right; margin-top: 10px">
            <div style="color: #2e2f31; float: right">
                FILTER BY:&nbsp;&nbsp<i class="fa fa-filter acitivty_short_button tooltip-examples " id="filter_btn" title="Filter" style="color: #444547; font-size: 14px;" onclick="clickfilterBtn(this)"></i>
            </div>

            <%-- 50px --%>
            <div style="margin-top: 50px; height: 180px">
                <asp:Panel runat="server" ID="pnlCommentCtr"></asp:Panel>
                <% If DisplayMode = ActivityLogMode.Leads Or DisplayMode = ActivityLogMode.Legal Or DisplayMode = ActivityLogMode.Construction Or DisplayMode = ActivityLogMode.Eviction Then%>
                <div style="visibility: hidden">Date of Comment:</div>
                <div class="border_under_line" style="height: 80px; visibility: hidden">
                    <dx:ASPxDateEdit ID="ASPxDateEdit1" ClientInstanceName="dateActivityClient" Width="130px" runat="server" DisplayFormatString="d"></dx:ASPxDateEdit>
                </div>
                <% End If%>

                <% If DisplayMode = ActivityLogMode.ShortSale Then%>
                <script type="text/javascript">

                    var ShortSale = {
                        StatusData: <%= IntranetPortal.JsonExtension.ToJsonString(IntranetPortal.Data.PropertyMortgage.StatusData)%>,
                        UpdateTypeChange: function(s)
                        {
                            var type = s.value;

                            var liens = ["1st Lien", "2nd Lien","3rd Lien"];
                            var categorys = ["Assign", "Closed", "Dead", "Evictions", "Held", "Intake", "Litigation"];
                            var updates = ["Referral Update", "Seller Update", "Title", "Pipeline", "Manager Update"];

                            if ($.inArray(type, categorys) > -1) {
                                $("#selCategory").val(type);
                                OnStatusCategoryChange(document.getElementById("selCategory"), this.StatusData);
                                $("#selCategory").attr("disabled", true);

                                $("#selStatusUpdate").attr("data-required", true);
                                return;
                            } else {
                                $("#selCategory").val("");
                                $("#selCategory").attr("disabled", false);

                                $("#selStatusUpdate").val("");
                                $("#selStatusUpdate").attr("disabled", false);
                            }

                            if ($.inArray(type, updates) > -1) {
                                $("#selCategory").attr("disabled", true);
                                $("#selStatusUpdate").attr("disabled", true);

                                $("#selStatusUpdate").attr("data-required", false);
                                $("#selCategory").attr("data-required", false);

                                return;
                            } else {
                                $("#selCategory").attr("disabled", false);
                                $("#selStatusUpdate").attr("disabled", false);

                                $("#selStatusUpdate").attr("data-required", true);
                                $("#selCategory").attr("data-required", true);
                            }
                        },                         
                        StatusUpdateChange: function(s)
                        { 
                            var categoryText = $("#selCategory").val();
                            var statusUpdateText = $("#selStatusUpdate").val();

                            if (categoryText in this.Checkinglist)
                            {
                                var category = this.Checkinglist[categoryText];
                                    
                                if(statusUpdateText in category)
                                {
                                    category[statusUpdateText].Checking(this.CheckingSuccess, this.CheckingCancel);
                                }
                            }
                        },
                        CheckingSuccess: function(result){
                            var comment = $("#selType1").val() + "/" + $("#selCategory").val() + " - " + $("#selStatusUpdate").val() + "<br />";
                                
                            if(typeof UpdateMortgageStatus != "undefined")
                                UpdateMortgageStatus($("#selType1").val(), $("#selStatusUpdate option:selected").text(), $("#selCategory").val());     
                               

                            if(typeof SaveShortSaleCase != "undefined")
                                SaveShortSaleCase()

                            if(result)
                                comment += result;

                            AddActivityLog(comment);
                        },
                        CheckingCancel: function(){
                            $("#selStatusUpdate").val("");
                        },
                        Checkinglist:{
                            "Approved":{
                                "Approval - Received":{
                                    Checking:function(success,cancel)
                                    {
                                        if(typeof window.ssToggleApprovalPopup != "undefined")
                                            window.ssToggleApprovalPopup(success,cancel);
                                    }
                                }
                            },
                            "Valuation":{
                                "BPO Call Received": {
                                    Checking:function(success,cancel)
                                    {
                                        if(typeof window.ssToggleValuationPopup != "undefined")
                                            window.ssToggleValuationPopup(1,success,cancel);
                                    }
                                },
                                "BPO Scheduled": {
                                    Checking:function(success,cancel)
                                    {
                                        if(typeof window.ssToggleValuationPopup != "undefined")
                                            window.ssToggleValuationPopup(2,success,cancel);
                                    }                                       
                                },
                                "BPO Complete": {
                                    Checking:function(success,cancel)
                                    {
                                        if(typeof window.ssToggleValuationPopup != "undefined")
                                            window.ssToggleValuationPopup(3,success,cancel);
                                    }                                       
                                }
                            }
                        }
                    }                        
                </script>
                <div>
                    <div style="float: right">
                        <div class="color_gray upcase_text">Type of update</div>
                        <select class="select_bootstrap select_margin" id="selType1" onchange="ShortSale.UpdateTypeChange(this)">
                            <% For Each type In IntranetPortal.Core.CommonData.GetData("UpdateType")%>
                            <option value="<%= type.Name%>"><%= type.Name%></option>
                            <% Next%>
                        </select>
                    </div>

                    <div style="float: right">
                        <div class="color_gray upcase_text">Category</div>
                        <select class="select_bootstrap select_margin " id="selCategory" onchange="OnStatusCategoryChange(this, ShortSale.StatusData)" data-required="true">
                            <option value=""></option>
                            <% For Each category In IntranetPortal.Data.PropertyMortgage.StatusCategory%>
                            <option value="<%= category%>"><%= category%></option>
                            <% Next%>
                        </select>
                    </div>

                    <div style="float: right">
                        <div class="color_gray upcase_text">Status Update</div>
                        <select class="select_bootstrap select_margin selStatusUpdate" id="selStatusUpdate" data-required="true" onchange="ShortSale.StatusUpdateChange(this)">
                            <option value=""></option>
                            <% For Each mortStatus In IntranetPortal.Data.PropertyMortgage.StatusData%>
                            <option value="<%= mortStatus.Category & "-" & mortStatus.Name%>" style="display: none"><%= mortStatus.Name%></option>
                            <% Next%>
                        </select>
                    </div>

                    <div style="float: right">
                        <div class="color_gray upcase_text">Follow Up date</div>
                        <dx:ASPxDateEdit ID="dtFollowup" Border-BorderStyle="None" CssClass="select_bootstrap select_margin" ClientInstanceName="dtClientFollowup" Width="130px" runat="server" DisplayFormatString="d"></dx:ASPxDateEdit>
                    </div>
                </div>
                <% End If%>
            </div>
            <div style="position: relative; bottom: 0; float: right; margin-right: 5px;">
                <i class="fa fa-plus-circle activity_add_buttons tooltip-examples icon_btn" title="Add Comment" style="margin-right: 15px; cursor: pointer" onclick="InsertNewComments()"></i>
                <% If DisplayMode = ActivityLogMode.Leads Or DisplayMode = ActivityLogMode.Construction Then%>
                <i class="fa fa-calendar-o activity_add_buttons tooltip-examples" style="margin-right: 15px; cursor: pointer" title="Schedule" onclick="showAppointmentPopup=true;ASPxPopupScheduleClient.PerformCallback();"></i>
                <%Else%>
                <% If DisplayMode = ActivityLogMode.ShortSale Then%>
                <i class="fa fa-comment activity_add_buttons tooltip-examples" style="margin-right: 15px; cursor: pointer" title="Previous Notes" onclick="popupPreviousNotes.Show();popupPreviousNotes.PerformCallback()"></i>
                <% End If%>
                <% End If%>
                <i class="fa fa-tasks activity_add_buttons tooltip-examples icon_btn" title="Create Task" style="margin-right: 15px;" onclick="ASPxPopupSetAsTaskControl.Show();ASPxPopupSetAsTaskControl.PerformCallback('Show');"></i>
                <i class="fa fa-repeat activity_add_buttons tooltip-examples icon_btn" title="Follow Up" onclick="ASPxPopupMenuClientControl.ShowAtElement(this);"></i>
            </div>

        </div>
    </div>
    <dx:ASPxCallback runat="server" ID="addCommentsCallback" ClientInstanceName="addCommentsCallbackClient" OnCallback="addCommentsCallback_Callback">
        <ClientSideEvents EndCallback="function(s,e){gridTrackingClient.Refresh(); EmailBody.SetHtml(''); document.getElementById('txtComments').value='';}" />
    </dx:ASPxCallback>
    <dx:ASPxCallback runat="server" ID="addLogsCallback" ClientInstanceName="addLogsCallbackClient" OnCallback="addLogsCallback_Callback">
        <ClientSideEvents EndCallback="function(s,e){gridTrackingClient.Refresh();}" />
    </dx:ASPxCallback>

    <%-------end-----%>
    <%-- log tables--%>
    <%Dim LogPostion = "position: absolute; top: 300px; bottom: 0; width: 100%; padding: 0" %>
    <% If Me.DisplayMode = Nothing OrElse Me.DisplayMode = ActivityLogMode.Leads Then %>
    <%--  <div style="max-height: 500px">--%>
    <% LogPostion = "max-height: 550px" %>
    <% End if %>
    <div style="<%= LogPostion%>">
        <asp:HiddenField ID="hfBBLE" runat="server" />
        <dx:ASPxGridView runat="server" ID="gridTracking" Width="100%" ViewStateMode="Disabled" ClientInstanceName="gridTrackingClient" AutoGenerateColumns="False" KeyFieldName="LogID" OnAfterPerformCallback="gridTracking_AfterPerformCallback" OnDataBinding="gridTracking_DataBinding" Visible="true">
            <Styles>
                <Cell VerticalAlign="Top"></Cell>
                <Header BackColor="#F5F5F5"></Header>
                <EditForm Paddings-Padding="0">
                    <Paddings Padding="0px"></Paddings>
                </EditForm>
                <Row Cursor="pointer" />
                <AlternatingRow CssClass="gridAlternatingRow"></AlternatingRow>
            </Styles>
            <Columns>
                <dx:GridViewDataColumn FieldName="ActionType" VisibleIndex="0" Caption="" Width="40px">
                    <HeaderStyle HorizontalAlign="Center" />
                    <HeaderTemplate>
                        <i class="fa fa-compress tooltip-examples" title="Expand or Collapse All" onclick="ExpandComments(this)"></i>
                    </HeaderTemplate>
                    <DataItemTemplate>
                        <%# GetCommentsIconClass(Eval("ActionType"))%>
                    </DataItemTemplate>
                    <CellStyle VerticalAlign="Top"></CellStyle>
                </dx:GridViewDataColumn>
                <dx:GridViewDataTextColumn FieldName="Comments" PropertiesTextEdit-EncodeHtml="false" VisibleIndex="1" FilterCellStyle-Wrap="Default" EditCellStyle-Wrap="False">
                    <HeaderTemplate>
                        Activity History
                        <asp:Literal runat="server" ID="ltArchievedBox" Visible="<%# ShowArchieveBox() %>">
                            <input type="checkbox" id="chkShowArchieve" onclick="ShowArchieve(this)" /><label for="chkShowArchieve">Show Archieved</label>
                            <script>
                                var checkTheBox = false;
                                function ShowArchieve(cb)
                                {
                                    if(cb.checked)
                                    {
                                        gridTrackingClient.PerformCallback("ShowArchieved");
                                        checkTheBox = true;

                                    } else {
                                        gridTrackingClient.Refresh();
                                    }
                                }
                            </script>
                        </asp:Literal>
                    </HeaderTemplate>
                    <PropertiesTextEdit EncodeHtml="False"></PropertiesTextEdit>
                    <EditCellStyle Wrap="False"></EditCellStyle>
                    <DataItemTemplate>
                        <asp:Panel runat="server" ID="pnlAppointment" Visible="false">
                            <div class="log_item_col1" style="width: auto">
                                <div class="font_black color_balck clearfix">
                                    <table style="width: 100%">
                                        <tr>
                                            <td style="width: 200px">Appointment with
                                                <asp:Label runat="server" ID="lblOwnerName"></asp:Label></td>
                                            <td>
                                                <div style="float: right; font-size: 18px">
                                                    <span style="font-size: 14px;">
                                                        <asp:Literal runat="server" ID="ltResult"></asp:Literal></span>
                                                    <i class="fa fa-check-circle-o log_item_hl_buttons tooltip-examples" runat="server" id="btnAccept" title="Accept" onclick='<%# String.Format("AcceptAppointment(""{0}"")", Eval("LogID"))%>' visible="false"></i>
                                                    <i class="fa fa-times-circle-o log_item_hl_buttons tooltip-examples" title="Decline" runat="server" id="btnDecline" onclick='<%# String.Format("DeclineAppointment(""{0}"")", Eval("LogID"))%>' visible="false"></i>
                                                    <i class="fa fa-history log_item_hl_buttons tooltip-examples" title="Reschedule" runat="server" id="btnReschedule" onclick='<%# String.Format("ShowAppointmentWindow(""{0}"")", Eval("LogID"))%>' visible="false"></i>
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
                                    <tr style="display: none">
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

                        <asp:Panel runat="server" ID="pnlTask" Visible='<%# Eval("Category").ToString.StartsWith("Task") OrElse Eval("ActionType") = IntranetPortal.LeadsActivityLog.EnumActionType.SetAsTask%>'>
                            <div class="log_item_col1" style="width: auto">
                                <div class="font_black color_balck clearfix">
                                    <table style="width: 100%">
                                        <tr>
                                            <td style="width: 200px">Task</td>
                                            <td>
                                                <div style="float: right; font-size: 18px">
                                                    <span style="font-size: 14px;">
                                                        <asp:Literal runat="server" ID="ltTaskResult"></asp:Literal></span>
                                                    <i class="fa fa-check-circle-o log_item_hl_buttons tooltip-examples" onclick='<%# String.Format("CompleteTask(""{0}"")", Eval("LogID"))%>' title="Completed" runat="server" id="btnTaskComplete" visible="false"></i>
                                                    <i class="fa fa-history log_item_hl_buttons tooltip-examples" title="Resend" runat="server" id="btnResend" onclick='<%# String.Format("ResendTask(""{0}"")", Eval("LogID"))%>' visible="false"></i>
                                                    <i class="fa fa-check-circle-o log_item_hl_buttons tooltip-examples" title="Approve" runat="server" id="btnTaskApprove" onclick='<%# String.Format("ApprovalTask(""{0}"", ""Approved"")", Eval("LogID"))%>' visible="false"></i>
                                                    <i class="fa fa-times-circle-o log_item_hl_buttons tooltip-examples" title="Decline" runat="server" id="btnTaskDecline" onclick='<%# String.Format("ApprovalTask(""{0}"",""Declined"")", Eval("LogID"))%>' visible="false"></i>
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

                        <asp:Panel runat="server" ID="pnlDoorknockTask" Visible='<%# Eval("Category").ToString.StartsWith("DoorknockTask")%>'>
                            <div class="log_item_col1" style="width: auto">
                                <div class="clearfix">
                                    <table style="width: 100%">
                                        <tr>
                                            <td style="width: 350px">
                                                <asp:Literal runat="server" ID="ltDoorknockAddress"></asp:Literal>
                                            </td>
                                            <td>
                                                <div style="float: right; font-size: 18px">
                                                    <span style="font-size: 14px;">
                                                        <asp:Literal runat="server" ID="ltDoorknockResult"></asp:Literal></span>
                                                    <i class="fa fa-check-circle-o log_item_hl_buttons tooltip-examples" onclick='<%# String.Format("CompleteTask(""{0}"")", Eval("LogID"))%>' title="Completed" runat="server" id="btnDoorkncokComplete" visible="false"></i>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </asp:Panel>

                        <asp:Panel runat="server" ID="pnlRecycleTask" Visible='<%# Eval("Category").ToString.StartsWith("RecycleTask")%>'>
                            <table style="width: 100%">
                                <thead>
                                    <tr>
                                        <td style="font-weight: bold">Recycle</td>
                                        <td style="text-align: right; width: 120px;">
                                            <div style="float: right">
                                                <asp:Panel runat="server" ID="pnlRecylce">
                                                    <div style="float: right;">
                                                        <span style="font-size: 14px;">
                                                            <asp:Literal runat="server" ID="ltRecycleDays"></asp:Literal></span>
                                                        <dx:ASPxComboBox runat="server" ID="cbRecycleDays" Width="80px" Visible="false" Native="true">
                                                            <Items>
                                                                <dx:ListEditItem Text="Extend..." Value="0" Selected="true" />
                                                                <dx:ListEditItem Text="1 Day" Value="1" />
                                                                <dx:ListEditItem Text="2 Days" Value="2" />
                                                                <dx:ListEditItem Text="3 Days" Value="3" />
                                                                <dx:ListEditItem Text="4 Days" Value="4" />
                                                                <dx:ListEditItem Text="5 Days" Value="5" />
                                                            </Items>
                                                        </dx:ASPxComboBox>
                                                    </div>
                                                </asp:Panel>
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

                        <asp:Panel runat="server" Visible='<%# Eval("Category").ToString.StartsWith("Approval")%>' ID="panelTask">
                            <table style="width: 100%">
                                <thead>
                                    <tr>
                                        <td style="font-weight: bold"><%# Eval("Category")%> </td>
                                        <td style="text-align: right; width: 120px;">
                                            <div style="float: right">
                                                <asp:Panel runat="server" ID="pnlAptButton" Visible="false">
                                                    <div style="float: right; font-size: 18px">
                                                        <i class="fa fa-check-circle-o log_item_hl_buttons tooltip-examples" title="Approve" onclick='<%# String.Format("ApproveNewLead(""{0}"")", Eval("LogID"))%>'></i>
                                                        <i class="fa fa-times-circle-o log_item_hl_buttons" title="Decline" onclick='<%# String.Format("DeclineNewLead(""{0}"")", Eval("LogID"))%>'></i>
                                                    </div>
                                                </asp:Panel>
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

                        <asp:Literal runat="server" Visible='<%# Not ((Eval("Category").ToString.StartsWith("Task") OrElse Eval("ActionType") = IntranetPortal.LeadsActivityLog.EnumActionType.SetAsTask) Or (Eval("Category").ToString.StartsWith("Appointment") OrElse Eval("ActionType") = IntranetPortal.LeadsActivityLog.EnumActionType.Appointment) Or Eval("Category").ToString.StartsWith("Approval") Or Eval("Category").ToString.StartsWith("DoorknockTask") Or Eval("Category").ToString.StartsWith("RecycleTask"))%>' Text='<%# String.Format("<div class=""divComments"">{0}</div>", Eval("Comments"))%>'>
                        </asp:Literal>
                    </DataItemTemplate>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="by" VisibleIndex="2" Width="120" FieldName="EmployeeName">
                    <HeaderTemplate>
                        BY
                    </HeaderTemplate>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="Category" VisibleIndex="3" FieldName="Category" Width="100" Visible="false">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="ActivityDate" Width="140" Caption="Date" VisibleIndex="4" PropertiesTextEdit-DisplayFormatString="d">
                    <PropertiesTextEdit DisplayFormatString="g"></PropertiesTextEdit>
                    <HeaderTemplate>
                        Date
                    </HeaderTemplate>
                </dx:GridViewDataTextColumn>
            </Columns>
            <Settings VerticalScrollBarMode="Auto" ShowHeaderFilterButton="true" />
            <SettingsBehavior AllowSort="false" AllowFocusedRow="false" AllowClientEventsOnLoad="false" AllowDragDrop="false"
                EnableRowHotTrack="false" ColumnResizeMode="Disabled" />
            <SettingsCommandButton>
                <UpdateButton ButtonType="Image">
                    <Image Url="~/images/add-button-hi.png" Width="16" Height="16">
                    </Image>
                </UpdateButton>
            </SettingsCommandButton>
            <SettingsEditing Mode="EditForm"></SettingsEditing>
            <SettingsText CommandUpdate="Add" />
            <SettingsPager Mode="ShowAllRecords" />

            <ClientSideEvents BeginCallback="function(s,e){CaseNeedComment = false}" EndCallback="function(s,e){if(typeof dateActivityClient != 'undefined'){dateActivityClient.SetDate(new Date());} if(NeedToRefreshList){RefreshList();} if(needRefreshShortSale){ if(typeof GetShortSaleData != 'undefined'){ NGGetShortSale(caseId);}} }" />
        </dx:ASPxGridView>

        <dx:ASPxPopupControl ClientInstanceName="popupFilterControl" Width="160px" Height="200px"
            MaxWidth="800px" MaxHeight="800px" MinHeight="150px" MinWidth="150px" ID="ASPxPopupControl3" ShowCloseButton="false" ShowHeader="false" ShowFooter="false"
            runat="server" EnableViewState="false" PopupHorizontalAlign="RightSides" PopupVerticalAlign="Below">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                    <dx:ASPxCheckBoxList ID="cbCateLog" runat="server" ClientInstanceName="cbCateLogClient" Border-BorderStyle="None" OnSelectedIndexChanged="cbCateLog_SelectedIndexChanged">
                        <Items>
                            <dx:ListEditItem Text="Leads" Value="SalesAgent;Status;Approved" />
                            <dx:ListEditItem Text="Short Sale" Value="ShortSale" />
                            <dx:ListEditItem Text="Legal" Value="Legal" />
                            <dx:ListEditItem Text="Title" Value="Title" />
                            <dx:ListEditItem Text="Construction" Value="Construction" />
                            <dx:ListEditItem Text="Eviction" Value="Eviction" />
                            <dx:ListEditItem Text="Task" Value="Task" />
                            <dx:ListEditItem Text="Email" Value="Email" />
                            <dx:ListEditItem Text="Appointment" Value="Appointment" />
                        </Items>
                        <Border BorderStyle="None"></Border>
                        <ClientSideEvents SelectedIndexChanged="OnlogSelectedIndexChanged" />
                    </dx:ASPxCheckBoxList>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

        <dx:ASPxPopupControl ClientInstanceName="popupBpo" Width="450px" Height="480px" OnWindowCallback="ASPxPopupControl2_WindowCallback"
            MaxWidth="800px" MinWidth="150px" ID="ASPxPopupControl2"
            HeaderText="BPO/Appraisal" Modal="true"
            runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
            <HeaderTemplate>
                <div class="clearfix">
                    <div class="pop_up_header_margin">
                        <i class="fa fa-tasks with_circle pop_up_header_icon"></i>
                        <span class="pop_up_header_text">BPO/Appraisal</span>
                    </div>
                    <div class="pop_up_buttons_div">
                        <i class="fa fa-times icon_btn" onclick="popupBpo.Hide()"></i>
                    </div>
                </div>
            </HeaderTemplate>
            <ContentCollection>
                <dx:PopupControlContentControl runat="server" Visible="false" ID="popupContentBpo">
                    <div class="form-group ">
                        <label class="upcase_text" style="display: block">Methods</label>
                        <dx:ASPxComboBox runat="server" Width="100%" DropDownStyle="DropDown" ID="cbMethods" CssClass="edit_drop">
                            <Items>
                                <dx:ListEditItem Text="Appraisal" Value="Appraisal" />
                                <dx:ListEditItem Text="BPO" Value="BPO" />
                                <dx:ListEditItem Text="Desktop Review" Value="Desktop Review" />
                            </Items>
                            <ValidationSettings ErrorDisplayMode="None">
                                <RequiredField IsRequired="true" />
                            </ValidationSettings>
                        </dx:ASPxComboBox>
                    </div>
                    <div class="form-group ">
                        <label class="upcase_text" style="display: block">Bank Value</label>
                        <dx:ASPxTextBox runat="server" Width="100%" Native="true" ID="txtBankValue" CssClass="form-control"></dx:ASPxTextBox>
                    </div>
                    <div class="form-group ">
                        <label class="upcase_text" style="display: block">Date Of Value</label>
                        <input class="form-control ss_date" onchange="dateValueChagne(this)" runat="server" id="txtDateofValue" />
                    </div>
                    <div class="form-group ">
                        <label class="upcase_text" style="display: block">Expired On</label>
                        <input class="form-control ss_date" onchange="dateValueChagne(this)" runat="server" id="txtExpiredDate" />
                    </div>
                    <div>
                        <div class="row" style="margin-top: 33px;">
                            <div class="col-md-7">&nbsp;</div>
                            <div class="col-md-5">
                                <dx:ASPxButton ID="ASPxButton2" runat="server" Text="OK" AutoPostBack="false" CssClass="rand-button rand-button-blue">
                                    <ClientSideEvents Click="function(){
                                                                                                                        var container = popupBpo.GetMainElement();
                                                                                                                        if (ASPxClientEdit.ValidateEditorsInContainer(container))
                                                                                                                        {
                                                                                                                            refreshLogs = true;
                                                                                                                            popupBpo.PerformCallback('Add');
                                                                                                                            popupBpo.Hide();
                                                                                                                        }                                                                                                                                                                                                                                        
                                                                                                                  }"></ClientSideEvents>
                                </dx:ASPxButton>
                                &nbsp;
                                                            <dx:ASPxButton runat="server" Text="Cancel" AutoPostBack="false" CausesValidation="false" CssClass="rand-button rand-button-gray">
                                                                <ClientSideEvents Click="function(){
                                                                                                                        popupBpo.Hide();                                                                                                                                                                                                                                               
                                                                                                                        }"></ClientSideEvents>
                                                            </dx:ASPxButton>
                            </div>
                        </div>
                    </div>
                </dx:PopupControlContentControl>
            </ContentCollection>
            <ClientSideEvents EndCallback="function(s,e){if(refreshLogs) { gridTrackingClient.Refresh();}}" />
        </dx:ASPxPopupControl>

        <dx:ASPxPopupControl ClientInstanceName="popupPreviousNotes" Width="800px" Height="480px" OnWindowCallback="popupPreviousNotes_WindowCallback"
            ID="popupPreviousNotes"
            HeaderText="Previous Notes" Modal="true"
            runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
            <HeaderTemplate>
                <div class="clearfix">
                    <div class="pop_up_header_margin">
                        <i class="fa fa-comment with_circle pop_up_header_icon"></i>
                        <span class="pop_up_header_text">Previous Notes</span>
                    </div>
                    <div class="pop_up_buttons_div">
                        <i class="fa fa-times icon_btn" onclick="popupPreviousNotes.Hide()"></i>
                    </div>
                </div>
            </HeaderTemplate>
            <ContentCollection>
                <dx:PopupControlContentControl runat="server" Visible="false" ID="popupCtontrlPreviousNotes">
                    <dx:ASPxGridView runat="server" ID="gvPreviousNotes" KeyFieldName="LogId" Width="100%" OnDataBinding="gvPreviousNotes_DataBinding" Theme="Moderno">
                        <Columns>
                            <dx:GridViewDataDateColumn FieldName="ActivityDate" PropertiesDateEdit-DisplayFormatString="g" Width="100px"></dx:GridViewDataDateColumn>
                            <dx:GridViewDataTextColumn FieldName="Source" Width="100px"></dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="ActivityType" Width="100px"></dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="ActivityTitle"></dx:GridViewDataTextColumn>
                            <dx:GridViewDataTextColumn FieldName="Shared" Width="60px"></dx:GridViewDataTextColumn>
                        </Columns>
                        <Templates>
                            <DetailRow>
                                <%# Eval("Description")%>
                            </DetailRow>
                        </Templates>
                        <Settings VerticalScrollableHeight="400" />
                        <SettingsPager Mode="EndlessPaging"></SettingsPager>
                        <SettingsDetail ShowDetailRow="true" />
                    </dx:ASPxGridView>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

        <dx:ASPxPopupControl ClientInstanceName="ASPxPopupScheduleClient" Width="400px" Height="280px"
            MaxWidth="800px" MaxHeight="800px" MinHeight="150px" MinWidth="150px" ID="aspxPopupSchedule"
            HeaderText="Appointment" Modal="true" OnWindowCallback="aspxPopupSchedule_WindowCallback"
            runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
            <HeaderTemplate>
                <div class="clearfix">
                    <div class="pop_up_header_margin">
                        <i class="fa fa-clock-o with_circle pop_up_header_icon"></i>
                        <span class="pop_up_header_text">Appointment</span>
                    </div>
                    <div class="pop_up_buttons_div">
                        <i class="fa fa-times icon_btn" onclick="ASPxPopupScheduleClient.Hide()"></i>
                    </div>
                </div>
            </HeaderTemplate>
            <ContentCollection>
                <dx:PopupControlContentControl runat="server" Visible="false" ID="popupContentSchedule">
                    <dx:ASPxHiddenField runat="server" ID="HiddenFieldLogId" ClientInstanceName="hfLogIDClient"></dx:ASPxHiddenField>
                    <dx:ASPxFormLayout ID="formLayout" runat="server" Width="100%" SettingsItemCaptions-Location="Top">
                        <Items>
                            <dx:LayoutItem Caption="Type">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                        <dx:ASPxComboBox runat="server" Width="100%" DropDownStyle="DropDown" ID="cbScheduleType" CssClass="edit_drop">
                                            <Items>
                                                <dx:ListEditItem Text="Consultation" Value="Consultation" />
                                                <dx:ListEditItem Text="Signing" Value="Signing" />
                                            </Items>
                                            <ValidationSettings ErrorDisplayMode="None" ValidationGroup="Appointment">
                                                <RequiredField IsRequired="true" />
                                            </ValidationSettings>
                                        </dx:ASPxComboBox>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            <dx:LayoutItem Caption="Date">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                        <dx:ASPxDateEdit runat="server" EditFormatString="g" Width="100%" ID="dateEditSchedule" ClientInstanceName="ScheduleDateClientCtr" TimeSectionProperties-Visible="True" CssClass="edit_drop">
                                            <TimeSectionProperties Visible="True"></TimeSectionProperties>
                                            <ValidationSettings ErrorDisplayMode="None" ValidationGroup="Appointment">
                                                <RequiredField IsRequired="true" />
                                            </ValidationSettings>
                                            <ClientSideEvents DropDown="function(s,e){ 
                                                                    var d = new Date('May 1 2014 12:00:00');                                                                    
                                                                    s.GetTimeEdit().SetValue(d);
                                                                    }" />
                                        </dx:ASPxDateEdit>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            <dx:LayoutItem Caption="Location">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                        <dx:ASPxTextBox ID="txtLocation" runat="server" Width="100%" Text="In Office" CssClass="edit_drop"></dx:ASPxTextBox>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            <dx:LayoutItem Caption="Manager">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                        <dx:ASPxComboBox runat="server" Width="100%" ID="cbMgr" CssClass="edit_drop" OnDataBinding="cbMgr_DataBinding">
                                            <%--<Items>
                                                                        <dx:ListEditItem Text="Any Manager" Value="*" />
                                                                        <dx:ListEditItem Text="Ron Borovinsky" Value="Ron Borovinsky" />
                                                                        <dx:ListEditItem Text="Michael Gendin" Value="Michael Gendin" />
                                                                        <dx:ListEditItem Text="Allen Glover" Value="Allen Glover" />
                                                                        <dx:ListEditItem Text="No Manager Needed" Value="" />
                                                                    </Items>--%>
                                        </dx:ASPxComboBox>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            <dx:LayoutItem Caption="Comments">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                        <dx:ASPxMemo runat="server" ID="txtScheduleDescription" Width="100%" Height="180px" ClientInstanceName="ScheduleCommentsClientCtr" CssClass="edit_text_area"></dx:ASPxMemo>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                        </Items>
                    </dx:ASPxFormLayout>
                    <table style="width: 100%">
                        <tr>
                            <td style="color: #666666; font-family: Tahoma; font-size: 10px; align-content: center; text-align: center; padding-top: 2px;">
                                <dx:ASPxButton ID="ASPxButton3" runat="server" Text="OK" AutoPostBack="false" CssClass="rand-button" BackColor="#3993c1" ValidationGroup="Appointment" CausesValidation="true">
                                    <ClientSideEvents Click="OnSaveAppointment"></ClientSideEvents>
                                </dx:ASPxButton>
                                &nbsp;
                                <dx:ASPxButton runat="server" Text="Cancel" AutoPostBack="false" CssClass="rand-button" BackColor="#77787b" CausesValidation="false">
                                    <ClientSideEvents Click="function(){ASPxPopupScheduleClient.Hide();}"></ClientSideEvents>
                                </dx:ASPxButton>
                            </td>
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
            <ClientSideEvents EndCallback="function(s,e){
                                            if(showAppointmentPopup)
                                                s.Show();
                                            else
                                                s.Hide();
                                        }" />
        </dx:ASPxPopupControl>

        <dx:ASPxPopupControl ClientInstanceName="ASPxPopupSetAsTaskControl" Width="450px" Height="550px" OnWindowCallback="ASPxPopupControl1_WindowCallback"
            MaxWidth="800px" MinWidth="150px" ID="ASPxPopupControl1"
            HeaderText="Set as Task" Modal="true"
            runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True" Target="">
            <HeaderTemplate>
                <div class="clearfix">
                    <div class="pop_up_header_margin">
                        <i class="fa fa-tasks with_circle pop_up_header_icon"></i>
                        <span class="pop_up_header_text">Set as Task</span>
                    </div>
                    <div class="pop_up_buttons_div">
                        <i class="fa fa-times icon_btn" onclick="ASPxPopupSetAsTaskControl.Hide()"></i>
                    </div>
                </div>
            </HeaderTemplate>
            <ContentCollection>
                <dx:PopupControlContentControl runat="server" Visible="false" ID="PopupContentSetAsTask">
                    <asp:HiddenField runat="server" ID="hfResend" />
                    <div style="color: #b1b2b7; padding: 10px">
                        <div class="form-group ">
                            <label class="upcase_text">Action</label>
                            <dx:ASPxComboBox runat="server" Width="100%" DropDownStyle="DropDown" ID="cbTaskAction" ClientInstanceName="cbTaskAction" CssClass="edit_drop">
                                <Items>
                                    <dx:ListEditItem Text="" Value="" />
                                    <dx:ListEditItem Text="Manager Review Needed" Value="Manager Review Needed" />
                                    <dx:ListEditItem Text="Update Needed" Value="Update Needed" />
                                    <dx:ListEditItem Text="Person Lookup" Value="Lookup Request" />
                                    <dx:ListEditItem Text="Incentive Offer" Value="Incentive Offer Needed" />
                                    <dx:ListEditItem Text="Documents Request" Value="Documents Request" />
                                    <dx:ListEditItem Text="Judgement Search Request" Value="Judgement Search Request" />
                                </Items>
                                <ValidationSettings ErrorDisplayMode="None">
                                    <RequiredField IsRequired="true" />
                                </ValidationSettings>
                                <ClientSideEvents SelectedIndexChanged="function(s,e){
                                       if(s.GetText() != '')
                                       {
                                            callbackGetEmployeesByAction.PerformCallback(s.GetText());                                           
                                            return;
                                       }
                                    }" />
                            </dx:ASPxComboBox>
                            <dx:ASPxCallback runat="server" ID="callbackGetEmployeesByAction" ClientInstanceName="callbackGetEmployeesByAction" OnCallback="callbackGetEmployeesByAction_Callback">
                                <ClientSideEvents CallbackComplete="function(s,e){                                       
                                            empCheckComboBox.SetText(e.result);
                                    }" />
                            </dx:ASPxCallback>
                        </div>
                        <div class="form-group ">
                            <label class="upcase_text">employees</label>
                            <dx:ASPxDropDownEdit ClientInstanceName="empCheckComboBox" ID="empsDropDownEdit" Width="100%" runat="server" CssClass="edit_drop" AnimationType="None">
                                <DropDownWindowStyle BackColor="#EDEDED" />
                                <DropDownWindowTemplate>
                                    <dx:ASPxPageControl runat="server" TabPosition="Bottom" Width="100%" ID="tabPageEmpSelect" ActiveTabIndex="1" TabStyle-Height="35px">
                                        <TabPages>
                                            <dx:TabPage Text="Recently" Name="tabRecent">
                                                <ContentCollection>
                                                    <dx:ContentControl runat="server">
                                                        <dx:ASPxListBox Width="100%" ID="lbRecentEmps" Height="260px" ClientInstanceName="empRecentlyListbox" SelectionMode="CheckColumn"
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
                                                                    <dx:ASPxTextBox runat="server" ID="txtTaskEmpSearch" CssClass="edit_drop" ClientInstanceName="txtTaskEmpSearchClient" Width="100%" NullText="Type Employees Name">
                                                                        <ClientSideEvents KeyDown="function(s,e){                                                                                                                                     
                                                                                                                                        OnEmplistSearch(s.GetText());                                                                                                                                    
                                                                                                                                    }" />
                                                                    </dx:ASPxTextBox>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                        <dx:ASPxListBox Width="100%" ID="lbEmps" Height="220px" ClientInstanceName="empListBox" SelectionMode="CheckColumn"
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
                                    <div style="float: right; margin-top: -37px; display: block; margin-right: 3px;">
                                        <dx:ASPxButton ID="ASPxButton1" AutoPostBack="False" runat="server" CausesValidation="false" Text="Close" Style="float: right" CssClass="rand-button rand-button-gray">
                                            <ClientSideEvents Click="function(s, e){ empCheckComboBox.HideDropDown(); }" />
                                        </dx:ASPxButton>
                                    </div>
                                </DropDownWindowTemplate>
                                <ValidationSettings ErrorDisplayMode="None">
                                    <RequiredField IsRequired="true" />
                                </ValidationSettings>
                                <ClientSideEvents TextChanged="SynchronizeEmpListBoxValues" DropDown="SynchronizeEmpListBoxValues" />
                            </dx:ASPxDropDownEdit>
                        </div>

                        <div class="form-group ">
                            <label class="upcase_text">Importance</label>
                            <dx:ASPxComboBox runat="server" Width="100%" ID="cbTaskImportant" CssClass="edit_drop">
                                <Items>
                                    <dx:ListEditItem Text="Normal" Value="Normal" />
                                    <dx:ListEditItem Text="Important" Value="Important" />
                                    <dx:ListEditItem Text="Urgent" Value="Urgent" />
                                </Items>
                                <ValidationSettings ErrorDisplayMode="None">
                                    <RequiredField IsRequired="true" />
                                </ValidationSettings>
                            </dx:ASPxComboBox>
                        </div>
                        <div class="form-group ">
                            <label class="upcase_text" style="display: block">Description</label>
                            <dx:ASPxMemo runat="server" Width="100%" Height="115px" ID="txtTaskDes" CssClass="edit_text_area"></dx:ASPxMemo>
                            <%-- <textarea class="edit_text_area" style="height: 115px"></textarea>--%>
                        </div>
                        <div>
                            <div class="row" style="margin-top: 33px;">
                                <div class="col-md-7">&nbsp;</div>
                                <div class="col-md-5">
                                    <dx:ASPxButton ID="ASPxButton4" runat="server" Text="OK" AutoPostBack="false" CssClass="rand-button rand-button-blue">
                                        <ClientSideEvents Click="function(){
                                                                                                                        var container = ASPxPopupSetAsTaskControl.GetMainElement();
                                                                                                                        if (ASPxClientEdit.ValidateEditorsInContainer(container))
                                                                                                                        {
                                                                                                                            gridTrackingClient.PerformCallback('Task');
                                                                                                                            ASPxPopupSetAsTaskControl.Hide(); 
                                                                                                                        }                                                                                                                                                                                                                                        
                                                                                                                        }"></ClientSideEvents>
                                    </dx:ASPxButton>
                                    &nbsp;
                                                            <dx:ASPxButton runat="server" Text="Cancel" AutoPostBack="false" CausesValidation="false" CssClass="rand-button rand-button-gray">
                                                                <ClientSideEvents Click="function(){
                                                                                                                        ASPxPopupSetAsTaskControl.Hide();                                                                                                                                                                                                                                               
                                                                                                                        }"></ClientSideEvents>

                                                            </dx:ASPxButton>
                                </div>

                            </div>
                        </div>
                    </div>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

    </div>

    <%------end-------%>
</div>
