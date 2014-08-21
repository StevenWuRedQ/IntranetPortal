<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LeadsSubMenu.ascx.vb" Inherits="IntranetPortal.LeadsSubMenu" %>
 <script type="text/javascript" src="/scripts/LeadsSubMenu.js"></script>
<dx:ASPxPopupMenu ID="popupMenuLeads" runat="server" ClientInstanceName="ASPxPopupMenuCategory"  PopupHorizontalAlign="Center" PopupVerticalAlign="Below" PopupAction="MouseOver" ForeColor="#3993c1" Font-Size="14px" CssClass="fix_pop_postion_s" Paddings-PaddingTop="15px" Paddings-PaddingBottom="18px">
    <Items>
        <dx:MenuItem GroupName="Sort" Text="View Map" Name="GoogleStreet">
            <Image Url="../images/drap_map_icons.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Google Map View" Name="GoogleMap" Image-Url="../images/drap_map_icons.png" ClientVisible="false">
            <Image Url="../images/drap_map_icons.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Bing Bird View" Name="BingBird" Image-Url="../images/drap_map_icons.png" ClientVisible="false">
            <Image Url="../images/drap_map_icons.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Priority" Name="Priority" Image-Url="../images/drap_prority_icons.png">
            <Image Url="../images/drap_prority_icons.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Door Knock" Name="DoorKnock" Image-Url="../images/drap_prority_icons.png">
            <Image Url="../images/drap_doorknock_icons.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Follow Up" Name="Callback" Image-Url="../images/drap_follow_up_icons.png">
            <Image Url="../images/drap_follow_up_icons.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Dead Lead" Name="DeadLead" Image-Url="../images/drap_deadlead_icons.png">
            <Image Url="../images/drap_deadlead_icons.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="In Process" Name="InProcess" Image-Url="../images/drap_inprocess_icons.png">
            <Image Url="../images/drap_inprocess_icons.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="View Lead" Name="ViewLead" Visible="false">
            <Image IconID="miscellaneous_viewonweb_16x16"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Closed" Name="Closed" Image-Url="../images/drap_closed_icons.png">
            <Image Url="../images/drap_closed_icons.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Delete" Name="Delete" Visible="false">
            <Image Url="../images/drap_closed_icons.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Reassign" Name="Reassign" Visible="false">
            <Image Url="/images/assigned.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="View Files" Name="ViewFiles">
            <Image Url="../images/drap_viewfile_icons.png"></Image>
        </dx:MenuItem>
        <dx:MenuItem GroupName="Sort" Text="Upload Docs/Pics" Name="Upload">
            <Image Url="../images/drap_upload_icons.png"></Image>
        </dx:MenuItem>
    </Items>
    <ClientSideEvents ItemClick="OnLeadsCategoryClick" />
    <ItemStyle Height="30px"></ItemStyle>
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