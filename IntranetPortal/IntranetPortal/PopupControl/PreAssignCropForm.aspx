<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="PreAssignCropForm.aspx.vb" Inherits="IntranetPortal.PerAssignCropForm" %>

<%@ Register Src="~/UserControl/AuditLogs.ascx" TagPrefix="uc1" TagName="AuditLogs" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .wizard-content {
            min-height: 400px;
        }

        .online {
            width: 100% !important;
        }

        .avoid-check {
            text-decoration: line-through;
        }

        a.dx-link-MyIdealProp:hover {
            font-weight: 500;
            cursor: pointer;
        }

        .myRow:hover {
            background-color: #efefef;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <input type="hidden" id="preSignId" value='<%= Request.QueryString("preSignId")%>' />
    <input type="hidden" id="BBLE" value='<%= Request.QueryString("BBLE")%>' />
    <div ng-controller="perAssignCtrl" class="container">
        <div class="row">
            <div class="col-md-12" ng-hide="!preSignList">
                <div style="padding: 20px">
                    <h2 ng-if="role==null">Pre Deal Request List</h2>
                    <h2 ng-if="role=='finance'">Check Requests List</h2>
                    <div dx-data-grid="preSignRecordsGridOpt">
                        <div data-options="dxTemplate: {name: 'detail'}">
                            <div class="internal-grid-container">
                                <div>Checks :</div>
                                <div class="internal-grid" dx-data-grid="{
				                    dataSource: data.Checks,
				                    columnAutoWidth: true,
                                    columns: ['PaybleTo', {
                                        dataField: 'Amount',
                                        format: 'currency', dataType: 'number', precision: 2
                                        
                                    }, {
                                        dataField: 'Date',
                                        caption:'Check Date',
                                        dataType: 'date',
                                        format: 'shortDate'
                                    },{
                                        dataField: 'Description'  
                                    }]                
			                    }">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row" ng-if="preAssign.BBLE||model=='View'||model=='Edit'" id="preDealForm">
            <div style="max-width: 700px">
                <div id="wizard" <%=IIf(String.IsNullOrEmpty(Request.QueryString("popup")), "style='padding:20px';max-width:600px", "") %>>
                    <%--<div class="wizardbar">
                <a class="wizardbar-item {{step==$index+1?'current':'' }}" href="#" ng-repeat="s in steps|filter:{show:true}">{{s.title}} {{$index +1}}
                </a>
            </div>--%>
                    <div ng-show="step==1" class="wizard-content">
                        <section>
                            <div>
                                <h4 class="ss_form_title ">Pre Deal <a role="button" class="btn btn-default pull-right" ng-show="model=='View'&&allowEdit" href="/popupControl/preAssignCropForm.aspx?model=Edit&Id={{preAssign.Id}}"><i class="fa fa-edit"></i>Edit</a></h4>
                                <ul class="ss_form_box clearfix">
                                    <li class="ss_form_item online">
                                        <label class="ss_form_input_title">Property Address</label>
                                        <input class="ss_form_input" <%--ng-model="perAssignCtrl.Property_Address"--%> ng-model="preAssign.Title" disabled>
                                    </li>
                                    <%-- <li class="ss_form_item ">
                                <label class="ss_form_input_title "># of Parties</label>
                                <input class="ss_form_input " ng-model="perAssignCtrl.Numberof_Parties">
                            </li>--%>
                                    <%-- <li class="ss_form_item ">
                                <label class="ss_form_input_title ">Name Of parties</label>
                                <input class="ss_form_input " ng-model="perAssignCtrl.Name_Of_parties">
                            </li>--%>
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title " ng-class="{ss_warning:!preAssign.ExpectedDate}">Expected Date of Signing </label>
                                        <input class="ss_form_input" ng-model="preAssign.ExpectedDate" ss-date required data-date-start-date="+0d" ng-if="model!='View'" />
                                        <input class="ss_form_input" ng-model="preAssign.ExpectedDate" ss-date ng-if="model=='View'" />
                                    </li>
                                    <li class="ss_form_item">
                                        <label class="ss_form_input_title">Doc Search</label>
                                        <pt-radio name="PreAssign_Needdosearch0" model="preAssign.NeedSearch"></pt-radio>
                                    </li>
                                    <li class="ss_form_item">
                                        <label class="ss_form_input_title">Check request</label>

                                        <input type="checkbox" id="PreAssign_Checkrequest0Y" ng-model="preAssign.NeedCheck" class="ss_form_input " ng-disabled="model=='Edit'">
                                        <label for="PreAssign_Checkrequest0Y" class="input_with_check">
                                            <span class="box_text ng-binding">yes&nbsp;</span>
                                        </label>
                                        <input type="checkbox" id="PreAssign_Checkrequest0N" ng-model="preAssign.NeedCheck" ng-true-value="false" ng-false-value="true" class="ss_form_input" ng-disabled="model=='Edit'">
                                        <label for="PreAssign_Checkrequest0N" class="input_with_check">
                                            <span class="box_text ng-binding">no&nbsp;</span>
                                        </label>

                                    </li>
                                    <li class="ss_form_item">
                                        <label class="ss_form_input_title">Manager </label>
                                        <input class="ss_form_input" value="<%=Page.User.Identity.Name %>" disabled />
                                    </li>
                                    <%-- <li class="ss_form_item ">
                                <label class="ss_form_input_title "># of checks</label>
                                <input class="ss_form_input " ng-model="perAssignCtrl.Number_of_checks">
                            </li>--%>
                                    <%--<li class="ss_form_item ">
                                <label class="ss_form_input_title ">Total Check Amount</label>
                                <input class="ss_form_input " money-mask ng-model="perAssignCtrl.Total_Check_Amount">
                            </li>--%>
                                    <div ng-show="preAssign.NeedCheck">
                                        <%--<li class="ss_form_item ">
                                <label class="ss_form_input_title ">Check Issued by</label>
                                <input class="ss_form_input" ng-model="preAssign.CheckIssuedBy" ng-show="CheckTotalAmount()<=100000" />
                                <input class="ss_form_input" ng-show="CheckTotalAmount()>10000" value="MyIdealProperty" disabled />
                            </li>--%>
                                        <li class="ss_form_item">
                                            <label class="ss_form_input_title " ng-class="{ss_warning:CheckTotalAmount() > preAssign.DealAmount}">Total Amount paid for the deal</label>
                                            <input class="ss_form_input" ng-model="preAssign.DealAmount" money-mask />
                                        </li>
                                        <li class="ss_form_item">
                                            <label class="ss_form_input_title">Type of Check request</label>
                                            <select class="ss_form_input" ng-model="preAssign.CheckRequestData.Type" ng-disabled="mode=='Edit'">
                                                <option>Short Sale</option>
                                                <option>Straight Sale</option>
                                                <option>Other</option>
                                            </select>
                                        </li>
                                    </div>
                                    <%--  <li class="ss_form_item ">
                                <label class="ss_form_input_title ">Name On Check</label>
                                <input class="ss_form_input " ng-model="perAssignCtrl.Name_On_Check">
                            </li>--%>
                                </ul>
                                <div ng-if="!preAssign.NeedSearch" class="alert alert-warning" role="alert">
                                    <strong><i class="fa fa-warning"></i>Warning!</strong> Please make sure you have all the required property information or you have completed a search already.
                                </div>
                            </div>
                            <div class="ss_form">
                                <h4 class="ss_form_title " ng-class="{ss_warning:preAssign.Parties.length<1 }">Parties <%--({{preAssign.Parties.length}})--%> <%--<i class="fa fa-plus-circle icon_btn" title="Add" ng-click="ensurePush('preAssign.Parties')">--%></i></h4>
                                <ul class="ss_form_box clearfix">
                                    <%--<li class="ss_form_item" ng-repeat="p in preAssign.Parties">
                                <label class="ss_form_input_title ">Party {{$index+1}} <i class="fa fa-times icon_btn" ng-click="arrayRemove(preAssign.Parties, $index)"></i></label>
                                <input class="ss_form_input " type="text" ng-model="p.Name" />
                            </li>--%>
                                    <li style="list-style: none">
                                        <div id="gridParties" dx-data-grid="partiesGridOptions"></div>
                                    </li>
                                </ul>
                            </div>

                            <div class="ss_form" ng-show="preAssign.NeedCheck">
                                <h4 class="ss_form_title " ng-class="{ss_warning:preAssign.CheckRequestData.Checks.length<1}">Checks <%--({{preAssign.CheckRequestData.Checks.length}})--%> <%--<i class="fa fa-plus-circle icon_btn" title="Add" ng-click="ensurePush('preAssign.CheckRequestData.Checks')"></i>--%></h4>
                                <ul class="ss_form_box clearfix">
                                    <%-- <li class="ss_form_item" ng-repeat="p in preAssign.CheckRequestData.Checks">
                                <label class="ss_form_input_title ">Check {{$index+1}} <i class="fa fa-times icon_btn" ng-click="arrayRemove(preAssign.CheckRequestData.Checks, $index)"></i></label>
                                <input class="ss_form_input " type="text" ng-model="p.Name" />
                            </li>--%>
                                    <li style="list-style: none">
                                        <div id="gridChecks" dx-data-grid="checkGridOptions"></div>
                                    </li>
                                </ul>
                            </div>
                        </section>
                    </div>
                    <%-- <div ng-show="step==2" class="wizard-content">
            </div>--%>

                    <div class="modal-footer">
                        <%--<button type="button" class="btn btn-default" ng-show="step>1" ng-click="PrevStep()">< Prev</button>--%>
                        <button type="button" class="btn btn-default" ng-click="RequestPreSign()" <%--ng-show="step==MaxStep"--%> ng-show="model!='View'">{{preAssign.Id ?'Update':'Submit'}} </button>
                        <%--<button type="button" class="btn btn-default" ng-show="step<MaxStep" ng-click="NextStep()">Next ></button>--%>
                    </div>
                    <div class="alert alert-success" role="alert" ng-if="model=='View'">Your request submit succeeded on {{preAssign.CreateDate|date:'MM/dd/yyyy HH:mm'}} </div>
                    <div class="row" style="font-size: 14px" ng-show="model=='View'">
                        <button type="button" class="btn btn-default" ng-click="showHistroy()" style="margin-bottom: 20px">History</button>
                        <uc1:AuditLogs runat="server" ID="AuditLogs" />
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript" src="/js/PortalHttpFactory.js"></script>

</asp:Content>
