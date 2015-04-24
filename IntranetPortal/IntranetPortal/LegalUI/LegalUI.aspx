<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LegalUI.aspx.vb" Inherits="IntranetPortal.LegalUI" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/PopupControl/VendorsPopup.ascx" TagPrefix="uc1" TagName="VendorsPopup" %>
<%@ Register Src="~/UserControl/ActivityLogs.ascx" TagPrefix="uc1" TagName="ActivityLogs" %>
<%@ Register Src="~/ShortSale/ShortSaleCaseList.ascx" TagPrefix="uc1" TagName="ShortSaleCaseList" %>
<%@ Register Src="~/LegalUI/LegalSecondaryActions.ascx" TagPrefix="uc1" TagName="LegalSecondaryActions" %>




<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <%--leagal Ui--%>
    <dx:ASPxSplitter ID="ASPxSplitter1" runat="server" Height="100%" Width="100%" ClientInstanceName="splitter" Orientation="Horizontal" FullscreenMode="true">
        <Panes>
            <dx:SplitterPane Name="listPanel" ShowCollapseBackwardButton="True" MinSize="100px" MaxSize="400px" Size="280px" PaneStyle-Paddings-Padding="2px">
                <ContentCollection>
                    <dx:SplitterContentControl ID="SplitterContentControl1" runat="server">
                        <uc1:ShortSaleCaseList runat="server" ID="ShortSaleCaseList" />
                    </dx:SplitterContentControl>
                </ContentCollection>
            </dx:SplitterPane>
            <dx:SplitterPane ShowCollapseBackwardButton="True">
                <ContentCollection>
                    <dx:SplitterContentControl>
                        <div style="width: 650px">
                            <div style="align-content: center; height: 100%">

                                <!-- Nav tabs -->

                                <ul class="nav nav-tabs clearfix" role="tablist" style="height: 70px; background: #ff400d; font-size: 18px; color: white;">
                                    <li class="active short_sale_head_tab">
                                        <a href="#property_info" role="tab" data-toggle="tab" class="tab_button_a">
                                            <i class="fa fa-info-circle  head_tab_icon_padding"></i>
                                            <div class="font_size_bold">Legal</div>
                                        </a>
                                    </li>

                                    <li style="margin-right: 30px; color: #ffa484; float: right">

                                        <i class="fa fa-mail-forward  sale_head_button sale_head_button_left tooltip-examples" title="" onclick="tmpBBLE=leadsInfoBBLE; popupCtrReassignEmployeeListCtr.PerformCallback();popupCtrReassignEmployeeListCtr.ShowAtElement(this);" data-original-title="Re-Assign"></i>
                                        <i class="fa fa-envelope sale_head_button sale_head_button_left tooltip-examples" title="" onclick="ShowEmailPopup(leadsInfoBBLE)" data-original-title="Mail"></i>
                                        <i class="fa fa-print sale_head_button sale_head_button_left tooltip-examples" title="" onclick="" data-original-title="Print"></i>
                                    </li>
                                </ul>

                                <style>
                                    .AttachmentSpan {
                                        margin-left: 10px;
                                        border: 1px solid #efefef;
                                        padding: 3px 20px 3px 10px;
                                        background-color: #ededed;
                                    }
                                </style>

                                <div id="ctl00_MainContentPH_ASPxSplitter1_ASPxCallbackPanel2_contentSplitter_SendMail_PopupSendMail_PW-1" class="dxpcLite_MetropolisBlue1 dxpclW" style="height: 700px; width: 630px; cursor: default; z-index: 10000; display: none;">
                                    <div class="dxpc-mainDiv dxpc-shadow">
                                        <div class="dxpc-header dxpc-withBtn" id="ctl00_MainContentPH_ASPxSplitter1_ASPxCallbackPanel2_contentSplitter_SendMail_PopupSendMail_PWH-1">

                                            <div class="clearfix">
                                                <div class="pop_up_header_margin">
                                                    <i class="fa fa-envelope with_circle pop_up_header_icon"></i>
                                                    <span class="pop_up_header_text ">Email</span>
                                                </div>
                                                <div class="pop_up_buttons_div">
                                                    <i class="fa fa-times icon_btn" onclick="popupSendEmailClient.Hide()"></i>
                                                </div>
                                            </div>

                                        </div>
                                        <div class="dxpc-contentWrapper">
                                            <div class="dxpc-content" id="ctl00_MainContentPH_ASPxSplitter1_ASPxCallbackPanel2_contentSplitter_SendMail_PopupSendMail_PWC-1">
                                            </div>
                                        </div>
                                    </div>
                                </div>


                                <div class="tab-content">

                                    <div class="tab-pane active" id="property_info">


                                        <script type="text/javascript">

                                            $(document).ready(function () {
                                                // Handler for .ready() called.
                                                format_input();
                                                $(".ss_phone").each(function (index) {
                                                    format_phone(this)
                                                });
                                            });
                                            var short_sale_case_data = null;
                                            function ShowSelectParty() {
                                                VendorsPopupClient.Show()
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
                                                            <span class="time_buttons" onclick="ShowDOBWindow(&quot;&quot;,&quot;1593 &quot;, &quot;48  &quot;)">DOB</span>
                                                            <span class="time_buttons" onclick="ShowAcrisMap(&quot;3015930048 &quot;)">Acris</span>
                                                            <span class="time_buttons" onclick="ShowPropertyMap(&quot;3015930048 &quot;)">Maps</span>

                                                            <span class="time_buttons" onclick="VendorsPopupClient.Show()">Assgin Attorney</span>
                                                            <span class="time_buttons" onclick="$('#RequestModal').modal()">Request Document</span>
                                                        </div>

                                                        <span style="font-size: 14px; margin-top: -5px; float: left; margin-left: 53px; visibility: visible">Started on 10/16/2014 9:30:16 PM</span>
                                                    </div>


                                                    <div class="font_deep_gray" style="border-top: 1px solid #dde0e7; font-size: 20px">
                                                        <div id="ctl00_MainContentPH_ASPxSplitter1_ASPxCallbackPanel2_contentSplitter_ShortSaleOverVew_ShortSaleCaseSavePanel_leadsCommentsCallbackPanel">

                                                            <input type="hidden" name="ctl00$MainContentPH$ASPxSplitter1$ASPxCallbackPanel2$contentSplitter$ShortSaleOverVew$ShortSaleCaseSavePanel$leadsCommentsCallbackPanel$hfCaseId" id="ctl00_MainContentPH_ASPxSplitter1_ASPxCallbackPanel2_contentSplitter_ShortSaleOverVew_ShortSaleCaseSavePanel_leadsCommentsCallbackPanel_hfCaseId" value="23">
                                                        </div>
                                                        <table id="ctl00_MainContentPH_ASPxSplitter1_ASPxCallbackPanel2_contentSplitter_ShortSaleOverVew_ShortSaleCaseSavePanel_leadsCommentsCallbackPanel_LP" class="dxcpLoadingPanelWithContent_MetropolisBlue1 dxlpLoadingPanelWithContent_MetropolisBlue1" style="left: 0px; top: 0px; z-index: 30000; display: none;">
                                                            <tbody>
                                                                <tr>
                                                                    <td class="dx" style="padding-right: 0px;">
                                                                        <img class="dxlp-loadingImage dxlp-imgPosLeft" src="/DXR.axd?r=1_15-8xia9" alt="" style="vertical-align: middle;"></td>
                                                                    <td class="dx" style="padding-left: 0px;"><span>Loading…</span></td>
                                                                </tr>
                                                            </tbody>
                                                        </table>


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
                                                                <div class="short_sale_content">


                                                                    <div>

                                                                        <div>
                                                                            <h4 class="ss_form_title">Property</h4>

                                                                            <ul class="ss_form_box clearfix">
                                                                                <li class="ss_form_item" style="width: 100%">
                                                                                    <label class="ss_form_input_title">address</label>

                                                                                    <input class="ss_form_input" style="width: 93.5%;" name="lender" value="421 HART ST, BEDFORD STUYVESANT,NY 11221">
                                                                                </li>
                                                                                <li class="ss_form_item">
                                                                                    <label class="ss_form_input_title">Block</label>
                                                                                    <input class="ss_form_input" data-field="PropertyInfo.Block">
                                                                                </li>
                                                                                <li class="ss_form_item">
                                                                                    <label class="ss_form_input_title">lot</label>
                                                                                    <input class="ss_form_input" data-field="PropertyInfo.Lot">
                                                                                </li>
                                                                                <li class="ss_form_item">
                                                                                    <label class="ss_form_input_title">Class</label>
                                                                                    <input class="ss_form_input" value="A0">
                                                                                </li>
                                                                                <li class="ss_form_item">
                                                                                    <label class="ss_form_input_title">Condition</label>
                                                                                    <input class="ss_form_input" value="Good">
                                                                                </li>

                                                                                <li class="ss_form_item">
                                                                                    <label class="ss_form_input_title">Vacant/Occupied </label>
                                                                                    <input class="ss_form_input">
                                                                                </li>
                                                                                <li class="ss_form_item">
                                                                                    <label class="ss_form_input_title">Status</label>
                                                                                    <select class="ss_form_input">
                                                                                        <option>Eviction</option>
                                                                                        <option>Short Sale</option>
                                                                                    </select>
                                                                                </li>
                                                                                <li class="ss_form_item">
                                                                                    <label class="ss_form_input_title ss_ssn">Agent </label>
                                                                                    <input class="ss_form_input">
                                                                                </li>

                                                                                <li class="ss_form_item">
                                                                                    <label class="ss_form_input_title">Use</label>
                                                                                    <input class="ss_form_input" value="">
                                                                                </li>

                                                                                <li class="ss_form_item">
                                                                                    <label class="ss_form_input_title">Owner of Record </label>
                                                                                    <input class="ss_form_input">
                                                                                </li>

                                                                                <li class="ss_form_item">
                                                                                    <label class="ss_form_input_title">Case Contact person/owner </label>
                                                                                    <input class="ss_form_input">
                                                                                </li>
                                                                                <li class="ss_form_item">
                                                                                    <label class="ss_form_input_title">Phone number </label>
                                                                                    <input class="ss_form_input">
                                                                                </li>

                                                                                <li class="ss_form_item">
                                                                                    <label class="ss_form_input_title">Case Contact person/owner </label>
                                                                                    <input class="ss_form_input">
                                                                                </li>
                                                                                <li class="ss_form_item">
                                                                                    <label class="ss_form_input_title">email  </label>
                                                                                    <input class="ss_form_input">
                                                                                </li>
                                                                                <li class="ss_form_item">
                                                                                    <label class="ss_form_input_title">Address</label>
                                                                                    <input class="ss_form_input">
                                                                                </li>



                                                                            </ul>
                                                                        </div>

                                                                        <div data-array-index="0" class="ss_array" style="display: inline;">

                                                                            <div class="ss_form">
                                                                                <h4 class="ss_form_title"><span class="title_index ">Foreclosure </span></h4>
                                                                                <ul class="ss_form_box clearfix">


                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Servicer</label>
                                                                                        <input class="ss_form_input" data-item="Lender" data-item-type="1">
                                                                                    </li>
                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Defendant</label>
                                                                                        <input class="ss_form_input" data-item="Loan" data-item-type="1">
                                                                                    </li>
                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Attorney of record </label>
                                                                                        <input class="ss_form_input input_currency" data-item="LoanAmount" data-item-type="1">
                                                                                    </li>
                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">last court date</label>
                                                                                        <input class="ss_form_input ss_date">
                                                                                    </li>
                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">next court date </label>
                                                                                        <input class="ss_form_input ss_date">
                                                                                    </li>
                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Sale date  </label>
                                                                                        <input class="ss_form_input ss_date">
                                                                                    </li>

                                                                                    <li class="ss_form_item">
                                                                                        <span class="ss_form_input_title">HAMP </span>

                                                                                        <input type="checkbox" id="pdf_check_yes30" name="1" class="ss_form_input" value="YES">
                                                                                        <label for="pdf_check_yes30" class="input_with_check">
                                                                                            <span class="box_text">Yes </span>
                                                                                        </label>

                                                                                    </li>
                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Last Update </label>
                                                                                        <input class="ss_form_input ss_date">
                                                                                    </li>
                                                                                </ul>
                                                                            </div>

                                                                        </div>


                                                                        <div class="ss_form">
                                                                            <h4 class="ss_form_title">Secondary</h4>
                                                                            <ul class="ss_form_box clearfix">

                                                                                <li class="ss_form_item">
                                                                                    <label class="ss_form_input_title">Client </label>
                                                                                    <input class="ss_form_input" value="">
                                                                                </li>
                                                                                <li class="ss_form_item">
                                                                                    <label class="ss_form_input_title">Attorney of record </label>
                                                                                    <input class="ss_form_input" value="">
                                                                                </li>
                                                                                <li class="ss_form_item">
                                                                                    <label class="ss_form_input_title">Opposing party  </label>
                                                                                    <input class="ss_form_input" value="">
                                                                                </li>

                                                                                <li class="ss_form_item">
                                                                                    <label class="ss_form_input_title">Status </label>
                                                                                    <input class="ss_form_input" value="">
                                                                                </li>

                                                                                <li class="ss_form_item">
                                                                                    <label class="ss_form_input_title">Tasks </label>
                                                                                    <input class="ss_form_input" value="">
                                                                                </li>

                                                                                <li class="ss_form_item">
                                                                                    <label class="ss_form_input_title">Attorney working file  </label>
                                                                                    <input class="ss_form_input" value="">
                                                                                </li>

                                                                                <li class="ss_form_item">
                                                                                    <label class="ss_form_input_title">Last Update </label>
                                                                                    <input class="ss_form_input" value="">
                                                                                </li>


                                                                            </ul>
                                                                        </div>

                                                                    </div>

                                                                </div>
                                                            </div>
                                                            <div class="tab-pane " id="Foreclosure_Review">
                                                                <div class="short_sale_content">


                                                                    <div class="clearfix">
                                                                        <div style="float: right">
                                                                            <input type="button" class="rand-button short_sale_edit" value="Completed Document Submit to Attorny" onclick="switch_edit_model(this, short_sale_case_data)">
                                                                        </div>
                                                                    </div>

                                                                    <div>
                                                                        <h4 class="ss_form_title">Property</h4>

                                                                        <ul class="ss_form_box clearfix">

                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Street Number</label>
                                                                                <input class="ss_form_input color_blue_edit" data-field="PropertyInfo.Number" value="2930">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Street Name</label>
                                                                                <input class="ss_form_input color_blue_edit" data-field="PropertyInfo.StreetName" value="TENBROECK AVE">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">City</label>
                                                                                <input class="ss_form_input color_blue_edit" data-field="PropertyInfo.City" value="BRONXDALE">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">State</label>
                                                                                <input class="ss_form_input color_blue_edit" data-field="PropertyInfo.State" value="NY">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Zip</label>
                                                                                <input class="ss_form_input color_blue_edit" data-field="PropertyInfo.Zipcode" value="10469">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">&nbsp;</label>
                                                                                <input class="ss_form_input ss_form_hidden color_blue_edit" value=" ">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">BLOCK</label>
                                                                                <input class="ss_form_input color_blue_edit" data-field="PropertyInfo.Block" value="4561">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Lot</label>
                                                                                <input class="ss_form_input color_blue_edit" data-field="PropertyInfo.Lot" value="22">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Building type</label>
                                                                                <select class="ss_form_input" data-field="PropertyInfo.BuildingType">
                                                                                    <option value="House">House</option>
                                                                                    <option value="Apartment">Apartment</option>
                                                                                    <option value="Condo">Condo</option>
                                                                                    <option value="Cottage/cabin">Cottage/cabin</option>
                                                                                    <option value="Duplex">Duplex</option>
                                                                                    <option value="Flat">Flat</option>
                                                                                    <option value="In-Law">In-Law</option>
                                                                                    <option value="Loft">Loft</option>
                                                                                    <option value="Townhouse">Townhouse</option>
                                                                                    <option value="Manufactured">Manufactured</option>
                                                                                    <option value="Assisted living">Assisted living</option>
                                                                                    <option value="Land">Land</option>
                                                                                </select>

                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Borrower</label>
                                                                                <input class="ss_form_input">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Co-Borrower</label>
                                                                                <input class="ss_form_input">
                                                                            </li>

                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">&nbsp;</label>
                                                                                <input class="ss_form_input ss_form_hidden" value=" ">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Language</label>
                                                                                <input class="ss_form_input">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Mental Capacity </label>
                                                                                <input class="ss_form_input">
                                                                            </li>

                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">&nbsp;</label>
                                                                                <input class="ss_form_input ss_form_hidden" value=" ">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Divorce</label>
                                                                                <input class="ss_form_input">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Borrowers Relationship </label>
                                                                                <input class="ss_form_input">
                                                                            </li>

                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">&nbsp;</label>
                                                                                <input class="ss_form_input ss_form_hidden" value=" ">
                                                                            </li>




                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Estate</label>
                                                                                <input class="ss_form_input" type="number" data-field="PropertyInfo.NumOfStories">
                                                                            </li>

                                                                            <li class="ss_form_item">
                                                                                <span class="ss_form_input_title">c/o(<span class="linkey_pdf">pdf</span>)</span>

                                                                                <input type="radio" class="ss_form_input" data-field="PropertyInfo.CO" data-radio="Y" id="key_PropertyInfo_checkYes_CO" name="pdf" value="YES">
                                                                                <label for="key_PropertyInfo_checkYes_CO" class="input_with_check">
                                                                                    <span class="box_text">Yes</span>
                                                                                </label>

                                                                                <input type="radio" class="ss_form_input" data-field="PropertyInfo.CO" id="none_pdf_checkey_no21" name="pdf" value="NO">
                                                                                <label for="none_pdf_checkey_no21" class="input_with_check">
                                                                                    <span class="box_text"><span class="box_text">No</span></span>
                                                                                </label>

                                                                            </li>


                                                                        </ul>
                                                                    </div>
                                                                    <div class="ss_form">
                                                                        <h4 class="ss_form_title">Plaintiff <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="VendorsPopupClient.Show()" style="display: inline !important;"></i></h4>
                                                                        <ul class="ss_form_box clearfix">

                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">name</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Name" value="Michael Simcha ">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">manager</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="Manager" value="">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Office</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Office">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">office #</label>
                                                                                <input class="ss_form_input ss_not_edit ss_phone" data-field="ReferralContact.OfficeNO" value="7186765222">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Cell #</label>
                                                                                <input class="ss_form_input ss_not_edit ss_phone" data-field="ReferralContact.Cell" value="7186765222">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">email</label>
                                                                                <input class="ss_form_input ss_not_edit ss_phone" data-field="ReferralContact.Email">
                                                                            </li>
                                                                        </ul>
                                                                    </div>
                                                                    <div class="ss_form">
                                                                        <h4 class="ss_form_title">Plaintiff Attorney<i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="VendorsPopupClient.Show()" style="display: inline !important;"></i></h4>
                                                                        <ul class="ss_form_box clearfix">

                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">name</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Name">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">manager</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="Manager" value="">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Office</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Office">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">office #</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.OfficeNO">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Cell #</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Cell">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">email</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Email">
                                                                            </li>
                                                                        </ul>
                                                                    </div>
                                                                    <div class="ss_form">
                                                                        <h4 class="ss_form_title">Servicer <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="VendorsPopupClient.Show()" style="display: inline !important;"></i></h4>
                                                                        <ul class="ss_form_box clearfix">

                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">name</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Name">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">manager</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="Manager" value="">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Office</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Office">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">office #</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.OfficeNO">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Cell #</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Cell">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">email</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Email">
                                                                            </li>
                                                                        </ul>
                                                                    </div>
                                                                    <div class="ss_form">
                                                                        <h4 class="ss_form_title">Defendant 1 <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="VendorsPopupClient.Show()" style="display: inline !important;"></i></h4>
                                                                        <ul class="ss_form_box clearfix">

                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">name</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Name">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">manager</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="Manager" value="">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Office</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Office">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">office #</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.OfficeNO">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Cell #</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Cell">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">email</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Email">
                                                                            </li>
                                                                        </ul>
                                                                    </div>
                                                                    <div class="ss_form">
                                                                        <h4 class="ss_form_title">Defendant 2 <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="VendorsPopupClient.Show()" style="display: inline !important;"></i></h4>
                                                                        <ul class="ss_form_box clearfix">

                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">name</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Name">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">manager</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="Manager" value="">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Office</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Office">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">office #</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.OfficeNO">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Cell #</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Cell">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">email</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Email">
                                                                            </li>
                                                                        </ul>
                                                                    </div>

                                                                    <div class="ss_form">
                                                                        <h4 class="ss_form_title">Attorney of record 1 <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="VendorsPopupClient.Show()" style="display: inline !important;"></i></h4>
                                                                        <ul class="ss_form_box clearfix">

                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">name</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Name">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">manager</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="Manager" value="">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Office</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Office">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">office #</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.OfficeNO">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Cell #</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Cell">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">email</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Email">
                                                                            </li>
                                                                        </ul>
                                                                    </div>
                                                                    <div class="ss_form">
                                                                        <h4 class="ss_form_title">Attorney of record 2 <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="VendorsPopupClient.Show()" style="display: inline !important;"></i></h4>
                                                                        <ul class="ss_form_box clearfix">

                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">name</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Name">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">manager</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="Manager" value="">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Office</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Office">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">office #</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.OfficeNO">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Cell #</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Cell">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">email</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Email">
                                                                            </li>
                                                                        </ul>
                                                                    </div>
                                                                    <%--background--%>
                                                                    <div class="ss_form">
                                                                        <h4 class="ss_form_title">Background</h4>
                                                                        <ul class="ss_form_box clearfix">

                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Deed Xfer </label>
                                                                                <input class="ss_form_input ss_date" data-field="PropertyInfo.Number">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Tax Lien  </label>
                                                                                <input class="ss_form_input currency_input" data-field="PropertyInfo.Number" value="30000">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">UCC  </label>
                                                                                <input class="ss_form_input currency_input" data-field="PropertyInfo.Number">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">HPD </label>
                                                                                <input class="ss_form_input currency_input" data-field="PropertyInfo.Number">
                                                                            </li>
                                                                            <li class="ss_form_item" style="width: 100%">
                                                                                <label class="ss_form_input_title">Questionable Satisfactions </label>
                                                                                <input class="ss_form_input" data-field="PropertyInfo.Number" style="width: 93%">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Title Issues </label>
                                                                                <input class="ss_form_input" data-field="PropertyInfo.Number">
                                                                            </li>


                                                                        </ul>
                                                                    </div>
                                                                    <div class="ss_form">
                                                                        <h4 class="ss_form_title">Originator  <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="VendorsPopupClient.Show()" style="display: inline !important;"></i></h4>
                                                                        <ul class="ss_form_box clearfix">

                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">name</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Name">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">manager</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="Manager" value="">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Office</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Office">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">office #</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.OfficeNO">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Cell #</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Cell">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">email</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Email">
                                                                            </li>
                                                                        </ul>
                                                                    </div>
                                                                    <div class="ss_form">
                                                                        <h4 class="ss_form_title">2nd Mortgage<i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="VendorsPopupClient.Show()" style="display: inline !important;"></i></h4>
                                                                        <ul class="ss_form_box clearfix">

                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">name</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Name">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">manager</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="Manager" value="">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Office</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Office">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">office #</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.OfficeNO">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Cell #</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Cell">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">email</label>
                                                                                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Email">
                                                                            </li>
                                                                        </ul>
                                                                    </div>

                                                                    <div class="ss_form">
                                                                        <h4 class="ss_form_title">Mortgage</h4>
                                                                        <ul class="ss_form_box clearfix">
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Active/Dissolved Date </label>
                                                                                <input class="ss_form_input ss_date" data-field="PropertyInfo.Number" value="04/08/2015">
                                                                            </li>

                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">1st Loan Amount</label>
                                                                                <input class="ss_form_input currency_input" data-field="PropertyInfo.Number">
                                                                            </li>

                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">2nd Loan Amount</label>
                                                                                <input class="ss_form_input currency_input" data-field="PropertyInfo.Number">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Type of Loan</label>
                                                                                <select class="ss_form_input" data-field="PropertyInfo.Number">
                                                                                    <option>FHA</option>
                                                                                    <option>FANNIE MAE</option>
                                                                                    <option>FREDDIE</option>
                                                                                    <option>ARM</option>
                                                                                    <option>FIXED</option>
                                                                                    <option>80/20</option>
                                                                                    <option>COMMERCIAL</option>
                                                                                </select>
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">First Mortgage Payment</label>
                                                                                <input class="ss_form_input currency_input" data-field="PropertyInfo.Number">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Maturity</label>
                                                                                <input class="ss_form_input ss_date" data-field="PropertyInfo.Number">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">signed</label>
                                                                                <input class="ss_form_input" data-field="PropertyInfo.Number">
                                                                            </li>

                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">last payment date</label>
                                                                                <input class="ss_form_input" data-field="PropertyInfo.Number">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <span class="ss_form_input_title">Eviction status</span>

                                                                                <input type="radio" id="checy_41" name="1" value="YES" class="ss_form_input">
                                                                                <label for="checy_41" class="input_with_check">
                                                                                    <span class="box_text">Vacant </span>

                                                                                </label>

                                                                                <input type="radio" id="checy_42" name="1" value="NO" class="ss_form_input">
                                                                                <label for="checy_42" class="input_with_check">
                                                                                    <span class="box_text">Tenant</span>
                                                                                </label>

                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <span class="ss_form_input_title">HAMP eligible</span>

                                                                                <input type="radio" id="checy_45" name="1" value="YES" class="ss_form_input">
                                                                                <label for="checy_45" class="input_with_check ">
                                                                                    <span class="box_text">Yes </span>

                                                                                </label>

                                                                                <input type="radio" id="checy_46" name="1" value="NO" class="ss_form_input">
                                                                                <label for="checy_46" class="input_with_check">
                                                                                    <span class="box_text">No</span>
                                                                                </label>
                                                                            </li>

                                                                        </ul>
                                                                    </div>
                                                                    <div class="ss_form">
                                                                        <h4 class="ss_form_title">Note</h4>

                                                                        <ul class="ss_form_box clearfix">
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Count Of signed</label>
                                                                                <input class="ss_form_input" data-field="PropertyInfo.Number">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <span class="ss_form_input_title">note  endorsed</span>

                                                                                <input type="radio" id="checy_47" name="1" value="YES" class="ss_form_input">
                                                                                <label for="checy_47" class="input_with_check ">
                                                                                    <span class="box_text">Yes </span>

                                                                                </label>

                                                                                <input type="radio" id="checy_48" name="1" value="NO" class="ss_form_input">
                                                                                <label for="checy_48" class="input_with_check">
                                                                                    <span class="box_text">No</span>
                                                                                </label>
                                                                            </li>

                                                                            <li class="ss_form_item">
                                                                                <span class="ss_form_input_title">endorsed By Lender</span>

                                                                                <input type="radio" id="checy_49" name="1" value="YES" class="ss_form_input">
                                                                                <label for="checy_49" class="input_with_check ">
                                                                                    <span class="box_text">Yes </span>

                                                                                </label>

                                                                                <input type="radio" id="checy_50" name="1" value="NO" class="ss_form_input">
                                                                                <label for="checy_50" class="input_with_check">
                                                                                    <span class="box_text">No</span>
                                                                                </label>
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <span class="ss_form_input_title">endorsed Dept</span>

                                                                                <input type="radio" id="checy_51" name="1" value="YES" class="ss_form_input">
                                                                                <label for="checy_51" class="input_with_check ">
                                                                                    <span class="box_text">entity </span>

                                                                                </label>

                                                                                <input type="radio" id="checy_52" name="1" value="NO" class="ss_form_input">
                                                                                <label for="checy_52" class="input_with_check">
                                                                                    <span class="box_text">Blank</span>
                                                                                </label>
                                                                            </li>

                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">signed</label>
                                                                                <input class="ss_form_input" data-field="PropertyInfo.Number">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">endorsed signed date</label>
                                                                                <input class="ss_form_input ss_date" data-field="PropertyInfo.Number">
                                                                            </li>



                                                                        </ul>


                                                                    </div>
                                                                    <div class="ss_form">
                                                                        <h4 class="ss_form_title">Note Alonge</h4>
                                                                        <ul class="ss_form_box clearfix">

                                                                            <li class="ss_form_item">
                                                                                <span class="ss_form_input_title">note  Alonge</span>

                                                                                <input type="radio" id="checy_61" name="1" value="YES" class="ss_form_input">
                                                                                <label for="checy_61" class="input_with_check ">
                                                                                    <span class="box_text">Yes </span>

                                                                                </label>

                                                                                <input type="radio" id="checy_62" name="1" value="NO" class="ss_form_input">
                                                                                <label for="checy_62" class="input_with_check">
                                                                                    <span class="box_text">No</span>
                                                                                </label>
                                                                            </li>

                                                                            <li class="ss_form_item">
                                                                                <span class="ss_form_input_title">Alonge By Lender</span>

                                                                                <input type="radio" id="checy_63" name="1" value="YES" class="ss_form_input">
                                                                                <label for="checy_63" class="input_with_check ">
                                                                                    <span class="box_text">Yes </span>

                                                                                </label>

                                                                                <input type="radio" id="checy_64" name="1" value="NO" class="ss_form_input">
                                                                                <label for="checy_64" class="input_with_check">
                                                                                    <span class="box_text">No</span>
                                                                                </label>
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <span class="ss_form_input_title">Alonge Dept</span>

                                                                                <input type="radio" id="checy_65" name="1" value="YES" class="ss_form_input">
                                                                                <label for="checy_65" class="input_with_check ">
                                                                                    <span class="box_text">entity </span>

                                                                                </label>

                                                                                <input type="radio" id="checy_66" name="1" value="NO" class="ss_form_input">
                                                                                <label for="checy_66" class="input_with_check">
                                                                                    <span class="box_text">Blank</span>
                                                                                </label>
                                                                            </li>

                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">signed</label>
                                                                                <input class="ss_form_input" data-field="PropertyInfo.Number">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Alonge signed date</label>
                                                                                <input class="ss_form_input ss_date" data-field="PropertyInfo.Number">
                                                                            </li>



                                                                        </ul>
                                                                    </div>

                                                                    <div class="ss_form">
                                                                        <h4 class="ss_form_title">Court Activity</h4>
                                                                        <ul class="ss_form_box clearfix">

                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Date</label>
                                                                                <input class="ss_form_input ss_date" data-field="PropertyInfo.Number">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Renewed Date</label>
                                                                                <input class="ss_form_input ss_date" data-field="PropertyInfo.Number">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Affidavit Date</label>
                                                                                <input class="ss_form_input ss_date" data-field="PropertyInfo.Number">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Affidavit Company</label>
                                                                                <input class="ss_form_input">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Prior Index Date</label>
                                                                                <input class="ss_form_input ss_date" data-field="PropertyInfo.Number">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Prior Index disposition </label>
                                                                                <input class="ss_form_input" data-field="PropertyInfo.Number">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Prior Index Opposing </label>
                                                                                <input class="ss_form_input" data-field="PropertyInfo.Number">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Conferences Date</label>
                                                                                <input class="ss_form_input ss_date" data-field="PropertyInfo.Number">
                                                                            </li>
                                                                            <li class="ss_form_item">

                                                                                <span class="ss_form_input_title">Conferences Attended</span>

                                                                                <input type="radio" id="checy_69" name="1" value="YES" class="ss_form_input">
                                                                                <label for="checy_69" class="input_with_check ">
                                                                                    <span class="box_text">Yes </span>

                                                                                </label>

                                                                                <input type="radio" id="checy_70" name="1" value="NO" class="ss_form_input">
                                                                                <label for="checy_70" class="input_with_check">
                                                                                    <span class="box_text">No</span>
                                                                                </label>
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Conferences Referee </label>
                                                                                <input class="ss_form_input" data-field="PropertyInfo.Number">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Status</label>
                                                                                <input class="ss_form_input" data-field="PropertyInfo.Number">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <span class="ss_form_input_title">Status Answered</span>

                                                                                <input type="radio" id="checy_71" name="1" value="YES" class="ss_form_input">
                                                                                <label for="checy_71" class="input_with_check ">
                                                                                    <span class="box_text">Yes </span>

                                                                                </label>

                                                                                <input type="radio" id="checy_72" name="1" value="NO" class="ss_form_input">
                                                                                <label for="checy_72" class="input_with_check">
                                                                                    <span class="box_text">No</span>
                                                                                </label>

                                                                            </li>

                                                                            <li class="ss_form_item">
                                                                                <span class="ss_form_input_title">Order of Reference</span>

                                                                                <input type="radio" id="checy_73" name="1" value="YES" class="ss_form_input">
                                                                                <label for="checy_73" class="input_with_check ">
                                                                                    <span class="box_text">Yes </span>

                                                                                </label>

                                                                                <input type="radio" id="checy_74" name="1" value="NO" class="ss_form_input">
                                                                                <label for="checy_74" class="input_with_check">
                                                                                    <span class="box_text">No</span>
                                                                                </label>

                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <span class="ss_form_input_title">Order of Reference</span>

                                                                                <input type="radio" id="check_76" name="1" value="YES" class="ss_form_input">
                                                                                <label for="check_76" class="input_with_check ">
                                                                                    <span class="box_text">Yes </span>

                                                                                </label>

                                                                                <input type="radio" id="check_77" name="1" value="NO" class="ss_form_input">
                                                                                <label for="check_77" class="input_with_check">
                                                                                    <span class="box_text">No</span>
                                                                                </label>

                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Stauts Date</label>
                                                                                <input class="ss_form_input ss_date" data-field="PropertyInfo.Number">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Sign off date</label>
                                                                                <input class="ss_form_input ss_date" data-field="PropertyInfo.Number">
                                                                            </li>

                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">HAMP submitted Date</label>
                                                                                <input class="ss_form_input" data-field="PropertyInfo.Number">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">HAMP submitted TYPE</label>
                                                                                <input class="ss_form_input" data-field="PropertyInfo.Number">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">HAMP submitted Resubmission</label>
                                                                                <input class="ss_form_input" data-field="PropertyInfo.Number">
                                                                            </li>

                                                                        </ul>
                                                                    </div>
                                                                    <div data-array-index="0" class="ss_array" style="display: inline;">

                                                                        <h4 class="ss_form_title title_with_line">
                                                                            <span class="title_index title_span">Assignments 1</span>&nbsp;
                                                        <i class="fa fa-compress expand_btn color_blue icon_btn color_blue tooltip-examples" style="display: none" onclick="expand_array_item(this)" title="" data-original-title="Expand or Collapse"></i>
                                                                            &nbsp;<i class="fa fa-plus-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="AddArraryItem(event,this)" title="" data-original-title="Add"></i>
                                                                            <i class="fa fa-times-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="delete_array_item(this)" title="" data-original-title="Delete"></i>
                                                                        </h4>
                                                                        <div class="collapse_div" style="">

                                                                            <div class="ss_form">
                                                                                <h4 class="ss_form_title">Assignor 
                                                            <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="ShowSelectParty()" style="display: inline !important;"></i>

                                                                                </h4>
                                                                                <ul class="ss_form_box clearfix">
                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Name</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Name" data-item-type="1" disabled="">
                                                                                    </li>



                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Phone #</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Cell" data-item-type="1" disabled="">
                                                                                    </li>

                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Fax #</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.OfficeNO" data-item-type="1" disabled="">
                                                                                    </li>

                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">email</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Email" data-item-type="1" disabled="">
                                                                                    </li>
                                                                                </ul>

                                                                            </div>

                                                                            <div class="ss_form">
                                                                                <h4 class="ss_form_title">Assignee 
                                                             <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="ShowSelectParty(' ',  " style="display: inline !important;"></i>
                                                                                </h4>
                                                                                <ul class="ss_form_box clearfix">
                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Name</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="NegotiatorContact.Name" data-item-type="1" disabled="">
                                                                                    </li>


                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Phone #</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="NegotiatorContact.Cell" data-item-type="1" disabled="">
                                                                                    </li>

                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Fax #</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="NegotiatorContact.OfficeNO" data-item-type="1" disabled="">
                                                                                    </li>

                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">email</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="NegotiatorContact.Email" data-item-type="1" disabled="">
                                                                                    </li>
                                                                                </ul>
                                                                            </div>
                                                                            <div class="ss_form">
                                                                                <h4 class="ss_form_title">Signed by 
                                                             <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="ShowSelectParty(' ',  " style="display: inline !important;"></i>
                                                                                </h4>
                                                                                <ul class="ss_form_box clearfix">
                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Name</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="NegotiatorContact.Name" data-item-type="1" disabled="">
                                                                                    </li>


                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Phone #</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="NegotiatorContact.Cell" data-item-type="1" disabled="">
                                                                                    </li>

                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Fax #</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="NegotiatorContact.OfficeNO" data-item-type="1" disabled="">
                                                                                    </li>

                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">email</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="NegotiatorContact.Email" data-item-type="1" disabled="">
                                                                                    </li>
                                                                                </ul>
                                                                            </div>

                                                                            <div class="ss_form">
                                                                                <h4 class="ss_form_title">Assignment
                                                                                </h4>
                                                                                <ul class="ss_form_box clearfix">
                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Date</label>
                                                                                        <input class="ss_form_input ss_not_edit ss_date" data-item="NegotiatorContact.Cell" data-item-type="1" disabled="">
                                                                                    </li>
                                                                                    <li class="ss_form_item">
                                                                                        <span class="ss_form_input_title">Document prepared</span>

                                                                                        <input type="radio" id="checy_81" name="1" value="YES" class="ss_form_input">
                                                                                        <label for="checy_81" class="input_with_check ">
                                                                                            <span class="box_text">Yes </span>

                                                                                        </label>

                                                                                        <input type="radio" id="checy_82" name="1" value="NO" class="ss_form_input">
                                                                                        <label for="checy_82" class="input_with_check">
                                                                                            <span class="box_text">No</span>
                                                                                        </label>

                                                                                    </li>
                                                                                    <li class="ss_form_item">
                                                                                        <span class="ss_form_input_title">Assigned before the S&C </span>

                                                                                        <input type="radio" id="checy_83" name="1" value="YES" class="ss_form_input">
                                                                                        <label for="checy_81" class="input_with_check ">
                                                                                            <span class="box_text">Yes </span>

                                                                                        </label>

                                                                                        <input type="radio" id="checy_84" name="1" value="NO" class="ss_form_input">
                                                                                        <label for="checy_82" class="input_with_check">
                                                                                            <span class="box_text">No</span>
                                                                                        </label>
                                                                                    </li>

                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Signed Place</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="NegotiatorContact.OfficeNO" data-item-type="1" disabled="">
                                                                                    </li>

                                                                                </ul>
                                                                            </div>

                                                                        </div>
                                                                    </div>


                                                                    <div data-array-index="0" class="ss_array" style="display: inline;">

                                                                        <h4 class="ss_form_title title_with_line">
                                                                            <span class="title_index title_span">Loan Pool Trust</span>&nbsp;
                                                        <i class="fa fa-compress expand_btn color_blue icon_btn color_blue tooltip-examples" style="display: none" onclick="expand_array_item(this)" title="" data-original-title="Expand or Collapse"></i>
                                                                            &nbsp;<i class="fa fa-plus-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="AddArraryItem(event,this)" title="" data-original-title="Add"></i>
                                                                            <i class="fa fa-times-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="delete_array_item(this)" title="" data-original-title="Delete"></i>
                                                                        </h4>
                                                                        <div class="collapse_div" style="">

                                                                            <div class="ss_form">
                                                                                <h4 class="ss_form_title">Trust Info
                                                            <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="ShowSelectParty()" style="display: inline !important;"></i>

                                                                                </h4>
                                                                                <ul class="ss_form_box clearfix">
                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Name</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Name" data-item-type="1" disabled="">
                                                                                    </li>



                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Phone #</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Cell" data-item-type="1" disabled="">
                                                                                    </li>

                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Fax #</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.OfficeNO" data-item-type="1" disabled="">
                                                                                    </li>

                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">email</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Email" data-item-type="1" disabled="">
                                                                                    </li>
                                                                                </ul>

                                                                            </div>

                                                                            <div class="ss_form">
                                                                                <h4 class="ss_form_title">Trust 
                                                            
                                                                                </h4>
                                                                                <ul class="ss_form_box clearfix">
                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Depositor Name</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="NegotiatorContact.Name" data-item-type="1" disabled="">
                                                                                    </li>


                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Trustee Name</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="NegotiatorContact.Cell" data-item-type="1" disabled="">
                                                                                    </li>
                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Cutoff Date</label>
                                                                                        <input class="ss_form_input ss_date" data-item="NegotiatorContact.Cell" data-item-type="1" disabled="">
                                                                                    </li>
                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Closing date</label>
                                                                                        <input class="ss_form_input ss_date" data-item="NegotiatorContact.Cell" data-item-type="1" disabled="">
                                                                                    </li>

                                                                                    <li class="ss_form_item">
                                                                                        <span class="ss_form_input_title">Trust documentation been located</span>

                                                                                        <input type="radio" id="check_90" name="1" value="YES" class="ss_form_input">
                                                                                        <label for="check_90" class="input_with_check ">
                                                                                            <span class="box_text">Yes </span>

                                                                                        </label>

                                                                                        <input type="radio" id="check_91" name="1" value="NO" class="ss_form_input">
                                                                                        <label for="check_91" class="input_with_check">
                                                                                            <span class="box_text">No</span>
                                                                                        </label>
                                                                                    </li>

                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Assignment date</label>
                                                                                        <input class="ss_form_input ss_date" data-item="NegotiatorContact.Email" data-item-type="1" disabled="">
                                                                                    </li>
                                                                                    <li class="ss_form_item">
                                                                                        <span class="ss_form_input_title">Default date after close</span>

                                                                                        <input type="radio" id="check_93" name="1" value="YES" class="ss_form_input">
                                                                                        <label for="check_93" class="input_with_check ">
                                                                                            <span class="box_text">Yes </span>
                                                                                        </label>

                                                                                        <input type="radio" id="check_94" name="1" value="NO" class="ss_form_input">
                                                                                        <label for="check_94" class="input_with_check">
                                                                                            <span class="box_text">No</span>
                                                                                        </label>
                                                                                    </li>
                                                                                </ul>
                                                                            </div>



                                                                        </div>
                                                                    </div>

                                                                    <div class="ss_form">
                                                                        <h4 class="ss_form_title">Bankruptcy</h4>
                                                                        <ul class="ss_form_box clearfix">

                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Prior</label>
                                                                                <input class="ss_form_input ss_date" data-field="PropertyInfo.Number">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">chapter</label>
                                                                                <input class="ss_form_input" data-field="PropertyInfo.Number">
                                                                            </li>
                                                                            <li class="ss_form_item">
                                                                                <label class="ss_form_input_title">Disposition</label>
                                                                                <input class="ss_form_input">
                                                                            </li>

                                                                        </ul>
                                                                    </div>

                                                                    <div data-array-index="0" class="ss_array" style="display: inline;">

                                                                        <h4 class="ss_form_title title_with_line">
                                                                            <span class="title_index title_span">Statute of Limitation</span>&nbsp;
                                                        <i class="fa fa-compress expand_btn color_blue icon_btn color_blue tooltip-examples" style="display: none" onclick="expand_array_item(this)" title="" data-original-title="Expand or Collapse"></i>
                                                                            &nbsp;<i class="fa fa-plus-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="AddArraryItem(event,this)" title="" data-original-title="Add"></i>
                                                                            <i class="fa fa-times-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="delete_array_item(this)" title="" data-original-title="Delete"></i>
                                                                        </h4>
                                                                        <div class="collapse_div" style="">

                                                                            <div class="ss_form">
                                                                                <h4 class="ss_form_title">Prior Plaintiff
                                                            <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="ShowSelectParty()" style="display: inline !important;"></i>

                                                                                </h4>
                                                                                <ul class="ss_form_box clearfix">
                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Name</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Name" data-item-type="1" disabled="">
                                                                                    </li>



                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Phone #</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Cell" data-item-type="1" disabled="">
                                                                                    </li>

                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Fax #</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.OfficeNO" data-item-type="1" disabled="">
                                                                                    </li>

                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">email</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Email" data-item-type="1" disabled="">
                                                                                    </li>
                                                                                </ul>

                                                                            </div>
                                                                            <div class="ss_form">
                                                                                <h4 class="ss_form_title">Prior Plaintiff
                                                            <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="ShowSelectParty()" style="display: inline !important;"></i>

                                                                                </h4>
                                                                                <ul class="ss_form_box clearfix">
                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Name</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Name" data-item-type="1" disabled="">
                                                                                    </li>



                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Phone #</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Cell" data-item-type="1" disabled="">
                                                                                    </li>

                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Fax #</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.OfficeNO" data-item-type="1" disabled="">
                                                                                    </li>

                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">email</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Email" data-item-type="1" disabled="">
                                                                                    </li>
                                                                                </ul>

                                                                            </div>
                                                                            <div class="ss_form">
                                                                                <h4 class="ss_form_title">Statute of Limitations</h4>
                                                                                <ul class="ss_form_box clearfix">

                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">LP Date</label>
                                                                                        <input class="ss_form_input ss_date" data-field="PropertyInfo.Number">
                                                                                    </li>
                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Default Date</label>
                                                                                        <input class="ss_form_input" data-field="PropertyInfo.Number">
                                                                                    </li>
                                                                                    <li class="ss_form_item">
                                                                                        <span class="ss_form_input_title">In foreclosure </span>

                                                                                        <input type="checkbox" id="pdf_check_yes39" name="1" class="ss_form_input" value="YES">
                                                                                        <label for="pdf_check_yes39" class="input_with_check">
                                                                                            <span class="box_text">Yes </span>
                                                                                        </label>

                                                                                    </li>

                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Disposition</label>
                                                                                        <select class="ss_form_input" data-field="PropertyInfo.Number">
                                                                                            <option>Dismissed</option>
                                                                                            <option>Discontinued</option>
                                                                                            <option>abandoned</option>
                                                                                            <option>other</option>

                                                                                        </select>
                                                                                    </li>
                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Prior Plaintiff</label>
                                                                                        <input class="ss_form_input" data-field="PropertyInfo.Number">
                                                                                    </li>
                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Prior attorney</label>
                                                                                        <input class="ss_form_input" data-field="PropertyInfo.Number">
                                                                                    </li>
                                                                                </ul>
                                                                            </div>

                                                                        </div>
                                                                        <div class="ss_form">
                                                                            <h4 class="ss_form_title">Estate</h4>
                                                                            <ul class="ss_form_box clearfix">


                                                                                <li class="ss_form_item">
                                                                                    <label class="ss_form_input_title">hold Reason</label>
                                                                                    <select class="ss_form_input" data-field="PropertyInfo.Number">
                                                                                        <option>Tenants in common</option>
                                                                                        <option>Joint Tenants w/right of survivorship</option>
                                                                                        <option>Tenancy by the entirety</option>

                                                                                    </select>
                                                                                </li>

                                                                                <li class="ss_form_item">
                                                                                    <span class="ss_form_input_title">Estate set up</span>

                                                                                    <select class="ss_form_input">
                                                                                        <option>Unknown</option>
                                                                                        <option>Yes</option>
                                                                                        <option>No</option>
                                                                                    </select>
                                                                                    <%--<input type="checkbox" id="pdf_check_yes103" name="1" class="ss_form_input" value="YES">
                                                                                    <label for="pdf_check_yes40" class="input_with_check">
                                                                                        <span class="box_text">Yes </span>
                                                                                    </label>--%>
                                                                                </li>
                                                                                <li class="ss_form_item">

                                                                                    <span class="ss_form_input_title">borrower Died</span>

                                                                                    <select class="ss_form_input">
                                                                                        <option>Unknown</option>
                                                                                        <option>Yes</option>
                                                                                        <option>No</option>
                                                                                    </select>
                                                                                    <%-- <input type="radio" id="pdf_check100" name="1" class="ss_form_input" value="YES">
                                                                                    <label for="pdf_check50" class="input_with_check">
                                                                                        <span class="box_text">Yes </span>
                                                                                    </label>
                                                                                    <input type="radio" id="pdf_check101" name="1" class="ss_form_input" value="YES">
                                                                                    <label for="pdf_check50" class="input_with_check">
                                                                                        <span class="box_text">Tenancy by the entirety </span>
                                                                                    </label>--%>

                                                                                </li>
                                                                                <li class="ss_form_item">
                                                                                    <label class="ss_form_input_title">prior action</label>


                                                                                    <input class="ss_form_input" data-field="PropertyInfo.Number">
                                                                                </li>

                                                                            </ul>
                                                                        </div>
                                                                        <div class="ss_form">
                                                                            <h4 class="ss_form_title">Defenses/Conclusion</h4>
                                                                            <ul class="ss_form_box clearfix">

                                                                                <li class="ss_form_item" style="width: 100%">
                                                                                    <label class="ss_form_input_title">Defenses/Conclusion</label>
                                                                                    <input class="ss_form_input" data-field="PropertyInfo.Number" style="width: 93%">
                                                                                </li>

                                                                            </ul>
                                                                        </div>

                                                                        <div class="ss_form">
                                                                            <h4 class="ss_form_title">Action Plan</h4>
                                                                            <ul class="ss_form_box clearfix">


                                                                                <li class="ss_form_item" style="width: 100%">
                                                                                    <label class="ss_form_input_title">Action Plan</label>
                                                                                    <input class="ss_form_input" data-field="PropertyInfo.Number" style="width: 93%">
                                                                                </li>

                                                                            </ul>
                                                                        </div>
                                                                        <div class="ss_form">
                                                                            <h4 class="ss_form_title">Etrack</h4>
                                                                            <ul class="ss_form_box clearfix">


                                                                                <li class="ss_form_item" style="width: 100%">
                                                                                    <label class="ss_form_input_title">Etrack</label>
                                                                                    <input class="ss_form_input" data-field="PropertyInfo.Number" style="width: 93%">
                                                                                </li>



                                                                            </ul>
                                                                        </div>
                                                                    </div>
                                                                </div>



                                                            </div>
                                                            <div class="tab-pane" id="Secondary_Actions">
                                                                <div class="short_sale_content">


                                                                    <div class="clearfix">
                                                                        <div style="float: right">
                                                                            <input type="button" class="rand-button short_sale_edit" value="Completed send back to Agent" onclick="switch_edit_model(this, short_sale_case_data)">
                                                                        </div>
                                                                    </div>
                                                                    <div data-array-index="0" class="ss_array" style="display: inline;">

                                                                        <h4 class="ss_form_title title_with_line">
                                                                            <span class="title_index title_span">Statute of Limitation</span>&nbsp;
                                                        <i class="fa fa-compress expand_btn color_blue icon_btn color_blue tooltip-examples" style="display: none" onclick="expand_array_item(this)" title="" data-original-title="Expand or Collapse"></i>
                                                                            &nbsp;<i class="fa fa-plus-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="AddArraryItem(event,this)" title="" data-original-title="Add"></i>
                                                                            <i class="fa fa-times-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="delete_array_item(this)" title="" data-original-title="Delete"></i>
                                                                        </h4>
                                                                        <div class="collapse_div" style="">
                                                                            <div class="ss_form">
                                                                                <h4 class="ss_form_title">Action</h4>
                                                                                <ul class="ss_form_box clearfix">

                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">case Type</label>
                                                                                        <select class="ss_form_input" data-field="PropertyInfo.Block">
                                                                                            <option>Partition</option>
                                                                                            <option>Breach of Contract</option>
                                                                                            <option>Quiet Title</option>
                                                                                            <option>Estate</option>
                                                                                            <option>Article 78           </option>
                                                                                            <option>Declaratory Relief   </option>
                                                                                            <option>Fraud                </option>
                                                                                            <option>Deed Reversion       </option>
                                                                                            <option>Other</option>
                                                                                        </select>
                                                                                    </li>
                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Index #</label>
                                                                                        <input class="ss_form_input" type="number" data-field="PropertyInfo.Block">
                                                                                    </li>
                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Relief requested</label>
                                                                                        <input class="ss_form_input" data-field="PropertyInfo.Block">
                                                                                    </li>
                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Goal</label>
                                                                                        <input class="ss_form_input" data-field="PropertyInfo.Block">
                                                                                    </li>
                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">represent</label>
                                                                                        <input class="ss_form_input" data-field="PropertyInfo.Block">
                                                                                    </li>

                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">against</label>
                                                                                        <input class="ss_form_input" data-field="PropertyInfo.Block">
                                                                                    </li>
                                                                                    <li class="ss_form_item">
                                                                                        <span class="ss_form_input_title">Deed</span>
                                                                                        <input type="checkbox" id="pdf_check_yes104" name="1" class="ss_form_input" value="YES">
                                                                                        <label for="pdf_check_yes40" class="input_with_check">
                                                                                            <span class="box_text">Yes </span>
                                                                                        </label>
                                                                                    </li>


                                                                                    <li class="ss_form_item">
                                                                                        <span class="ss_form_input_title">service completed</span>
                                                                                        <input type="checkbox" id="pdf_check_yes106" name="1" class="ss_form_input" value="YES">
                                                                                        <label for="pdf_check_yes40" class="input_with_check">
                                                                                            <span class="box_text">Yes </span>
                                                                                        </label>
                                                                                    </li>

                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Action commenced</label>
                                                                                        <input class="ss_form_input" data-field="PropertyInfo.Block">
                                                                                    </li>

                                                                                    <li class="ss_form_item">
                                                                                        <span class="ss_form_input_title">documents completed</span>
                                                                                        <input type="checkbox" id="pdf_check_yes105" name="1" class="ss_form_input" value="YES">
                                                                                        <label for="pdf_check_yes40" class="input_with_check">
                                                                                            <span class="box_text">Yes </span>
                                                                                        </label>
                                                                                    </li>
                                                                                    <li class="ss_form_item">
                                                                                        <span class="ss_form_input_title">action answered</span>
                                                                                        <input type="checkbox" id="pdf_check_yes107" name="1" class="ss_form_input" value="YES">
                                                                                        <label for="pdf_check_yes40" class="input_with_check">
                                                                                            <span class="box_text">Yes </span>
                                                                                        </label>
                                                                                    </li>
                                                                                    <li class="ss_form_item">

                                                                                        <label class="ss_form_input_title">Upcoming court Motions</label>
                                                                                        <input class="ss_form_input" data-field="PropertyInfo.Block">
                                                                                    </li>
                                                                                    <li class="ss_form_item">

                                                                                        <label class="ss_form_input_title">Upcoming court Orders</label>
                                                                                        <input class="ss_form_input" data-field="PropertyInfo.Block">
                                                                                    </li>
                                                                                    <li class="ss_form_item">

                                                                                        <label class="ss_form_input_title">Upcoming court Date</label>
                                                                                        <input class="ss_form_input ss_date" data-field="PropertyInfo.Block">
                                                                                    </li>


                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Partition</label>
                                                                                        <input class="ss_form_input" data-field="PropertyInfo.Lot">
                                                                                    </li>
                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Breach of Contract</label>
                                                                                        <input class="ss_form_input">
                                                                                    </li>
                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Quiet Title</label>
                                                                                        <input class="ss_form_input">
                                                                                    </li>

                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Other </label>
                                                                                        <input class="ss_form_input">
                                                                                    </li>
                                                                                </ul>
                                                                            </div>

                                                                            <div class="ss_form">
                                                                                <h4 class="ss_form_title">Attorney 1
                                                            <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="ShowSelectParty()" style="display: inline !important;"></i>

                                                                                </h4>
                                                                                <ul class="ss_form_box clearfix">
                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Name</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Name" data-item-type="1" disabled="">
                                                                                    </li>



                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Phone #</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Cell" data-item-type="1" disabled="">
                                                                                    </li>

                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Fax #</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.OfficeNO" data-item-type="1" disabled="">
                                                                                    </li>

                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">email</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Email" data-item-type="1" disabled="">
                                                                                    </li>
                                                                                </ul>

                                                                            </div>
                                                                            <div class="ss_form">
                                                                                <h4 class="ss_form_title">Attorney 2
                                                            <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="ShowSelectParty()" style="display: inline !important;"></i>

                                                                                </h4>
                                                                                <ul class="ss_form_box clearfix">
                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Name</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Name" data-item-type="1" disabled="">
                                                                                    </li>



                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Phone #</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Cell" data-item-type="1" disabled="">
                                                                                    </li>

                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Fax #</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.OfficeNO" data-item-type="1" disabled="">
                                                                                    </li>

                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">email</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Email" data-item-type="1" disabled="">
                                                                                    </li>
                                                                                </ul>

                                                                            </div>

                                                                            <div class="ss_form">
                                                                                <h4 class="ss_form_title">Opposing Counsel
                                                                                <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="ShowSelectParty()" style="display: inline !important;"></i>

                                                                                </h4>
                                                                                <ul class="ss_form_box clearfix">
                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Name</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Name" data-item-type="1" disabled="">
                                                                                    </li>



                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Phone #</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Cell" data-item-type="1" disabled="">
                                                                                    </li>

                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">Fax #</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.OfficeNO" data-item-type="1" disabled="">
                                                                                    </li>

                                                                                    <li class="ss_form_item">
                                                                                        <label class="ss_form_input_title">email</label>
                                                                                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Email" data-item-type="1" disabled="">
                                                                                    </li>
                                                                                </ul>

                                                                            </div>

                                                                            <uc1:LegalSecondaryActions runat="server" id="LegalSecondaryActions" />

                                                                        </div>
                                                                    </div>



                                                                    <div class="ss_form" style="padding-bottom: 20px;">
                                                                        <h4 class="ss_form_title">Legal  Notes <i class="fa fa-plus-circle  color_blue_edit collapse_btn tooltip-examples" title="" onclick="addOccupantNoteClick( 0  ,this);" data-original-title="Add"></i></h4>


                                                                        <div class="note_input" style="display: none" data-index="0">
                                                                            {{#Notes}}
                                                                            <div class="clearence_list_item">
                                                                                <div class="clearence_list_content clearfix" style="margin-bottom: 10px">
                                                                                    <div class="clearence_list_text" style="margin-top: 0px;">
                                                                                        <div class="clearence_list_text14">
                                                                                            <i class="fa fa-caret-right clearence_caret_right_icon"></i>
                                                                                            <i class="fa fa-times color_blue_edit icon_btn tooltip-examples" title="" style="float: right" onclick="deleteAccoupantNote(0,{{id}})" data-original-title="Delete"></i>
                                                                                            <span class="clearence_list_text14">{{Notes}}
                                                                                                    <br>

                                                                                                <span class="clearence_list_text12">{{CreateDate}} by {{CreateBy}}
                                                                                                </span>
                                                                                            </span>

                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                            {{/Notes}}
                                                                        </div>
                                                                        <div class="note_output">


                                                                            <div class="clearence_list_item">
                                                                                <div class="clearence_list_content clearfix" style="margin-bottom: 10px">
                                                                                    <div class="clearence_list_text" style="margin-top: 0px;">
                                                                                        <div class="clearence_list_text14">
                                                                                            <i class="fa fa-caret-right clearence_caret_right_icon"></i>
                                                                                            <i class="fa fa-times color_blue_edit icon_btn tooltip-examples" title="" style="float: right" onclick="deleteAccoupantNote(0,0)" data-original-title="Delete"></i>
                                                                                            <span class="clearence_list_text14">Note for test
                                                                        <br>

                                                                                                <span class="clearence_list_text12">4/6/2015 9:57:43 AM by 123
                                                                                                </span>
                                                                                            </span>

                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>


                                                                </div>
                                                            </div>

                                                        </div>
                                                    </div>
                                                </div>

                                            </div>



                                        </div>


                                    </div>
                                </div>
                            </div>
                            <uc1:VendorsPopup runat="server" ID="VendorsPopup" />
                            <script src="/scripts/jquery.formatCurrency-1.1.0.js"></script>
                        </div>
                    </dx:SplitterContentControl>

                </ContentCollection>

            </dx:SplitterPane>
            <dx:SplitterPane ShowCollapseBackwardButton="True" PaneStyle-BackColor="#f9f9f9">
                <ContentCollection>
                    <dx:SplitterContentControl>
                        <div style="font-size: 12px; color: #9fa1a8;">
                            <ul class="nav nav-tabs clearfix" role="tablist" style="height: 70px; background: #295268; font-size: 18px; color: white">
                                <li class="short_sale_head_tab activity_light_blue">
                                    <a href="#property_info" role="tab" data-toggle="tab" class="tab_button_a">
                                        <i class="fa fa-history head_tab_icon_padding"></i>
                                        <div class="font_size_bold">Activity Log</div>
                                    </a>
                                </li>
                                <%--<li><a role="tab" data-toggle="tab">Settings</a></li>--%>
                                <li style="margin-right: 30px; color: #7396a9; float: right">

                                    <div style="display: inline-block">
                                        <a href="/LegalUI/LegalUI.aspx?SecondaryAction=true"><i class="fa fa-arrow-right sale_head_button sale_head_button_left tooltip-examples" style="margin-right: 10px; color: #7396A9" title="Secondary" onclick=""></i></a>
                                    </div>
                                    <i class="fa fa-repeat sale_head_button tooltip-examples" title="Follow Up" onclick="ASPxPopupMenuClientControl.ShowAtElement(this);"></i>
                                    <%-- <i class="fa fa-file sale_head_button sale_head_button_left tooltip-examples" title="New File" onclick="LogClick('NewFile')"></i>--%>
                                    <i class="fa fa-folder-open sale_head_button sale_head_button_left tooltip-examples" title="Active" onclick="LogClick('Active')"></i>
                                    <i class="fa fa-sign-out  sale_head_button sale_head_button_left tooltip-examples" title="Eviction" onclick="tmpBBLE=leadsInfoBBLE;popupEvictionUsers.PerformCallback();popupEvictionUsers.ShowAtElement(this);"></i>
                                    <i class="fa fa-pause sale_head_button sale_head_button_left tooltip-examples" title="On Hold" onclick="LogClick('OnHold')"></i>
                                    <i class="fa fa-check-circle sale_head_button sale_head_button_left tooltip-examples" title="Closed" onclick="LogClick('Closed')"></i>
                                    <i class="fa fa-print  sale_head_button sale_head_button_left tooltip-examples" title="Print" onclick="PrintLogInfo()"></i>
                                </li>
                            </ul>
                            <uc1:ActivityLogs runat="server" ID="ActivityLogs" DispalyMode="ShortSale" />
                        </div>
                    </dx:SplitterContentControl>
                </ContentCollection>
            </dx:SplitterPane>
        </Panes>


    </dx:ASPxSplitter>

    <style>
       
    </style>
</asp:Content>
