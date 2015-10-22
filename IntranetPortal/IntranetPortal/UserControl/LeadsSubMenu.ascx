<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LeadsSubMenu.ascx.vb" Inherits="IntranetPortal.LeadsSubMenu" %>
<%@ Register Src="~/LegalUI/LegalSecondaryActions.ascx" TagPrefix="uc1" TagName="LegalSecondaryActions" %>

<script type="text/javascript" src="/Scripts/LeadsSubMenu.js"></script>
<dx:ASPxPopupMenu ID="popupMenuLeads" runat="server" ClientInstanceName="ASPxPopupMenuCategory" PopupHorizontalAlign="Center" PopupVerticalAlign="Below" PopupAction="MouseOver" ForeColor="#3993c1" Font-Size="14px" CssClass="fix_pop_postion_s" Paddings-PaddingTop="15px" Paddings-PaddingBottom="18px">
    <Items>
        <dx:MenuItem GroupName="Sort" Text="View Map" Image-Url="/images/drap_map_icons.png" Name="GoogleStreet">
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Google Map View" Name="GoogleMap" Image-Url="/images/drap_map_icons.png" ClientVisible="false">
            <Image Url="/images/drap_map_icons.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Bing Bird View" Name="BingBird" Image-Url="/images/drap_map_icons.png" ClientVisible="false">
            <Image Url="/images/drap_map_icons.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Hot Leads" Name="Priority" Image-Url="/images/drap_prority_icons.png">
            <Image Url="/images/drap_prority_icons.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Door Knock" Name="DoorKnock" Image-Url="/images/drap_prority_icons.png">
            <Image Url="/images/drap_doorknock_icons.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Follow Up" Name="Callback" Image-Url="/images/drap_follow_up_icons.png">
            <Image Url="/images/drap_follow_up_icons.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Dead Lead" Name="DeadLead" Image-Url="/images/drap_deadlead_icons.png">
            <Image Url="/images/drap_deadlead_icons.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="In Process" Name="InProcess" Image-Url="/images/drap_inprocess_icons.png">
            <Image Url="/images/drap_inprocess_icons.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="View Lead" Name="ViewLead" Visible="false">
            <Image Url="/images/drap_view_leads.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Closed" Name="Closed" Image-Url="/images/drap_closed_icons.png">
            <Image Url="/images/drap_closed_icons.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Share Leads" Name="Shared">
            <Image Url="/images/drap_deadlead_icons.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Reassign" Name="Reassign" Visible="false">
            <Image Url="/images/drap_reassign_icon.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="View Files" Name="ViewFiles">
            <Image Url="/images/drap_viewfile_icons.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Upload Docs/Pics" Name="Upload">
            <Image Url="/images/drap_upload_icons.png"></Image>
        </dx:MenuItem>
    </Items>
    <ClientSideEvents ItemClick="function(s,e){OnLeadsCategoryClick(s,e);}" />
    <ItemStyle Height="30px"></ItemStyle>
</dx:ASPxPopupMenu>
<dx:ASPxPopupMenu ID="ASPxPopupMenu1" runat="server" ClientInstanceName="AspPopupColorMark" PopupHorizontalAlign="Center" PopupVerticalAlign="Below" PopupAction="MouseOver" ForeColor="#3993c1" Font-Size="14px" CssClass="fix_pop_postion_s" Paddings-PaddingTop="15px" Paddings-PaddingBottom="18px">
    <Items>
        <dx:MenuItem Text="Normal">
        </dx:MenuItem>
        <dx:MenuItem Text="Important" ItemStyle-ForeColor="#ec471b"></dx:MenuItem>
        <dx:MenuItem Text="Urgent" ItemStyle-ForeColor="#a820e1">
        </dx:MenuItem>
        <dx:MenuItem Text="Later" ItemStyle-ForeColor="#7bb71b"></dx:MenuItem>
    </Items>
    <ItemStyle Height="30px" Paddings-PaddingLeft="20px"></ItemStyle>
    <ClientSideEvents ItemClick="function(s,e){ if(OnColorMark){OnColorMark(s,e);} }" />
</dx:ASPxPopupMenu>

<dx:ASPxPopupControl ClientInstanceName="popupCtrUploadFiles" Width="950px" Height="840px" ID="ASPxPopupControl2"
    HeaderText="Upload Files" AutoUpdatePosition="true" Modal="true" CloseAction="CloseButton"
    runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
    <HeaderTemplate>
        <div class="clearfix">
            <div class="pop_up_header_margin">
                <i class="fa fa-cloud-upload with_circle pop_up_header_icon"></i>
                <span class="pop_up_header_text">Upload Files</span>
            </div>
            <div class="pop_up_buttons_div">
                <i class="fa fa-times icon_btn" onclick="popupCtrUploadFiles.Hide()"></i>
            </div>
        </div>
    </HeaderTemplate>
    <ContentCollection>
        <dx:PopupControlContentControl runat="server">
        </dx:PopupControlContentControl>
    </ContentCollection>
    <ClientSideEvents CloseUp="function(s,e){}" />
</dx:ASPxPopupControl>

<dx:ASPxPopupControl ClientInstanceName="popupViewFiles" Width="950px" Height="840px" ID="popupWinViewFiles"
    HeaderText="View Files" AutoUpdatePosition="true" Modal="true" CloseAction="CloseButton" OnWindowCallback="ASPxPopupControl6_WindowCallback"
    runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
    <HeaderTemplate>
        <div class="clearfix">
            <div class="pop_up_header_margin">
                <i class="fa fa-cloud-upload with_circle pop_up_header_icon"></i>
                <span class="pop_up_header_text">View Files</span>
            </div>
            <div class="pop_up_buttons_div">
                <i class="fa fa-times icon_btn" onclick="popupViewFiles.Hide()"></i>
            </div>
        </div>
    </HeaderTemplate>
    <ContentCollection>
        <dx:PopupControlContentControl runat="server" ID="popupViewFiles">
        </dx:PopupControlContentControl>
    </ContentCollection>
    <ClientSideEvents CloseUp="function(s,e){}" />
</dx:ASPxPopupControl>

<dx:ASPxPopupControl ClientInstanceName="popupCtrReassignEmployeeListCtr" Width="300px" Height="300px"
    MaxWidth="800px" MaxHeight="800px" MinHeight="150px" MinWidth="150px" ID="ASPxPopupControl3"
    HeaderText="Select Employee" AutoUpdatePosition="true" Modal="true" OnWindowCallback="ASPxPopupControl3_WindowCallback"
    runat="server" EnableViewState="false" EnableHierarchyRecreation="True">
    <ContentCollection>
        <dx:PopupControlContentControl runat="server" Visible="false" ID="PopupContentReAssign">
            <dx:ASPxListBox runat="server" ID="listboxEmployee" ClientInstanceName="listboxEmployeeClient" Height="270" TextField="Name" ValueField="EmployeeID"
                SelectedIndex="0" Width="100%">
            </dx:ASPxListBox>
            <table style="margin-top:3px;">
                <tr>
                    <td style="width: 100px">
                        <dx:ASPxCheckBox runat="server" Text="Archive Logs" ID="cbArchived"></dx:ASPxCheckBox>
                    </td>
                    <td>
                        <dx:ASPxButton Text="Assign" runat="server" ID="btnAssign" AutoPostBack="false">
                            <ClientSideEvents Click="function(s,e){
                                        var item = listboxEmployeeClient.GetSelectedItem();
                                        if(item == null)
                                        {
                                             alert('Please select employee.');
                                             return;
                                         }
                                        reassignCallback.PerformCallback(tmpBBLE + '|' + item.value + '|' + item.text);
                                        popupCtrReassignEmployeeListCtr.Hide();                                       
                                        }" />
                        </dx:ASPxButton>
                    </td>
                </tr>
            </table>
        </dx:PopupControlContentControl>
    </ContentCollection>
</dx:ASPxPopupControl>

<dx:ASPxCallback runat="server" ClientInstanceName="reassignCallback" ID="reassignCallback" OnCallback="reassignCallback_Callback">
    <ClientSideEvents EndCallback="function(s,e){ if(typeof gridLeads != undefined){gridLeads.Refresh();}}" />
</dx:ASPxCallback>

<dx:ASPxPopupControl ClientInstanceName="ASPxPopupMapControl" Width="900px" Height="700px"
    ID="ASPxPopupControl1" AllowDragging="true"
    HeaderText="Street View" AutoUpdatePosition="true" Modal="true" ContentUrlIFrameTitle="streetViewFrm"
    runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
    <HeaderTemplate>
        <div class="clearfix">
            <div style="float: right; position: relative; margin-right: 10px; margin-bottom: -27px; color: #2e2f31">
                <i class="fa fa-expand icon_btn" style="margin-right: 10px" onclick="AdjustPopupSize(ASPxPopupMapControl)"></i>
                <i class="fa fa-times icon_btn" onclick="ASPxPopupMapControl.Hide()"></i>
            </div>
            <!-- Nav tabs -->
            <ul class="nav nav-tabs" style="border: 0px" role="tablist">
                <li><a href="#street_image" class="popup_tab_text" role="tab" data-toggle="tab" onclick="popupControlMapTabClick(5)" style="display: none">Street View Image</a></li>

                <li class="active"><a href="#streetView" class="popup_tab_text" role="tab" data-toggle="tab" onclick="popupControlMapTabClick(0)">Street View</a></li>
                <li><a href="#mapView" role="tab" class="popup_tab_text" data-toggle="tab" onclick="popupControlMapTabClick(1)">Map View</a></li>
                <li><a href="#BingBird" role="tab" class="popup_tab_text" data-toggle="tab" onclick="popupControlMapTabClick(2)">Bing Bird</a></li>
                <li><a href="#Oasis" role="tab" class="popup_tab_text" data-toggle="tab" onclick="popupControlMapTabClick(3)">Oasis</a></li>
                <li><a href="#ZOLA" role="tab" class="popup_tab_text" data-toggle="tab" onclick="popupControlMapTabClick(4)">ZOLA</a></li>
            </ul>
            <!-- Tab panes -->
            <div class="tab-content" style="display: none">
                <div class="tab-pane" id="street_image">
                </div>
                <div class="tab-pane active" id="streetView">streetView</div>
                <div class="tab-pane" id="mapView">mapView</div>
                <div class="tab-pane" id="BingBird">BingBird</div>
                <div class="tab-pane" id="Oasis">Oasis</div>
                <div class="tab-pane" id="ZOLA">ZOLA</div>

            </div>
            <div style="width: 100%; text-align: center; display: none" id="leads_address_popup"></div>
        </div>
    </HeaderTemplate>
    <ContentCollection>
        <dx:PopupControlContentControl runat="server">
        </dx:PopupControlContentControl>
    </ContentCollection>
</dx:ASPxPopupControl>
<script type="text/javascript">
    function InProcessSelectChange(s, e) {
        if (s.GetSelectedValues().indexOf('1') != -1) {
            document.getElementById('divEvictionUsers').style.display = 'block';
            s.SelectValues(['0']);
        } else {
            document.getElementById('divEvictionUsers').style.display = 'none';
        }

        if (s.GetSelectedValues().indexOf('5') != -1) {
            document.getElementById('divThirdParty').style.display = 'block';
        } else {
            document.getElementById('divThirdParty').style.display = 'none';
        }
        var selected = s.GetSelectedValues();

        if (selected.indexOf("0") != -1) {
            s.SelectValues(['3']);
        }

    }
</script>
<dx:ASPxPopupControl ClientInstanceName="aspxPopupInprocessClient" Width="356px" Height="350px" ID="ASPxPopupControl4"
    Modal="true" ShowFooter="true" OnWindowCallback="ASPxPopupControl4_WindowCallback" runat="server" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
    <HeaderTemplate>
        <div class="clearfix">
            <div class="pop_up_header_margin">
                <i class="fa fa-refresh with_circle pop_up_header_icon"></i>
                <span class="pop_up_header_text">In Process</span>
            </div>
            <div class="pop_up_buttons_div">
                <i class="fa fa-times icon_btn" onclick="aspxPopupInprocessClient.Hide()"></i>
            </div>
        </div>
    </HeaderTemplate>
    <ContentCollection>
        <dx:PopupControlContentControl runat="server" ID="popupContentInProcess" Visible="false">
            <asp:HiddenField runat="server" ID="hfInProcessBBLE" />
            <dx:ASPxCheckBoxList ID="lbSelectionMode" runat="server" ClientInstanceName="lbSelectionModeClient" AutoPostBack="false" Border-BorderStyle="None">
                <Items>
                    <dx:ListEditItem Text="In House SS" Value="0" />
                    <dx:ListEditItem Text="Eviction" Value="1" />
                    <dx:ListEditItem Text="Legal" Value="3" />
                    <dx:ListEditItem Text="Construction" Value="2" />
                    <%--<dx:ListEditItem Text="Open Market Sale" Value="4" />--%>
                    <dx:ListEditItem Text="Straight Sale" Value="6" />
                    <dx:ListEditItem Text="3rd Party" Value="5" />
                </Items>
                <ClientSideEvents SelectedIndexChanged="InProcessSelectChange" />
            </dx:ASPxCheckBoxList>
            <div id="divEvictionUsers" style="display: none; width: 300px;">
                Eviction User: 
                <dx:ASPxComboBox ID="cbEvictionUsers" runat="server" AutoPostBack="false" Width="100%" CssClass="edit_drop">
                </dx:ASPxComboBox>
            </div>
            <div id="divThirdParty" style="display: none; width: 300px">
                Select Third Parties:
                <dx:ASPxComboBox ID="cbThirdParty" runat="server" AutoPostBack="false" Width="100%" CssClass="edit_drop">
                </dx:ASPxComboBox>
            </div>
        </dx:PopupControlContentControl>
    </ContentCollection>
    <FooterContentTemplate>
        <div style="height: 30px; vertical-align: central">
            <script>
                function ConfirmClick() {
                    popupShow = false;
                    var selected = lbSelectionModeClient.GetSelectedValues();
                    var index3 = selected.indexOf("3");
                    if (index3 >= 0) {
                        aspxPopupInprocessClient.Hide();
                        // aspxPopupLegalInfoClient.Show();                        
                        // ASPLegalPopupClient.SetContentUrl('/LegalUI/LegalUI.aspx?InPopUp=true&bble=' + bble);
                        // $("#LegalPopUp").modal();
                        // ASPLegalPopupClient.Show();
                        var bble = $('#<%= hfInProcessBBLE.ClientID%>').val();
                        window.open('/LegalUI/LegalPreQuestions.aspx?bble=' + bble, 'LegalPreQuestion', "width=1024, height=800");
                        aspxPopupInprocessClient.PerformCallback('Save');
                    } else {

                        aspxPopupInprocessClient.PerformCallback('Save');
                    }
                }
            </script>
            <span class="time_buttons" onclick="aspxPopupInprocessClient.Hide()">Cancel</span>
            <span class="time_buttons" onclick="ConfirmClick();">Confirm</span>
        </div>
    </FooterContentTemplate>
    <ClientSideEvents EndCallback="function(s,e){
        if(popupShow)
            s.Show();
        else{
            s.Hide();
            OnSetStatusComplete(s,e);
        }
        }" />
</dx:ASPxPopupControl>

<dx:ASPxPopupControl ClientInstanceName="ASPLegalPopupClient" ID="ASPLegalPopup" Width="670" Height="550"
    Modal="true" ShowFooter="true" runat="server" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True" ContentUrl="about:blank">
    <HeaderTemplate>
        <div class="clearfix">
            <div class="pop_up_header_margin">
                <i class="fa fa-university with_circle pop_up_header_icon"></i>
                <span class="pop_up_header_text">Legal</span>
            </div>
            <div class="pop_up_buttons_div">
                <i class="fa fa-times icon_btn" onclick="ASPLegalPopupClient.Hide()"></i>
            </div>
        </div>
    </HeaderTemplate>
    <FooterContentTemplate>
        <div style="height: 30px; vertical-align: central">
            <script>
                function LegalConfirmClick() {
                    var lCase = ASPLegalPopupClient.GetContentIFrame().contentWindow.GetLegalData();
                    //$.getJSON("getGeoCaseURL", function (data) { lCase.pe })
                    aspxPopupInprocessClient.PerformCallback('StartlegalProcess|' + JSON.stringify(lCase));
                    ASPLegalPopupClient.Hide();
                    //alert(" get leagl case " + lCase);
                }
            </script>
            <span class="time_buttons" onclick="ASPLegalPopupClient.Hide()">Cancel</span>
            <span class="time_buttons" onclick="LegalConfirmClick();">Confirm</span>
        </div>
    </FooterContentTemplate>
</dx:ASPxPopupControl>


<dx:ASPxPopupControl ClientInstanceName="aspxPopupDeadLeadsClient" Width="356px" Height="350px" ID="ASPxPopupControl5" Modal="true" ShowFooter="true" OnWindowCallback="ASPxPopupControl5_WindowCallback"
    runat="server" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
    <HeaderTemplate>
        <div class="clearfix">
            <div class="pop_up_header_margin">
                <i class="fa fa-times-circle with_circle pop_up_header_icon"></i>
                <span class="pop_up_header_text">Dead Leads</span>
            </div>
            <div class="pop_up_buttons_div">
                <i class="fa fa-times icon_btn" onclick="aspxPopupDeadLeadsClient.Hide()"></i>
            </div>
        </div>
    </HeaderTemplate>
    <ContentCollection>
        <dx:PopupControlContentControl runat="server" ID="popupContentDeadLeads" Visible="false">
            <asp:HiddenField runat="server" ID="hfBBLE" />
            <div style="color: #b1b2b7;">
                <div class="form-group ">
                    <label class="upcase_text">Select Reason</label>
                    <dx:ASPxComboBox ID="cbDeadReasons" runat="server" AutoPostBack="false" Width="100%" CssClass="edit_drop">
                        <Items>
                            <dx:ListEditItem Text="Full Sale Completed" Value="8" />
                            <dx:ListEditItem Text="Dead Recorded with Other Party" Value="1" />
                            <dx:ListEditItem Text="Working towards a Loan MOD" Value="2" />
                            <dx:ListEditItem Text="Working towards a short sale with another company" Value="3" />
                            <dx:ListEditItem Text="MOD Completed" Value="4" />
                            <dx:ListEditItem Text="Not Interested" Value="5" />
                            <dx:ListEditItem Text="Unable to contact" Value="6" />
                            <dx:ListEditItem Text="Manager disapproved" Value="7" />
                        </Items>
                        <ClientSideEvents SelectedIndexChanged="function(s,e){}" />
                    </dx:ASPxComboBox>
                </div>
                <div class="form-group ">
                    <label class="upcase_text" style="display: block">Description</label>
                    <dx:ASPxMemo runat="server" Width="100%" Height="115px" ID="txtDeadLeadDescription" CssClass="edit_text_area"></dx:ASPxMemo>
                </div>
            </div>
        </dx:PopupControlContentControl>
    </ContentCollection>
    <FooterContentTemplate>
        <div style="height: 30px; vertical-align: central">
            <span class="time_buttons" onclick="aspxPopupDeadLeadsClient.Hide()">Cancel</span>
            <span class="time_buttons" onclick="popupShow=false;aspxPopupDeadLeadsClient.PerformCallback('Save');">Confirm</span>
            <span class="time_buttons" onclick="popupShow=false;aspxPopupDeadLeadsClient.PerformCallback('DumpDeadLeads');">Dump Dead Leads</span>
        </div>
    </FooterContentTemplate>
    <ClientSideEvents EndCallback="function(s,e){
        if(popupShow)
            s.Show();
        else{
            s.Hide();
            OnSetStatusComplete(s,e);
        }
        }" />
</dx:ASPxPopupControl>

<dx:ASPxPopupControl ClientInstanceName="aspxPopupChangeLeadsStatusClient" Width="356px" Height="350px" ID="aspxPopupChangeLeadsStatus" Modal="true" ShowFooter="true" 
    runat="server" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
    <HeaderTemplate>
        <div class="clearfix">
            <div class="pop_up_header_margin">
                <i class="fa fa-exchange with_circle pop_up_header_icon"></i>
                <span class="pop_up_header_text">Change Status</span>
            </div>
            <div class="pop_up_buttons_div">
                <i class="fa fa-times icon_btn" onclick="aspxPopupChangeLeadsStatusClient.Hide()"></i>
            </div>
        </div>
    </HeaderTemplate>
    <ContentCollection>
        <dx:PopupControlContentControl runat="server" ID="PopupControlContentControl1" >
           
            <div style="color: #b1b2b7;">
                
                <div class="form-group ">
                    <label class="upcase_text" style="display: block">Reason</label>
                    <dx:ASPxMemo runat="server" Width="100%" Height="115px" ID="ChangeStatusResonText" ClientInstanceName="ChangeStatusResonTextClient" CssClass="edit_text_area"></dx:ASPxMemo>
                </div>
               
            </div>
        </dx:PopupControlContentControl>
    </ContentCollection>
    <FooterContentTemplate>
        <div style="height: 30px; vertical-align: central">
            <span class="time_buttons" onclick="aspxPopupChangeLeadsStatusClient.Hide()">Cancel</span>
            <span class="time_buttons" onclick="CofrimLeadStatusChange();">Confirm</span>
          
        </div>
    </FooterContentTemplate>
    
</dx:ASPxPopupControl>

<dx:ASPxPopupControl ClientInstanceName="AspxPopupShareleadClient" Width="356px" Height="450px" ID="aspxPopupShareleads"
    HeaderText="Share Lead" Modal="true" ContentUrl="~/PopupControl/ShareLeads.aspx"
    runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
    <HeaderTemplate>
        <div class="clearfix">
            <div class="pop_up_header_margin">
                <i class="fa fa-share-alt with_circle pop_up_header_icon"></i>
                <span class="pop_up_header_text">Share Lead</span>
            </div>
            <div class="pop_up_buttons_div">
                <i class="fa fa-times icon_btn" onclick="AspxPopupShareleadClient.Hide()"></i>
            </div>
        </div>
    </HeaderTemplate>
</dx:ASPxPopupControl>

<dx:ASPxPopupControl ClientInstanceName="ASPxPopupRequestUpdateControl" Width="500px" Height="420px"
    MaxWidth="800px" MinWidth="150px" ID="popupRequestUpdate"
    HeaderText="Request Update" Modal="true" OnWindowCallback="popupRequestUpdate_WindowCallback"
    runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
    <ContentCollection>
        <dx:PopupControlContentControl runat="server" Visible="false" ID="popContentRequestUpdate">
            <asp:HiddenField runat="server" ID="hfRequestUpdateBBLE" />
            <dx:ASPxFormLayout ID="requestUpdateFormlayout" runat="server" Width="100%">
                <Items>
                    <dx:LayoutItem Caption="Leads Name">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxTextBox runat="server" Width="100%" CssClass="edit_drop" ID="txtRequestUpdateLeadsName" ReadOnly="true"></dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Create By">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxTextBox runat="server" Width="100%" CssClass="edit_drop" ID="txtRequestUpdateCreateby" ReadOnly="true"></dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Manager">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxTextBox runat="server" Width="100%" CssClass="edit_drop" ID="txtRequestUpdateManager" ReadOnly="true"></dx:ASPxTextBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Importance">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server" Width="100%" SupportsDisabledAttribute="True">
                                <dx:ASPxComboBox runat="server" Width="100%" CssClass="edit_drop" ID="cbTaskImportant">
                                    <Items>
                                        <dx:ListEditItem Text="Normal" Value="Normal" Selected="true" />
                                        <dx:ListEditItem Text="Important" Value="Important" />
                                        <dx:ListEditItem Text="Urgent" Value="Urgent" />
                                    </Items>
                                </dx:ASPxComboBox>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Description">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxMemo runat="server" Width="100%" CssClass="edit_drop" Height="80px" ID="txtTaskDes" ClientInstanceName="txtRequestUpdateDescription" ValidationSettings-RequiredField-IsRequired="true"></dx:ASPxMemo>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                    <dx:LayoutItem Caption="Description" ShowCaption="False" HorizontalAlign="Right">
                        <LayoutItemNestedControlCollection>
                            <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                <dx:ASPxButton ID="ASPxButton4" runat="server" Text="Send Request" AutoPostBack="false">
                                    <ClientSideEvents Click="function(){      if(txtRequestUpdateDescription.GetIsValid()) {                                                                                                               
                                                                                                                        ASPxPopupRequestUpdateControl.Hide();
                                                                                                                        ASPxPopupRequestUpdateControl.PerformCallback('SendRequest');
                                                                                                                        isSendRequest =true;  } 
                                                                                                                        }"></ClientSideEvents>
                                </dx:ASPxButton>
                                &nbsp;
                                                            <dx:ASPxButton runat="server" Text="Cancel" AutoPostBack="false">
                                                                <ClientSideEvents Click="function(){
                                                                                                                        ASPxPopupRequestUpdateControl.Hide();                                                                                                                                                                                                                                               
                                                                                                                        }"></ClientSideEvents>

                                                            </dx:ASPxButton>
                            </dx:LayoutItemNestedControlContainer>
                        </LayoutItemNestedControlCollection>
                    </dx:LayoutItem>
                </Items>
            </dx:ASPxFormLayout>
        </dx:PopupControlContentControl>
    </ContentCollection>
    <ClientSideEvents EndCallback="OnEndCallbackPanelRequestUpdate" />
</dx:ASPxPopupControl>

<%--<dx:ASPxPopupMenu ID="ASPxPopupMenu2" runat="server" ClientInstanceName="popupMenuLeads"
    AutoPostBack="false" PopupHorizontalAlign="Center" PopupVerticalAlign="Below" PopupAction="LeftMouseClick" ForeColor="#3993c1" Font-Size="14px" CssClass="fix_pop_postion_s" Paddings-PaddingTop="15px" Paddings-PaddingBottom="18px">
    <ItemStyle Paddings-PaddingLeft="20px" />
    <Items>
        <dx:MenuItem Text="Leads" Name="Leads"></dx:MenuItem>
        <dx:MenuItem Text="Short Sale" Name="ShortSale"></dx:MenuItem>
        <dx:MenuItem Text="Eviction" Name="Eviction"></dx:MenuItem>
        <dx:MenuItem Text="Legal" Name="Legal"></dx:MenuItem>
    </Items>
    <ClientSideEvents ItemClick="OnPopupMenuLeadsClick" />
</dx:ASPxPopupMenu>--%>

<dx:ASPxCallback ID="leadStatusCallback" runat="server" ClientInstanceName="leadStatusCallbackClient" OnCallback="leadStatusCallback_Callback">
    <ClientSideEvents CallbackComplete="function(s,e) {OnSetStatusComplete(s,e)}" />
</dx:ASPxCallback>
<dx:ASPxCallback runat="server" ClientInstanceName="getAddressCallback" ID="getAddressCallback" OnCallback="getAddressCallback_Callback">
    <ClientSideEvents CallbackComplete="function(s,e){OnGetAddressCallbackComplete(s,e);}" CallbackError="function(s,e){OnGetAddressCallbackError(s,e)}" />
</dx:ASPxCallback>
