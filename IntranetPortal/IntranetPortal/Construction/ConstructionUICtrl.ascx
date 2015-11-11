<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionUICtrl.ascx.vb" Inherits="IntranetPortal.ConstructionUICtrl" %>
<%@ Register Src="~/Construction/ConstructionTab.ascx" TagPrefix="uc1" TagName="ConstructionTab" %>
<%@ Register Src="~/PopupControl/SendMail.ascx" TagPrefix="uc1" TagName="SendMail" %>
<%@ Register Src="~/UserControl/DocumentsUI.ascx" TagPrefix="uc1" TagName="DocumentsUI" %>
<div id="ConstructionCtrl" ng-controller="ConstructionCtrl">
    <!-- Nav tabs -->
    <input id="LastUpdateTime" type="hidden" />
    <div class="legal-menu row" style="margin: 0;">
        <ul class="nav nav-tabs clearfix" role="tablist" style="background: #ff400d; font-size: 18px; color: white; height: 70px">
            <li class="active short_sale_head_tab">
                <a href="#ConstructionTab" role="tab" data-toggle="tab" class="tab_button_a">
                    <i class="fa fa-info-circle  head_tab_icon_padding"></i>
                    <div class="font_size_bold">Construction</div>
                </a>
            </li>
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
                <i class="fa fa-save sale_head_button sale_head_button_left tooltip-examples" title="" ng-click="saveCSCase()" data-original-title="Save"></i>
                <i class="fa fa-check sale_head_button sale_head_button_left tooltip-examples" title="Intake Complete" ng-click="intakeComplete()" data-original-title="Intake Completed"></i>
                <i class="fa fa-mail-reply sale_head_button sale_head_button_left tooltip-examples" title="" onclick="popupSelectOwner.PerformCallback('Show');popupSelectOwner.ShowAtElement(this);" data-original-title="Reassign"></i>
                <i class="fa fa-envelope sale_head_button sale_head_button_left tooltip-examples" title="" onclick="ShowEmailPopup(leadsInfoBBLE)" data-original-title="Mail"></i>
                <i class="fa fa-print sale_head_button sale_head_button_left tooltip-examples" title="" ng-click="printWindow()" data-original-title="Print"></i>
            </li>
        </ul>
    </div>

    <dx:ASPxPopupControl ClientInstanceName="popupSelectOwner" Width="300px" Height="300px"
        MaxWidth="800px" MaxHeight="800px" MinHeight="150px" MinWidth="150px" ID="ASPxPopupControl3"
        HeaderText="Select Employee" AutoUpdatePosition="true" Modal="true" OnWindowCallback="ASPxPopupControl3_WindowCallback"
        runat="server" EnableViewState="false" EnableHierarchyRecreation="True">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server" Visible="false" ID="PopupContentReAssign">
                <asp:HiddenField runat="server" ID="hfUserType" />
                <dx:ASPxListBox runat="server" ID="listboxEmployee" ClientInstanceName="listboxEmployeeClient" Height="270" SelectedIndex="0" Width="100%">
                </dx:ASPxListBox>
                <dx:ASPxButton Text="Assign" runat="server" ID="btnAssign" AutoPostBack="false">
                    <ClientSideEvents Click="function(s,e){
                                                            var item = listboxEmployeeClient.GetSelectedItem();
                                                            if(item == null)
                                                            {
                                                                 AngularRoot.alert('Please select user.');
                                                                 return;
                                                             }
                                                            popupSelectOwner.PerformCallback('Save|' + leadsInfoBBLE + '|' + item.text);
                                                            popupSelectOwner.Hide();
                                                            }" />
                </dx:ASPxButton>
            </dx:PopupControlContentControl>
        </ContentCollection>
        <ClientSideEvents Closing="function(s,e){
                                              if (typeof gridTrackingClient != 'undefined')
                                                    gridTrackingClient.Refresh();
                                              if (typeof gridCase != 'undefined')
                                                    gridCase.Refresh();    
                                        }" />
    </dx:ASPxPopupControl>

    <div class="tab-content">
        <div class="tab-pane active" id="ConstructionTab">
            <uc1:ConstructionTab runat="server" ID="ConstructionTab1" />
        </div>
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
</div>

<dx:ASPxPopupControl ClientInstanceName="popupCtrUploadFiles" Width="950px" Height="840px" ID="ASPxPopupControl2"
    HeaderText="Upload Files" AutoUpdatePosition="true" Modal="true" CloseAction="CloseButton"
    runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
    <HeaderTemplate>
        <div class="clearfix">
            <div class="pop_up_header_margin">
                <i class="fa fa-cloud-upload with_circle pop_up_header_icon"></i>
                <span class="pop_up_header_text">Upload Files</span>
            </div>
            <div class="pop_up_buttons_div">
                <i class="fa fa-times icon_btn" onclick="popupCtrUploadFiles.Hide()"></i>
            </div>
        </div>
    </HeaderTemplate>
    <ContentCollection>
        <dx:PopupControlContentControl runat="server">
        </dx:PopupControlContentControl>
    </ContentCollection>
    <ClientSideEvents CloseUp="function(s,e){}" />
</dx:ASPxPopupControl>
<uc1:SendMail runat="server" ID="SendMail" />


<script type="text/javascript">
    var Current_User = '<%= HttpContext.Current.User.Identity.Name%>';
    function LoadCaseData(bble) {
        $(document).ready(function () {
            //put construction data loading logic here
            var scope = angular.element('#ConstructionCtrl').scope();
            scope.init(bble, function () {
                scope.updatePercentage();

            });
        });
    }

    angular.module('PortalApp').controller('ConstructionCtrl', function ($scope, $http, $timeout, $interpolate, ptCom, ptContactServices, ptEntityService, ptShortsSaleService, ptLeadsService, ptConstructionService) {
        // scope variables defination
        $scope._ = _;
        $scope.arrayRemove = ptCom.arrayRemove;
        $scope.ptContactServices = ptContactServices;
        $scope.ensurePush = function (modelName, data) { ptCom.ensurePush($scope, modelName, data); }

        $scope.ReloadedData = {}
        $scope.CSCase = {}
        $scope.CSCase.CSCase = {
            InitialIntake: {},
            Photos: {},
            Utilities: {},
            Violations: {},
            ProposalBids: {},
            Plans: {},
            Contract: {},
            Signoffs: {},
            Comments: []
        };
        $scope.CSCase.CSCase.Utilities.Company = [];
        $scope.CSCase.CSCase.Utilities.Insurance_Type = [];
        $scope.percentage = {
            intake: {
                count: 0,
                finished: 0,
            },
            signoff: {
                count: 0,
                finished: 0
            },
            construction: {
                count: 0,
                finished: 0
            },
            test: {
                count: 0,
                finished: 0
            }
        }
        $scope.UTILITY_SHOWN = {
            'ConED': 'CSCase.CSCase.Utilities.ConED_Shown',
            'Energy Service': 'CSCase.CSCase.Utilities.EnergyService_Shown',
            'National Grid': 'CSCase.CSCase.Utilities.NationalGrid_Shown',
            'DEP': 'CSCase.CSCase.Utilities.DEP_Shown',
            'MISSING Water Meter': 'CSCase.CSCase.Utilities.MissingMeter_Shown',
            'Taxes': 'CSCase.CSCase.Utilities.Taxes_Shown',
            'ADT': 'CSCase.CSCase.Utilities.ADT_Shown',
            'Insurance': 'CSCase.CSCase.Utilities.Insurance_Shown',
        };
        $scope.HIGHLIGHTS = [
                                { message: 'Plumbing signed off at {{CSCase.CSCase.Signoffs.Plumbing_SignedOffDate}}', criteria: 'CSCase.CSCase.Signoffs.Plumbing_SignedOffDate' },
                                { message: 'Electrical signed off at {{CSCase.CSCase.Signoffs.Electrical_SignedOffDate}}', criteria: 'CSCase.CSCase.Signoffs.Electrical_SignedOffDate' },
                                { message: 'Construction signed off at {{CSCase.CSCase.Signoffs.Construction_SignedOffDate}}', criteria: 'CSCase.CSCase.Signoffs.Construction_SignedOffDate' },
                                { message: 'HPD Violations has all finished', criteria: 'CSCase.CSCase.Violations.HPD_OpenHPDViolation === false' }
        ];
        $scope.WATCHED_MODEL = [
                                    {
                                        model: 'CSCase.CSCase.Signoffs.Plumbing_SignedOffDate',
                                        backedModel: 'ReloadedData.Backed_Plumbing_SignedOffDate',
                                        info: 'Plumbing Sign Off Date'
                                    },
                                    {
                                        model: 'CSCase.CSCase.Signoffs.Construction_SignedOffDate',
                                        backedModel: 'ReloadedData.Backed_Construction_SignedOffDate',
                                        info: 'Construction Sign Off Date'
                                    },
                                    {
                                        model: 'CSCase.CSCase.Signoffs.Electrical_SignedOffDate',
                                        backedModel: 'ReloadedData.Electrical_SignedOffDate',
                                        info: 'Electrical Sign Off Date'
                                    }];

        // end scope variables defination

        $scope.reload = function () {

            $scope.ReloadedData = {}
            $scope.CSCase = {}
            $scope.CSCase.CSCase = {
                InitialIntake: {},
                Photos: {},
                Utilities: {},
                Violations: {},
                ProposalBids: {},
                Plans: {},
                Contract: {},
                Signoffs: {},
                Comments: []
            };
            $scope.CSCase.CSCase.Utilities.Company = [];
            $scope.CSCase.CSCase.Utilities.Insurance_Type = [];
            $scope.ensurePush('CSCase.CSCase.Utilities.Floors', { FloorNum: '?', ConED: {}, EnergyService: {}, NationalGrid: {} });
            $scope.percentage = {
                intake: {
                    count: 0,
                    finished: 0,
                },
                signoff: {
                    count: 0,
                    finished: 0
                },
                construction: {
                    count: 0,
                    finished: 0
                },
                test: {
                    count: 0,
                    finished: 0
                }
            }

            $scope.clearWarning();
        }
        $scope.init = function (bble, callback) {
            ptCom.startLoading();
            bble = bble.trim();
            $scope.reload();
            var done1, done2, done3, done4;

            ptConstructionService.getConstructionCases(bble, function (res) {
                ptCom.nullToUndefined(res);
                $.extend(true, $scope.CSCase, res);
                $scope.initWatchedModel();
                done1 = true;
                if (done1 && done2 && done3 & done4) {
                    ptCom.stopLoading();
                    if (callback) callback();
                }
                ScopeSetLastUpdateTime($scope.GetTimeUrl());
            });

            ptShortsSaleService.getShortSaleCaseByBBLE(bble, function (res) {
                $scope.SsCase = res;
                done2 = true;
                if (done1 && done2 && done3 & done4) {
                    ptCom.stopLoading();
                    if (callback) callback();
                }

            });

            ptLeadsService.getLeadsByBBLE(bble, function (res) {
                $scope.LeadsInfo = res;
                done3 = true;
                if (done1 && done2 && done3 & done4) {
                    ptCom.stopLoading();
                    if (callback) callback();
                }
            });

            ptEntityService.getEntityByBBLE(bble, function (error, data) {
                if (data) {
                    $scope.EntityInfo = data;
                } else {
                    $scope.EntityInfo = {};
                    console.log(error);
                }
                done4 = true;
                if (done1 && done2 && done3 & done4) {
                    ptCom.stopLoading();
                    if (callback) callback();
                }
            })

        }

        /* Status change function -- Chris */
        $scope.ChangeStatus = function (scuessfunc, status) {

            $http.post('/api/ConstructionCases/ChangeStatus/' + leadsInfoBBLE, status).
                    success(function () {
                        if (scuessfunc) {
                            scuessfunc();
                        } else {
                            ptCom.alert("Successed !");
                        }
                    }).
                    error(function (data, status) {
                        ptCom.alert("Fail to save data. status " + status + "Error : " + JSON.stringify(data));
                    });
        }
        /* end status change function */

        $scope.saveCSCase = function () {
            var data = JSON.stringify($scope.CSCase);
            ptConstructionService.saveConstructionCases($scope.CSCase.BBLE, data, function (res) {
                ScopeSetLastUpdateTime($scope.GetTimeUrl());
                ptCom.alert("Save successfully!");
            });
            $scope.updateInitialFormOwner();
            $scope.checkWatchedModel();
        }
        /***spliter***/

        /* multiple company selection */
        $scope.resetCompany = function (obj) {
            for (var key in obj) {
                var value = obj[key];
                $scope.$eval(value + '=false');
            }
        };
        $scope.$watch('CSCase.CSCase.Utilities.Company', function (newValue) {
            if (newValue) {
                var ds = $scope.UTILITY_SHOWN;
                var target = $scope.CSCase.CSCase.Utilities.Company;
                $scope.resetCompany(ds);
                for (var i in target) {
                    $scope.$eval(ds[target[i]] + '=true');
                }
            }
        }, true);
        $scope.$watch('CSCase.CSCase.Utilities.ConED_EnergyServiceRequired', function (newVal) {

            if (newVal) {
                if ($scope.CSCase.CSCase.Utilities.Company.indexOf('Energy Service') < 0) {
                    $scope.CSCase.CSCase.Utilities.Company.push('Energy Service');
                    $scope.ReloadedData.EnergyService_Collapsed = false;
                }
            } else {
                var index;
                if ((index = $scope.CSCase.CSCase.Utilities.Company.indexOf('Energy Service')) != -1) $scope.CSCase.CSCase.Utilities.Company.splice(index, 1);
            }


        });
        /* end multiple company selection */

        /* reminder */
        $scope.sendNotice = function (id, name) {
            var confirmed = confirm("Send Intake Sheet To " + name + " ?");
        }
        /* end reminder */

        /* comments */
        $scope.showPopover = function (e) {
            aspxConstructionCommentsPopover.ShowAtElement(e.target);
        }
        $scope.addComment = function (comment) {
            var newComments = {}
            newComments.comment = comment;
            newComments.caseId = $scope.CaseId;
            newComments.createBy = Current_User;
            newComments.createDate = new Date();
            $scope.CSCase.CSCase.Comments.push(newComments);
        }
        $scope.addCommentFromPopup = function () {
            var comment = $scope.addCommentTxt;
            $scope.addComment(comment);
            $scope.addCommentTxt = '';
        }
        /* end comments */

        /* active tab */
        $scope.activeTab = 'CSInitialIntake';
        $scope.updateActive = function (id) {
            $scope.activeTab = id;
        }
        /* end active tab */

        /* highlight */

        $scope.isHighlight = function (criteria) {
            return $scope.$eval(criteria);
        }
        $scope.highlightMsg = function (msg) {
            var msgstr = $interpolate(msg)($scope);
            return msgstr;
        }
        $scope.initWatchedModel = function () {
            _.each($scope.WATCHED_MODEL, function (el, i) {
                $scope.$eval(el.backedModel + '=' + el.model);
            })
        }
        $scope.checkWatchedModel = function () {
            var res = ''
            _.each($scope.WATCHED_MODEL, function (el, i) {
                if ($scope.$eval(el.backedModel + '!=' + el.model)) {
                    $scope.$eval(el.backedModel + '=' + el.model);
                    res += (el.info + ' changes to ' + $scope.$eval(el.model) + '.<br>')
                }
            })
            if (res) AddActivityLog(res);
        }

        /* end highlight */

        /* Popup */
        $scope.setPopupVisible = function (modelName, bVal) {
            $scope.$eval(modelName + '=' + bVal)
        }
        /* end Popup*/

        /* header editing */
        $scope.HeaderEditing = false;
        $scope.toggleHeaderEditing = function (open) {
            $scope.HeaderEditing = !$scope.HeaderEditing;
            if (open) $("#ConstructionTitleInput").focus();
        }
        /* end header editing */

        /* dob fetch */
        $scope.CSCase.CSCase.Violations.DOBViolations = [{}];
        $scope.CSCase.CSCase.Violations.ECBViolations = [{}];
        $scope.addNewDOBViolation = function () {
            $scope.ensurePush('CSCase.CSCase.Violations.DOBViolations');
            $scope.setPopupVisible('DOBViolations_PopupVisible_' + ($scope.CSCase.CSCase.Violations.DOBViolations.length - 1), true);
        }
        $scope.addNewECBViolation = function () {
            $scope.ensurePush('CSCase.CSCase.Violations.ECBViolations');
            $scope.setPopupVisible('ECBViolations_PopupVisible_' + ($scope.CSCase.CSCase.Violations.ECBViolations.length - 1), true);
        }
        $scope.fetchDOBViolations = function () {
            var dialog = DevExpress.ui.dialog.confirm("Get the information from DOB will take a while\n and REPLACE your current Data, are you sure to continue?", "Warning");
            dialog.done(function (confirmed) {
                if (confirmed) {
                    ptConstructionService.getDOBViolations($scope.CSCase.BBLE, function (error, res) {
                        if (error) {
                            ptCom.alert(error);
                            console.log(error)
                        } else {
                            var dialog = DevExpress.ui.dialog.confirm("Your current DOB Violation data will be replaced?", "Warning");
                            dialog.done(function (confirmed) {
                                if (confirmed) {
                                    var data = res
                                    $scope.$apply(function () {
                                        if (data.DOB_TotalDOBViolation) $scope.CSCase.CSCase.Violations.DOB_TotalDOBViolation = data.DOB_TotalDOBViolation;
                                        if (data.DOB_TotalOpenViolations) $scope.CSCase.CSCase.Violations.DOB_TotalOpenViolations = data.DOB_TotalOpenViolations;
                                        if (data.violations) $scope.CSCase.CSCase.Violations.DOBViolations = data.violations;
                                    })
                                }
                            })

                        }
                    })
                }

            })

        }
        $scope.fetchECBViolations = function () {
            var dialog = DevExpress.ui.dialog.confirm("Get the information from DOB will REPLACE your current data, yes to continue?", "Warning");
            dialog.done(function (confirmed) {
                if (confirmed) {
                    ptConstructionService.getECBViolations($scope.CSCase.BBLE, function (error, res) {
                        if (error) {
                            ptCom.alert(error);
                            console.log(error)
                        } else {
                            var dialog = DevExpress.ui.dialog.confirm("Your current ECB Violation data will be replaced?", "Warning");
                            dialog.done(function (confirmed) {
                                if (confirmed) {
                                    var data = res
                                    $scope.$apply(function () {
                                        if (data.ECP_TotalViolation) $scope.CSCase.CSCase.Violations.ECP_TotalViolation = data.ECP_TotalViolation;
                                        if (data.ECP_TotalOpenViolations) $scope.CSCase.CSCase.Violations.ECP_TotalOpenViolations = data.ECP_TotalOpenViolations;
                                        if (data.violations) {
                                            $scope.CSCase.CSCase.Violations.ECBViolations = _.filter(data.violations, function (el, i) { return el.DOBViolationStatus.slice(0,4) == "OPEN" });
                                        }
                                    })
                                }
                            })

                        }
                    })
                }

            })
        }
        /* end dob fetch */

        /* intakeComplete */
        $scope.test = $scope.checkIntake;
        $scope.intakeComplete = function () {
            if (!$scope.checkIntake(function (el) {
                el.prev().css('background-color', 'yellow')
            })) {
                $scope.CSCase.IntakeCompleted = true;
                AddActivityLog("Intake Process have finished!");
                $scope.saveCSCase();
            } else {
                ptCom.alert("Intake Complete Fails.\nPlease check highlights for missing information!");
            }
        }
        $scope.checkIntake = function (callback) {
            $scope.clearWarning();
            $scope.percentage.intake.count = 0;
            $scope.percentage.intake.finished = 0;
            $(".intakeCheck").each(function (idx) {
                var model = $(this).attr('ng-model') || $(this).attr('ss-model') || $(this).attr('file-model') || $(this).attr('model');
                if (model) {
                    if (model.slice(0,4) == "floor") {
                        var test = _.has($(this).scope().floor, model.split(".").splice(1).join('.'));
                        if (!test) {
                            if (callback) callback($(this))
                        } else {
                            $scope.percentage.intake.finished++;
                        }
                    } else {
                        var test = $scope.$eval(model)
                        if (test === undefined) {
                            if (callback) callback($(this))
                        } else {
                            $scope.percentage.intake.finished++;
                        }
                    }
                }
                $scope.percentage.intake.count++;
            })
            var errors = $scope.percentage.intake.count - $scope.percentage.intake.finished;
            return errors;
        }
        $scope.clearWarning = function () {
            $(".intakeCheck").each(function (idx) {
                $(this).prev().css('background-color', 'transparent');
            });
        }
        $scope.updatePercentage = function () {
            $scope.checkIntake();
        }
        /* end intakeComplte */

        /*check file be modify*/
        $scope.GetTimeUrl = function () {
            return $scope.CSCase.BBLE ? "/api/ConstructionCases/LastLastUpdate/" + $scope.CSCase.BBLE : "";
        }
        $scope.GetCSCaseId = function () {
            return $scope.CSCase.BBLE;
        }
        $scope.GetModifyUserUrl = function () {
            return "/api/ConstructionCases/LastModifyUser/" + $scope.CSCase.BBLE;
        }
        ScopeDateChangedByOther($scope.GetTimeUrl, LoadCaseData, $scope.GetCSCaseId, $scope.GetModifyUserUrl);
        /****** end check file be modify*********/

        /* printWindows*/
        $scope.printWindow = function () {
            window.open("/Construction/ConstructionPrint.aspx?bble=" + $scope.CSCase.BBLE, 'Print', 'width=1024, height=800');
        }
        /* end printWindows */

        $scope.openInitialForm = function () {
            window.open("/Construction/ConstructionInitialForm.aspx?bble=" + $scope.CSCase.BBLE, 'Initial Form', 'width=1280, height=960')
        }

        $scope.openBudgetForm = function () {
            window.open("/Construction/ConstructionBudgetForm.aspx?bble=" + $scope.CSCase.BBLE, 'Budget Form', 'width=1024, height=768')
        }

        $scope.getRunnerList = function () {
            var url = "/api/ConstructionCases/GetRunners"
            $http.get(url)
            .then(function (res) {
                if (res.data) {
                    $scope.RUNNER_LIST = res.data;
                }
            })
        }();

        $scope.updateInitialFormOwner = function () {
            var url = "/api/ConstructionCases/UpdateInitialFormOwner?BBLE=" + $scope.CSCase.BBLE + "&owner=" + $scope.CSCase.CSCase.InitialIntake.InitialFormAssign
            $http({
                method: 'POST',
                url: url
            }).then(function success(res) {
                console.log("Assign Initial Form owner Success.")
            }, function error(res) {
                console.log("Fail to assign Initial Form owner.")
            })
        }
    });
</script>
