<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PropertyMap.aspx.vb" Inherits="IntranetPortal.PropertyMap" Title="Property Map" MasterPageFile="~/Content.Master" %>

<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <script type="text/javascript">

        var tmpBBLE = '<%= Page.Request.QueryString("bble")%>';

        function popupControlMapTabClick(index) {
            if (index == 0) {
                if (tmpBBLE != null) {
                    var url = "/StreetView.aspx?bble=" + tmpBBLE;
                    SetPopupControlMapURL(url);
                }
            }

            if (index == 1) {
                if (tmpBBLE != null) {
                    var url = "/StreetView.aspx?t=map&bble=" + tmpBBLE;
                    SetPopupControlMapURL(url);
                }
            }

            if (index == 2) {
                if (tmpBBLE != null) {
                    var url = "/BingViewMap.aspx";
                    SetPopupControlMapURL(url);
                }
            }

            if (index == 3) {
                if (tmpBBLE != null) {
                    var url = "http://www.oasisnyc.net/map.aspx?zoomto=lot:" + tmpBBLE;

                    SetPopupControlMapURL(url);
                }
            }

            if (index == 4) {
                if (tmpBBLE != null) {
                    var url = "http://gis.nyc.gov/doitt/nycitymap/template?applicationName=ZOLA";
                    SetPopupControlMapURL(url);
                }
            }
        }

        function SetPopupControlMapURL(url) {
            var pane = contentSplitter.GetPaneByName("mapPane");
            pane.SetContentUrl(url);
        }

    </script>

    <dx:ASPxSplitter ID="contentSplitter" PaneStyle-BackColor="#f9f9f9" runat="server" FullscreenMode="true" ClientInstanceName="contentSplitter" Orientation="Vertical">
        <Styles>
            <Pane Paddings-Padding="0">
                <Paddings Padding="0px"></Paddings>
            </Pane>
        </Styles>
        <Panes>
            <dx:SplitterPane ShowCollapseBackwardButton="false" MinSize="50" AutoHeight="true" Name="topTab">
                <ContentCollection>
                    <dx:SplitterContentControl>
                        <% If DisplayView = ViewType.PropertyMap Then%>
                        <ul class="nav nav-tabs" style="border: 0px" role="tablist">
                            <li class="active"><a href="#streetView" class="popup_tab_text" role="tab" data-toggle="tab" onclick="popupControlMapTabClick(0)">Street View</a></li>
                            <li class=""><a href="#mapView" role="tab" class="popup_tab_text" data-toggle="tab" onclick="popupControlMapTabClick(1)">Map View</a></li>
                            <li class=""><a href="#BingBird" role="tab" class="popup_tab_text" data-toggle="tab" onclick="popupControlMapTabClick(2)">Bing Bird</a></li>
                            <li class=""><a href="#Oasis" role="tab" class="popup_tab_text" data-toggle="tab" onclick="popupControlMapTabClick(3)">Oasis</a></li>
                            <li class=""><a href="#ZOLA" role="tab" class="popup_tab_text" data-toggle="tab" onclick="popupControlMapTabClick(4)">ZOLA</a></li>
                        </ul>

                        <!-- Tab panes -->
                        <div class="tab-content" style="display: none">
                            <div class="tab-pane active" id="streetView">streetView</div>
                            <div class="tab-pane" id="mapView">mapView</div>
                            <div class="tab-pane" id="BingBird">BingBird</div>
                            <div class="tab-pane" id="Oasis">Oasis</div>
                            <div class="tab-pane" id="ZOLA">ZOLA</div>
                        </div>
                        <% End If%>

                        <% If DisplayView = ViewType.Acris Then%>
                        <div class="clearfix">
                            <div class="pop_up_header_margin">
                                <i class="fa fa-tasks with_circle pop_up_header_icon"></i>
                                <% Dim ld = IntranetPortal.LeadsInfo.GetInstance(Request.QueryString("bble"))%>
                                <% If ld IsNot Nothing Then%>
                                <span class="pop_up_header_text"><%= ld.PropertyAddress%>&nbsp;-&nbsp;(Borough: <%=  ld.BoroughName %> , Block:<%=ld.Block %> ,Lot:<%=ld.Lot %>)  </span>                              
                                <% End If%>
                            </div>                           
                        </div>
                        <% End If%>
                    </dx:SplitterContentControl>
                </ContentCollection>
            </dx:SplitterPane>
            <dx:SplitterPane ContentUrl="about:blank" Name="mapPane" ScrollBars="Auto">
                <Separator Visible="False"></Separator>
            </dx:SplitterPane>
        </Panes>
        <ClientSideEvents />
    </dx:ASPxSplitter>
</asp:Content>
