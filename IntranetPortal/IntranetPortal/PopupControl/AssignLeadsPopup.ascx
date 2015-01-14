<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="AssignLeadsPopup.ascx.vb" Inherits="IntranetPortal.AssignLeadsPopup" %>
<script type="text/javascript">
    function OnNewClick() {
        RulesGridClient.AddNewRow();
    }


    function OnSaveClick() {
        RulesGridClient.UpdateEdit();
    }

    function OnCancelClick() {
        RulesGridClient.CancelEdit();
    }

    function OnDeleteClick(index) {

        RulesGridClient.DeleteRow(index);
    }
</script>
<dx:ASPxPopupControl ID="AssignLeadsPopUp" runat="server" ClientInstanceName="AssignLeadsPopupClient"
    Width="960px" Height="650px" CloseAction="CloseButton" ShowFooter="true"
    HeaderText="Assign Leads " Modal="true"
    PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableViewState="false" EnableHierarchyRecreation="True">
    <HeaderTemplate>
        <div class="clearfix">

            <div class="pop_up_header_margin">
                <i class="fa fa-check-square-o with_circle pop_up_header_icon"></i>
                <span class="pop_up_header_text">Assign Leads</span>
                <%--<div style="display: inline-block; font-size: 12px;">
                    <div>50 Leads</div>
                    <div>to be assigned</div>
                </div>--%>
            </div>
            <div class="pop_up_buttons_div">
                <i class="fa fa-times icon_btn" onclick="AssignLeadsPopupClient.Hide()"></i>
            </div>
        </div>
    </HeaderTemplate>
    <ContentCollection>
        <dx:PopupControlContentControl>
            <div>
                <style>
                    .edit_cell div:first-child {
                        border: 1px solid #dde0e7;
                        border-radius: 5px;
                        padding: 7px;
                        margin: 5px;
                    }

                    .edit_cell tbody tr td {
                        border: none !important;
                    }
                    /*.dxgvStatusBar_MetropolisBlue1 tr.dxgv > td
                    {
                        display:none;
                    }*/
                </style>
                <dx:ASPxGridView ID="RulesGrid" runat="server" KeyFieldName="RuleId" ClientInstanceName="RulesGridClient" EnableRowsCache="false" Width="100%"
                    OnRowUpdating="RulesGrid_RowUpdating"
                    OnRowInserting="RulesGrid_RowInserting"
                    OnRowDeleting="RulesGrid_RowDeleting" CssClass="hidden_btn">
                    <%--<Styles>
                        <Cell CssClass="edit_cell">
                        </Cell>
                    </Styles>--%>
                    <Columns>
                        <dx:GridViewDataComboBoxColumn FieldName="LeadsTypeText" Caption="Leads Type">
                            <%--<CellStyle CssClass="edit_drop">

                           </CellStyle>--%>

                            <%-- <DataItemTemplate>
                                <input  class="form-control" value='<%#Eval("LeadsTypeText")%>'/>
                            </DataItemTemplate>--%>
                            <%--<EditItemTemplate>
                                <dx:ASPxComboBox runat="server" ID="cbLeadsType" OnDataBinding="cbLeadsType_DataBinding" CssClass="edit_drop padding_edit">
                                    
                                </dx:ASPxComboBox>
                            </EditItemTemplate>--%>
                        </dx:GridViewDataComboBoxColumn>
                        <dx:GridViewDataComboBoxColumn FieldName="EmployeeName" Caption="Assigning To">
                        </dx:GridViewDataComboBoxColumn>
                        <%-- <dx:GridViewDataTextColumn FieldName="EmployeeName" Caption="Assigning To">
                            <EditItemTemplate>
                                <dx:ASPxComboBox runat="server" ID="cbEmployeeName" OnDataBinding="cbEmployeeName_DataBinding" CssClass="edit_drop padding_edit">
                                    
                                </dx:ASPxComboBox>
                            </EditItemTemplate>
                        </dx:GridViewDataTextColumn>--%>
                        <dx:GridViewDataTextColumn FieldName="Count">
                        </dx:GridViewDataTextColumn>
                        <dx:GridViewDataComboBoxColumn FieldName="IntervalTypeText" Caption="Interval">
                            <%--<EditItemTemplate>
                                <dx:ASPxComboBox runat="server" ID="cbIntervalType" CssClass="edit_drop padding_edit" OnDataBinding="cbIntervalType_DataBinding">
                                   
                                </dx:ASPxComboBox>
                            </EditItemTemplate>--%>
                        </dx:GridViewDataComboBoxColumn>
                        <dx:GridViewDataTextColumn Caption="Delete">
                            <DataItemTemplate>
                                <i class="fa fa-times icon_btn color_blue table_delete_row" onclick="OnDeleteClick(<%# Container.VisibleIndex %>)"></i>
                            </DataItemTemplate>
                            <EditItemTemplate>
                                <i class="fa fa-times icon_btn color_blue table_delete_row" onclick="OnDeleteClick(<%# Container.VisibleIndex %>)"></i>
                            </EditItemTemplate>
                        </dx:GridViewDataTextColumn>
                        <%--<dx:GridViewCommandColumn ShowDeleteButton="True" />--%>
                    </Columns>
                    <Styles>
                        <RowHotTrack BackColor="#f5f5f5"></RowHotTrack>

                    </Styles>
                    <SettingsEditing Mode="Batch" />


                </dx:ASPxGridView>
                <%-- <table class="table table-striped">
                    <thead class="upcase_text color_gray " style="font-weight: 300">
                        <tr>
                            <th>Leads Type</th>
                            <th>Assigning to</th>
                            <th>Count</th>
                            <th>Interval</th>
                            <th>Delete</th>
                        </tr>
                    </thead>
                    <tr>
                        <td>
                            <select class="form-control" >
                                <option>Unbuilt Property</option>
                                <option>Vacant House</option>

                            </select>
                        </td>
                        <td>
                            <select class="form-control">
                                <option>Albert Gavrielov’s Team </option>
                                <option>Ron Borovinsky’s Team</option>

                            </select>
                        </td>
                        <td>
                            <input class="form-control" />

                        </td>
                        <td>
                            <select class="form-control">
                                <option>Every 3 days</option>
                                <option>Every week</option>

                            </select>
                        </td>
                        <td>
                            <i class="fa fa-times icon_btn color_blue table_delete_row" onclick=""></i>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <select class="form-control" >
                                <option>Unbuilt Property</option>
                                <option selected>Vacant House</option>

                            </select>
                        </td>
                        <td>
                            <select class="form-control">
                                <option>Albert Gavrielov’s Team </option>
                                <option selected>Ron Borovinsky’s Team</option>

                            </select>
                        </td>
                        <td>
                            <input class="form-control" />

                        </td>
                        <td>
                            <select class="form-control">
                                <option>Every 3 days</option>
                                <option selected>Every week</option>

                            </select>
                        </td>
                        <td>
                            <i class="fa fa-times icon_btn color_blue table_delete_row" onclick=""></i>
                        </td>
                    </tr>
                </table>--%>
                <div style="float: right">
                    <i class="fa fa-plus-circle tooltip-examples icon_btn color_blue" style="font-size: 24px; margin-right: 37px;" title="Add" onclick="OnNewClick()"></i>
                </div>
                <asp:HiddenField runat="server" ID="hfSource" />
                <asp:HiddenField runat="server" ID="hfEmployees" />
            </div>
        </dx:PopupControlContentControl>


    </ContentCollection>
    <FooterContentTemplate>

        <div style="float: right; padding-bottom: 20px;">
            <input style="margin-right: 20px;" type="button" class="rand-button rand-button-padding bg_color_blue" value="Assign" onclick="OnSaveClick()">
            <input type="button" class="rand-button rand-button-padding bg_color_gray" value="Close" onclick="AssignLeadsPopupClient.Hide()">
        </div>

    </FooterContentTemplate>
</dx:ASPxPopupControl>
