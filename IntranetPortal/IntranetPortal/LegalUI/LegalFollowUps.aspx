<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LegalFollowUps.aspx.vb" Inherits="IntranetPortal.LegalFollowUps" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/UserControl/Common.ascx" TagPrefix="uc1" TagName="Common" %>



<asp:Content runat="server" ContentPlaceHolderID="head">
    <script>
        function SearchGrid() {

            var filterCondition = "";
            var key = document.getElementById("QuickSearch").value;

            if (key.trim() == "") {
                AllLeadsGridClient.ClearFilter();
                return;
            }

            filterCondition = "[CaseName] LIKE '%" + key + "%' OR [CaseName] LIKE '%" + key + "%'";
            filterCondition += " OR [ResearchBy] LIKE '%" + key + "%'";
            filterCondition += " OR [Attorney] LIKE '%" + key + "%'";
            filterCondition += " OR [BBLE] LIKE '%" + key + "%'";
            AllLeadsGridClient.ApplyFilter(filterCondition);
            return false;
        }
        function ShowCaseInfo(BBLE)
        {
            var url = '/LegalUI/LegalUI.aspx?bble=' + BBLE;
            OpenLeadsWindow(url, 'Legal')
        }
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <uc1:Common runat="server" ID="Common" />
    <div class="container" style="margin-top:20px">
        <div class="row">
            <div class="col-md-4 col-md-offset-8 form-inline">
               <input type="text" style="margin-right: 20px" id="QuickSearch" class="form-control"  placeholder="Quick Search" onkeydown="javascript:if(event.keyCode == 13){ SearchGrid(); return false;}"/> 
                <i class="fa fa-search icon_btn tooltip-examples  grid_buttons"  style="margin-right: 20px;font-size:19px" onclick="SearchGrid()" title="search" ></i> 
                <asp:LinkButton ID="lbExportExcel" runat="server" Text="<i class='fa fa fa-file-excel-o report_head_button report_head_button_padding tooltip-examples' title='export to excel'></i>" OnClick="lbExportExcel_Click"></asp:LinkButton>                
            </div>
        </div>
        <div class="row" style="margin-top:10px">
            <dx:ASPxGridView ID="gdCases" runat="server" KeyFieldNam="BBLE" Theme="Moderno" CssClass="table" ClientInstanceName="AllLeadsGridClient" OnDataBinding="gdCases_DataBinding">
                <Columns>
                    <dx:GridViewDataColumn FieldName="BBLE" Visible="false">
                        <Settings HeaderFilterMode="CheckedList"/>                      
                    </dx:GridViewDataColumn>
                    <dx:GridViewDataColumn FieldName="CaseName">
                        <Settings HeaderFilterMode="CheckedList"/>
                          <DataItemTemplate>
                            <div style="cursor: pointer;" class="font_black" onclick='<%# String.Format("ShowCaseInfo({0})", Eval("BBLE"))%>'><%# Eval("CaseName")%></div>
                        </DataItemTemplate>
                    </dx:GridViewDataColumn>
                    <dx:GridViewDataColumn FieldName="Attorney">
                        <Settings HeaderFilterMode="CheckedList"/>
                    </dx:GridViewDataColumn>
                    <dx:GridViewDataDateColumn FieldName="FollowUp"></dx:GridViewDataDateColumn>
                    <dx:GridViewDataColumn FieldName="LegalStatusString" Caption="Stage">
                        <Settings HeaderFilterMode="CheckedList"/>
                    </dx:GridViewDataColumn>
                    <dx:GridViewDataDateColumn FieldName="AuctionDate">
                        <DataItemTemplate>
                            <%# String.Format("{0:d}", IntranetPortal.ShortSale.ShortSaleCase.GetCaseByBBLE(Eval("BBLE")).SaleDate)%>
                        </DataItemTemplate>
                    </dx:GridViewDataDateColumn>
                    <dx:GridViewDataColumn FieldName="ResearchBy" Caption="Research" Visible="false">
                        <Settings HeaderFilterMode="CheckedList"/>
                    </dx:GridViewDataColumn>
                </Columns>                
                <Settings ShowHeaderFilterButton="true" />               
            </dx:ASPxGridView>
             <dx:ASPxGridViewExporter ID="CaseExporter" runat="server" GridViewID="gdCases"></dx:ASPxGridViewExporter>
        </div>
        
    </div>

</asp:Content>
