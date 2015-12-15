<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionUICtrl.ascx.vb" Inherits="IntranetPortal.ConstructionUICtrl" %>
<%@ Register Src="~/Construction/ConstructionTab.ascx" TagPrefix="uc1" TagName="ConstructionTab" %>
<%@ Register Src="~/PopupControl/SendMail.ascx" TagPrefix="uc1" TagName="SendMail" %>
<%@ Register Src="~/UserControl/DocumentsUI.ascx" TagPrefix="uc1" TagName="DocumentsUI" %>
<div id="ConstructionCtrl" ng-controller="ConstructionCtrl" style="height: 100%">
    <!-- Nav tabs -->
    <input id="LastUpdateTime" type="hidden" />
    <div class="legal-menu" style="position: relative; top: 0; margin: 0; z-index: 1; width: 100%">
        <ul class="nav nav-tabs" role="tablist" style="background: #ff400d; font-size: 18px; color: white">
            <li class="active short_sale_head_tab">
                <a href="#ConstructionTab" role="tab" data-toggle="tab" class="tab_button_a">
                    <i class="fa fa-info-circle  head_tab_icon_padding"></i>
                    <div class="font_size_bold">Construction</div>
                </a>
            </li>
            <li class="short_sale_head_tab">
                <a href="#DocumentTab" role="tab" data-toggle="tab" class="tab_button_a" onclick="BindDocuments(false)">
                    <i class="fa fa-file head_tab_icon_padding"></i>
                    <div class="font_size_bold">Documents</div>
                </a>
            </li>
            <li class="short_sale_head_tab">
                <a class="tab_button_a">
                    <i class="fa fa-list-ul head_tab_icon_padding"></i>
                    <div class="font_size_bold">&nbsp;&nbsp;&nbsp;&nbsp;More&nbsp;&nbsp;&nbsp;&nbsp;</div>
                </a>
                <div class="shot_sale_sub">
                    <ul class="nav clearfix" role="tablist">
                        <li class="short_sale_head_tab">
                            <a role="tab" class="tab_button_a" data-toggle="tab" href="#more_leads" data-url="/ViewLeadsInfo.aspx?HiddenTab=true&id=BBLE" data-href="#more_leads" onclick="LoadMoreFrame(this)">
                                <i class="fa fa-folder head_tab_icon_padding"></i>
                                <div class="font_size_bold">Leads</div>

                            </a>
                        </li>
                        <li class="short_sale_head_tab" ng-show="LegalCase.InShortSale">
                            <a role="tab" class="tab_button_a" data-toggle="tab" href="#more_short_sale" data-url="/ShortSale/ShortSale.aspx?HiddenTab=true&bble=BBLE" data-href="#more_short_sale" onclick="LoadMoreFrame(this)">
                                <i class="fa fa-sign-out head_tab_icon_padding"></i>
                                <div class="font_size_bold">Short Sale</div>
                            </a>
                        </li>
                        <li class="short_sale_head_tab" ng-show="LegalCase.InShortSale">
                            <a role="tab" class="tab_button_a" data-toggle="tab" href="#more_evction" data-url="/ShortSale/ShortSale.aspx?HiddenTab=true&isEviction=true&bble=BBLE" data-href="#more_evction" onclick="LoadMoreFrame(this)">
                                <i class="fa fa-sign-out head_tab_icon_padding"></i>
                                <div class="font_size_bold">Eviction</div>
                            </a>
                        </li>
                    </ul>
                </div>
            </li>
            <li class="pull-right" style="margin-right: 30px; color: #ffa484">
                <i class="fa fa-save sale_head_button sale_head_button_left tooltip-examples" title="" ng-click="saveCSCase()" data-original-title="Save"></i>
                <i class="fa fa-check sale_head_button sale_head_button_left tooltip-examples" title="Intake Complete" ng-click="intakeComplete()" data-original-title="Intake Completed"></i>
                <i class="fa fa-mail-reply sale_head_button sale_head_button_left tooltip-examples" title="" onclick="popupSelectOwner.PerformCallback('Show');popupSelectOwner.ShowAtElement(this);" data-original-title="Reassign"></i>
                <i class="fa fa-envelope sale_head_button sale_head_button_left tooltip-examples" title="" onclick="ShowEmailPopup(leadsInfoBBLE)" data-original-title="Mail"></i>
                <i class="fa fa-print sale_head_button sale_head_button_left tooltip-examples" title="" ng-click="printWindow()" data-original-title="Print"></i>
            </li>
        </ul>
    </div>

    <dx:ASPxPopupControl ClientInstanceName="popupSelectOwner" Width="300px" Height="300px"
        MaxWidth="800px" MaxHeight="800px" MinHeight="150px" MinWidth="150px" ID="ASPxPopupControl3"
        HeaderText="Select Employee" AutoUpdatePosition="true" Modal="true" OnWindowCallback="ASPxPopupControl3_WindowCallback"
        runat="server" EnableViewState="false" EnableHierarchyRecreation="True">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server" Visible="false" ID="PopupContentReAssign">
                <asp:HiddenField runat="server" ID="hfUserType" />
                <dx:ASPxListBox runat="server" ID="listboxEmployee" ClientInstanceName="listboxEmployeeClient" Height="270" SelectedIndex="0" Width="100%">
                </dx:ASPxListBox>
                <dx:ASPxButton Text="Assign" runat="server" ID="btnAssign" AutoPostBack="false">
                    <ClientSideEvents Click="function(s,e){
                                                            var item = listboxEmployeeClient.GetSelectedItem();
                                                            if(item == null)
                                                            {
                                                                 AngularRoot.alert('Please select user.');
                                                                 return;
                                                             }
                                                            popupSelectOwner.PerformCallback('Save|' + leadsInfoBBLE + '|' + item.text);
                                                            popupSelectOwner.Hide();
                                                            }"></ClientSideEvents>
                </dx:ASPxButton>
            </dx:PopupControlContentControl>
        </ContentCollection>
        <ClientSideEvents Closing="function(s,e){
                                              if (typeof gridTrackingClient != 'undefined')
                                                    gridTrackingClient.Refresh();
                                              if (typeof gridCase != 'undefined')
                                                    gridCase.Refresh();    
                                        }" />
    </dx:ASPxPopupControl>
    <div class="wrapper-content" style="height: 95%; overflow-y: scroll">
        <div class="tab-content" style="margin-bottom: 100px">
            <div class="tab-pane active" id="ConstructionTab">
                <uc1:ConstructionTab runat="server" ID="ConstructionTab1" />
            </div>
            <div class="tab-pane" id="DocumentTab">
                <uc1:DocumentsUI runat="server" ID="DocumentsUI" />
            </div>

            <div class="tab-pane load_bg" id="more_leads">
                <iframe width="100%" height="100%" class="more_frame" frameborder="0"></iframe>
            </div>
            <div class="tab-pane load_bg" id="more_evction">
                <iframe width="100%" height="100%" class="more_frame" frameborder="0"></iframe>
            </div>
            <div class="tab-pane load_bg" id="more_short_sale">
                <iframe width="100%" height="100%" class="more_frame" frameborder="0"></iframe>
            </div>
        </div>
    </div>
</div>

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
<uc1:SendMail runat="server" ID="SendMail" />


<script type="text/javascript">
    var Current_User = '<%= HttpContext.Current.User.Identity.Name%>';
    function LoadCaseData(bble) {
        $(document).ready(function () {
            //put construction data loading logic here
            var scope = angular.element('#ConstructionCtrl').scope();
            scope.init(bble, function () {
                scope.updatePercentage();
                ScopeSetLastUpdateTime(scope.GetTimeUrl());
            });
        });
    }

    $(function () {
        var scope = angular.element('#ConstructionCtrl').scope();
        ScopeDateChangedByOther(scope.GetTimeUrl, LoadCaseData, scope.GetCSCaseId, scope.GetModifyUserUrl);
    })
</script>
