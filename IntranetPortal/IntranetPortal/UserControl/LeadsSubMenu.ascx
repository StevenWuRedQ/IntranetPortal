<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LeadsSubMenu.ascx.vb" Inherits="IntranetPortal.LeadsSubMenu" %>
 <script type="text/javascript" src="/scripts/LeadsSubMenu.js"></script>
<dx:ASPxPopupMenu ID="popupMenuLeads" runat="server" ClientInstanceName="ASPxPopupMenuCategory"  PopupHorizontalAlign="Center" PopupVerticalAlign="Below" PopupAction="MouseOver" ForeColor="#3993c1" Font-Size="14px" CssClass="fix_pop_postion_s" Paddings-PaddingTop="15px" Paddings-PaddingBottom="18px">
    <Items>
        <dx:MenuItem GroupName="Sort" Text="View Map" Name="GoogleStreet">
            <Image Url="/images/drap_map_icons.png"></Image>
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
        <dx:MenuItem GroupName="Sort" Text="Delete" Name="Delete" Visible="false">
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
    <ClientSideEvents ItemClick="OnLeadsCategoryClick" />
    <ItemStyle Height="30px"></ItemStyle>
</dx:ASPxPopupMenu>

 <dx:ASPxPopupControl ClientInstanceName="ASPxPopupMapControl" Width="900px" Height="700px"
        ID="ASPxPopupControl1"
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
                    <li class="active"><a href="#streetView" class="popup_tab_text" role="tab" data-toggle="tab" onclick="popupControlMapTabClick(0)">Street View</a></li>
                    <li><a href="#mapView" role="tab" class="popup_tab_text" data-toggle="tab" onclick="popupControlMapTabClick(1)">Map View</a></li>
                    <li><a href="#BingBird" role="tab" class="popup_tab_text" data-toggle="tab" onclick="popupControlMapTabClick(2)">Bing Bird</a></li>
                    <li><a href="#Oasis" role="tab" class="popup_tab_text" data-toggle="tab" onclick="popupControlMapTabClick(3)">Oasis</a></li>
                    <li><a href="#ZOLA" role="tab" class="popup_tab_text" data-toggle="tab" onclick="popupControlMapTabClick(4)">ZOLA</a></li>
                </ul>

                <!-- Tab panes -->
                <div class="tab-content" style="display: none">
                    <div class="tab-pane active" id="streetView">streetView</div>
                    <div class="tab-pane" id="mapView">mapView</div>
                    <div class="tab-pane" id="BingBird">BingBird</div>
                    <div class="tab-pane" id="Oasis">Oasis</div>
                    <div class="tab-pane" id="ZOLA">ZOLA</div>
                </div>               
            </div>
        </HeaderTemplate>
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">            
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
<dx:ASPxCallback ID="leadStatusCallback" runat="server" ClientInstanceName="leadStatusCallbackClient" OnCallback="leadStatusCallback_Callback">
    <ClientSideEvents CallbackComplete="OnSetStatusComplete" />
</dx:ASPxCallback>
<dx:ASPxCallback runat="server" ClientInstanceName="getAddressCallback" ID="getAddressCallback" OnCallback="getAddressCallback_Callback" ClientSideEvents-CallbackError="OnGetAddressCallbackError">
    <ClientSideEvents CallbackComplete="OnGetAddressCallbackComplete" />
</dx:ASPxCallback>