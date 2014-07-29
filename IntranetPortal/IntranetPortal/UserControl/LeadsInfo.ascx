<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LeadsInfo.ascx.vb" Inherits="IntranetPortal.LeadsInfo1" %>
<%@ Register Src="~/UserControl/ActivityLogs.ascx" TagPrefix="uc1" TagName="ActivityLogs" %>
<%@ Register Src="~/UserControl/HomeOwnerInfo.ascx" TagPrefix="uc1" TagName="HomeOwnerInfo" %>
<%@ Register Src="~/UserControl/DocumentsUI.ascx" TagPrefix="uc1" TagName="DocumentsUI" %>

<script type="text/javascript">
    // <![CDATA[
    function OnClick(s, e) {
        ASPxPopupMenuPhone.ShowAtElement(s.GetMainElement());
    }

    var tmpPhoneNo = null;
    function OnTelphoneLinkClick(tellink, phoneNo) {
        tmpPhoneNo = phoneNo;
        ASPxPopupMenuPhone.ShowAtElement(tellink);
    }

    function OnPhoneNumberClick(s, e) {
        if (tmpPhoneNo != null) {
            if (e.item.index == 0) {
                OnCallPhoneCallback("CallPhone|" + tmpPhoneNo);
            }

            if (e.item.index == 1) {
                //telphoneLine.style.textDecoration = "line-through";
                //telphoneLine.style.color = "red";
                OnCallPhoneCallback("BadPhone|" + tmpPhoneNo);
            }

            if (e.item.index == 2) {
                //telphoneLine.style.color = "green";
                //telphoneLine.style.textDecoration = "none";
                OnCallPhoneCallback("RightPhone|" + tmpPhoneNo);
            }


            if (e.item.index == 3) {
                //telphoneLine.style.color = "green";
                //telphoneLine.style.textDecoration = "none";
                OnCallPhoneCallback("UndoPhone|" + tmpPhoneNo);
            }
        }

        e.item.SetChecked(false);
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
            ownerInfoCallbackPanel.PerformCallback("");
        }
    }

    function OnCallBackButtonClick(s, e) {
        ASPxPopupMenuClientControl.ShowAtElement(s.GetMainElement());
    }

    function OnCallbackMenuClick(s, e) {

        if (e.item.name == "Custom") {
            ASPxPopupSelectDateControl.ShowAtElement(s.GetMainElement());
            e.processOnServer = false;
            return;
        }

        SetLeadStatus(e.item.name);
        e.processOnServer = false;
    }

    function SetLeadStatus(status) {
        if (leadStatusCallbackClient.InCallback()) {
            alert("Server is busy! Please wait!")
        } else {
            leadStatusCallbackClient.PerformCallback(status);
        }
    }

    function OnSetStatusComplete(s, e) {
        if (typeof gridLeads == "undefined") {
            //alert("undefined");
        }
        else
            gridLeads.Refresh();

        if (typeof window.parent.agentTreeCallbackPanel == "undefined")
            return;
        else
            window.parent.agentTreeCallbackPanel.PerformCallback("");
    }

    function PrintLeadInfo() {
        if (leadsInfoBBLE != null) {
            var url = '/ShowReport.aspx?id=' + leadsInfoBBLE;
            window.showModalDialog(url, 'Show Report', 'dialogWidth:800px;dialogHeight:800px');
        }
    }

    function PrintLogInfo(formlayoutActivityLog) {
        if (leadsInfoBBLE != null) {
            var url = '/ShowReport.aspx?id=' + leadsInfoBBLE + "&t=log";
            window.showModalDialog(url, 'Show Report', 'dialogWidth:800px;dialogHeight:800px');
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

    var tmpAddress = null;
    function OnAddressLinkClick(s, address) {
        tmpAddress = address;
        AspxPopupMenuAddress.ShowAtElement(s);
    }

    function OnAddressPopupMenuClick(s, e) {

        if (tmpAddress != null) {
            if (e.item.index == 0) {
                OnCallPhoneCallback("DoorKnock|" + tmpAddress);
                SetLeadStatus(4);
            }

            if (e.item.index == 1) {
                OnCallPhoneCallback("BadAddress|" + tmpAddress);
            }

            if (e.item.index == 2) {
                OnCallPhoneCallback("RightAddress|" + tmpAddress);
            }

            if (e.item.index == 3) {
                OnCallPhoneCallback("UndoAddress|" + tmpAddress);
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
            ContentCallbackPanel.PerformCallback(parms);
        }
        else {
            __doPostBack(s.name, '');
        }
    }

    function OnSaveAppointment(s, e) {
        ASPxPopupScheduleClient.Hide();
        var logId = hfLogIDClient.Get('logId');
        if (logId != null && logId > 0) {
            ReScheduledAppointment(logId);
            SetLeadStatus(9);
            appointmentCallpanel.PerformCallback("Clear");
        }
        else {
            SetLeadStatus(9);
        }
        gridTrackingClient.Refresh();
    }

    var currOwner = "";
    function AddBestPhoneNum(bble, ownerName, ulClient, addButton) {
        //var ul = document.getElementById(ulClient);
        //var li = document.createElement("li");
        //li.innerHTML = "<input type='text' id='' /><input type='button' value='Update'><input type='button' value='Delete'>";

        //if (ul.hasChildNodes())
        //    ul.insertBefore(li, ul.childNodes[0]);
        currOwner = ownerName;
        aspxPopupAddPhoneNum.ShowAtElement(addButton);
    }

    function SaveBestPhoneNo(s, e) {
        var phoneNo = txtPhoneNoClient.GetText();
        ownerInfoCallbackPanel.PerformCallback(phoneNo + "|" + currOwner);
        aspxPopupAddPhoneNum.Hide();
        txtPhoneNoClient.SetText("");
    }

    // ]]> 
</script>

<dx:ASPxCallbackPanel runat="server" OnCallback="ASPxCallbackPanel2_Callback" ID="ASPxCallbackPanel2" Height="100%" ClientInstanceName="ContentCallbackPanel" EnableCallbackAnimation="true" ScrollBars="Auto">
    <PanelCollection>
        <dx:PanelContent ID="PanelContent1" runat="server">
            <dx:ASPxPanel runat="server" ID="doorKnockMapPanel" Visible="false" Width="100%" Height="100%">
                <PanelCollection>
                    <dx:PanelContent>
                        <iframe id="MapContent" width="100%" height="100%" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="/WebForm2.aspx"></iframe>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxPanel>
            <dx:ASPxSplitter ID="contentSplitter" PaneStyle-BackColor="#f9f9f9" runat="server" Height="100%" Width="100%" ClientInstanceName="contentSplitter">
                <Styles>
                    <Pane Paddings-Padding="0">
                        <Paddings Padding="0px"></Paddings>
                    </Pane>
                </Styles>
                <Panes>
                    <dx:SplitterPane ShowCollapseBackwardButton="True" ScrollBars="Auto" PaneStyle-BackColor="#f9f9f9">
                        <PaneStyle Paddings-Padding="0">
                            <Paddings Padding="0px"></Paddings>
                        </PaneStyle>
                        <ContentCollection>
                            <dx:SplitterContentControl ID="SplitterContentControl3" runat="server">
                                <div style="width: 100%; align-content: center;">
                                    <div style="text-align: right; float: right; position: relative; margin-bottom: -21px; margin-right: 15px; font-size: 12px">
                                        <dx:ASPxButton Text="Refresh" Image-Url="/images/Refresh.png" UseSubmitBehavior="false" AutoPostBack="false" Image-Width="16px" Image-Height="16px" runat="server" ID="btnRefresh" AllowFocus="False">
                                            <FocusRectPaddings PaddingLeft="2" PaddingRight="2" />
                                            <Image Height="16px" Width="16px" Url="/images/Refresh.png"></Image>
                                            <Paddings PaddingLeft="2" PaddingRight="2" />
                                            <ClientSideEvents Click="function(s,e){
                                            popupMenuRefreshClient.ShowAtElement(s.GetMainElement());
                                            //OnRefreshPage();
                                            }" />
                                        </dx:ASPxButton>
                                        <dx:ASPxButton runat="server" Text="Share" ID="btnShare" UseSubmitBehavior="false" AutoPostBack="false">
                                            <FocusRectPaddings PaddingLeft="2" PaddingRight="2" />
                                            <Paddings PaddingLeft="2" PaddingRight="2" />
                                            <Image IconID="actions_add_16x16"></Image>
                                            <ClientSideEvents Click="function(){  
                                                        var url = '/PopupControl/ShareLeads.aspx?bble=' + leadsInfoBBLE;
                                                        AspxPopupShareleadClient.SetContentUrl(url);        
                                                        AspxPopupShareleadClient.Show();                                  
                                             }" />
                                        </dx:ASPxButton>

                                        <dx:ASPxButton Text="Save" AutoPostBack="false" runat="server" ID="btnSave" AllowFocus="False" UseSubmitBehavior="false" Visible="false">
                                            <FocusRectPaddings PaddingLeft="2" PaddingRight="2" />
                                            <Paddings PaddingLeft="2" PaddingRight="2" />
                                            <Image IconID="save_save_16x16"></Image>
                                            <ClientSideEvents Click="function(){
                                             callBackSaveLeadsInfoClient.PerformCallback();
                                             }" />
                                        </dx:ASPxButton>
                                        <dx:ASPxCallback runat="server" ID="callbackSaveLeadsInfo" ClientInstanceName="callBackSaveLeadsInfoClient" OnCallback="callbackSaveLeadsInfo_Callback">
                                        </dx:ASPxCallback>
                                        <dx:ASPxButton Text="Print" ID="btnPrint" Image-Url="/images/imprimir.png" UseSubmitBehavior="false" Image-Width="16px" AutoPostBack="false" Image-Height="16px" runat="server" AllowFocus="False">
                                            <FocusRectPaddings PaddingLeft="2" PaddingRight="2" />

                                            <Image Height="16px" Width="16px" Url="/images/imprimir.png"></Image>

                                            <Paddings PaddingLeft="2" PaddingRight="2" />
                                            <ClientSideEvents Click="function(s,e){PrintLeadInfo();}" />
                                        </dx:ASPxButton>
                                    </div>
                                    <dx:ASPxPopupMenu ID="ASPxPopupMenu3" runat="server" ClientInstanceName="popupMenuRefreshClient"
                                        AutoPostBack="false" PopupHorizontalAlign="RightSides" PopupVerticalAlign="Below" PopupAction="LeftMouseClick">
                                        <Items>
                                            <dx:MenuItem Text="All" Name="All"></dx:MenuItem>
                                            <dx:MenuItem Text="General Property Info" Name="Assessment"></dx:MenuItem>
                                            <dx:MenuItem Text="Mortgage and Violations" Name="PropData"></dx:MenuItem>
                                            <dx:MenuItem Text="Home Owner" Name="TLO">
                                            </dx:MenuItem>
                                        </Items>
                                        <ClientSideEvents ItemClick="OnRefreshMenuClick" />
                                        <ItemStyle Width="143px"></ItemStyle>
                                    </dx:ASPxPopupMenu>
                                    <asp:HiddenField ID="hfBBLE" runat="server" />
                                    <dx:ASPxPageControl Width="100%" Height="815px" EnableViewState="false" ID="pageLeadsInfo" runat="server" ActiveTabIndex="0" TabSpacing="2px">
                                        <Paddings Padding="0px" />
                                        <TabStyle Width="80px" Paddings-PaddingLeft="10px" HorizontalAlign="Center">
                                        </TabStyle>
                                        <TabPages>
                                            <dx:TabPage Text="Lead" Name="tabLeadInfo">
                                                <TabStyle Paddings-PaddingLeft="25px"></TabStyle>
                                                <ContentCollection>
                                                    <dx:ContentControl runat="server">
                                                        <dx:ASPxFormLayout ClientInstanceName="formlayoutLeadsInfoClient" ID="formlayoutLeadsInfo" Width="100%" runat="server">
                                                            <Items>
                                                                <dx:LayoutGroup Caption="Lead Info" Width="100%" Height="100%" ColCount="3" Name="leadGroup" GroupBoxDecoration="None" SettingsItemCaptions-Location="Top">
                                                                    <GroupBoxStyle>
                                                                        <Caption BackColor="Transparent" ForeColor="Black"></Caption>
                                                                    </GroupBoxStyle>
                                                                    <Items>
                                                                        <dx:LayoutGroup ColCount="3" ColSpan="3" Width="100%" GroupBoxDecoration="None">
                                                                            <Items>
                                                                                <dx:LayoutItem ShowCaption="False" FieldName="LastIssuedOn">
                                                                                    <LayoutItemNestedControlCollection>
                                                                                        <dx:LayoutItemNestedControlContainer>
                                                                                            <dx:ASPxLabel runat="server">
                                                                                            </dx:ASPxLabel>
                                                                                        </dx:LayoutItemNestedControlContainer>
                                                                                    </LayoutItemNestedControlCollection>
                                                                                </dx:LayoutItem>
                                                                                <dx:LayoutItem ShowCaption="False" FieldName="UpdateInfo" ColSpan="2" HorizontalAlign="Right">
                                                                                    <LayoutItemNestedControlCollection>
                                                                                        <dx:LayoutItemNestedControlContainer>
                                                                                            <dx:ASPxLabel runat="server" EncodeHtml="false">
                                                                                            </dx:ASPxLabel>
                                                                                        </dx:LayoutItemNestedControlContainer>
                                                                                    </LayoutItemNestedControlCollection>
                                                                                </dx:LayoutItem>
                                                                            </Items>
                                                                            <ParentContainerStyle Paddings-Padding="0"></ParentContainerStyle>
                                                                            <CellStyle Paddings-Padding="2"></CellStyle>
                                                                        </dx:LayoutGroup>
                                                                        <dx:LayoutGroup Caption="Indicator" ColCount="2" GroupBoxStyle-Caption-ForeColor="Red" ColSpan="3" GroupBoxDecoration="Box" Width="100%" Visible="false">
                                                                            <GroupBoxStyle>
                                                                                <Caption ForeColor="Red"></Caption>
                                                                            </GroupBoxStyle>
                                                                            <Items>
                                                                                <dx:LayoutItem ShowCaption="False" FieldName="IndicatorOfLiens">
                                                                                    <LayoutItemNestedControlCollection>
                                                                                        <dx:LayoutItemNestedControlContainer>
                                                                                            <dx:ASPxLabel runat="server" EncodeHtml="false">
                                                                                            </dx:ASPxLabel>
                                                                                        </dx:LayoutItemNestedControlContainer>
                                                                                    </LayoutItemNestedControlCollection>
                                                                                </dx:LayoutItem>
                                                                                <dx:LayoutItem ShowCaption="False" FieldName="IndicatorOfWater">
                                                                                    <LayoutItemNestedControlCollection>
                                                                                        <dx:LayoutItemNestedControlContainer>
                                                                                            <dx:ASPxLabel runat="server" EncodeHtml="false">
                                                                                            </dx:ASPxLabel>
                                                                                        </dx:LayoutItemNestedControlContainer>
                                                                                    </LayoutItemNestedControlCollection>
                                                                                </dx:LayoutItem>
                                                                            </Items>
                                                                        </dx:LayoutGroup>
                                                                        <dx:LayoutItem Caption="Property Address" ColSpan="2" FieldName="PropertyAddress">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                                                    <dx:ASPxTextBox ID="ASPxTextBox1"
                                                                                        runat="server" Width="100%" />
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="BBLE" FieldName="BBLE" Width="33%">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                                                    <dx:ASPxLabel runat="server" Font-Bold="true">
                                                                                    </dx:ASPxLabel>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="Neighborhood" FieldName="NeighName">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer>
                                                                                    <dx:ASPxTextBox ID="ASPxTextBox16" Width="100%"
                                                                                        runat="server" Text="" />
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="Borough" FieldName="Borough">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer>
                                                                                    <dx:ASPxTextBox ID="ASPxTextBox17" Width="100%"
                                                                                        runat="server" Text="" />
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="NYC Sqft" FieldName="NYCSqft">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer>
                                                                                    <dx:ASPxTextBox ID="ASPxTextBox18" Width="100%"
                                                                                        runat="server" Text="" />
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="Sale Date" FieldName="SaleDate" Width="33%">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer>
                                                                                    <dx:ASPxDateEdit runat="server" ID="dataPick" Width="100%" />
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="Block" FieldName="Block">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer>
                                                                                    <dx:ASPxTextBox ID="ASPxTextBox2" Width="100%"
                                                                                        runat="server" Text="" />
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="Lot" FieldName="Lot">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer>
                                                                                    <dx:ASPxTextBox ID="ASPxTextBox3" Width="100%"
                                                                                        runat="server" Text="" />
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="Year Build">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer>
                                                                                    <dx:ASPxTextBox ID="ASPxTextBox6" Width="100%"
                                                                                        runat="server" Text="" />
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="Tax Class" FieldName="TaxClass">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer>
                                                                                    <dx:ASPxTextBox ID="ASPxTextBox4" Width="100%"
                                                                                        runat="server" Text="" />
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="# of Floors" FieldName="NumFloors">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer>
                                                                                    <dx:ASPxTextBox ID="ASPxTextBox5" Width="100%"
                                                                                        runat="server" Text="" />
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="Zoning" FieldName="Zoning">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer>
                                                                                    <dx:ASPxTextBox ID="ASPxTextBox19" Width="100%"
                                                                                        runat="server" Text="" />
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="MAX FAR" FieldName="MaxFar">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer>
                                                                                    <dx:ASPxTextBox ID="ASPxTextBox20" Width="100%"
                                                                                        runat="server" Text="" />
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="Actual FAR" FieldName="ActualFar">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer>
                                                                                    <dx:ASPxTextBox ID="ASPxTextBox21" Width="100%"
                                                                                        runat="server" Text="" />
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>

                                                                        <dx:LayoutItem Caption="Lis Pendens" FieldName="IsLisPendens">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer>
                                                                                    <dx:ASPxRadioButtonList runat="server" ID="ASPxRadioButtonList11" RepeatDirection="Horizontal" Border-BorderStyle="None" Paddings-Padding="0" ValueType="System.Boolean">
                                                                                        <Paddings Padding="0px"></Paddings>
                                                                                        <Items>
                                                                                            <dx:ListEditItem Text="Yes" Value="true" />
                                                                                            <dx:ListEditItem Text="No" Value="false" />
                                                                                        </Items>
                                                                                        <Border BorderStyle="None"></Border>
                                                                                    </dx:ASPxRadioButtonList>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="1st Mortgage" FieldName="C1stMotgrAmt">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer>
                                                                                    <dx:ASPxTextBox ID="ASPxTextBox8" DisplayFormatString="C2" Width="100%"
                                                                                        runat="server" Text="" />
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="2st Mortgage" FieldName="C2ndMotgrAmt">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer>
                                                                                    <dx:ASPxTextBox ID="ASPxTextBox9" DisplayFormatString="C2" Width="100%"
                                                                                        runat="server" Text="" />
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="Other Liens" FieldName="IsOtherLiens">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer>
                                                                                    <dx:ASPxRadioButtonList runat="server" ID="ASPxRadioButtonList10" ValueType="System.Boolean" RepeatDirection="Horizontal" Border-BorderStyle="None" Paddings-Padding="0">
                                                                                        <Paddings Padding="0px"></Paddings>
                                                                                        <Items>
                                                                                            <dx:ListEditItem Text="Yes" Value="true" />
                                                                                            <dx:ListEditItem Text="No" Value="false" />
                                                                                        </Items>
                                                                                        <Border BorderStyle="None"></Border>
                                                                                    </dx:ASPxRadioButtonList>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="" ShowCaption="False" VerticalAlign="Bottom">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer>
                                                                                    <dx:ASPxTextBox ID="ASPxTextBox15" Width="100%"
                                                                                        runat="server" Text="" />
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="Unbuilt Sqft" VerticalAlign="Bottom">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer>
                                                                                    <dx:ASPxTextBox ID="ASPxTextBox22"
                                                                                        runat="server" Text="" Width="100%" />
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="Taxes Owed" FieldName="IsTaxesOwed">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer>
                                                                                    <dx:ASPxRadioButtonList runat="server" ValueType="System.Boolean" ID="ASPxRadioButtonList12" RepeatDirection="Horizontal" Border-BorderStyle="None" Paddings-Padding="0">
                                                                                        <Paddings Padding="0px"></Paddings>
                                                                                        <Items>
                                                                                            <dx:ListEditItem Text="Yes" Value="true" />
                                                                                            <dx:ListEditItem Text="No" Value="false" />
                                                                                        </Items>
                                                                                        <Border BorderStyle="None"></Border>
                                                                                    </dx:ASPxRadioButtonList>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="Amount" FieldName="TaxesAmt">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer>
                                                                                    <dx:ASPxTextBox ID="ASPxTextBox7" DisplayFormatString="C2" Width="100%"
                                                                                        runat="server" Text="" />
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="Building Dem" FieldName="BuildingDem">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer>
                                                                                    <dx:ASPxTextBox ID="ASPxTextBox10" Width="100%"
                                                                                        runat="server" Text="" />
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="Water Owed" FieldName="IsWaterOwed">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer>
                                                                                    <dx:ASPxRadioButtonList runat="server" ID="radioBox" ValueType="System.Boolean" RepeatDirection="Horizontal" Border-BorderStyle="None" Paddings-Padding="0">
                                                                                        <Paddings Padding="0px"></Paddings>
                                                                                        <Items>
                                                                                            <dx:ListEditItem Text="Yes" Value="true" />
                                                                                            <dx:ListEditItem Text="No" Value="false" />
                                                                                        </Items>

                                                                                        <Border BorderStyle="None"></Border>
                                                                                    </dx:ASPxRadioButtonList>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="Amount" FieldName="WaterAmt">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer>
                                                                                    <dx:ASPxTextBox ID="ASPxTextBox11" DisplayFormatString="C2" Width="100%"
                                                                                        runat="server" Text="" />
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="Lot Dem" FieldName="LotDem">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer>
                                                                                    <dx:ASPxTextBox ID="ASPxTextBox12" Width="100%"
                                                                                        runat="server" Text="" />
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="Violations" FieldName="Violation">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer>
                                                                                    <dx:ASPxCheckBoxList runat="server" ID="cbkViolations" RepeatDirection="Horizontal" Border-BorderStyle="None" Paddings-Padding="0" ValueType="System.String">
                                                                                        <Paddings Padding="0px"></Paddings>
                                                                                        <Items>
                                                                                            <dx:ListEditItem Text="ECB" Value="ECB" />
                                                                                            <dx:ListEditItem Text="DOB" Value="DOB" />
                                                                                        </Items>
                                                                                        <Border BorderStyle="None"></Border>
                                                                                    </dx:ASPxCheckBoxList>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="Amount" FieldName="ViolationAmount">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer>
                                                                                    <dx:ASPxTextBox ID="ASPxTextBox13" DisplayFormatString="C2" Width="100%"
                                                                                        runat="server" Text="" />
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="Est Value" FieldName="EstValue">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer>
                                                                                    <dx:ASPxTextBox ID="ASPxTextBox14" Width="100%" DisplayFormatString="C2"
                                                                                        runat="server" Text="" />
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="Liens" ColSpan="3">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer>
                                                                                    <dx:ASPxGridView runat="server" ID="gridLiens" KeyFieldName="LisPenID" Width="100%">
                                                                                        <Columns>
                                                                                            <dx:GridViewDataTextColumn FieldName="Type" Settings-AllowSort="False"></dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Effective" Settings-AllowSort="False"></dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Expiration" Settings-AllowSort="False"></dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Plaintiff" Settings-AllowSort="False"></dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Defendant" Settings-AllowSort="False"></dx:GridViewDataTextColumn>
                                                                                            <dx:GridViewDataTextColumn FieldName="Index" Settings-AllowSort="False"></dx:GridViewDataTextColumn>
                                                                                        </Columns>
                                                                                    </dx:ASPxGridView>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>

                                                                    </Items>
                                                                    <SettingsItemCaptions Location="Top"></SettingsItemCaptions>
                                                                </dx:LayoutGroup>
                                                            </Items>
                                                            <Styles>
                                                                <LayoutGroupBox>
                                                                    <Caption Font-Bold="True"></Caption>
                                                                </LayoutGroupBox>
                                                            </Styles>
                                                        </dx:ASPxFormLayout>
                                                    </dx:ContentControl>
                                                </ContentCollection>
                                            </dx:TabPage>
                                            <dx:TabPage Text="Homeowner" Name="tabOwnerInfo">
                                                <ContentCollection>
                                                    <dx:ContentControl runat="server">
                                                        <dx:ASPxCallbackPanel runat="server" ID="ownerInfoCallbackPanel" ClientInstanceName="ownerInfoCallbackPanel" OnCallback="ownerInfoCallbackPanel_Callback" Height="780px" ScrollBars="Auto" Paddings-Padding="0px">
                                                            <PanelCollection>
                                                                <dx:PanelContent>
                                                                    <table style="width: 100%; margin: 0px; padding: 0px;">
                                                                        <tr>
                                                                            <td style="width: 50%; vertical-align: top">
                                                                                <uc1:HomeOwnerInfo runat="server" ID="HomeOwnerInfo2" />
                                                                            </td>
                                                                            <td style="vertical-align: top">
                                                                                <uc1:HomeOwnerInfo runat="server" ID="HomeOwnerInfo3" />
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                    <dx:ASPxFormLayout ID="formlayoutOwnerInfo" runat="server" Width="100%" Styles-LayoutGroupBox-Caption-Font-Bold="true" Paddings-Padding="0">
                                                                        <Items>
                                                                            <dx:LayoutGroup Caption="Home Owner Info" GroupBoxStyle-Caption-ForeColor="Black" Width="100%" ColCount="2" SettingsItemCaptions-Location="Top" GroupBoxDecoration="None">
                                                                                <GroupBoxStyle>
                                                                                    <Caption ForeColor="Black"></Caption>
                                                                                </GroupBoxStyle>
                                                                                <Items>
                                                                                    <dx:LayoutItem Caption="Owner" FieldName="Owner" ShowCaption="False" VerticalAlign="Top">
                                                                                        <LayoutItemNestedControlCollection>
                                                                                            <dx:LayoutItemNestedControlContainer>
                                                                                            </dx:LayoutItemNestedControlContainer>
                                                                                        </LayoutItemNestedControlCollection>
                                                                                    </dx:LayoutItem>
                                                                                    <dx:LayoutItem Caption="Co-Owner" FieldName="CoOwner" ShowCaption="False" VerticalAlign="Top">
                                                                                        <LayoutItemNestedControlCollection>
                                                                                            <dx:LayoutItemNestedControlContainer>
                                                                                            </dx:LayoutItemNestedControlContainer>
                                                                                        </LayoutItemNestedControlCollection>
                                                                                    </dx:LayoutItem>
                                                                                </Items>
                                                                                <SettingsItemCaptions Location="Top"></SettingsItemCaptions>
                                                                            </dx:LayoutGroup>
                                                                        </Items>
                                                                        <Styles>
                                                                            <LayoutGroupBox>
                                                                                <Caption Font-Bold="True"></Caption>
                                                                            </LayoutGroupBox>
                                                                        </Styles>
                                                                    </dx:ASPxFormLayout>
                                                                </dx:PanelContent>
                                                            </PanelCollection>
                                                        </dx:ASPxCallbackPanel>
                                                    </dx:ContentControl>
                                                </ContentCollection>
                                            </dx:TabPage>
                                            <dx:TabPage Text="Documents" Name="tabFiles">
                                                <ContentCollection>
                                                    <dx:ContentControl>
                                                        <uc1:DocumentsUI runat="server" ID="DocumentsUI" />
                                                    </dx:ContentControl>
                                                </ContentCollection>
                                            </dx:TabPage>
                                        </TabPages>
                                    </dx:ASPxPageControl>
                                    <dx:ASPxPopupMenu ID="ASPxPopupMenu1" runat="server" ClientInstanceName="ASPxPopupMenuPhone"
                                        PopupElementID="numberLink" ShowPopOutImages="false" AutoPostBack="false"
                                        PopupHorizontalAlign="OutsideRight" PopupVerticalAlign="TopSides" PopupAction="LeftMouseClick">
                                        <Items>
                                            <dx:MenuItem GroupName="Sort" Text="Call Phone" Name="Call">
                                            </dx:MenuItem>
                                            <dx:MenuItem GroupName="Sort" Text="# doesn't work" Name="nonWork">
                                            </dx:MenuItem>
                                            <dx:MenuItem GroupName="Sort" Text="Working Phone number" Name="Work">
                                            </dx:MenuItem>
                                              <dx:MenuItem GroupName="Sort" Text="Undo" Name="Undo">
                                            </dx:MenuItem>
                                        </Items>
                                        <ItemStyle Width="143px"></ItemStyle>
                                        <ClientSideEvents ItemClick="OnPhoneNumberClick" />
                                    </dx:ASPxPopupMenu>
                                    <dx:ASPxPopupMenu ID="ASPxPopupMenu2" runat="server" ClientInstanceName="AspxPopupMenuAddress"
                                        ShowPopOutImages="false" AutoPostBack="false"
                                        PopupHorizontalAlign="OutsideRight" PopupVerticalAlign="TopSides" PopupAction="LeftMouseClick">
                                        <Items>
                                            <dx:MenuItem GroupName="Sort" Text="Door knock" Name="doorKnock">
                                            </dx:MenuItem>
                                            <dx:MenuItem GroupName="Sort" Text="Wrong Property" Name="wrongProperty">
                                            </dx:MenuItem>
                                            <dx:MenuItem GroupName="Sort" Text="Correct Property" Name="correctProperty">
                                            </dx:MenuItem>
                                               <dx:MenuItem GroupName="Sort" Text="Undo" Name="Undo">
                                            </dx:MenuItem>
                                        </Items>
                                        <ItemStyle Width="143px"></ItemStyle>
                                        <ClientSideEvents ItemClick="OnAddressPopupMenuClick" />
                                    </dx:ASPxPopupMenu>
                                </div>
                            </dx:SplitterContentControl>
                        </ContentCollection>
                    </dx:SplitterPane>
                    <dx:SplitterPane ShowCollapseForwardButton="True" Name="LogPanel">
                        <Panes>
                            <dx:SplitterPane ShowCollapseBackwardButton="True" PaneStyle-BackColor="#f9f9f9">
                                <PaneStyle BackColor="#F9F9F9"></PaneStyle>
                                <ContentCollection>
                                    <dx:SplitterContentControl ID="SplitterContentControl4" runat="server">
                                        <div id="divLeftContent" style="width: 100%; float: left">
                                            <div style="text-align: right; float: right; margin-bottom: -21px; z-index: 100; margin-right: 15px; position: relative;">
                                                <dx:ASPxButton Text="Schedule" UseSubmitBehavior="false" FocusRectPaddings-PaddingLeft="0" FocusRectPaddings-PaddingRight="0" Paddings-PaddingLeft="0" Paddings-PaddingRight="0" ID="ASPxButton2" Image-Url="/images/upcomming.jpg" AutoPostBack="false" Image-Width="16px" Image-Height="16px" runat="server">
                                                    <FocusRectPaddings PaddingLeft="2" PaddingRight="2" />
                                                    <Image Height="16px" Width="16px" Url="/images/upcomming.jpg"></Image>
                                                    <Paddings PaddingLeft="2" PaddingRight="2" />
                                                    <ClientSideEvents Click="function(s,e){ASPxPopupScheduleClient.ShowAtElement(s.GetMainElement());}" />
                                                </dx:ASPxButton>
                                                <dx:ASPxButton Text="Follow Up" UseSubmitBehavior="false" ID="btnCallBack" Image-Url="/images/callback.png" AutoPostBack="false" Image-Width="16px" Image-Height="16px" runat="server">
                                                    <FocusRectPaddings PaddingLeft="2" PaddingRight="2" />
                                                    <Image Height="16px" Width="16px" Url="/images/callback.png"></Image>
                                                    <Paddings PaddingLeft="2" PaddingRight="2" />
                                                    <ClientSideEvents Click="OnCallBackButtonClick" />
                                                </dx:ASPxButton>
                                                <dx:ASPxButton Text="Door Knock" UseSubmitBehavior="false" Image-Url="/images/door_knocks.jpg" AutoPostBack="false" Image-Width="16px" Image-Height="16px" runat="server">
                                                    <FocusRectPaddings PaddingLeft="2" PaddingRight="2" />

                                                    <Image Height="16px" Width="16px" Url="/images/door_knocks.jpg"></Image>

                                                    <Paddings PaddingLeft="2" PaddingRight="2" />
                                                    <ClientSideEvents Click="function(){SetLeadStatus(4);}" />
                                                </dx:ASPxButton>
                                                <dx:ASPxButton Text="Priority" UseSubmitBehavior="false" Image-Url="/images/priority.jpg" AutoPostBack="false" Image-Width="16px" Image-Height="16px" runat="server">
                                                    <FocusRectPaddings PaddingLeft="2" PaddingRight="2" />

                                                    <Image Height="16px" Width="16px" Url="/images/priority.jpg"></Image>

                                                    <Paddings PaddingLeft="2" PaddingRight="2" />
                                                    <ClientSideEvents Click="function(){SetLeadStatus(5);}" />
                                                </dx:ASPxButton>
                                                <dx:ASPxButton Text="Print" UseSubmitBehavior="false" Image-Url="/images/imprimir.png" Image-Width="16px" AutoPostBack="false" Image-Height="16px" runat="server">
                                                    <FocusRectPaddings PaddingLeft="2" PaddingRight="2" />
                                                    <Image Height="16px" Width="16px" Url="/images/imprimir.png"></Image>
                                                    <Paddings PaddingLeft="2" PaddingRight="2" />
                                                    <ClientSideEvents Click="function(){PrintLogInfo(formlayoutActivityLogClient);}" />
                                                </dx:ASPxButton>
                                            </div>
                                            <uc1:ActivityLogs runat="server" ID="ActivityLogs" />
                                        </div>
                                        <dx:ASPxCallback ID="leadStatusCallback" runat="server" ClientInstanceName="leadStatusCallbackClient" OnCallback="leadStatusCallback_Callback">
                                            <ClientSideEvents CallbackComplete="OnSetStatusComplete" />
                                        </dx:ASPxCallback>
                                        <dx:ASPxCallback ID="callPhoneCallback" runat="server" ClientInstanceName="callPhoneCallbackClient" OnCallback="callPhoneCallback_Callback">
                                            <ClientSideEvents CallbackComplete="OnCallPhoneCallbackComplete" />
                                        </dx:ASPxCallback>
                                        <dx:ASPxPopupMenu ID="ASPxPopupCallBackMenu2" runat="server" ClientInstanceName="ASPxPopupMenuClientControl"
                                            AutoPostBack="false" PopupHorizontalAlign="LeftSides" PopupVerticalAlign="Below" PopupAction="LeftMouseClick">
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
                                            <ItemStyle Width="143px"></ItemStyle>
                                        </dx:ASPxPopupMenu>

                                        <dx:ASPxPopupControl ClientInstanceName="ASPxPopupSelectDateControl" Width="260px" Height="250px"
                                            MaxWidth="800px" MaxHeight="800px" MinHeight="150px" MinWidth="150px" ID="pcMain"
                                            HeaderText="Select Date" Modal="true"
                                            runat="server" EnableViewState="false" PopupHorizontalAlign="LeftSides" PopupVerticalAlign="Below" EnableHierarchyRecreation="True">
                                            <ContentCollection>
                                                <dx:PopupControlContentControl runat="server">
                                                    <asp:Panel ID="Panel1" runat="server">
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <dx:ASPxCalendar ID="ASPxCalendar1" runat="server" ClientInstanceName="callbackCalendar" ShowClearButton="False" ShowTodayButton="False"></dx:ASPxCalendar>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="color: #666666; font-family: Tahoma; font-size: 10px; align-content: center; text-align: center; padding-top: 2px;">
                                                                    <dx:ASPxButton ID="ASPxButton1" runat="server" Text="OK" AutoPostBack="false" ClientSideEvents-Click="function(){ASPxPopupSelectDateControl.Hide();}">
                                                                        <ClientSideEvents Click="function(){
                                                                                                                        ASPxPopupSelectDateControl.Hide();                                                                                                                       
                                                                                                                        SetLeadStatus('customDays');
                                                                                                                        }"></ClientSideEvents>
                                                                    </dx:ASPxButton>
                                                                    &nbsp;
                                                            <dx:ASPxButton runat="server" Text="Cancel" AutoPostBack="false">
                                                                <ClientSideEvents Click="function(){
                                                                                                                        ASPxPopupSelectDateControl.Hide();                                                                                                                                                                                                                                               
                                                                                                                        }"></ClientSideEvents>

                                                            </dx:ASPxButton>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </asp:Panel>
                                                </dx:PopupControlContentControl>
                                            </ContentCollection>
                                        </dx:ASPxPopupControl>
                                        <dx:ASPxPopupControl ClientInstanceName="ASPxPopupScheduleClient" Width="400px" Height="280px"
                                            MaxWidth="800px" MaxHeight="800px" MinHeight="150px" MinWidth="150px" ID="ASPxPopupControl1"
                                            HeaderText="Appointment" Modal="true"
                                            runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
                                            <ContentCollection>
                                                <dx:PopupControlContentControl runat="server">
                                                    <dx:ASPxCallbackPanel runat="server" ID="appointmentCallpanel" ClientInstanceName="appointmentCallpanel" OnCallback="appointmentCallpanel_Callback">
                                                        <PanelCollection>
                                                            <dx:PanelContent>
                                                                <dx:ASPxHiddenField runat="server" ID="HiddenFieldLogId" ClientInstanceName="hfLogIDClient"></dx:ASPxHiddenField>
                                                                <dx:ASPxFormLayout ID="formLayout" runat="server" Width="100%">
                                                                    <Items>
                                                                        <dx:LayoutItem Caption="Type">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                                                    <dx:ASPxComboBox runat="server" Width="100%" DropDownStyle="DropDown" ID="cbScheduleType">
                                                                                        <Items>
                                                                                            <dx:ListEditItem Text="Consultation" Value="Consultation" />
                                                                                            <dx:ListEditItem Text="Signing" Value="Signing" />
                                                                                        </Items>
                                                                                    </dx:ASPxComboBox>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="Date">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                                                    <dx:ASPxDateEdit runat="server" EditFormatString="g" Width="100%" ID="dateEditSchedule" ClientInstanceName="ScheduleDateClientCtr" TimeSectionProperties-Visible="True">
                                                                                        <TimeSectionProperties Visible="True"></TimeSectionProperties>
                                                                                        <ClientSideEvents DropDown="function(s,e){ 
                                                                    var d = new Date('May 1 2014 12:00:00');                                                                    
                                                                    s.GetTimeEdit().SetValue(d);
                                                                    }" />
                                                                                    </dx:ASPxDateEdit>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="Location">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                                                    <dx:ASPxTextBox ID="txtLocation" runat="server" Width="100%" Text="In Office"></dx:ASPxTextBox>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="Manager">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                                                    <dx:ASPxComboBox runat="server" Width="100%" ID="cbMgr">
                                                                                        <Items>
                                                                                            <dx:ListEditItem Text="Any Manager" Value="*" />
                                                                                            <dx:ListEditItem Text="Ron Borovinsky" Value="Ron Borovinsky" />
                                                                                            <dx:ListEditItem Text="Michael Gendin" Value="Michael Gendin" />
                                                                                            <dx:ListEditItem Text="Allen Glover" Value="Allen Glover" />
                                                                                            <dx:ListEditItem Text="No Manager Needed" Value="" />
                                                                                        </Items>
                                                                                    </dx:ASPxComboBox>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="Comments">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                                                    <dx:ASPxMemo runat="server" ID="txtScheduleDescription" Width="100%" Height="180px" ClientInstanceName="ScheduleCommentsClientCtr"></dx:ASPxMemo>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                    </Items>
                                                                </dx:ASPxFormLayout>
                                                                <table style="width: 100%">
                                                                    <tr>
                                                                        <td style="color: #666666; font-family: Tahoma; font-size: 10px; align-content: center; text-align: center; padding-top: 2px;">
                                                                            <dx:ASPxButton ID="ASPxButton3" runat="server" Text="OK" AutoPostBack="false">
                                                                                <ClientSideEvents Click="OnSaveAppointment"></ClientSideEvents>
                                                                            </dx:ASPxButton>
                                                                            &nbsp;
                                                            <dx:ASPxButton runat="server" Text="Cancel" AutoPostBack="false">
                                                                <ClientSideEvents Click="function(){
                                                                                                                        ASPxPopupScheduleClient.Hide();                                                                                                                                                                                                                                               
                                                                                                                        }"></ClientSideEvents>

                                                            </dx:ASPxButton>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </dx:PanelContent>
                                                        </PanelCollection>
                                                    </dx:ASPxCallbackPanel>
                                                </dx:PopupControlContentControl>
                                            </ContentCollection>
                                        </dx:ASPxPopupControl>
                                    </dx:SplitterContentControl>
                                </ContentCollection>
                            </dx:SplitterPane>
                        </Panes>
                        <ContentCollection>
                            <dx:SplitterContentControl runat="server" SupportsDisabledAttribute="True"></dx:SplitterContentControl>
                        </ContentCollection>
                    </dx:SplitterPane>
                </Panes>
            </dx:ASPxSplitter>
            <dx:ASPxPopupControl ClientInstanceName="AspxPopupShareleadClient" Width="260px" Height="400px" ID="aspxPopupShareleads"
                HeaderText="Share Lead" Modal="true" ContentUrl="~/PopupControl/ShareLeads.aspx"
                runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
            </dx:ASPxPopupControl>
            <dx:ASPxPopupControl ClientInstanceName="aspxPopupAddPhoneNum" Width="200px" Height="80px" ID="ASPxPopupControl2"
                HeaderText="Add Phone Number" ShowHeader="false"
                runat="server" EnableViewState="false" PopupHorizontalAlign="LeftSides" PopupVerticalAlign="Below" EnableHierarchyRecreation="True">
                <ContentCollection>
                    <dx:PopupControlContentControl>
                        <table>
                            <tr>
                                <td>Phone No.:</td>
                            </tr>
                            <tr style="padding-top: 3px;">
                                <td>
                                    <dx:ASPxTextBox runat="server" ID="txtPhoneNo" ClientInstanceName="txtPhoneNoClient"></dx:ASPxTextBox>
                                </td>
                            </tr>
                            <tr style="margin-top: 3px; line-height: 30px;">
                                <td>
                                    <dx:ASPxButton runat="server" ID="btnAdd" Text="Add" AutoPostBack="false">
                                        <ClientSideEvents Click="SaveBestPhoneNo" />
                                    </dx:ASPxButton>
                                    &nbsp;
                                                                <dx:ASPxButton runat="server" ID="ASPxButton4" Text="Close" AutoPostBack="false">
                                                                    <ClientSideEvents Click="function(s,e){aspxPopupAddPhoneNum.Hide();}" />
                                                                </dx:ASPxButton>
                                </td>
                            </tr>
                        </table>
                    </dx:PopupControlContentControl>
                </ContentCollection>
            </dx:ASPxPopupControl>
        </dx:PanelContent>
    </PanelCollection>
    <ClientSideEvents EndCallback="OnEndCallback"></ClientSideEvents>
    <Border BorderStyle="None"></Border>
</dx:ASPxCallbackPanel>
