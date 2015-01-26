<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LeadsSearchUploadData.aspx.vb" Inherits="IntranetPortal.LeadsSearchUploadData" MasterPageFile="~/Content.Master" %>

<asp:Content runat="server" ContentPlaceHolderID="MainContentPH">
    <div style="padding: 30px; color: #2e2f31; height: 100%">
        <div style="margin-bottom: 30px;">
            <i class="fa fa-search-plus title_icon color_gray"></i>
            <span class="title_text">Leads Search - <%= ActivityName%></span>
        </div>
        <table>
            <tr>
                <td>
                    <div class="form_head">Date:</div>
                </td>
                <td><%= If(Me.SubmitedDate = DateTime.MinValue, "", Me.SubmitedDate.ToString("g"))%></td>
            </tr>
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
               OnSubmited();
            }" />
    </dx:ASPxCallback>
    <script type="text/javascript">
        function OnSubmited() {
            $('#msgModal').modal('show');
            $('#msgModal').on('hide.bs.modal', function (e) {
                if (window.parent && typeof window.parent.ClosePage == 'function')
                    window.parent.ClosePage();
                else
                    window.close();
            });
        }
    </script>
    <div class="modal fade" id="msgModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">Success</h4>
                </div>
                <div class="modal-body">
                    The action is submited.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
