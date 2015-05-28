<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="PropertyLinks.ascx.vb" Inherits="IntranetPortal.PropertyLinks" %>
<script type="text/javascript">
    function ShowAcrisMap(propBBLE) {
        //var url = "http://www.oasisnyc.net/map.aspx?zoomto=lot:" + propBBLE;
        ShowPopupMap("https://a836-acris.nyc.gov/DS/DocumentSearch/BBL", "Acris");
        $("#addition_info").html($("#borugh_block_lot_data").val());
    }

    function ShowDOBWindow(boro, block, lot) {
        if (block == null || block == "" || lot == null || lot == "" || boro == null || boro == "") {
            alert("The property info isn't complete. Please try to refresh data.");
            return;
        }

        var url = "http://a810-bisweb.nyc.gov/bisweb/PropertyProfileOverviewServlet?boro=" + boro + "&block=" + encodeURIComponent(block) + "&lot=" + encodeURIComponent(lot);
        ShowPopupMap(url, "DOB");
        $("#addition_info").html(' ');
    }

    function ShowPopupMap(url, header) {
        if (header == "eCourts") {
            $("#addition_info").html($('#LinesDefendantAndIndex').val());
        }

        aspxAcrisControl.SetContentHtml("Loading...");
        aspxAcrisControl.SetContentUrl(url);
        aspxAcrisControl.SetHeaderText(header);
        $('#pop_up_header_text').html(header);
        aspxAcrisControl.Show();
    }
    
    function SaveLeadsComments(s, e) {
        var comments = txtLeadsComments.GetText();
        leadsCommentsCallbackPanel.PerformCallback("Add|" + comments);
        txtLeadsComments.SetText("");
        aspxAddLeadsComments.Hide();
    }

    function ShowDiv() {
        var display = document.getElementById("divOtherProperties").style.display;

        if (display == "block") {
            document.getElementById("divOtherProperties").style.display = "none";
        }
        else
            document.getElementById("divOtherProperties").style.display = "block";
    }

    function DeleteComments(commentId) {
        leadsCommentsCallbackPanel.PerformCallback("Delete|" + commentId);
    }
    
    function openZoningUrl(zoingcode) {
        window.open("http://www.nyc.gov/html/dcp/pdf/zone/zoning_handbook/" + zoingcode + ".pdf");
    }
    //init_currency();
</script>

<input type="hidden" id="borugh_block_lot_data" value='(Borough: <%=  LeadsInfoData.BoroughName %> , Block:<%=LeadsInfoData.Block %> ,Lot:<%=LeadsInfoData.Lot %>)' />
<input type="hidden" id="LinesDefendantAndIndex" value='<%= LinesDefendantAndIndex()%>' />
<dx:ASPxPopupControl ClientInstanceName="aspxAcrisControl" Width="1000px" Height="800px"
    ID="ASPxPopupControl1" HeaderText="Acris" Modal="true" CloseAction="CloseButton" ShowMaximizeButton="true"
    runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
    <HeaderTemplate>
        <div class="clearfix">
            <div class="pop_up_header_margin">
                <i class="fa fa-tasks with_circle pop_up_header_icon"></i>
                <span class="pop_up_header_text" id="pop_up_header_text">Acris</span> <span class="pop_up_header_text"><%= LeadsInfoData.PropertyAddress%> </span>
            </div>
            <div class="pop_up_buttons_div">
                <i class="fa fa-times icon_btn" onclick="aspxAcrisControl.Hide()"></i>
            </div>
        </div>
        <div style="text-align: center" id="addition_info"></div>
    </HeaderTemplate>
    <ContentCollection>
        <dx:PopupControlContentControl runat="server">
        </dx:PopupControlContentControl>
    </ContentCollection>
</dx:ASPxPopupControl>

<dx:ASPxPopupControl ClientInstanceName="aspxAddLeadsComments" Width="550px" Height="50px" ID="ASPxPopupControl2"
    HeaderText="Add Comments" ShowHeader="false"
    runat="server" EnableViewState="false" PopupHorizontalAlign="OutsideRight" PopupVerticalAlign="Middle" EnableHierarchyRecreation="True">
    <ContentCollection>
        <dx:PopupControlContentControl>
            <table>
                <tr style="padding-top: 3px;">
                    <td style="width: 380px; vertical-align: central">
                        <dx:ASPxTextBox runat="server" ID="txtLeadsComments" ClientInstanceName="txtLeadsComments" Width="360px"></dx:ASPxTextBox>
                    </td>
                    <td style="text-align: right">
                        <div>
                            <dx:ASPxButton runat="server" ID="btnAdd" Text="Add" AutoPostBack="false" CssClass="rand-button" BackColor="#3993c1">
                                <ClientSideEvents Click="SaveLeadsComments" />
                            </dx:ASPxButton>
                            &nbsp;
                                    <dx:ASPxButton runat="server" ID="ASPxButton4" Text="Close" AutoPostBack="false" CssClass="rand-button" BackColor="#77787b">
                                        <ClientSideEvents Click="function(s,e){aspxAddLeadsComments.Hide();}" />
                                    </dx:ASPxButton>
                        </div>

                    </td>
                </tr>
            </table>
        </dx:PopupControlContentControl>
    </ContentCollection>
</dx:ASPxPopupControl>
