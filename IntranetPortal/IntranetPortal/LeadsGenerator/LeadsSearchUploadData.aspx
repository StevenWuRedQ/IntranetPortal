<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LeadsSearchUploadData.aspx.vb" Inherits="IntranetPortal.LeadsSearchUploadData" MasterPageFile="~/Content.Master" %>

<asp:Content runat="server" ContentPlaceHolderID="MainContentPH">
    <div style="padding: 30px; color: #2e2f31; height: 100%">
        <div style="margin-bottom: 30px;">
            <i class="fa fa-search-plus title_icon color_gray"></i>
            <span class="title_text">Leads Search - <%= ActivityName%></span>
        </div>
        <table>
            <tr>
                <td>Applicant: </td>
                <td><%= Me.Applicant%></td>
            </tr>
            <tr>
                <td>Name: </td>
                <td>
                    <%= SearchName%>
                </td>
            </tr>
            <tr>
                <td>Criteria: </td>
                <td><%= SearchData %></td>
            </tr>
            <tr>
                <td colspan="2">&nbsp;</td>
            </tr>           
            <tr>
                <td colspan="2">
                    <button type="button" class="rand-button rand-button-pad bg_orange button_margin" onclick="cbApproval.PerformCallback('Complete')">Complete</button>                    
                </td>
            </tr>
        </table>
    </div>
    <dx:ASPxCallback runat="server" ID="cbApproval" ClientInstanceName="cbApproval" OnCallback="cbApproval_Callback">
          <ClientSideEvents EndCallback="function(s,e){
            alert('Submited');
            }" />
    </dx:ASPxCallback>
</asp:Content>
