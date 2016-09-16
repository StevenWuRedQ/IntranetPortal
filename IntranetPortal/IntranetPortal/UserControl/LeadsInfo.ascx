<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LeadsInfo.ascx.vb" Inherits="IntranetPortal.LeadsInfo1" %>
<%@ Register Src="~/UserControl/ActivityLogs.ascx" TagPrefix="uc1" TagName="ActivityLogs" %>
<%@ Register Src="~/UserControl/HomeOwnerInfo.ascx" TagPrefix="uc1" TagName="HomeOwnerInfo" %>
<%@ Register Src="~/UserControl/DocumentsUI.ascx" TagPrefix="uc1" TagName="DocumentsUI" %>
<%@ Register Src="~/UserControl/PropertyInfo.ascx" TagPrefix="uc1" TagName="PropertyInfo" %>
<%@ Register Src="~/PopupControl/SendMail.ascx" TagPrefix="uc1" TagName="SendMail" %>
<%@ Register Src="~/PopupControl/EditHomeOwner.ascx" TagPrefix="uc1" TagName="EditHomeOwner" %>
<%@ Register Src="~/UserControl/TitleInLeadsControl.ascx" TagPrefix="uc1" TagName="TitleControl" %>
<%@ Register Src="~/OneDrive/LeadsDocumentOneDrive.ascx" TagPrefix="uc1" TagName="LeadsDocumentOneDrive" %>
<script src="/Scripts/stevenjs.js"></script>
<script type="text/javascript">
    init_tooltip_and_scroll();
    // <![CDATA[
    function OnClick(s, e) {
        ASPxPopupMenuPhone.ShowAtElement(s.GetMainElement());
    }

    var tmpPhoneNo = null;
    var temTelLink = null;
    var tmpEmail = null;
    var temCommentSpan = null;
    var tempEmailLink = null;
    var tmpAddress = null;
    var currOwner = "";
    var isSave = false;

    function onSavePhoneComment() {
        var comment = $("#phone_comment").val();
        var temCommentSpan = $(temTelLink).parent().find(".phone_comment:first")
        if (temCommentSpan != null) {
            //$(".phone_comment").text("-" + comment); 
            if (comment && comment.length > 30)
            {
                comment = comment.substring(0,30) + "..."
            }
            temCommentSpan.text("-" + comment);
        } else
        {
            console.error("Can not find temCommentSpan in onSavePhoneComment");
        }
        OnCallPhoneCallback("SaveComment|" + tmpPhoneNo + "|" + comment);
    }

    function OnTelphoneLinkClick(tellink, phoneNo) {
        tmpPhoneNo = phoneNo;
        temTelLink = tellink;
        ASPxPopupMenuPhone.ShowAtElement(tellink);
    }

    var tmpEmail = null;
    var tempEmailLink = null;
    function OnEmailLinkClick(EmailId, bble, ownerName, emailink) {
        tmpEmail = EmailId;
        tempEmailLink = emailink;
        currOwner = ownerName;
        EmailPopupClient.ShowAtElement(emailink);
    }
    function OnSortPhoneClick(s, e) {
        if (sortPhoneFunc == undefined) {
            console.error("sortPhoneFunc is null please check javascript import stevenjs");
            return;
        }
        if (e.item.index == 0) {

            sortPhoneFunc(compareLastCalledDate);

        }

        if (e.item.index == 1) {
            sortPhoneFunc(compareByCallCount);
        }
    }
    function OnPhoneNumberClick(s, e) {
        if (tmpPhoneNo != null) {
            if (e.item.index == 0) {
                OnCallPhoneCallback("CallPhone|" + tmpPhoneNo);
                OnCallPhone();
                //if (sortPhones != undefined) {
                //    sortPhones();
                //}
            }

            if (e.item.index == 1) {
                //telphoneLine.style.textDecoration = "line-through";
                //telphoneLine.style.color = "red";

                OnCallPhoneCallback("BadPhone|" + tmpPhoneNo);

                SetSameStyle("PhoneLink", "phone-wrong", tmpPhoneNo);
            }

            if (e.item.index == 2) {
                //telphoneLine.style.color = "green";
                //telphoneLine.style.textDecoration = "none";                
                OnCallPhoneCallback("RightPhone|" + tmpPhoneNo);
                SetSameStyle("PhoneLink", "phone-working", tmpPhoneNo);
            }

            if (e.item.index == 3) {
                //telphoneLine.style.color = "green";
                //telphoneLine.style.textDecoration = "none";
                OnCallPhoneCallback("UndoPhone|" + tmpPhoneNo);
                SetSameStyle("PhoneLink", "", tmpPhoneNo);
            }
            if (e.item.index == 4) {
                $("#phone_comment").val("")
                $('#exampleModal').modal();
                //PhoneCommentPopUpClient.Show();

            }
        }
        e.item.SetChecked(false);

        if (sortPhones && e.item.index != 4 && e.item.index != 0) {
            sortPhones();
        }
    }

    function SetSameStyle(className, style, value) {
        var list = document.getElementsByClassName(className)
        // alert('find class ' + className+ 'get item count '+list.length +' value'+value);
        for (var i = 0; i < list.length; i++) {
            var item = list[i];

            if (item.innerText.trim().indexOf(value) == 0) {

                $(item).removeClass("phone-wrong");
                $(item).removeClass("phone-working");
                $(item).addClass(style);
            }
        }
    }

    function OnCallPhoneCallback(e) {
        if (callPhoneCallbackClient.InCallback()) {
            alert("Server is busy! Please wait!")
        } else {
            callPhoneCallbackClient.PerformCallback(e);
        }
    }

    function OnCallPhoneCallbackComplete(s, e) {

        if (e.result == "True") {
            if (typeof gridTrackingClient != "undefined") {
                gridTrackingClient.Refresh();
            }
        }
        else {
            //disable call back, use client script to format same phone num or address
            //ownerInfoCallbackPanel.PerformCallback("");
        }
    }

    function OnCallBackButtonClick(s, e) {
        ASPxPopupMenuClientControl.ShowAtElement(s.GetMainElement());
    }

    function OnCallbackMenuClick(s, e) {

        if (e.item.name == "Custom") {
            ASPxPopupSelectDateControl.PerformCallback("Show");
            ASPxPopupSelectDateControl.ShowAtElement(s.GetMainElement());
            e.processOnServer = false;
            return;
        }

        SetLeadStatus(e.item.name + "|" + leadsInfoBBLE);
        e.processOnServer = false;
    }

    function OnSetStatusComplete(s, e) {
        if (typeof gridLeads == "undefined") {
            //alert("undefined");
        }
        else
            gridLeads.Refresh();

        if (typeof gridTrackingClient != "undefined")
            gridTrackingClient.Refresh();

        if (typeof window.parent.agentTreeCallbackPanel == "undefined")
            return;
        else
            window.parent.agentTreeCallbackPanel.PerformCallback("");
    }

    function PrintLeadInfo() {
        if (leadsInfoBBLE != null) {
            var url = '/ShowReport.aspx?id=' + leadsInfoBBLE;
            window.open(url, 'Show Report', 'Width=800px,Height=800px');
        }
    }

    function ReloadPage(bbleToLoad) {
        if (bbleToLoad == leadsInfoBBLE) {
            if (typeof ContentCallbackPanel != undefined) {
                ContentCallbackPanel.PerformCallback(bbleToLoad);
            }

            return true;
        }

        return false;
    }

    function PrintLogInfo() {
        if (leadsInfoBBLE != null) {
            var url = '/ShowReport.aspx?id=' + leadsInfoBBLE + "&t=log";
            window.open(url, 'Show Report', 'Width=800px,Height=800px');
        }
    }

    function detectivePhoneNumber(panel) {

        var regexObj = /\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})/g;

        var subjectString = panel.GetContentHtml();
        if (regexObj.test(subjectString)) {
            subjectString = subjectString.replace(regexObj, "<a href='#' onclick='return OnTelphoneLinkClick(this)'>($1) $2-$3</a>");
            panel.SetContentHtml(subjectString);
        }
    }

    function detectiveAddress(panel) {

        var regexObj = /\s+([0-9]{1,6}){0,1}(court|ct|street|st|drive|dr|lane|ln|road|rd|blvd)([\s|\,|.|\;]+)?(([a-zA-Z|\s+]{1,30}){1,2})([\s|\,|.]+)?\b(AK|AL|AR|AZ|CA|CO|CT|DC|DE|FL|GA|GU|HI|IA|ID|IL|IN|KS|KY|LA|MA|MD|ME|MI|MN|MO|MS|MT|NC|ND|NE|NH|NJ|NM|NV|NY|OH|OK|OR|PA|RI|SC|SD|TN|TX|UT|VA|VI|VT|WA|WI|WV|WY)([\s|\,|.]+)?(\s+\d{5})?([\s|\,|.]+)/i

        var subjectString = panel.GetContentHtml();
        //alert(subjectString);
        //alert(regexObj.test(subjectString));
        if (regexObj.test(subjectString)) {
            subjectString = subjectString.replace(regexObj, "<a href='#' onclick='return OnTelphoneLinkClick(this)'>$1 $2 $3</a>");
            panel.SetContentHtml(subjectString);
        }
    }

    function OnAddressLinkClick(s, address) {
        tmpAddress = address;
        AspxPopupMenuAddress.ShowAtElement(s);
    }



    function OnCallPhone() {
        if (temTelLink) {
            var parent = $(temTelLink).parent().parent();
            var lastCallSpan = parent.find(".phone-last-called:first");
            var callCountSpan = parent.find(".phone-call-count:first");
            if (callCountSpan) {
                var countText = callCountSpan.text().trim();
                countText = countText.length > 0 ? countText : "(0)";
                var countInt = countText.match(/\d+/);
                if (countInt) {
                    countInt = countInt || 0;
                    var count = parseInt(countInt);
                    count++;
                    countText = countText.replace(countInt, count);
                    callCountSpan.text(countText);
                }


            }

            if (lastCallSpan) {
                var d = new Date();
                lastCallSpan.text(d.toLocaleDateString() + " " + d.getHours() + ':' + d.getSeconds())
            }

        } else {
            console.error("temTelLink is null");
        }
    }

    function OnAddressPopupMenuClick(s, e) {

        if (tmpAddress != null) {
            if (e.item.index == 0) {
                OnCallPhoneCallback("DoorKnock|" + tmpAddress);

                SetLeadStatus(4);
            }

            if (e.item.index == 1) {
                OnCallPhoneCallback("BadAddress|" + tmpAddress);
                SetSameStyle("AddressLink", "phone-wrong", tmpAddress);
            }

            if (e.item.index == 2) {
                OnCallPhoneCallback("RightAddress|" + tmpAddress);
                SetSameStyle("AddressLink", "phone-working", tmpAddress);
            }

            if (e.item.index == 3) {
                OnCallPhoneCallback("UndoAddress|" + tmpAddress);
                SetSameStyle("AddressLink", "", tmpAddress);
            }

            e.item.SetChecked(false);
        }
    }

    function OnRefreshPage() {
        if (typeof ContentCallbackPanel != "undefined") {
            var parms = "Refresh|" + leadsInfoBBLE;
            ContentCallbackPanel.PerformCallback(parms);
        }
        else {
            __doPostBack('', '');
        }
    }

    function OnRefreshMenuClick(s, e) {
        if (typeof ContentCallbackPanel != "undefined") {
            var parms = "Refresh|" + leadsInfoBBLE + "|" + e.item.name;

            //if (e.item.name == "TLO")
            //{
            //    ownerInfoCallbackPanel.PerformCallback(parms)
            //}
            //else
            //{
            ContentCallbackPanel.PerformCallback(parms);
            //}            
        }
        else {
            __doPostBack(s.name, '');
        }
    }


    function AddBestPhoneNum(bble, ownerName, ulClient, addButton) {
        //var ul = document.getElementById(ulClient);
        //var li = document.createElement("li");
        //li.innerHTML = "<input type='text' id='' /><input type='button' value='Update'><input type='button' value='Delete'>";

        //if (ul.hasChildNodes())
        //    ul.insertBefore(li, ul.childNodes[0]);
        currOwner = ownerName;
        aspxPopupAddPhoneNum.ShowAtElement(addButton);
    }

    function OnEmailPopupClick(s, e) {
        ownerInfoCallbackPanel.PerformCallback("DeleteEmail|" + tmpEmail + "|" + currOwner);
    }

    function AddBestEmail(bble, ownerName, ulClient, addButton) {
        currOwner = ownerName;
        aspxPopupAddEmail.ShowAtElement(addButton);
    }

    function AddBestAddress(bble, ownerName, addButton) {
        isSave = false;
        currOwner = ownerName;
        aspxPopupAddAddress.PerformCallback(addButton);
    }

    function SaveBestPhoneNo(s, e) {
        var phoneNo = txtPhoneNoClient.GetText();
        ownerInfoCallbackPanel.PerformCallback(phoneNo + "|" + currOwner);
        aspxPopupAddPhoneNum.Hide();
        txtPhoneNoClient.SetText("");
    }

    function SaveBestEmail(s, e) {
        var email = txtEmailClient.GetText();
        ownerInfoCallbackPanel.PerformCallback("SaveEmail|" + email + "|" + currOwner);
        aspxPopupAddEmail.Hide();
        txtEmailClient.SetText("");
    }

    function ShowLogPanel() {
        var paneInfo = contentSplitter.GetPaneByName("paneInfo");
        var paneLog = contentSplitter.GetPaneByName("LogPanel");

        if (paneInfo.IsCollapsed()) {
            paneInfo.Expand();
            paneLog.Collapse(paneInfo);
        }
        else {
            paneLog.Expand();
            paneInfo.Collapse(paneLog);

            if (typeof EmailBody != undefined) {
                EmailBody.SetHeight(148);
            }
        }

        contentSplitter.AdjustControl();
    }
    function addHomeOwnerClick(e) {
        var btn = $(e).parent().find('.fa fa-edit tooltip-examples:first')

        btn.onclick();
    }

    function OnLeadsInfoEndCallBack(s, e) {
        if (leadsInfoBBLE) reloadHomeBreakCtrl(leadsInfoBBLE);
        if (sortPhones) {
            sortPhones();
        }

        // reload callback on get lead status in propertyinfo
        if (LoanModStatusCtrl) {
            LoanModStatusCtrl.reload();
        }
    }

    function reloadHomeBreakCtrl(bble) {
        var homeBreakDownCtrl = document.getElementById('homeBreakDownCtrl');
        // in hot leads, there is not homeBreakDownCtrl
        if (homeBreakDownCtrl) {
            var target = angular.element(homeBreakDownCtrl);
            var $injector = target.injector();
            $injector.invoke(function ($compile, ptCom, ptHomeBreakDownService) {
                var parentScope = target.scope();
                var $scope = parentScope.$new(true);
                /* think as setup controller */
                $scope.PropFloors = [];
                $scope.BBLE = bble;
                $scope.init = function (bble) {
                    ptHomeBreakDownService.loadByBBLE(bble, function (res) {
                        $scope.PropFloors = res ? res : [];
                    });
                }
                $scope.ensurePush = function (modelName, data) { ptCom.ensurePush($scope, modelName, data); }
                $scope.arrayRemove = ptCom.arrayRemove;

                $scope.setPopupVisible = function (model, bVal) {
                    model.popupVisible = bVal;
                }

                $scope.addNewUnit = function () {
                    $scope.ensurePush('PropFloors');
                    $scope.setPopupVisible($scope.PropFloors[$scope.PropFloors.length - 1], true);
                }
                $scope.saveHomeBreakDown = function () {
                    ptHomeBreakDownService.save($scope.BBLE, $scope.PropFloors, function (res) {
                        console.log(res);
                        alert('Save Successfullly!');
                    })
                }

                var compiled = $compile(homeBreakDownCtrl.innerHTML);
                var cElem = compiled($scope);
                $scope.$digest();
                target.html(cElem);
                $scope.init(bble);
            });
        }

    }
    angular.module('PortalApp').controller('homeBreakDownCtrl', function () { })


    // change leads status to additional folder
    otherFolderPopupCtrl = {
        show: function (elm) {
            otherFolderPopup.ShowAtElement(elm);
        },
        onClick: function (s, e) {
            //debugger;
            var args = e.item.name.split('|');
            // pass request fomat will be "x|{leadstatuscode}|{bble}"
            SetLeadStatus("x" + "|" + e.item.name + "|" + leadsInfoBBLE);

        }
    }
</script>


<style type="text/css">
    .UpdateInfoAlign {
        text-align: right;
    }

    .LeadsContentPanel {
        min-height: 800px;
        /*min-width:1100px;*/
    }
</style>

<dx:ASPxCallbackPanel runat="server" OnCallback="ASPxCallbackPanel2_Callback" ID="ASPxCallbackPanel2" Height="100%" ClientInstanceName="ContentCallbackPanel" EnableCallbackAnimation="true" CssClass="LeadsContentPanel">
    <PanelCollection>
        <dx:PanelContent ID="PanelContent1" runat="server">

            <dx:ASPxPanel runat="server" ID="doorKnockMapPanel" Visible="false" Width="100%" Height="100%">
                <PanelCollection>
                    <dx:PanelContent>
                        <iframe id="MapContent" width="100%" height="100%" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="/WebForm2.aspx"></iframe>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxPanel>

            <dx:ASPxSplitter ID="contentSplitter" PaneStyle-BackColor="#f9f9f9" runat="server" Width="100%" ClientInstanceName="contentSplitter">

                <Styles>
                    <Pane Paddings-Padding="0">
                        <Paddings Padding="0px"></Paddings>
                    </Pane>
                </Styles>
                <Panes>
                    <dx:SplitterPane ShowCollapseBackwardButton="True" AutoHeight="true" Name="paneInfo">
                        <PaneStyle Paddings-Padding="0">
                            <Paddings Padding="0px"></Paddings>
                        </PaneStyle>
                        <ContentCollection>
                            <dx:SplitterContentControl ID="SplitterContentControl3" runat="server">
                                <div style="width: 100%; align-content: center; height: 100%">
                                    <dx:ASPxPopupMenu ID="ASPxPopupMenu3" runat="server" ClientInstanceName="popupMenuRefreshClient"
                                        AutoPostBack="false" PopupHorizontalAlign="Center" PopupVerticalAlign="Below" PopupAction="LeftMouseClick" ForeColor="#3993c1" Font-Size="14px" CssClass="fix_pop_postion_s" Paddings-PaddingTop="15px" Paddings-PaddingBottom="18px">
                                        <ItemStyle Paddings-PaddingLeft="20px" />
                                        <Items>
                                            <dx:MenuItem Text="All" Name="All"></dx:MenuItem>
                                            <dx:MenuItem Text="General Property Info" Name="Assessment"></dx:MenuItem>
                                            <dx:MenuItem Text="Mortgage and Violations" Name="PropData"></dx:MenuItem>
                                            <dx:MenuItem Text="Home Owner Info" Name="TLO"></dx:MenuItem>
                                            <dx:MenuItem Text="zEstimate" Name="ZEstimate"></dx:MenuItem>
                                            <dx:MenuItem Text="Judgment Search" Name="JudgmentSearch"></dx:MenuItem>
                                        </Items>
                                        <ClientSideEvents ItemClick="OnRefreshMenuClick" />
                                        <%--<ItemStyle Width="143px"></ItemStyle>--%>
                                    </dx:ASPxPopupMenu>
                                    <asp:HiddenField ID="hfBBLE" runat="server" />
                                    <!-- Nav tabs -->
                                    <% If Not HiddenTab Then%>
                                    <ul class="nav nav-tabs clearfix" role="tablist" style="height: 70px; background: #ff400d; font-size: 16px; color: white">

                                        <li class="active short_sale_head_tab">
                                            <a href="#property_info" role="tab" data-toggle="tab" class="tab_button_a">
                                                <i class="fa fa-info-circle head_tab_icon_padding"></i>
                                                <div class="font_size_bold" style="font-weight: 900;">Property</div>
                                            </a>
                                        </li>
                                        <li class="short_sale_head_tab">
                                            <a href="#home_owner" role="tab" data-toggle="tab" class="tab_button_a">
                                                <i class="fa fa-home head_tab_icon_padding"></i>
                                                <div class="font_size_bold" style="font-weight: 900;">Homeowner</div>
                                            </a>
                                        </li>
                                        <li class="short_sale_head_tab">
                                            <a href="#documents" role="tab" data-toggle="tab" class="tab_button_a" onclick="BindDocuments(false)">
                                                <i class="fa fa-file head_tab_icon_padding"></i>
                                                <div class="font_size_bold" style="font-weight: 900;">Documents</div>
                                            </a>
                                        </li>
                                        <li class="short_sale_head_tab">
                                            <a href="#titlePane" role="tab" data-toggle="tab" class="tab_button_a" onclick="cbGetJudgementData.PerformCallback(leadsInfoBBLE)">
                                                <i class="fa fa-key head_tab_icon_padding"></i>
                                                <div class="font_size_bold" style="font-weight: 900;">Title</div>
                                            </a>
                                        </li>

                                        <li style="margin-right: 30px; color: #ffa484; float: right">

                                            <% If Not ShowLogPanel Then%>
                                            <i class="fa fa-history sale_head_button tooltip-examples" id="btnShowlogPanel" style="background-color: #295268; color: white;" title="Show Logs" onclick="ShowLogPanel()"></i>
                                            <div class="tooltip fade bottom in" style="top: 54px; left: -17px; display: block;">
                                                <div class="tooltip-arrow"></div>
                                                <div class="tooltip-inner">Show Logs</div>
                                            </div>
                                            <% End If%>

                                            <i class="fa fa-refresh sale_head_button sale_head_button_left tooltip-examples" title="Refresh" onclick="popupMenuRefreshClient.ShowAtElement(this)"></i>
                                            <i class="fa fa-envelope sale_head_button sale_head_button_left tooltip-examples" title="Mail" onclick="ShowEmailPopup(leadsInfoBBLE)"></i>
                                            <i class="fa fa-share-alt  sale_head_button sale_head_button_left tooltip-examples" title="Share Leads" onclick="var url = '/PopupControl/ShareLeads.aspx?bble=' + leadsInfoBBLE;AspxPopupShareleadClient.SetContentUrl(url);AspxPopupShareleadClient.Show();"></i>
                                            <i class="fa fa-print sale_head_button sale_head_button_left tooltip-examples" title="Print" onclick="PrintLeadInfo()"></i>

                                        </li>
                                    </ul>
                                    <% End If%>

                                    <div class="tab-content clearfix">
                                        <uc1:PropertyInfo runat="server" ID="PropertyInfo" />
                                        <div class="tab-pane clearfix" id="home_owner">
                                            <div style="height: 850px; overflow: auto" id="scrollbar_homeowner">
                                                <dx:ASPxCallbackPanel runat="server" ID="ownerInfoCallbackPanel" ClientInstanceName="ownerInfoCallbackPanel" OnCallback="ownerInfoCallbackPanel_Callback" Paddings-Padding="0px">
                                                    <PanelCollection>
                                                        <dx:PanelContent>
                                                            <div style="padding: 20px 20px 0px 20px">
                                                                <table style="width: 100%; margin: 0px; padding: 0px;">
                                                                    <tr>
                                                                        <td style="width: 50%; vertical-align: top">
                                                                            <uc1:HomeOwnerInfo runat="server" ID="HomeOwnerInfo2" />
                                                                        </td>
                                                                        <td style="border-left: 1px solid #b1b2b7; width: 8px;">&nbsp;
                                                                        </td>
                                                                        <td style="vertical-align: top">

                                                                            <uc1:HomeOwnerInfo runat="server" ID="HomeOwnerInfo3" />
                                                                            <% If (Not HomeOwnerInfo3.Visible) Then%>

                                                                            <% End If%>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                                <div>
                                                                </div>
                                                            </div>
                                                        </dx:PanelContent>
                                                    </PanelCollection>
                                                </dx:ASPxCallbackPanel>
                                            </div>

                                            <div style="position: fixed; right: 0; bottom: 5px;">
                                                <iframe src="/AutoDialer/Dialer.aspx" id="AutoDialer" style="width: 339px; height: 406px; border: none; display: none"></iframe>
                                            </div>
                                        </div>
                                        <div class="tab-pane" id="documents">
                                            <uc1:DocumentsUI runat="server" ID="DocumentsUI" />
                                        </div>
                                        <div class="tab-pane" id="titlePane">
                                            <uc1:TitleControl runat="server" ID="TitleControl" />
                                        </div>
                                    </div>
                                    <dx:ASPxPopupMenu ID="ASPxPopupSortPhone" runat="server" ClientInstanceName="ASPxPopupSortPhoneClient"
                                        PopupElementID="numberLink" ShowPopOutImages="false" AutoPostBack="false"
                                        PopupHorizontalAlign="Center" PopupVerticalAlign="Below" PopupAction="LeftMouseClick"
                                        ForeColor="#3993c1" Font-Size="14px" CssClass="fix_pop_postion_s" Paddings-PaddingTop="15px" Paddings-PaddingBottom="18px">
                                        <ItemStyle Paddings-PaddingLeft="20px" />
                                        <Items>
                                            <dx:MenuItem Text="last called" Name="LastCalledDate">
                                            </dx:MenuItem>
                                            <dx:MenuItem Text="call count" Name="CallCount">
                                            </dx:MenuItem>

                                        </Items>
                                        <ClientSideEvents ItemClick="OnSortPhoneClick" />
                                    </dx:ASPxPopupMenu>
                                    <dx:ASPxPopupMenu ID="ASPxPopupMenu1" runat="server" ClientInstanceName="ASPxPopupMenuPhone"
                                        PopupElementID="numberLink" ShowPopOutImages="false" AutoPostBack="false"
                                        PopupHorizontalAlign="Center" PopupVerticalAlign="Below" PopupAction="LeftMouseClick"
                                        ForeColor="#3993c1" Font-Size="14px" CssClass="fix_pop_postion_s" Paddings-PaddingTop="15px" Paddings-PaddingBottom="18px">
                                        <ItemStyle Paddings-PaddingLeft="20px" />
                                        <Items>
                                            <dx:MenuItem Text="Call Phone" Name="Call">
                                            </dx:MenuItem>
                                            <dx:MenuItem Text="# doesn't work" Name="nonWork">
                                            </dx:MenuItem>
                                            <dx:MenuItem Text="Working Phone number" Name="Work">
                                            </dx:MenuItem>
                                            <dx:MenuItem Text="Undo" Name="Undo">
                                            </dx:MenuItem>
                                            <dx:MenuItem Text="Comment" Name="Comment">
                                            </dx:MenuItem>
                                        </Items>
                                        <ClientSideEvents ItemClick="OnPhoneNumberClick" />
                                    </dx:ASPxPopupMenu>
                                    <dx:ASPxPopupMenu ID="EmailPopup" runat="server" ClientInstanceName="EmailPopupClient"
                                        PopupElementID="numberLink" ShowPopOutImages="false" AutoPostBack="false"
                                        PopupHorizontalAlign="Center" PopupVerticalAlign="Below" PopupAction="LeftMouseClick"
                                        ForeColor="#3993c1" Font-Size="14px" CssClass="fix_pop_postion_s" Paddings-PaddingTop="15px" Paddings-PaddingBottom="18px">
                                        <ItemStyle Paddings-PaddingLeft="20px" />
                                        <Items>
                                            <dx:MenuItem Text="Delete" Name="Delete">
                                            </dx:MenuItem>
                                        </Items>
                                        <ClientSideEvents ItemClick="OnEmailPopupClick" />
                                    </dx:ASPxPopupMenu>
                                    <dx:ASPxPopupMenu ID="ASPxPopupMenu2" runat="server" ClientInstanceName="AspxPopupMenuAddress"
                                        ShowPopOutImages="false" AutoPostBack="false"
                                        ForeColor="#3993c1" Font-Size="14px" CssClass="fix_pop_postion_s" Paddings-PaddingTop="15px" Paddings-PaddingBottom="18px"
                                        PopupHorizontalAlign="Center" PopupVerticalAlign="Below" PopupAction="LeftMouseClick">
                                        <ItemStyle Paddings-PaddingLeft="20px" />
                                        <Items>
                                            <dx:MenuItem Text="Door knock" Name="doorKnock">
                                            </dx:MenuItem>
                                            <dx:MenuItem Text="Wrong Property" Name="wrongProperty">
                                            </dx:MenuItem>
                                            <dx:MenuItem Text="Correct Property" Name="correctProperty">
                                            </dx:MenuItem>
                                            <dx:MenuItem Text="Undo" Name="Undo">
                                            </dx:MenuItem>
                                        </Items>
                                        <%--disable the width by steven--%>
                                        <%--<ItemStyle Width="143px"></ItemStyle>--%>
                                        <%------end------%>
                                        <ClientSideEvents ItemClick="OnAddressPopupMenuClick" />
                                    </dx:ASPxPopupMenu>
                                </div>
                            </dx:SplitterContentControl>
                        </ContentCollection>
                    </dx:SplitterPane>

                    <dx:SplitterPane ShowCollapseForwardButton="True" Name="LogPanel">
                        <PaneStyle BackColor="#F9F9F9"></PaneStyle>
                        <ContentCollection>
                            <dx:SplitterContentControl ID="SplitterContentControl4" runat="server">

                                <div style="font-size: 12px; color: #9fa1a8;">
                                    <ul class="nav nav-tabs clearfix" role="tablist" style="height: 70px; background: #295268; font-size: 16px; color: white">
                                        <li class="short_sale_head_tab activity_light_blue">
                                            <a href="#property_info" role="tab" data-toggle="tab" class="tab_button_a">
                                                <i class="fa fa-history head_tab_icon_padding"></i>
                                                <div class="font_size_bold" style="font-weight: 900;">Activity Log</div>
                                            </a>
                                        </li>

                                        <%--<li><a role="tab" data-toggle="tab">Settings</a></li>--%>

                                        <li style="margin-right: 30px; color: #7396a9; float: right">
                                            <% If Not ShowLogPanel Then%>
                                            <i class="fa fa-info-circle sale_head_button tooltip-examples" style="background-color: #ff400d; color: white;" title="Show Property Info" onclick="ShowLogPanel()"></i>
                                            <div class="tooltip fade bottom in" style="top: 54px; left: -38px; display: block;">
                                                <div class="tooltip-arrow" style="border-bottom-color: #ff400d;"></div>
                                                <div class="tooltip-inner" style="background-color: #ff400d;">Show Property Info</div>
                                            </div>
                                            <% End If%>
                                            <i class="fa fa-folder-open-o sale_head_button sale_head_button_left tooltip-examples" title="Add to folder" onclick="otherFolderPopupCtrl.show(this)" runat="server" id="otherFolderIcon"></i>
                                            <i class="fa fa-calendar-o sale_head_button sale_head_button_left tooltip-examples" title="Schedule" onclick="showAppointmentPopup=true;ASPxPopupScheduleClient.PerformCallback();"></i>
                                            <i class="fa fa-sun-o sale_head_button sale_head_button_left tooltip-examples" title="Hot Leads" onclick="SetLeadStatus('5|'+leadsInfoBBLE);"></i>
                                            <i class="fa fa-rotate-right sale_head_button sale_head_button_left tooltip-examples" title="Follow Up" onclick="ASPxPopupMenuClientControl.ShowAtElement(this);"></i>
                                            <i class="fa fa-sign-in  sale_head_button sale_head_button_left tooltip-examples" title="Door Knock" onclick="SetLeadStatus('4|'+leadsInfoBBLE);"></i>
                                            <i class="fa fa-refresh sale_head_button sale_head_button_left tooltip-examples" title="In Process" onclick="ShowInProcessPopup(leadsInfoBBLE);"></i>
                                            <i class="fa fa-times-circle sale_head_button sale_head_button_left tooltip-examples" title="Dead Lead" onclick="ShowDeadLeadsPopup(leadsInfoBBLE);"></i>
                                            <i class="fa fa-print sale_head_button sale_head_button_left tooltip-examples" title="Print" onclick="PrintLogInfo()"></i>
                                        </li>
                                    </ul>
                                </div>

                                <div class="clearfix">
                                    <uc1:ActivityLogs runat="server" ID="ActivityLogs" />
                                </div>
                                <dx:ASPxCallback ID="callPhoneCallback" runat="server" ClientInstanceName="callPhoneCallbackClient" OnCallback="callPhoneCallback_Callback">
                                    <ClientSideEvents CallbackComplete="OnCallPhoneCallbackComplete" />
                                </dx:ASPxCallback>

                                <dx:ASPxPopupMenu ID="ASPxPopupCallBackMenu2" runat="server" ClientInstanceName="ASPxPopupMenuClientControl"
                                    AutoPostBack="false" PopupHorizontalAlign="Center" PopupVerticalAlign="Below" PopupAction="LeftMouseClick"
                                    ForeColor="#3993c1" Font-Size="14px" CssClass="fix_pop_postion_s" Paddings-PaddingTop="15px" Paddings-PaddingBottom="18px">
                                    <ItemStyle Paddings-PaddingLeft="20px" />
                                    <Items>
                                        <dx:MenuItem Text="Tomorrow" Name="Tomorrow"></dx:MenuItem>
                                        <dx:MenuItem Text="Next Week" Name="nextWeek"></dx:MenuItem>
                                        <dx:MenuItem Text="30 Days" Name="thirtyDays">
                                        </dx:MenuItem>
                                        <dx:MenuItem Text="60 Days" Name="sixtyDays">
                                        </dx:MenuItem>
                                        <dx:MenuItem Text="Custom" Name="Custom">
                                        </dx:MenuItem>
                                    </Items>
                                    <ClientSideEvents ItemClick="OnCallbackMenuClick" />
                                </dx:ASPxPopupMenu>

                                <dx:ASPxPopupMenu ID="OtherFolderPopup" runat="server" ClientInstanceName="otherFolderPopup"
                                    AutoPostBack="false" PopupHorizontalAlign="Center" PopupVerticalAlign="Below" PopupAction="LeftMouseClick"
                                    ForeColor="#3993c1" Font-Size="14px" CssClass="fix_pop_postion_s" Paddings-PaddingTop="15px" Paddings-PaddingBottom="18px">
                                    <ItemStyle Paddings-PaddingLeft="20px" />
                                    <Items></Items>
                                    <ClientSideEvents ItemClick="otherFolderPopupCtrl.onClick" />
                                </dx:ASPxPopupMenu>

                                <dx:ASPxPopupControl ClientInstanceName="ASPxPopupSelectDateControl" Width="360px" Height="250px"
                                    MaxWidth="800px" MaxHeight="150px" MinHeight="150px" MinWidth="150px" ID="pcMain"
                                    HeaderText="Select Date" Modal="false" OnWindowCallback="pcMain_WindowCallback"
                                    runat="server" PopupHorizontalAlign="LeftSides" PopupVerticalAlign="Below" EnableHierarchyRecreation="True">
                                    <ContentCollection>
                                        <dx:PopupControlContentControl runat="server" Visible="false" ID="pcMainPopupControl">
                                            <table>
                                                <tr>
                                                    <td>
                                                        <dx:ASPxCalendar ID="ASPxCalendar1" runat="server" ClientInstanceName="callbackCalendar" ShowClearButton="False" ShowTodayButton="False" Visible="true"></dx:ASPxCalendar>
                                                        <%--     <dx:ASPxDateEdit runat="server" EditFormatString="g" Width="100%" ID="ASPxDateEdit1" ClientInstanceName="ScheduleDateClientFllowUp" 
                                                            TimeSectionProperties-Visible="True" CssClass="edit_drop">
                                                            <TimeSectionProperties Visible="True"></TimeSectionProperties>
                                                            <ClientSideEvents Init="function(s,e){ s.SetDate(new Date());}" />
                                                        </dx:ASPxDateEdit>--%>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="color: #666666; font-size: 10px; align-content: center; text-align: center; padding-top: 2px;">
                                                        <dx:ASPxButton ID="ASPxButton1" runat="server" Text="OK" AutoPostBack="false" CssClass="rand-button rand-button-blue">
                                                            <ClientSideEvents Click="function(){ASPxPopupSelectDateControl.Hide();SetLeadStatus('customDays|' + leadsInfoBBLE + '|' + callbackCalendar.GetSelectedDate().toISOString());}"></ClientSideEvents>
                                                        </dx:ASPxButton>
                                                        &nbsp;
                                                            <dx:ASPxButton runat="server" Text="Cancel" AutoPostBack="false" CssClass="rand-button rand-button-gray">
                                                                <ClientSideEvents Click="function(){ASPxPopupSelectDateControl.Hide();}"></ClientSideEvents>
                                                            </dx:ASPxButton>
                                                    </td>
                                                </tr>
                                            </table>
                                        </dx:PopupControlContentControl>
                                    </ContentCollection>
                                </dx:ASPxPopupControl>

                            </dx:SplitterContentControl>
                        </ContentCollection>
                    </dx:SplitterPane>
                </Panes>
            </dx:ASPxSplitter>

            <dx:ASPxPopupControl ClientInstanceName="aspxPopupAddPhoneNum" Width="320px" Height="80px" ID="ASPxPopupControl2"
                HeaderText="Add Phone Number" ShowHeader="false"
                runat="server" EnableViewState="false" PopupHorizontalAlign="LeftSides" PopupVerticalAlign="Below" EnableHierarchyRecreation="True">
                <ContentCollection>
                    <dx:PopupControlContentControl>
                        <table>
                            <tr>
                                <td>
                                    <dx:ASPxTextBox runat="server" ID="txtPhoneNo" ClientInstanceName="txtPhoneNoClient" CssClass="edit_drop"></dx:ASPxTextBox>
                                </td>
                                <td>
                                    <div style="margin: 0px 10px; padding-top: 13px;">
                                        <dx:ASPxButton runat="server" ID="btnAdd" Text="Add" AutoPostBack="false" CssClass="rand-button rand-button-blue">
                                            <ClientSideEvents Click="SaveBestPhoneNo" />
                                        </dx:ASPxButton>
                                        &nbsp;
                                       
                                    </div>
                                </td>
                                <td>
                                    <dx:ASPxButton runat="server" ID="ASPxButton4" Text="Close" AutoPostBack="false" CssClass="rand-button rand-button-gray">
                                        <ClientSideEvents Click="function(s,e){aspxPopupAddPhoneNum.Hide();}" />
                                    </dx:ASPxButton>
                                </td>
                            </tr>


                        </table>
                    </dx:PopupControlContentControl>
                </ContentCollection>
            </dx:ASPxPopupControl>

            <dx:ASPxPopupControl ClientInstanceName="aspxPopupAddEmail" Width="320px" Height="80px" ID="PopupAddEmail"
                HeaderText="Add Phone Number" ShowHeader="false"
                runat="server" EnableViewState="false" PopupHorizontalAlign="LeftSides" PopupVerticalAlign="Below" EnableHierarchyRecreation="True">

                <ContentCollection>
                    <dx:PopupControlContentControl>
                        <table>
                            <tr>
                                <td>
                                    <dx:ASPxTextBox runat="server" ID="txtEmail" ClientInstanceName="txtEmailClient" CssClass="edit_drop"></dx:ASPxTextBox>
                                </td>
                                <td>
                                    <div style="margin: 0px 10px; padding-top: 13px;">
                                        <dx:ASPxButton runat="server" ID="BtnAddEmail" Text="Add" AutoPostBack="false" CssClass="rand-button rand-button-blue">
                                            <ClientSideEvents Click="SaveBestEmail" />
                                        </dx:ASPxButton>
                                        &nbsp;
                                       
                                    </div>
                                </td>
                                <td>
                                    <dx:ASPxButton runat="server" ID="ASPxButton7" Text="Close" AutoPostBack="false" CssClass="rand-button rand-button-gray">
                                        <ClientSideEvents Click="function(s,e){aspxPopupAddEmail.Hide();}" />
                                    </dx:ASPxButton>
                                </td>
                            </tr>
                        </table>
                    </dx:PopupControlContentControl>
                </ContentCollection>
            </dx:ASPxPopupControl>

            <dx:ASPxPopupControl ClientInstanceName="aspxPopupAddAddress" Width="400px" Height="80px" ID="ASPxPopupControl1"
                HeaderText="Add Address" OnWindowCallback="ASPxPopupControl1_WindowCallback" Modal="true"
                runat="server" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter">
                <ContentCollection>
                    <dx:PopupControlContentControl Visible="false" ID="popupContentAddAddress">
                        <table class="mail_edits">
                            <tr style="padding-top: 3px;">
                                <td><span class="font_12 color_gray upcase_text">Address:</span></td>
                                <td>
                                    <dx:ASPxTextBox runat="server" ID="txtUserAddress" CssClass="email_input"></dx:ASPxTextBox>
                                </td>
                            </tr>
                            <tr style="padding-top: 3px;">
                                <td><span class="font_12 color_gray upcase_text">Description:</span></td>
                                <td>
                                    <dx:ASPxTextBox runat="server" ID="txtAdrDes" CssClass="email_input"></dx:ASPxTextBox>
                                </td>
                            </tr>
                            <tr style="margin-top: 3px; line-height: 30px; margin-top: 10px">
                                <td></td>
                                <td>
                                    <div style="margin-top: 10px">
                                        <dx:ASPxButton runat="server" ID="ASPxButton2" Text="Add" AutoPostBack="false" CssClass="rand-button rand-button-blue">
                                            <ClientSideEvents Click="function(s,e){isSave = true;aspxPopupAddAddress.PerformCallback('Save|' + currOwner);}" />
                                        </dx:ASPxButton>
                                        &nbsp;
                                        <dx:ASPxButton runat="server" ID="ASPxButton5" Text="Close" AutoPostBack="false" CssClass="rand-button rand-button-gray">
                                            <ClientSideEvents Click="function(s,e){aspxPopupAddAddress.Hide();}" />
                                        </dx:ASPxButton>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </dx:PopupControlContentControl>
                </ContentCollection>
                <ClientSideEvents EndCallback="function(s,e){if(!isSave){s.Show();}else{s.Hide();ownerInfoCallbackPanel.PerformCallback();}}" />
            </dx:ASPxPopupControl>

            <uc1:SendMail runat="server" ID="SendMail" />
            <uc1:EditHomeOwner runat="server" ID="EditHomeOwner" />
            <dx:ASPxCallback ID="ReportNoHomeCallBack" runat="server" OnCallback="ReportNoHomeCallBack_OnCallback" ClientInstanceName="ReportNoHomeCallBackClinet"></dx:ASPxCallback>

        </dx:PanelContent>
    </PanelCollection>
    <ClientSideEvents EndCallback="OnLeadsInfoEndCallBack"></ClientSideEvents>
    <Border BorderStyle="None"></Border>
</dx:ASPxCallbackPanel>

<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                <h4 class="modal-title" id="exampleModalLabel">Phone Comments</h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label for="phone_comment" class="control-label">Comments:</label>
                    <input type="text" class="form-control" id="phone_comment">
                </div>


            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="onSavePhoneComment();">Save</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>

            </div>
        </div>
    </div>
</div>
