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
    <div>
        <h3>Import Search Leads Data</h3>
        <table style="width: 720px; text-align: left; margin: 10px,10px,0,0;">
            <tr>
                <td class="caption" style="width: 100px;">
                    <dx:ASPxLabel ID="ASPxLabel2" runat="server" Text="Select File:">
                    </dx:ASPxLabel>
                </td>
                <td>
                    <dx:ASPxUploadControl ID="SearchResultsUpolad" runat="server" ClientInstanceName="searchReslutuploader" ShowProgressPanel="True" ShowAddRemoveButtons="false" AddUploadButtonsHorizontalPosition="Left"
                        NullText="Click here to browse files..." Size="35" Width="100%" OnFilesUploadComplete="SearchResultsUpolad_FilesUploadComplete">
                        
                        <%--<ClientSideEvents FileUploadComplete="function(s, e) { Uploader_OnFileUploadComplete(e); }"
                                                FileUploadStart="function(s, e) { Uploader_OnUploadStart(); }"
                                                TextChanged="function(s, e) { UpdateUploadButton(); }"></ClientSideEvents>
                            --%>
                                            <ValidationSettings MaxFileSize="4194304">
                                            </ValidationSettings>
                    </dx:ASPxUploadControl>
                </td>
                <td style="padding-left: 5px; width: 180px">
                    <dx:ASPxButton ID="ASPxButton8" runat="server" AutoPostBack="False" Text="Upload" ClientInstanceName="btnUpload" Width="100px" ClientEnabled="False" Style="margin: 0 auto;">
                        <ClientSideEvents Click="function(s, e) { searchReslutuploader.Upload(); }" />
                    </dx:ASPxButton>
                </td>
            </tr>
            <tr>
                <td></td>
                <td class="note">
                    <dx:ASPxLabel ID="ASPxLabel3" runat="server" Text="Allowed types: xlst;"
                        Font-Size="8pt">
                    </dx:ASPxLabel>
                    <dx:ASPxLabel ID="ASPxLabel4" runat="server" Text="Maximum file size: 4Mb" Font-Size="8pt">
                    </dx:ASPxLabel>
                </td>
                <td></td>
            </tr>
            <tr style="height: 40px;">
                <td></td>
                <td class="buttonCell" style="margin-bottom: 5px; text-align: right">
                    <dx:ASPxLabel ID="ASPxLabel5" runat="server" ClientInstanceName="lblDataFileName"></dx:ASPxLabel>
                </td>
                <td style="padding-left: 5px;">
                    
                   
                    <dx:ASPxButton Text="Import"  runat="server" ID="ASPxButton11" AutoPostBack="false">
                        <ClientSideEvents Click="function(s,e){ImportFile();}" />
                    </dx:ASPxButton>
                    <dx:ASPxButton Text="Refresh" RenderMode="Link" runat="server" ID="ASPxButton12" AutoPostBack="false">
                        <ClientSideEvents Click="function(s,e){ gridLeadsData.Refresh();}" />
                    </dx:ASPxButton>
                </td>
            </tr>
        </table>
        <dx:ASPxGridView runat="server" ID="ASPxGridView1" Width="100%" ClientInstanceName="gridLeadsData" KeyFieldName="ID" >
            <Columns>
                <dx:GridViewDataTextColumn FieldName="BBLE"></dx:GridViewDataTextColumn>

            </Columns>
            <SettingsEditing Mode="Batch"></SettingsEditing>
        </dx:ASPxGridView>
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
