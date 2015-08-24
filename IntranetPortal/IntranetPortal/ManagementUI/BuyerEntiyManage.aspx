<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="BuyerEntiyManage.aspx.vb" Inherits="IntranetPortal.BuyerEntiyManage" MasterPageFile="~/Content.Master" %>

<%@ Import Namespace="IntranetPortal" %>
<%@ Register Src="~/PopupControl/SendMailWithAttach.ascx" TagPrefix="uc1" TagName="SendMailWithAttach" %>


<asp:Content runat="server" ContentPlaceHolderID="head">
     <script>
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
         function FilterGridByCondtion(filterName, filterCondition)
         {
             
             entitiesGridClient.ApplyFilter(filterCondition);
         }
         
    </script>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="MainContentPH">
    <uc1:SendMailWithAttach runat="server" ID="SendMailWithAttach2" />
    <div class="container-fluid">
        <div class="row" style="margin-top:20px">
            <div class="col-md-8">
                <h3>All Entities
                   
                   
                </h3>
                <div>
                    <% Dim filter = Team.GetAllTeams.Select(Function(t) New With {.Name = t.Name & "'s Assigned Out", .Condtion = "[Status] = 'Assigned Out' and [Office] = '" & t.Name & "'"}).Tolist()
                        filter.AddRange(Team.GetAllTeams.Select(Function(t) New With {.Name = t.Name & "'s Available", .Condtion = "[Status] = 'Available' and [Office] = '" & t.Name & "'"}).ToList)
                        Dim OtherStatus = {"NHA Current Offer", "Isabel Current Offers", "Jay Current Offers"}.ToList
                        filter.AddRange(OtherStatus.Select(Function(o) New With {.Name = o, .Condtion = "[Status] = '" & o & "'"}))
                        'filter.Add(New With {.Name = "Closed NHA Files", .Condtion = "[Status] = 'Close'"})
                       %>
                    <%For Each f In filter %>
                    <span class="time_buttons" onclick="FilterGridByCondtion('<%= f.Name.Replace("'", "\'")%>','<%= f.Condtion.Replace("'","\'") %>')"><%=f.Name %></span>
                    <%Next %>
                </div>
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
                        
                        <dx:GridViewDataColumn FieldName="Notes"></dx:GridViewDataColumn>
                    </Columns>
                    <Settings ShowHeaderFilterButton="true"/>
                </dx:ASPxGridView>
                 <dx:ASPxGridViewExporter ID="CaseExporter" runat="server" GridViewID="entitiesGrid"></dx:ASPxGridViewExporter>
            </div>
        </div>
    </div>
</asp:Content>
