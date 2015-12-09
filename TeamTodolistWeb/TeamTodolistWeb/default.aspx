<%@ Page Language="VB" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="TodoListPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <script type="text/javascript">
        var IsLoadedChart = false;

        function CompleteTask(taskId) {
            gridTaskClient.PerformCallback("CompleteTask|" + taskId);
        }

        function ChangeOwner(s, taskId) {
            //gridTaskClient.PerformCallback("ChangeOwner|" + taskId + "|" + s.GetText());
            if (!callbackChangeOwner.InCallback())
                callbackChangeOwner.PerformCallback("ChangeOwner|" + taskId + "|" + s.GetText());
            else
                alert("Server is busy. Please try later");
        }

        function FilterLogs(s, e) {
            var filterCondition = "";
            var key = s.GetValue();

            if (key == 2) {
                gridTaskClient.ClearFilter();
                return;
            }

            filterCondition = "[Status] = " + key;
            gridTaskClient.AutoFilterByColumn("Status", key);
        }

        function FilterOwnerLogs(s, e) {
            var key = s.GetValue();
            gridTaskClient.AutoFilterByColumn("Owner", key);
        }

        function FilterCategoryLogs(s, e) {
            var key = s.GetValue();
            gridTaskClient.AutoFilterByColumn("Category", key);
        }
        function OnLogMemoKeyDown(s, e) {
            var textArea = s.GetInputElement();

            if (textArea.scrollHeight + 2 > s.GetHeight()) {
                //alert(textArea.scrollHeight + "|" + s.GetHeight());
                s.SetHeight(textArea.scrollHeight + 2);
            }

            if (textArea.scrollHeight + 2 < s.GetHeight()) {
                //alert(textArea.scrollHeight + "|" + s.GetHeight());
                s.SetHeight(textArea.scrollHeight + 2);
            }
        }

        function SaveComments(s, taskId) {
            var comments = s.GetText();
            callbackSaveComments.PerformCallback(taskId + "|" + comments);
        }

        function ChangeTaskPriority(s, taskId) {
            var priority = s.GetText();
            gridTaskClient.PerformCallback("Priority|" + taskId + "|" + priority);
        }
        function ChangeDateNeed(s, taskId) {
            var dateNeed = s.GetValue();
            gridTaskClient.PerformCallback("DataNeedChange|" + taskId + "|" + dateNeed);
        }

        function ShowBorder(s) {
            var tbl = s.GetMainElement();
            if (tbl.style.borderColor == 'transparent') {
                //border-top: 1px solid #9da0aa;
                //border-right: 1px solid #c2c4cb;
                //border-bottom: 1px solid #d9dae0;
                //border-left: 1px solid #c2c4cb;
                tbl.style.borderColor = "#9da0aa";
                tbl.style.backgroundColor = 'white';
            }
            else {
                tbl.style.borderColor = 'transparent';
                tbl.style.backgroundColor = 'transparent';
            }
        }

        function OnDueDateChange(s, taskId) {
            if (confirm("Are you sure to change the due date?")) {
                var newDate = s.GetDate();
                gridTaskClient.PerformCallback("DueDate|" + taskId + "|" + newDate.toISOString());
            }
            else {
                gridTaskClient.Refresh();
            }
        }

    </script>
    <style>
        .colors_ss {
            margin: 5px;
            width: 20px;
            height: 20px;
        }

        .margin_top {
            padding-top: 5px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div style="width: 1500px; background-color: #efefef; margin: 0 auto; padding: 10px; overflow: auto">
            <h2 style="font-family: Tahoma; font-size: 20px; margin-top: 10px; text-align: center; padding-top: 5px;">Team Task List</h2>
            <dx:ASPxFormLayout ID="ASPxFormLayout1" runat="server" ClientInstanceName="AddTaskFormLayout">
                <Items>
                    <dx:LayoutGroup Caption="Add Task" ColCount="3">
                        <Items>
                            <dx:LayoutItem Caption="Title">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxTextBox runat="server" ID="txtTitle">
                                            <ValidationSettings ErrorDisplayMode="None">
                                                <RequiredField IsRequired="True" />
                                            </ValidationSettings>                                        
                                        </dx:ASPxTextBox>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            <dx:LayoutItem Caption="Description" RowSpan="6">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxHtmlEditor runat="server" ID="txtMemo" Width="700px" Height="200px" ClientInstanceName="DescriptionClient">
                                            <Settings AllowHtmlView="false" AllowPreview="false" />
                                            <SettingsValidation>
                                                <RequiredField IsRequired="true" />
                                            </SettingsValidation>
                                        </dx:ASPxHtmlEditor>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                                <CaptionSettings Location="Top"></CaptionSettings>
                            </dx:LayoutItem>
                            <dx:LayoutItem Caption=" " RowSpan="6" CaptionSettings-Location="Top">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <table style="width: 100px;">
                                            <tr>
                                                <td>priority 1:
                                                </td>
                                                <td>
                                                    <div style="background: #D9534F;" class="colors_ss"></div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>priority 2:
                                                </td>
                                                <td>
                                                    <div style="background: #F0AD4E;" class="colors_ss"></div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>priority 3:
                                                </td>
                                                <td>
                                                    <div style="background: #5BC0DE;" class="colors_ss"></div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>priority 4:
                                                </td>
                                                <td>
                                                    <div style="background: #5CB85C;" class="colors_ss"></div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>priority 5:
                                                </td>
                                                <td>
                                                    <div style="background: #428BCA;" class="colors_ss"></div>
                                                </td>
                                            </tr>
                                        </table>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            <dx:LayoutItem Caption="Assign to:">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxComboBox runat="server" ID="cbAssign">
                                            <Items>
                                                <dx:ListEditItem Text="Ron" Value="Ron" />
                                                <dx:ListEditItem Text="George" Value="George" />
                                                <dx:ListEditItem Text="Sujie" Value="Sujie" />
                                                <dx:ListEditItem Text="Steven" Value="Steven" />
                                                <dx:ListEditItem Text="Chris" Value="Chris" />
                                            </Items>
                                            <ValidationSettings ErrorDisplayMode="None">
                                                <RequiredField IsRequired="True" />
                                            </ValidationSettings>
                                        </dx:ASPxComboBox>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>                            
                            <dx:LayoutItem Caption="Category:">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxComboBox runat="server" ID="cbCategory">
                                            <Items>
                                                <dx:ListEditItem Text="Functional" Value="Functional" Selected="true" />
                                                <dx:ListEditItem Text="Improvement" Value="Improvement" />
                                            </Items>
                                            <ValidationSettings ErrorDisplayMode="None">
                                                <RequiredField IsRequired="True" />
                                            </ValidationSettings>
                                        </dx:ASPxComboBox>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            <dx:LayoutItem Caption="Days need:">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxComboBox runat="server" ID="cbDateNeed">
                                            <ValidationSettings ErrorDisplayMode="None">
                                                <RequiredField IsRequired="True" />
                                            </ValidationSettings>
                                        </dx:ASPxComboBox>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            <dx:LayoutItem Caption="By:">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxLabel runat="server" ID="lblLoginUser"></dx:ASPxLabel>
                                        <dx:ASPxComboBox runat="server" ID="cbUsers" Visible="false">
                                            <Items>
                                                <dx:ListEditItem Text="Ron" Value="Ron" Selected="true" />
                                                <dx:ListEditItem Text="George" Value="George" />
                                                <dx:ListEditItem Text="Sujie" Value="Sujie" />
                                                <dx:ListEditItem Text="Steven" Value="Steven" />
                                                <dx:ListEditItem Text="Chris" Value="Chris" />
                                            </Items>
                                            <ValidationSettings ErrorDisplayMode="None">
                                                <RequiredField IsRequired="True" />
                                            </ValidationSettings>
                                        </dx:ASPxComboBox>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                            <dx:LayoutItem Caption="Due Date:" ShowCaption="False" HorizontalAlign="Right">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxButton Text="Add" runat="server" ID="btnAdd"></dx:ASPxButton>
                                        &nbsp;
                                          <dx:ASPxButton Text="Reset" runat="server" ID="ASPxButton1" AutoPostBack="false">
                                              <ClientSideEvents Click="function(s, e) {
		ASPxClientEdit.ClearEditorsInContainer(AddTaskFormLayout.GetMainElement ());
                                                  DescriptionClient.SetHtml('');
	}" />
                                          </dx:ASPxButton>
                                        &nbsp;
                                
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                        </Items>
                    </dx:LayoutGroup>
                </Items>
            </dx:ASPxFormLayout>
            <dx:ASPxPageControl runat="server" ID="pageTasks" ClientInstanceName="pageTasks">
                <TabPages>
                    <dx:TabPage Name="page1" Text="Tasks">
                        <ContentCollection>
                            <dx:ContentControl>
                                <dx:ASPxGridView runat="server" ID="gridTask" Width="1000" KeyFieldName="ListId" ClientInstanceName="gridTaskClient" Paddings-Padding="5px" Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto">
                                    <Columns>
                                        <dx:GridViewDataColumn FieldName="ListId" Caption="#" Width="50px">
                                        </dx:GridViewDataColumn>
                                        <dx:GridViewDataDateColumn FieldName="CreateDate" Width="110px" PropertiesDateEdit-DisplayFormatString="g">
                                            <PropertiesDateEdit DisplayFormatString="g"></PropertiesDateEdit>
                                            <FilterTemplate>
                                            </FilterTemplate>
                                        </dx:GridViewDataDateColumn>
                                        <dx:GridViewDataTextColumn FieldName="Description" Width="400px">
                                            <FilterTemplate>
                                            </FilterTemplate>
                                            <DataItemTemplate>
                                                <%# String.Format("<h4>{0}</h4>", Eval("Title"))%>
                                                <div>
                                                    <%# Eval("Description") %>
                                                </div>
                                            </DataItemTemplate>
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="CreateBy" Width="80px">
                                            <FilterTemplate>
                                            </FilterTemplate>
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataTextColumn FieldName="Owner" Caption="Assign To" Width="80px">
                                            <FilterTemplate>
                                                <dx:ASPxComboBox runat="server" ID="cbOwner" Width="100%">
                                                    <Items>
                                                        <dx:ListEditItem Text="All" Value="" />
                                                        <dx:ListEditItem Text="Ron" Value="Ron" />
                                                        <dx:ListEditItem Text="George" Value="George" />
                                                        <dx:ListEditItem Text="Sujie" Value="Sujie" />
                                                        <dx:ListEditItem Text="Steven" Value="Steven" />
                                                        <dx:ListEditItem Text="Chris" Value="Chris" />
                                                    </Items>
                                                    <ClientSideEvents SelectedIndexChanged="FilterOwnerLogs" />
                                                </dx:ASPxComboBox>
                                            </FilterTemplate>
                                            <DataItemTemplate>
                                                <dx:ASPxComboBox runat="server" ID="cbOwner" Visible="false" Width="100%">
                                                    <Items>
                                                        <dx:ListEditItem Text="Ron" Value="Ron" />
                                                        <dx:ListEditItem Text="George" Value="George" />
                                                        <dx:ListEditItem Text="Sujie" Value="Sujie" />
                                                        <dx:ListEditItem Text="Steven" Value="Steven" />
                                                        <dx:ListEditItem Text="Chris" Value="Chris" />
                                                    </Items>
                                                    <ValidationSettings ErrorDisplayMode="None">
                                                        <RequiredField IsRequired="True" />
                                                    </ValidationSettings>
                                                </dx:ASPxComboBox>
                                                <dx:ASPxLabel ID="lblOwner" runat="server" Text='<%#String.Format("{0}", Eval("Owner"))%>' Visible='<%# Eval("Status") = TaskStatus.Completed%>'></dx:ASPxLabel>
                                            </DataItemTemplate>
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataDateColumn FieldName="DateNeed" Caption="Day Need" Width="90px">
                                            <FilterTemplate>
                                            </FilterTemplate>
                                            <DataItemTemplate>
                                                <dx:ASPxComboBox runat="server" ID="cbDateNeed" Width="70px" Visible='<%# Eval("Status") = TaskStatus.NewTask%>'>
                                                    <Items>
                                                        <dx:ListEditItem Text="" Value="" />
                                                        <dx:ListEditItem Text="1" Value="1" />
                                                        <dx:ListEditItem Text="2" Value="2" />
                                                        <dx:ListEditItem Text="3" Value="3" />
                                                        <dx:ListEditItem Text="4" Value="4" />
                                                        <dx:ListEditItem Text="5" Value="5" />
                                                        <dx:ListEditItem Text="6" Value="6" />
                                                        <dx:ListEditItem Text="7" Value="7" />
                                                        <dx:ListEditItem Text="8" Value="8" />
                                                        <dx:ListEditItem Text="9" Value="9" />
                                                    </Items>
                                                </dx:ASPxComboBox>
                                                <dx:ASPxLabel runat="server" Text='<%# Eval("DateNeed") %>' Visible='<%# Eval("Status") <> TaskStatus.NewTask%>'></dx:ASPxLabel>
                                            </DataItemTemplate>
                                        </dx:GridViewDataDateColumn>
                                        <dx:GridViewDataDateColumn FieldName="DueDate" Caption="Due Date" PropertiesDateEdit-DisplayFormatString="d" Width="100px">
                                            <DataItemTemplate>
                                                <%--<dx:ASPxDateEdit runat="server" ID="dateDue" Date='<%# Bind("DueDate")%>'  Width="110px">
                                <ValidationSettings ErrorDisplayMode="None">
                                    <RequiredField IsRequired="True" />
                                </ValidationSettings>
                            </dx:ASPxDateEdit>--%>
                                                <dx:ASPxLabel runat="server" ID="dateDue" Text='<%# String.Format("{0:d}", Eval("DueDate"))%>'></dx:ASPxLabel>
                                            </DataItemTemplate>
                                        </dx:GridViewDataDateColumn>
                                        <dx:GridViewDataColumn FieldName="Priority" Caption="Priority" Width="60px">
                                            <FilterTemplate>
                                            </FilterTemplate>
                                            <DataItemTemplate>
                                                <dx:ASPxComboBox runat="server" ID="cbPriority" Width="100%" Visible='<%# Eval("Status") = TaskStatus.NewTask %>'>
                                                    <Items>
                                                        <dx:ListEditItem Text="" Value="" />
                                                        <dx:ListEditItem Text="1" Value="1" />
                                                        <dx:ListEditItem Text="2" Value="2" />
                                                        <dx:ListEditItem Text="3" Value="3" />
                                                        <dx:ListEditItem Text="4" Value="4" />
                                                        <dx:ListEditItem Text="5" Value="5" />
                                                    </Items>
                                                    <ClientSideEvents SelectedIndexChanged="PriorityChanges" />
                                                </dx:ASPxComboBox>
                                            </DataItemTemplate>
                                        </dx:GridViewDataColumn>
                                        <dx:GridViewDataColumn FieldName="Category" Caption="Category" Width="80px">
                                            <FilterTemplate>
                                                <dx:ASPxComboBox runat="server" ID="cbFilter" Width="100%">
                                                    <Items>
                                                        <dx:ListEditItem Text="All" Value="" />
                                                        <dx:ListEditItem Text="Functional" Value="Functional" />
                                                        <dx:ListEditItem Text="Improvement" Value="Improvement" />
                                                    </Items>
                                                    <ClientSideEvents SelectedIndexChanged="FilterCategoryLogs" />
                                                </dx:ASPxComboBox>
                                            </FilterTemplate>
                                        </dx:GridViewDataColumn>
                                        <dx:GridViewDataTextColumn FieldName="Comments" Caption="Comments" Width="275px">
                                            <FilterTemplate></FilterTemplate>
                                            <DataItemTemplate>
                                                <dx:ASPxMemo ID="txtComments" Width="100%" ClientInstanceName="txtCommentsClient" runat="server" Text='<%# Eval("Comments") %>' Height="13px" Border-BorderColor="Transparent" BackColor="Transparent">
                                                    <ClientSideEvents KeyDown="OnLogMemoKeyDown" Init="function(s,e){
                                                                                        s.GetInputElement().style.overflowY='hidden';
                                                                                        OnLogMemoKeyDown(s,e);
                                                                                    }"
                                                        GotFocus="function(s,e){ShowBorder(s);}" LostFocus="function(s,e){ShowBorder(s);}" />
                                                </dx:ASPxMemo>
                                            </DataItemTemplate>
                                        </dx:GridViewDataTextColumn>
                                        <dx:GridViewDataColumn FieldName="Status" Caption="Completed" Width="80px">
                                            <DataItemTemplate>
                                                <dx:ASPxCheckBox ID="chkCompleted" runat="server" Visible='<%# Eval("Status") = TaskStatus.NewTask %>'></dx:ASPxCheckBox>
                                                <dx:ASPxLabel ID="lblComplete" runat="server" Text='<%#String.Format("{0:d}", Eval("UpdateDate"))%>' Visible='<%# Eval("Status") = TaskStatus.Completed%>'></dx:ASPxLabel>
                                            </DataItemTemplate>
                                            <FilterTemplate>
                                                <dx:ASPxComboBox runat="server" ID="cbFilter" Width="100%">
                                                    <Items>
                                                        <dx:ListEditItem Text="All" Value="" />
                                                        <dx:ListEditItem Text="Completed" Value="1" />
                                                        <dx:ListEditItem Text="Non-Completed" Value="0" />
                                                    </Items>
                                                    <ClientSideEvents SelectedIndexChanged="FilterLogs" />
                                                </dx:ASPxComboBox>
                                            </FilterTemplate>
                                        </dx:GridViewDataColumn>
                                        <dx:GridViewDataColumn Caption="Days" Width="50px">
                                            <DataItemTemplate>
                                                <dx:ASPxLabel ID="lblHours" runat="server" Text='<%# CalculateWorkingDays(Eval("UpdateDate"), Eval("CreateDate"))%>' Visible='<%# Eval("Status") = TaskStatus.Completed%>'></dx:ASPxLabel>
                                            </DataItemTemplate>
                                        </dx:GridViewDataColumn>
                                    </Columns>
                                    <Styles>
                                        <AlternatingRow BackColor="#f9f9f9"></AlternatingRow>
                                        <Row VerticalAlign="Top" CssClass="margin_top">
                                        </Row>
                                    </Styles>
                                    <Settings VerticalScrollableHeight="600" />
                                    <SettingsPager Mode="EndlessPaging" PageSize="30"></SettingsPager>
                                </dx:ASPxGridView>
                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>
                    <dx:TabPage Text="Gantt Chart" Name="tabGantt">
                        <ContentCollection>
                            <dx:ContentControl>
                                <table style="width: 100%">
                                    <tr>
                                        <td style="vertical-align: top; padding-top: 10px; width: 130px;">
                                            <ul style="list-style: none; padding-left: 1px; line-height: 30px">
                                                <li>User:
                                                        <dx:ASPxListBox runat="server" ID="cbChartUser" ClientInstanceName="cbChartuser" SelectionMode="CheckColumn" Width="120px" Height="140px">
                                                            <Items>
                                                                <dx:ListEditItem Text="Ron" Value="Ron" />
                                                                <dx:ListEditItem Text="George" Value="George" />
                                                                <dx:ListEditItem Text="Sujie" Value="Sujie" />
                                                                <dx:ListEditItem Text="Steven" Value="Steven" />
                                                                <dx:ListEditItem Text="Chris" Value="Chris" />
                                                            </Items>
                                                        </dx:ASPxListBox>
                                                </li>
                                                <li>
                                                    <dx:ASPxButton Text="Filter" runat="server" ID="btnViewChart" AutoPostBack="false" CausesValidation="false">
                                                        <ClientSideEvents Click="function(s,e){
                                                            cpGanttChart.PerformCallback(cbChartuser.GetSelectedValues().toString());
                                                            }" />
                                                    </dx:ASPxButton>
                                                </li>
                                            </ul>
                                        </td>
                                        <td style="background-color: #efefef;">
                                            <dx:ASPxCallbackPanel runat="server" ClientInstanceName="cpGanttChart" OnCallback="Unnamed_Callback">
                                                <PanelCollection>
                                                    <dx:PanelContent>
                                                        <asp:HiddenField runat="server" ID="hfLoad" />
                                                        <dx:WebChartControl runat="server" Height="550px" Width="1300px" ID="ganttChart">
                                                            <legend alignmenthorizontal="Right" direction="LeftToRight">
                                                                <margins bottom="10" left="10" right="10" top="10" />
                                                            </legend>
                                                            <diagramserializable>
            <dx:GanttDiagram>                
                <AxisX Title-Text="Tasks" VisibleInPanesSerializable="-1"> 
                    <GridLines Visible="True"></GridLines>
                </AxisX>
                <AxisY Title-Text="Date" VisibleInPanesSerializable="-1" MinorCount="4" Interlaced="True">
                    <DateTimeScaleOptions GridAlignment="Month" AutoGrid="False" GridSpacing="0.5"/>                    
                    <WholeRange Auto="False" MinValueSerializable="12/10/2014 00:00:00.000" MaxValueSerializable="2/1/2015 00:00:00.000" AutoSideMargins="False" SideMarginsValue="0"></WholeRange>
                    <GridLines MinorVisible="True"></GridLines>
                    <Label TextPattern="{V:m}">
                    </Label>
                </AxisY>
            </dx:GanttDiagram>
        </diagramserializable>
                                                            <borderoptions visibility="False" />
                                                        </dx:WebChartControl>
                                                    </dx:PanelContent>
                                                </PanelCollection>
                                            </dx:ASPxCallbackPanel>
                                        </td>
                                    </tr>
                                </table>
                            </dx:ContentControl>
                        </ContentCollection>
                    </dx:TabPage>
                </TabPages>
                <ClientSideEvents ActiveTabChanged="function(s,e){
                    if(e.tab.name=='tabGantt'){
                    if(! IsLoadedChart)
                    {cpGanttChart.PerformCallback(); IsLoadedChart = true;}
                    }
                    }" />
            </dx:ASPxPageControl>
            <dx:ASPxCallback runat="server" ID="callbackSaveComments" ClientInstanceName="callbackSaveComments" OnCallback="callbackSaveComments_Callback"></dx:ASPxCallback>
            <dx:ASPxCallback runat="server" ID="callbackChangeOwner" ClientInstanceName="callbackChangeOwner" OnCallback="callbackChangeOwner_Callback">
                <ClientSideEvents EndCallback="function(s,e){gridTaskClient.Refresh()}" />
            </dx:ASPxCallback>
        </div>
    </form>
</body>
</html>
