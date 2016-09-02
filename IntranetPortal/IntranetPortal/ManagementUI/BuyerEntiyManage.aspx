<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="BuyerEntiyManage.aspx.vb" Inherits="IntranetPortal.BuyerEntiyManage" MasterPageFile="~/Content.Master" %>

<%@ Import Namespace="IntranetPortal" %>
<%@ Register Src="~/PopupControl/SendMailWithAttach.ascx" TagPrefix="uc1" TagName="SendMailWithAttach" %>


<asp:Content runat="server" ContentPlaceHolderID="head">
    <link rel="stylesheet" href="/css/right-pane.css" />

    <script>
        $(document).ready(function () {

            $("#right-pane-button").mouseenter(function () {
                $("#right-pane-container").css("right", "0");
            });

            $('body').click(function (e) {
                if (e.target.id == 'right-pane-container')
                { return true; }
                else
                {
                    $("#right-pane-container").css("right", "-290px");
                }

            });
        });

        function SearchGrid() {

            var filterCondition = "";
            var key = document.getElementById("QuickSearch").value;

            if (key.trim() == "") {
                entitiesGridClient.ClearFilter();
                return;
            }

            filterCondition = "[CorpName] LIKE '%" + key + "%' OR [Address] LIKE '%" + key + "%'";
            filterCondition += " OR [PropertyAssigned] LIKE '%" + key + "%'";
            filterCondition += " OR [Signer] LIKE '%" + key + "%'";
            filterCondition += " OR [EIN] LIKE '%" + key + "%'";
            entitiesGridClient.ApplyFilter(filterCondition);
            return false;
        }
        function ShowCaseInfo(BBLE) {
            var url = '/LegalUI/LegalUI.aspx?bble=' + BBLE;
            OpenLeadsWindow(url, 'Legal')
        }
        function FilterGridByCondtion(filterName, filterCondition) {

            entitiesGridClient.ApplyFilter(filterCondition);
        }

    </script>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="MainContentPH">
    <uc1:SendMailWithAttach runat="server" ID="SendMailWithAttach2" />
    <div class="container-fluid">
        <div class="row" style="margin-top: 20px">
            <div class="col-md-8">
                <h3>All Entities
                </h3>

            </div>
            <div class="col-md-4  form-inline">
                <input type="text" style="margin-right: 20px" id="QuickSearch" class="form-control" placeholder="Quick Search" onkeydown="javascript:if(event.keyCode == 13){ SearchGrid(); return false;}" />
                <i class="fa fa-search icon_btn tooltip-examples  grid_buttons" style="margin-right: 20px; font-size: 19px" onclick="SearchGrid()" title="search"></i>
                <asp:LinkButton ID="lbExportExcel" runat="server" Text="<i class='fa fa fa-file-excel-o report_head_button report_head_button_padding tooltip-examples' title='export to excel'></i>" OnClick="lbExportExcel_Click"></asp:LinkButton>
                <i class="fa fa-envelope icon_btn tooltip-examples  grid_buttons" style="margin-right: 20px; font-size: 19px" onclick="popupSendEmailAttachClient.Show(); popupSendEmailAttachClient.PerformCallback('Show');" title="email"></i>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">

                <dx:ASPxGridView ID="entitiesGrid" ClientInstanceName="entitiesGridClient" runat="server" KeyFieldName="EntityId" OnDataBinding="entityGrid_DataBinding" Theme="Moderno" SettingsPager-PageSize="13">
                    <Columns>
                        <dx:GridViewDataColumn FieldName="CorpName">
                            <Settings HeaderFilterMode="CheckedList" />
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="Status">
                            <Settings HeaderFilterMode="CheckedList" />
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="Address">
                            <Settings HeaderFilterMode="CheckedList" />
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="PropertyAssigned">
                            <Settings HeaderFilterMode="CheckedList" />
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="FillingDate">
                            <Settings HeaderFilterMode="CheckedList" />
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="Signer">
                            <Settings HeaderFilterMode="CheckedList" />
                        </dx:GridViewDataColumn>

                        <dx:GridViewDataColumn FieldName="Office">
                            <Settings HeaderFilterMode="CheckedList" />
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="EIN">
                            <Settings HeaderFilterMode="CheckedList" />
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="AssignOn">
                            <Settings HeaderFilterMode="CheckedList" />
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="ReceivedOn">
                            <Settings HeaderFilterMode="CheckedList" />
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="SubmittedtoAcris">
                            <Settings HeaderFilterMode="CheckedList" />
                        </dx:GridViewDataColumn>
                        <%--  <dx:GridViewDataColumn FieldName="SubmittedOn">
                            <Settings HeaderFilterMode="CheckedList" />
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="RecordedOn">
                            <Settings HeaderFilterMode="CheckedList" />
                        </dx:GridViewDataColumn>--%>

                        <dx:GridViewDataColumn FieldName="UpdateTime">
                            <Settings HeaderFilterMode="CheckedList" />
                        </dx:GridViewDataColumn>

                        <dx:GridViewDataColumn FieldName="Notes" Visible="false"></dx:GridViewDataColumn>
                    </Columns>
                    <Settings ShowHeaderFilterButton="true" />
                </dx:ASPxGridView>
                <dx:ASPxGridViewExporter ID="CaseExporter" runat="server" GridViewID="entitiesGrid"></dx:ASPxGridViewExporter>
            </div>
        </div>


    </div>
    <div id="right-pane-container" class="clearfix">
        <div id="right-pane-button" class="right-pane_custom_reports"></div>
        <div id="right-pane">
            <div style="height: 100%; background: #EFF2F5;">
                <div style="width: 310px; background: #f5f5f5" class="agent_layout_float">
                    <div style="margin-left: 30px; margin-top: 30px; margin-right: 20px; font-size: 24px; float: none;">

                        <div>
                            <div style="padding-top: 19px; padding-bottom: 14px;" class="border_under_line">
                                <span style="color: #234b60">Custom Reports</span>
                                <i class="fa fa-question-circle tooltip-examples" title="Check items view the customized report." style="color: #999ca1; float: right; margin-top: 3px"></i>
                            </div>
                            <ul class="list-group" style="font-size: 14px; box-shadow: none; height: 800px; overflow: auto">
                                <% Dim filter = Team.GetAllTeams.Select(Function(t) New With {.Name = t.Name & "'s Assigned Out", .Condtion = "[Status] = 'Assigned Out' and [Office] = '" & t.Name & "'"}).Tolist()
                                    filter.AddRange(Team.GetAllTeams.Select(Function(t) New With {.Name = t.Name & "'s Available", .Condtion = "[Status] = 'Available' and [Office] = '" & t.Name & "'"}).ToList)
                                    Dim OtherStatus = {"NHA Current Offer", "Isabel Current Offers", "Jay Current Offers"}.ToList
                                    filter.AddRange(OtherStatus.Select(Function(o) New With {.Name = o, .Condtion = "[Status] = '" & o & "'"}))
                                    'filter.Add(New With {.Name = "Closed NHA Files", .Condtion = "[Status] = 'Close'"})
                                %>
                                <%For Each f In filter%>
                                <li class="list-group-item color_gray save_report_list" style="background-color: transparent; border: 0px;">
                                    <i class="fa fa-file-o" style="font-size: 18px"></i>
                                    <span class="drappable_field_text" onclick="FilterGridByCondtion('<%= f.Name.Replace("'", "\'")%>','<%= f.Condtion.Replace("'","\'") %>')" style="cursor: pointer; width: 178px;"><%=f.Name %></span>

                                </li>

                                <%Next%>
                            </ul>


                        </div>

                    </div>
                </div>
            </div>
            <div style="height: 100%; background: #EFF2F5; display: none">
                <div style="width: 100%; height: 100%;">
                    <div style="height: 70px;">
                        <div style="color: #b2b4b7; padding-top: 35px; margin-left: 26px; font-size: 30px; font-weight: 300;">Notes</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
