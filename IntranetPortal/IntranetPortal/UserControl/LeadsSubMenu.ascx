<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LeadsSubMenu.ascx.vb" Inherits="IntranetPortal.LeadsSubMenu" %>
 <script type="text/javascript" src="/scripts/LeadsSubMenu.js"></script>
<dx:ASPxPopupMenu ID="popupMenuLeads" runat="server" ClientInstanceName="ASPxPopupMenuCategory" PopupHorizontalAlign="OutsideLeft" PopupVerticalAlign="TopSides" PopupAction="LeftMouseClick" ItemImage-Height="16" ItemImage-Width="16">
    <Items>
        <dx:MenuItem GroupName="Sort" Text="View Map" Name="GoogleStreet">
            <Image Url="/images/Street-view.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Google Map View" Name="GoogleMap" Image-Url="/images/Street-view.png" ClientVisible="false">
            <Image Url="/images/Street-view.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Bing Bird View" Name="BingBird" Image-Url="/images/Street-view.png" ClientVisible="false">
            <Image Url="/images/Street-view.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Priority" Name="Priority" Image-Url="/images/priority.jpg">
            <Image Url="/images/priority.jpg"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Door Knock" Name="DoorKnock" Image-Url="/images/door_knocks.png">
            <Image Url="/images/door_knocks.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Follow Up" Name="Callback" Image-Url="/images/callback.png">
            <Image Url="/images/callback.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Dead Lead" Name="DeadLead" Image-Url="/images/dead.png">
            <Image Url="/images/dead.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="In Process" Name="InProcess" Image-Url="/images/process-icon2.jpg">
            <Image Url="/images/process-icon2.jpg"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="View Lead" Name="ViewLead" Visible="false">
            <Image IconID="miscellaneous_viewonweb_16x16"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Closed" Name="Closed" Image-Url="/images/Closed.png">
            <Image Url="/images/Closed.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Delete" Name="Delete" Visible="false">
            <Image IconID="edit_delete_16x16"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Reassign" Name="Reassign" Visible="false">
            <Image Url="/images/assigned.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="View Files" Name="ViewFiles">
            <Image IconID="mail_attach_16x16"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Upload Docs/Pics" Name="Upload">
            <Image IconID="print_preview_16x16"></Image>
        </dx:MenuItem>
    </Items>
    <ClientSideEvents ItemClick="OnLeadsCategoryClick" />
    <ItemImage Height="16px" Width="16px"></ItemImage>
    <ItemStyle Width="143px"></ItemStyle>
</dx:ASPxPopupMenu>
<dx:ASPxCallback runat="server" ClientInstanceName="getAddressCallback" ID="getAddressCallback" OnCallback="getAddressCallback_Callback" ClientSideEvents-CallbackError="OnGetAddressCallbackError">
    <ClientSideEvents CallbackComplete="OnGetAddressCallbackComplete" />
</dx:ASPxCallback>
<dx:ASPxPopupControl ClientInstanceName="ASPxPopupMapControl" Width="500px" Height="500px"
    MaxWidth="800px" MaxHeight="800px" MinHeight="150px" MinWidth="150px" ID="ASPxPopupControl1"
    HeaderText="Street View" AutoUpdatePosition="true" Modal="true"
    runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
     <HeaderTemplate>
            <div>
                <div style="float: right; position: relative; margin-right: 10px; margin-bottom:-27px;">
                    <dx:ASPxImage ID="img" runat="server" ImageUrl="~/images/x_close.png" Height="15" Width="14" Cursor="pointer" AlternateText="[Close]">
                        <ClientSideEvents Click="function(s, e){
                        ASPxPopupMapControl.Hide();
                    }" />
                    </dx:ASPxImage>
                </div>
                <dx:ASPxTabControl ID="ASPxTabControl1" runat="server" Width="100%">
                    <Tabs>
                        <dx:Tab Text="Street View" Name="streetView" />
                        <dx:Tab Text="Map View" Name="mapView" />
                        <dx:Tab Text="Bing Bird" Name="BingBird" />
                    </Tabs>
                    <ClientSideEvents ActiveTabChanged="PopupControlMapTabChange" />
                </dx:ASPxTabControl>
            </div>
        </HeaderTemplate>
    <ContentCollection>
        <dx:PopupControlContentControl runat="server">
            <iframe width="950" height="650" id="streetViewFrm" frameborder="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
        </dx:PopupControlContentControl>
    </ContentCollection>
</dx:ASPxPopupControl>
<dx:ASPxCallback ID="leadStatusCallback" runat="server" ClientInstanceName="leadStatusCallbackClient" OnCallback="leadStatusCallback_Callback">
    <ClientSideEvents CallbackComplete="OnSetStatusComplete" />
</dx:ASPxCallback>