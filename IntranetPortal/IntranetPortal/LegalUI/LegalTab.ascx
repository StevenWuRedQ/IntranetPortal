<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LegalTab.ascx.vb" Inherits="IntranetPortal.LegalTab" %>
<%@ Register TagPrefix="uc1" TagName="legalsecondaryactions" Src="~/LegalUI/LegalSecondaryActions.ascx" %>
<%@ Register Src="~/LegalUI/LegalSummaryTab.ascx" TagPrefix="uc1" TagName="LegalSummaryTab" %>
<%@ Register Src="~/LegalUI/LegalForeclosureReviewTab.ascx" TagPrefix="uc1" TagName="LegalForeclosureReviewTab" %>
<%@ Register Src="~/LegalUI/LegalSecondaryActionTab.ascx" TagPrefix="uc1" TagName="LegalSecondaryActionTab" %>
<%@ Register Src="~/LegalUI/LegalWriteupTab.ascx" TagPrefix="uc1" TagName="LegalWriteupTab" %>
<%@ Register Src="~/UserControl/LeadsSubMenu.ascx" TagPrefix="uc1" TagName="LeadsSubMenu" %>

<div id="LegalCtrl" ng-controller="LegalCtrl" style="position: absolute; top: 70px; bottom: 0px; width: 100%; margin-bottom: 250px">
    <div id="prioity_content" style="height: 250px;">
        <div class="content-title font_gray">
            <div style="font-size: 30px">
                <span>
                    <i class="fa fa-home"></i>
                    <span style="margin-left: 19px;">{{GetCaseInfo().Address}}&nbsp; {{LeadsInfo.BoroughName}} &nbsp; <span style="color: red">{{LegalCase.SaleDate|date}}</span></span>
                </span>
                <span class="time_buttons" style="margin-right: 30px" ng-click="ShowECourts(LegalCase.PropertyInfo.Borough, 'eCourts')" ng-show="LegalCase.PropertyInfo.Borough!=1">eCourts</span>
                <span class="time_buttons" onclick="ShowDOBWindow(GetLegalData().PropertyInfo.Borough,GetLegalData().PropertyInfo.Block, GetLegalData().PropertyInfo.Lot)">DOB</span>
                <span class="time_buttons" onclick="ShowAcrisMap(leadsInfoBBLE)">Acris</span>
                <span class="time_buttons" onclick="ShowPropertyMap(leadsInfoBBLE)">Maps</span>
                <span class="time_buttons" onclick="" runat="server" visible="false" id="btnAssignAttorney">Assign Attorney</span>
                <span class="time_buttons" onclick="$('#RequestModal').modal()" style="display: none">Request Document</span>
                <br />

                <span class="time_buttons" ng-show="LegalCase.PreQuestions" onclick="window.open('/LegalUI/LegalPreQuestions.aspx?r=true&bble=' + leadsInfoBBLE, 'LegalPreQuestion', 'width=1024, height=800');">Show Questions Form</span>
            </div>
            <span style="font-size: 14px; margin-top: -5px; float: left; margin-left: 53px; visibility: visible">{{GetCaseInfo().Name}}</span>
        </div>

        <div class="font_deep_gray" style="border-top: 1px solid #dde0e7; font-size: 20px; margin: 0">
            <div class="note_item" style="background: white">
                <div style="overflow: auto; max-height: 100px">
                    <table style="width: 100%;" class="table-striped">
                        <tbody>
                            <tr ng-show="LegalECourt" style="color: red">
                                <td style="width: 20px">
                                    <i class="fa fa-exclamation-circle note_img"></i>
                                </td>
                                <td>
                                    <div class="note_text">Get new Appearance Date : {{LegalECourt.AppearanceDate |date:'MM/dd/yyyy'}}</div>
                                </td>

                            </tr>
                            <tr ng-show="LegalCase.Description!=null">
                                <td style="width: 20px">
                                    <i class="fa fa-exclamation-circle note_img"></i>
                                </td>
                                <td>
                                    <div class="note_text">Agent description : {{LegalCase.Description}}</div>
                                </td>
                                <td style="width: 30px; padding-right: 25px;">&nbsp;
                                </td>
                            </tr>
                            <tr ng-repeat="n in hSummery" ng-show="n.visible">
                                <td style="width: 30px">
                                    <i class="fa fa-exclamation-circle note_img"></i>
                                </td>
                                <td>
                                    <div class="note_text">{{n.Description}}</div>
                                </td>
                                <td style="width: 30px; padding-right: 25px;">&nbsp;
                                </td>
                            </tr>

                            <tr ng-repeat="n in LegalCase.LegalComments">
                                <td style="width: 30px">
                                    <i class="fa fa-exclamation-circle note_img"></i>
                                </td>
                                <td>
                                    <div class="note_text">{{n.Comment}}</div>
                                </td>
                                <td style="width: 30px; padding-right: 25px;">
                                    <i class="fa fa-times" style="font-size: 18px; color: #b1b2b7; cursor: pointer" ng-click="DeleteComments($index)"></i>
                                </td>
                            </tr>

                        </tbody>
                    </table>

                </div>


                <i class="fa fa-plus-circle note_img tooltip-examples" title="" style="color: #3993c1; cursor: pointer" ng-click="ShowAddPopUp($event);" data-original-title="Add Notes"></i>
            </div>
        </div>
    </div>

    <!--detial Nav tabs -->
    <div style="height: 100%; position: absolute; top: 250px; bottom: 0; width: 100%;">
        <ul class="nav nav-tabs overview_tabs" role="tablist">
            <li class="short_sale_tab active"><a class="shot_sale_tab_a " href="#Summary" role="tab" data-toggle="tab">Summary</a></li>
            <li class="short_sale_tab"><a class="shot_sale_tab_a " href="#Foreclosure_Review" role="tab" data-toggle="tab">Foreclosure Review</a></li>
            <li class="short_sale_tab"><a class="shot_sale_tab_a " href="#Secondary_Actions" role="tab" data-toggle="tab">Secondary Actions</a></li>
            <li class="short_sale_tab"><a class="shot_sale_tab_a " href="#LegalWriteupTab" role="tab" data-toggle="tab">Write Up</a></li>
        </ul>
        <!-- Tab panes -->
        <div class="tab-content" style="height:100%; overflow:auto">
            <div class="tab-pane active" id="Summary">
                <uc1:LegalSummaryTab runat="server" ID="LegalSummaryTab" />
            </div>
            <div class="tab-pane " id="Foreclosure_Review">
                <uc1:LegalForeclosureReviewTab runat="server" ID="LegalForeclosureReviewTab" />
            </div>
            <div class="tab-pane" id="Secondary_Actions">
                <uc1:LegalSecondaryActionTab runat="server" ID="LegalSecondaryActionTab" />
            </div>
            <div class="tab-pane" id="LegalWriteupTab">
                <uc1:LegalWriteupTab runat="server" ID="LegalWriteupTab1" />
            </div>
        </div>
    </div>
    <input hidden="" id="short_sale_case_id" value="23" />

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
    <dx:ASPxPopupControl ClientInstanceName="aspxAddLeadsComments" Width="550px" Height="50px" ID="ASPxPopupControl2"
        HeaderText="Add Comments" ShowHeader="false"
        runat="server" EnableViewState="false" PopupHorizontalAlign="OutsideRight" PopupVerticalAlign="Middle" EnableHierarchyRecreation="True">
        <ContentCollection>
            <dx:PopupControlContentControl>
                <table>
                    <tr style="padding-top: 3px;">
                        <td style="width: 380px; vertical-align: central">
                            <input type="text" ng-model="addCommentTxt" class="form-control" />
                        </td>
                        <td style="text-align: right">
                            <div style="margin-left: 20px">
                                <input type="button" value="Add" ng-click="SaveLegalComments()" class="rand-button" style="background-color: #3993c1" />
                                <input type="button" value="Close" onclick="aspxAddLeadsComments.Hide()" class="rand-button" style="background-color: #3993c1" />
                            </div>
                        </td>
                    </tr>
                </table>
            </dx:PopupControlContentControl>
        </ContentCollection>
    </dx:ASPxPopupControl>
    <dx:ASPxPopupControl ClientInstanceName="aspxAcrisControl" Width="1000px" Height="800px"
        ID="ASPxPopupControl1" HeaderText="Acris" Modal="true" CloseAction="CloseButton" ShowMaximizeButton="true"
        runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
        <HeaderTemplate>
            <div class="clearfix">
                <div class="pop_up_header_margin">
                    <i class="fa fa-tasks with_circle pop_up_header_icon"></i>
                    <span class="pop_up_header_text" id="pop_up_header_text">Acris</span> <span class="pop_up_header_text"></span>
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

        function ShowPopupMap(url, header, subHeader) {
            aspxAcrisControl.SetContentHtml("Loading...");
            aspxAcrisControl.SetContentUrl(url);
            aspxAcrisControl.SetHeaderText(header);

            $('#pop_up_header_text').html(header);
            $('#addition_info').html(subHeader ? subHeader : '');

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
    <uc1:LeadsSubMenu runat="server" ID="LeadsSubMenu" />

    <div class="modal fade" id="NeedAddCommentPopUp">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">You didn't add a comment please input open files reason to continue!</h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="message-text" class="control-label">Comment:</label>
                        <textarea class="form-control" ng-model="MustAddedComment"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" data-dismiss="modal" ng-disabled="!MustAddedComment" ng-click="AddActivityLog()">Add Comment</button>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="WorkPopUp">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">Working Total : {{TotleHours.Total}} hours</h4>
                </div>
                <div class="modal-body">
                    <div style="overflow: auto; max-height: 300px">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <td>User</td>
                                    <td>StartTime</td>

                                    <td>EndTime</td>
                                    <td>Duration</td>
                                </tr>
                            </thead>
                            <tbody>
                                <tr ng-repeat="l in TotleHours.LogData">
                                    <td class="">{{l.UserName }}
                                    </td>
                                    <td>{{l.StartTime |date:'MM/dd/yyyy HH:mm:ss'}}
                                    </td>
                                    <td>{{l.EndTime |date:'MM/dd/yyyy HH:mm:ss'}}
                                    </td>
                                    <td>{{l.Duration |date:'HH:mm:ss'}}
                                    </td>

                                </tr>
                            </tbody>
                        </table>
                    </div>

                </div>

            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <div class="modal fade" id="HistoryPopup">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title">History Versions:</h4>
                </div>
                <div class="modal-body">
                    <div style="overflow: auto; max-height: 300px">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <td>Modified Date</td>
                                    <td>Modified User</td>
                                    <td>Details</td>
                                </tr>
                            </thead>
                            <tbody>
                                <tr ng-repeat="h in History| orderBy: '-CreateDate'">
                                    <td>{{ h.CreateDate |date:'MM/dd/yyyy HH:mm:ss'}}
                                    </td>
                                    <td>{{ h.CreateBy }}
                                    </td>
                                    <td><a href="" ng-click="openHistoryWindow(h.LogId)">Open</a>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                </div>

            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</div>
