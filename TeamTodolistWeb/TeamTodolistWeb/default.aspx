<%@ Page Language="VB" AutoEventWireup="false" CodeFile="default.aspx.vb" Inherits="TodoListPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">

        function CompleteTask(taskId) {
            gridTaskClient.PerformCallback("CompleteTask|" + taskId);
        }

        function ChangeOwner(s, taskId) {
            gridTaskClient.PerformCallback("ChangeOwner|" + taskId + "|" + s.GetText());
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
            //if (e.htmlEvent.keyCode == 13) {
            //    //alert(textArea.scrollHeight + "|" + s.GetHeight());
            //    var text = txtCommentsClient.GetText();
            //    if (text.trim() == "") {
            //        alert("Please input comments.");
            //    }
            //    else
            //        gridTrackingClient.UpdateEdit();

            //    e.htmlEvent.preventDefault();
            //    return;
            //}

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

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div style="width: 80%; background-color: #efefef; margin: 0 auto; padding: 10px;">
            <h2 style="font-family: Tahoma; font-size: 20px; margin-top: 15px; text-align: center; padding-top: 15px;">Team Task List</h2>
            <dx:ASPxFormLayout ID="ASPxFormLayout1" runat="server" Width="900px" ClientInstanceName="AddTaskFormLayout">
                <Items>
                    <dx:LayoutGroup Caption="Add Task" ColCount="3">
                        <Items>
                            <dx:LayoutItem Caption="Description" RowSpan="4" CaptionSettings-Location="Top">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxMemo runat="server" ID="txtMemo" Width="600px" Height="100px">
                                            <ValidationSettings ErrorDisplayMode="None">
                                                <RequiredField IsRequired="True" />
                                            </ValidationSettings>
                                        </dx:ASPxMemo>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                                <CaptionSettings Location="Top"></CaptionSettings>
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
                            <dx:LayoutItem Caption="Due Date:">
                                <LayoutItemNestedControlCollection>
                                    <dx:LayoutItemNestedControlContainer>
                                        <dx:ASPxDateEdit runat="server" ID="dateDue">
                                            <ValidationSettings ErrorDisplayMode="None">
                                                <RequiredField IsRequired="True" />
                                            </ValidationSettings>
                                        </dx:ASPxDateEdit>
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
	}" />
                                          </dx:ASPxButton>
                                    </dx:LayoutItemNestedControlContainer>
                                </LayoutItemNestedControlCollection>
                            </dx:LayoutItem>
                        </Items>
                    </dx:LayoutGroup>
                </Items>
            </dx:ASPxFormLayout>
            <dx:ASPxGridView runat="server" ID="gridTask" Width="100%" KeyFieldName="ListId" ClientInstanceName="gridTaskClient" Paddings-Padding="5px" Settings-ShowFilterRow="true" SettingsBehavior-FilterRowMode="Auto">
                <Columns>
                    <dx:GridViewDataColumn FieldName="ListId" Caption="#" Width="50px">
                    </dx:GridViewDataColumn>
                    <dx:GridViewDataDateColumn FieldName="CreateDate" Width="110px" PropertiesDateEdit-DisplayFormatString="g">
                        <PropertiesDateEdit DisplayFormatString="g"></PropertiesDateEdit>
                        <FilterTemplate>
                        </FilterTemplate>
                    </dx:GridViewDataDateColumn>
                    <dx:GridViewDataTextColumn FieldName="Description">
                        <FilterTemplate>
                        </FilterTemplate>
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
                    <dx:GridViewDataDateColumn FieldName="DueDate" Caption="Due Date" PropertiesDateEdit-DisplayFormatString="d" Width="80px">
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
                    <dx:GridViewDataTextColumn FieldName="Comments" Caption="Comments" Width="200px">
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
                </Styles>
                <Settings VerticalScrollableHeight="600" />
                <SettingsPager Mode="EndlessPaging" PageSize="30"></SettingsPager>
            </dx:ASPxGridView>
            <dx:ASPxCallback runat="server" ID="callbackSaveComments" ClientInstanceName="callbackSaveComments" OnCallback="callbackSaveComments_Callback"></dx:ASPxCallback>
        </div>
    </form>
</body>
</html>
