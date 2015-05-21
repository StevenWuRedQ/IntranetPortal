﻿<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LegalTab.ascx.vb" Inherits="IntranetPortal.LegalTab" %>
<%@ Register TagPrefix="uc1" TagName="legalsecondaryactions" Src="~/LegalUI/LegalSecondaryActions.ascx" %>
<%@ Register Src="~/LegalUI/LegalSummaryTab.ascx" TagPrefix="uc1" TagName="LegalSummaryTab" %>
<%@ Register Src="~/LegalUI/LegalForeclosureReviewTab.ascx" TagPrefix="uc1" TagName="LegalForeclosureReviewTab" %>
<%@ Register Src="~/LegalUI/LegalSecondaryActionTab.ascx" TagPrefix="uc1" TagName="LegalSecondaryActionTab" %>



<script type="text/javascript">

    $(document).ready(function () {
        // Handler for .ready() called.
        format_input();
        $(".ss_phone").each(function (index) {
            format_phone(this);
        });
    });
    var short_sale_case_data = null;
    function ShowSelectParty() {
        VendorsPopupClient.Show();
    }
    function getShortSaleInstanceComplete(s, e) {
        debugger;
        short_sale_case_data = e != null ? $.parseJSON(e.result) : ShortSaleCaseData; //ShortSaleCaseData;//;
        ShortSaleCaseData = short_sale_case_data;
        short_sale_case_data.PropertyInfo.UpdateBy = "Chris Yan";


        ShortSaleDataBand(1);

        clearHomeOwner();
        //console.log("the data is give to save is 222", JSON.stringify(ShortSaleCaseData));
        var strJson = JSON.stringify(ShortSaleCaseData);

        //d_alert(strJson);
        if (e == null) {
            SaveClicklCallbackCallbackClinet.PerformCallback(strJson);
        }

    }
    function saveComplete(s, e) {
        //RefreshContent();
        ShortSaleCaseData = $.parseJSON(e.result);
        clearArray(ShortSaleCaseData.Mortgages);
        clearArray(ShortSaleCaseData.PropertyInfo.Owners);

        ShortSaleDataBand(2);

    }

    function ShowAcrisMap(propBBLE) {
        //var url = "http://www.oasisnyc.net/map.aspx?zoomto=lot:" + propBBLE;
        ShowPopupMap("https://a836-acris.nyc.gov/DS/DocumentSearch/BBL", "Acris");
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
        aspxAcrisControl.SetContentHtml("Loading...");
        aspxAcrisControl.SetContentUrl(url);

        aspxAcrisControl.SetHeaderText(header);
        //header = header + "(Borough:" + ShortSaleCaseData.PropertyInfo.Borough + "Lot:" + ShortSaleCaseData.PropertyInfo.Lot + ")";
        $('#pop_up_header_text').html(header)
        aspxAcrisControl.Show();
    }

    function SaveLeadsComments(s, e) {
        var comments = txtLeadsComments.GetText();
        leadsCommentsCallbackPanel.PerformCallback("Add|" + comments);
        txtLeadsComments.SetText("");
        aspxAddLeadsComments.Hide();
    }

    function DeleteComments(commentId) {
        leadsCommentsCallbackPanel.PerformCallback("Delete|" + commentId);
    }

</script>

<div class="modal fade" id="RequestModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">

                <h4 class="modal-title">Request Document</h4>
            </div>
            <div class="modal-body">
                <div class="input-group" style="width: 100%">
                    <span>Assgin to</span>
                    <select class="form-control">
                        <option>Agent 1</option>
                        <option>Attoeny 1</option>
                    </select>

                </div>
                <br />
                <div class="input-group" style="width: 100%">
                    <span>Assgin for</span>
                    <select class="form-control">
                        <option>Bankruptcy</option>
                        <option>Statute of Limitations</option>
                        <option>Foreclosure Doucment</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary">Submit</button>
            </div>
        </div>
    </div>
</div>

<div id="" style="width: 100%;">

    <input hidden="" id="short_sale_case_id" value="23">
    <div style="padding-top: 5px">
        <div style="height: 850px; overflow: auto;" id="prioity_content">


            <div style="height: 80px; font-size: 30px; margin-left: 30px; margin-top: 20px;" class="font_gray">
                <div style="font-size: 30px">
                    <span>
                        <i class="fa fa-refresh"></i>
                        <span style="margin-left: 19px;">10/16/2014 9:30:16 PM</span>
                    </span>

                    <span class="time_buttons" style="margin-right: 30px" onclick="ShowPopupMap('https://iapps.courts.state.ny.us/webcivil/ecourtsMain', 'eCourts')">eCourts</span>
                    <span class="time_buttons" onclick="ShowDOBWindow('','1593 ', '48')">DOB</span>
                    <span class="time_buttons" onclick="ShowAcrisMap('3015930048')">Acris</span>
                    <span class="time_buttons" onclick="ShowPropertyMap('3015930048')">Maps</span>

                    <span class="time_buttons" onclick="" runat="server" visible="false" id="btnAssignAttorney">Assign Attorney</span>
                    <span class="time_buttons" onclick="$('#RequestModal').modal()">Request Document</span>
                </div>
                <span style="font-size: 14px; margin-top: -5px; float: left; margin-left: 53px; visibility: visible">Started on 10/16/2014 9:30:16 PM</span>
            </div>


            <div class="font_deep_gray" style="border-top: 1px solid #dde0e7; font-size: 20px">
                
                <div class="note_item" style="background: white">
                    <i class="fa fa-plus-circle note_img tooltip-examples" title="" style="color: #3993c1; cursor: pointer" onclick="aspxAddLeadsComments.ShowAtElement(this)" data-original-title="Add Notes"></i>

                </div>
            </div>

            <div>
                <!--detial Nav tabs -->

                <ul class="nav nav-tabs overview_tabs" role="tablist" style="">
                    <li class="short_sale_tab active">
                        <a class="shot_sale_tab_a " href="#Summary" role="tab" data-toggle="tab">Summary</a></li>
                    <% If Agent Then%>
                    <li class="short_sale_tab">
                        <a class="shot_sale_tab_a " href="#Foreclosure_Review" role="tab" data-toggle="tab">Foreclosure Review</a></li>
                    <% End If%>
                    <% If SecondaryAction Then%>
                    <li class="short_sale_tab "><a class="shot_sale_tab_a " href="#Secondary_Actions" role="tab" data-toggle="tab">Secondary Actions</a></li>
                    <% End If%>
                </ul>

                <!-- Tab panes -->
                <div class="tab-content">
                    <div class="tab-pane active" id="Summary">
                        <uc1:LegalSummaryTab runat="server" id="LegalSummaryTab" />
                    </div>
                    <div class="tab-pane " id="Foreclosure_Review">
                       
                        <uc1:LegalForeclosureReviewTab runat="server" ID="LegalForeclosureReviewTab" />

                    </div>
                    <div class="tab-pane" id="Secondary_Actions">
                        <uc1:LegalSecondaryActionTab runat="server" id="LegalSecondaryActionTab" />
                    </div>

                </div>
            </div>
        </div>

    </div>



</div>
