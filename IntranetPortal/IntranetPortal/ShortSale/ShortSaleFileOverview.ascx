<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ShortSaleFileOverview.ascx.vb" Inherits="IntranetPortal.ShortSaleFileOverview" %>

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

    .filited {
        background: url(/images/ic_filtered_bg.png) no-repeat;
    }

    /* for fix the email message link color hover bug in activty log*/
    td.dxgv:hover a {
        color: black !important;
    }
</style>

<script type="text/javascript">
    // <![CDATA[

    function InsertOverview() {
        //var comments = document.getElementById("txtComments");

        //if (comments.value == "") {
        //    alert("Comments can not be empty.")
        //    return;
        //}
        var commentHtml = document.getElementById("txtOverview").value;
        if (commentHtml == "") {
            alert("Comments can't be empty.")
            return
        }

        gridOverviewClient.PerformCallback("Add|" + commentHtml);
        $("#txtOverview").val("");
    }

    function OnOverviewCommentsKeyDown(e) {
        if (e.ctrlKey && e.keyCode == 13) {
            // Ctrl-Enter pressed
            InsertOverview();
        }
    }
    // ]]>
</script>

<div style="font-size: 12px; color: #9fa1a8; font-family: 'Source Sans Pro'; width: 100%">
    <!-- Nav tabs -->
    <%--comment box filters--%>
    <div style="padding: 20px; background: #f5f5f5" class="clearfix">
        <%--comment box and text--%>
        <div style="float: left; height: 80px; min-width: 450px; width: 60%; margin-top: 10px;">
            <div class="clearfix">
                <span style="color: #295268;" class="upcase_text">Update Overview&nbsp;&nbsp;<i class="fa fa-comment" style="font-size: 14px"></i></span>
            </div>
            <textarea title="Press CTRL+ENTER to submit." class="edit_text_area" style="height: 60px;" id="txtOverview" onkeydown="OnOverviewCommentsKeyDown(event);"></textarea>
        </div>
        <div class="clearfix" style="width: 100%">
            <div style="float: left; margin-left: 20px;">
                <div style="margin-top: 20px;">
                    <div class="border_under_line" style="height: 10px; width: 100px">
                        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;                        
                    </div>
                </div>
                <div style="margin-top: 15px; float: left; margin-right: 5px;">
                    <i class="fa fa-plus-circle activity_add_buttons tooltip-examples icon_btn" title="Add Comment" style="margin-right: 15px; cursor: pointer" onclick="InsertOverview()"></i>
                </div>
            </div>
        </div>
    </div>
    <%-------end-----%>
    <%-- log tables--%>
    <div style="width: 100%; padding: 0px; display: block;">
        <asp:HiddenField ID="hfBBLE" runat="server" />
        <dx:ASPxGridView ID="gridTracking" Width="100%" ViewStateMode="Disabled" SettingsCommandButton-UpdateButton-ButtonType="Image" Visible="true" SettingsEditing-Mode="EditForm" ClientInstanceName="gridOverviewClient" runat="server" AutoGenerateColumns="False" KeyFieldName="LogId" SettingsBehavior-AllowSort="false" Styles-FilterBuilderHeader-BackColor="Gray"
            OnCustomCallback="gridTracking_CustomCallback" OnDataBinding="gridTracking_DataBinding">
            <Styles>
                <Cell VerticalAlign="Top"></Cell>
                <Header BackColor="#F5F5F5"></Header>
            </Styles>
            <Columns>
                <dx:GridViewDataColumn FieldName="ActionType" VisibleIndex="0" Caption="" Width="40px">
                    <HeaderStyle HorizontalAlign="Center" />
                    <HeaderTemplate>
                    </HeaderTemplate>
                    <DataItemTemplate>
                    </DataItemTemplate>
                    <CellStyle VerticalAlign="Top"></CellStyle>
                </dx:GridViewDataColumn>
                <dx:GridViewDataTextColumn FieldName="Comments" PropertiesTextEdit-EncodeHtml="false" VisibleIndex="1" FilterCellStyle-Wrap="Default" EditCellStyle-Wrap="False">
                    <HeaderTemplate>
                        Overview
                    </HeaderTemplate>
                    <PropertiesTextEdit EncodeHtml="False"></PropertiesTextEdit>
                    <EditCellStyle Wrap="False"></EditCellStyle>
                    <DataItemTemplate>
                        <asp:Literal runat="server" Text='<%# String.Format("<div class=""divComments"">{0}</div>", Eval("Comments"))%>'>
                        </asp:Literal>
                    </DataItemTemplate>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="by" VisibleIndex="2" Width="120" FieldName="UserName">
                    <HeaderTemplate>
                        BY
                    </HeaderTemplate>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn FieldName="ActivityDate" Width="140" Caption="Date" VisibleIndex="4" PropertiesTextEdit-DisplayFormatString="d">
                    <PropertiesTextEdit DisplayFormatString="g"></PropertiesTextEdit>
                    <HeaderTemplate>
                        Date
                    </HeaderTemplate>
                </dx:GridViewDataTextColumn>
            </Columns>
            <Settings VerticalScrollableHeight="650" />
            <SettingsEditing Mode="EditForm"></SettingsEditing>
            <SettingsText CommandUpdate="Add" />
            <SettingsPager Mode="ShowAllRecords" />
            <Styles>
                <EditForm Paddings-Padding="0">
                    <Paddings Padding="0px"></Paddings>
                </EditForm>
                <Row Cursor="pointer" />
                <AlternatingRow CssClass="gridAlternatingRow"></AlternatingRow>
            </Styles>
            <Settings VerticalScrollBarMode="Auto" ShowHeaderFilterButton="true" />
            <SettingsBehavior AllowFocusedRow="false" AllowClientEventsOnLoad="false" AllowDragDrop="false"
                EnableRowHotTrack="false" ColumnResizeMode="Disabled" />
        </dx:ASPxGridView>
    </div>
    <%------end-------%>
</div>
