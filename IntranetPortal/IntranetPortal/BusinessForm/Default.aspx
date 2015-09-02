<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="Default.aspx.vb" Inherits="IntranetPortal.BusinessFormDefault" %>

<%@ Register Src="~/UserControl/DocumentsUI.ascx" TagPrefix="uc1" TagName="DocumentsUI" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <dx:ASPxSplitter ID="contentSplitter" runat="server" Height="100%" Width="100%" ClientInstanceName="splitter" Orientation="Horizontal" FullscreenMode="true">
        <Panes>
            <%-- list panel  --%>
            <dx:SplitterPane Name="listPanel" ShowCollapseBackwardButton="True" MinSize="100px" MaxSize="400px" Size="280px" PaneStyle-Paddings-Padding="0">
                <PaneStyle>
                    <Paddings Padding="0px"></Paddings>
                </PaneStyle>
                <ContentCollection>
                    <dx:SplitterContentControl ID="SplitterContentControl1" runat="server">
                    </dx:SplitterContentControl>
                </ContentCollection>
            </dx:SplitterPane>
            <%-- data panel     --%>
            <dx:SplitterPane ShowCollapseBackwardButton="True" ScrollBars="None" PaneStyle-Paddings-Padding="0px" Name="dataPane">
                <PaneStyle>
                    <Paddings Padding="0px"></Paddings>
                </PaneStyle>
                <ContentCollection>
                    <dx:SplitterContentControl>
                        <div class="legal-menu row" style="margin: 0px;">
                            <ul class="nav nav-tabs clearfix" role="tablist" style="background: #ff400d; font-size: 18px; color: white; height: 70px">
                                <asp:Repeater runat="server" ID="rptTopmenu">
                                    <ItemTemplate>
                                        <li class="<%# ActivieTab(Container.ItemIndex)%> short_sale_head_tab">
                                            <a href='#<%#Eval("Name")%>' role="tab" data-toggle="tab" class="tab_button_a">
                                                <i class="fa fa-info-circle  head_tab_icon_padding"></i>
                                                <div class="font_size_bold"><%# Eval("Name")%></div>
                                            </a>
                                        </li>
                                    </ItemTemplate>
                                </asp:Repeater>
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
                                    <i class="fa fa-save sale_head_button sale_head_button_left tooltip-examples" title="" onclick="FormControl.SaveData()" data-original-title="Save"></i>
                                    <i class="fa fa-envelope sale_head_button sale_head_button_left tooltip-examples" title="" onclick="ShowEmailPopup(leadsInfoBBLE)" data-original-title="Mail"></i>
                                    <i class="fa fa-print sale_head_button sale_head_button_left tooltip-examples" title="" onclick="" data-original-title="Print"></i>
                                </li>
                            </ul>
                        </div>
                        <div class="tab-content">
                            <asp:Repeater runat="server" ID="rptBusinessControl" OnItemDataBound="rptBusinessControl_ItemDataBound">
                                <ItemTemplate>
                                    <div class="<%# ActivieTab(Container.ItemIndex)%> tab-pane" id="<%# Eval("Name")%>">
                                        <asp:Panel runat="server" ID="pnlHolder">
                                        </asp:Panel>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
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

                         <script type="text/javascript">
                             var FormControl = {
                                 CurrentTab: null,
                                 InitTab: function (tab) {
                                     if (typeof tab != "undefined") {
                                         currentTab = tab;
                                     }
                                 },
                                 LoadData: function (dataId) {
                                     var tab = this.CurrentTab;
                                     var url = "/api/BusinessForm/" + dataId
                                     $.ajax({
                                         type: "GET",
                                         url: url,
                                         dataType: 'json',
                                         success: function (data) {
                                             angular.element($('#' + tab.CurrentTab + 'Controller')).scope().Load(data);                                             
                                         },
                                         error: function (data) {
                                             alert("Failed to load data." + data)
                                         }
                                     });
                                 },
                                 SaveData: function () {
                                     var tab = this.CurrentTab;
                                     var data = angular.element($('#' + tab.CurrentTab + 'Controller')).scope().Get();

                                     var url = "/api/BusinessForm/"
                                     $.ajax({
                                         type: "POST",
                                         url: url,
                                         data:data,
                                         dataType: 'json',
                                         success: function (data) {
                                             alert("Save successful.")
                                         },
                                         error: function (data) {
                                             alert("Failed to save data." + data);
                                         }
                                     });
                                 }
                             }

                             $(function () {
                                 FormControl.InitTab('<%= FormData.DefaultControl.Name%>');
                             });
                        </script>

                    </dx:SplitterContentControl>
                </ContentCollection>
            </dx:SplitterPane>
        </Panes>
    </dx:ASPxSplitter>



</asp:Content>
