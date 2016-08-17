<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="DocSearchNewVersion.ascx.vb" Inherits="IntranetPortal.DocSearchNewVersion" %>
<div class="tab-content">
    <div class="tab-pane active" id="LegalTab">

        <div style="overflow: auto; height: 830px; padding: 0 20px" class="shortSaleUI" id="DocSearchErrorDiv">

            <div class="alert alert-warning" style="margin-top: 20px; font-size: 16px" ng-show="DocSearch.Status != 1">
                <i class="fa fa-warning"></i><strong>Warning!</strong> Document search didn't completed yet!
            </div>
            <div class="alert alert-success" style="margin-top: 20px; font-size: 16px" ng-show="DocSearch.Status == 1 && DocSearch.CompletedOn">
                Document search completed on {{DocSearch.CompletedOn|date:'shortDate'}} by {{DocSearch.CompletedBy}}!
            </div>



            <%----------------------------Request Info----------------------------------------%>
            <div class="ss_form">
                <h4 class="ss_form_title ">Request Info
                    <pt-collapse model="CollapseRequestInfo" />
                </h4>
                <div class="ss_border" uib-collapse="CollapseRequestInfo">
                    <ul class="ss_form_box clearfix">
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title">Requested On</label><input class="ss_form_input" ng-model="DocSearch.CreateDate" ss-date disabled="disabled" /></li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title">Team</label>
                            <input class="ss_form_input" ng-model="DocSearch.team" readonly="readonly" />
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title">Requested By</label><input class="ss_form_input" ng-model="DocSearch.CreateBy" readonly="readonly" /></li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title">Block</label><input class="ss_form_input" ng-model="LeadsInfo.Block" readonly="readonly" /></li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title">Lot</label><input class="ss_form_input" ng-model="LeadsInfo.Lot" readonly="readonly" /></li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title">Expected Signing Date</label><input class="ss_form_input" ng-model="DocSearch.ExpectedSigningDate" ss-date disabled="disabled" /></li>
                        <li class="ss_form_item " style="width: 97%">
                            <label class="ss_form_input_title">Property Addressed</label><input class="ss_form_input" ng-model="LeadsInfo.PropertyAddress" readonly="readonly" /></li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title">Owner Name</label><input class="ss_form_input" ng-model="DocSearch.LeadResearch.ownerName" />
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title">Owner SSN</label><input class="ss_form_input" ng-model="DocSearch.LeadResearch.ownerSSN" />
                        </li>
                        <li class="ss_form_item " style="width: 97%">
                            <label class="ss_form_input_title">Owner Address</label>
                            <input class="ss_form_input" ng-model="DocSearch.LeadResearch.ownerAddress" />
                        </li>
                    </ul>
                </div>
            </div>
            <%-----------------------End Request Info----------------------------------------%>

            <%--- new version should have sub title so need deleted all ---%>
            <%-- links --%>

            <%--<ul class="ss_form_box clearfix">
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Geodata</label>
                    <button class="btn btn-secondary" type="button">
                        <a href="http://www.geodataplus.com/" target="_blank">Go to Geodata</a>
                    </button>
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Acris</label>
                    <button class="btn btn-secondary" type="button">
                        <a href="https://a836-acris.nyc.gov/DS/DocumentSearch/BBL" target="_blank">Go to Acris</a>
                    </button>
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">NYCSERV </label>
                    <button class="btn btn-secondary" type="button">
                        <a href="http://nycserv.nyc.gov/NYCServWeb/NYCSERVMain" target="_blank">Go to NYCSERV</a>
                    </button>
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">DOB </label>
                    <button class="btn btn-secondary" type="button">
                        <a href="http://www1.nyc.gov/site/buildings/index.page" target="_blank">Go to DOB</a>
                    </button>
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">HPD </label>
                    <button class="btn btn-secondary" type="button">
                        <a href="https://hpdonline.hpdnyc.org/HPDonline/provide_address.aspx" target="_blank">Go to HPD</a>
                    </button>
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">NY Data</label>
                    <button class="btn btn-secondary" type="button">
                        <a href="https://oma.edatatrace.com/oma/" target="_blank">Go to NY Data</a>
                    </button>
                </li>
            </ul>--%>
            <%-- --links ----%>
            <%--  <a href="http://nycprop.nyc.gov/nycproperty/nynav/jsp/selectbbl.jsp" target="_blank">Servicer </a>
            <a href="https://www.knowyouroptions.com/loanlookup" target="_blank">Fannie </a>
            <a href="https://ww3.freddiemac.com/loanlookup/" target="_blank">Freddie Mac</a>--%>


            <%-- end links --%>
            <%-- by steven
                 used 5 hours in devextrem grid
                 becuase the initinal of grid should take an array.
                 and two way bind should use bindingOptions instand dataSource.
            --%>
            <%--
            <div class="ss_form  ">
                <h5 class="ss_form_title  ">Other Mortgage                                 
                        <pt-collapse model="DocSearch.LeadResearch.OtherMortgageDiv"> </pt-collapse>
                </h5>
                <div uib-collapse="DocSearch.LeadResearch.OtherMortgageDiv" class="ss_border">
                    <div init-grid dx-data-grid='{
                        bindingOptions: {
                            dataSource: "DocSearch.LeadResearch.OtherMortgage"
                        },
                        paging: {
                            pageSize: 10
                        },
                        pager: {
                            showPageSizeSelector: true,
                            allowedPageSizes: [5, 10, 20],
                            showInfo: true
                        },
                        editing: {
                            editMode: "cell",
                            editEnabled: true,
                            insertEnabled: true,
                            removeEnabled: true
                        },
                        columns: ["Amount"]
                    }'>
                    </div>
                </div>
            </div>
            <div class="ss_form  ">
                <h5 class="ss_form_title  ">Other Liens                                 
                        <pt-collapse model="DocSearch.LeadResearch.OtherLiensDiv"> </pt-collapse>
                </h5>
                <div uib-collapse="DocSearch.LeadResearch.OtherLiensDiv" class="ss_border">
                    <div init-grid dx-data-grid='{
                        bindingOptions: {
                            dataSource: "DocSearch.LeadResearch.OtherLiens"
                        },
                        paging: {
                            pageSize: 10
                        },
                        pager: {
                            showPageSizeSelector: true,
                            allowedPageSizes: [5, 10, 20],
                            showInfo: true
                        },
                        editing: {
                            editMode: "cell",
                            editEnabled: true,
                            insertEnabled: true,
                            removeEnabled: true
                        },
                        columns: ["Lien","Amount","Date"],
                    }'
                        ng-show="newVersion">
                    </div>
                </div>

            </div>
            <div class="ss_form  ">
                <h5 class="ss_form_title  ">Tax Lien Certificate                                
                        <pt-collapse model="DocSearch.LeadResearch.TaxLienCertificateDiv"> </pt-collapse>
                </h5>

                <div uib-collapse="DocSearch.LeadResearch.TaxLienCertificateDiv" class="ss_border">
                    <div init-grid dx-data-grid='{
                        bindingOptions: {
                            dataSource: "DocSearch.LeadResearch.TaxLienCertificate"
                        },
                        paging: {
                            pageSize: 10
                        },
                        pager: {
                            showPageSizeSelector: true,
                            allowedPageSizes: [5, 10, 20],
                            showInfo: true
                        },
                        editing: {
                            editMode: "cell",
                            editEnabled: true,
                            insertEnabled: true,
                            removeEnabled: true
                        },
                        columns: ["Year","Amount"],
                    }'>
                    </div>
                </div>



            </div>

            <div class="ss_form  ">
                <h5 class="ss_form_title  ">COS Recorded                                
                        <pt-collapse model="DocSearch.LeadResearch.COSRecordedDiv"> </pt-collapse>
                </h5>
                <div uib-collapse="DocSearch.LeadResearch.COSRecordedDiv" class="ss_border">
                    <div init-grid dx-data-grid='{
                        bindingOptions: {
                            dataSource: "DocSearch.LeadResearch.COSRecorded"
                        },
                        paging: {
                            pageSize: 10
                        },
                        pager: {
                            showPageSizeSelector: true,
                            allowedPageSizes: [5, 10, 20],
                            showInfo: true
                        },
                        editing: {
                            editMode: "cell",
                            editEnabled: true,
                            insertEnabled: true,
                            removeEnabled: true
                        },
                        columns: ["Date","Buyer"],
                    }'>
                    </div>
                </div>

            </div>
            <div class="ss_form  ">
                <h5 class="ss_form_title  ">Deed Recorded                                
                        <pt-collapse model="DocSearch.LeadResearch.DeedRecordedDiv"> </pt-collapse>
                </h5>
                <div uib-collapse="DocSearch.LeadResearch.DeedRecordedDiv" class="ss_border">
                    <div init-grid dx-data-grid='{
                        bindingOptions: {
                            dataSource: "DocSearch.LeadResearch.DeedRecorded"
                        },
                        paging: {
                            pageSize: 10
                        },
                        pager: {
                            showPageSizeSelector: true,
                            allowedPageSizes: [5, 10, 20],
                            showInfo: true
                        },
                        editing: {
                            editMode: "cell",
                            editEnabled: true,
                            insertEnabled: true,
                            removeEnabled: true
                        },
                        columns: ["Date","Buyer"],
                    }'>
                    </div>
                </div>

            </div>
            --%>
            <%-- spent 2 hours add yes or no disable relatived filed and test if it's correct
                 becusae the key vaule too long .
                 it may cause some problem .
                 @see /js/directives/preCondition for todo list
            --%>

            <%-- Ownership Mortgage Info --%>


            <div class="ss_form  ">
                <h4 class="ss_form_title ">Ownership Mortgage Info                               
                    <pt-collapse model="DocSearch.LeadResearch.Ownership_Mortgage_Info">                            </pt-collapse>
                </h4>


                <div class="ss_border" uib-collapse="DocSearch.LeadResearch.Ownership_Mortgage_Info">
                    <div>
                        <ul class="ss_form_box clearfix">
                            <li class="ss_form_item ">
                                <label class="ss_form_input_title ">Geodata</label>
                                <button class="btn btn-secondary" type="button">
                                    <a href="http://www.geodataplus.com/" target="_blank">Go to Geodata</a>
                                </button>
                            </li>
                            <li class="ss_form_item ">
                                <label class="ss_form_input_title ">Acris</label>
                                <button class="btn btn-secondary" type="button">
                                    <a href="https://a836-acris.nyc.gov/DS/DocumentSearch/BBL" target="_blank">Go to Acris</a>
                                </button>
                            </li>
                        </ul>
                    </div>

                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">Purchase Deed                                       
                            <pt-collapse model="DocSearch.LeadResearch.Purchase_Deed_Ownership_Mortgage_Info"> </pt-collapse>
                        </h5>
                        <div class="ss_border" uib-collapse="DocSearch.LeadResearch.Purchase_Deed_Ownership_Mortgage_Info">


                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item " ng-show="true">
                                    <label class="ss_form_input_title ">Has Deed *</label>
                                    <pt-radio name="OwnershipMortgageInfo_HasDeed0" model="DocSearch.LeadResearch.Has_Deed_Purchase_Deed"></pt-radio>
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.Has_Deed_Purchase_Deed">
                                    <label class="ss_form_input_title ">Date of Deed</label>
                                    <input class="ss_form_input " ss-date ng-model="DocSearch.LeadResearch.Date_of_Deed_Purchase_Deed">
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.Has_Deed_Purchase_Deed">
                                    <label class="ss_form_input_title ">Party 1</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Party_1_Purchase_Deed">
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.Has_Deed_Purchase_Deed">
                                    <label class="ss_form_input_title ">Party 2</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Party_2_Purchase_Deed">
                                </li>
                            </ul>
                        </div>
                    </div>

                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">1st Mortgage                                       
                            <pt-collapse model="DocSearch.LeadResearch.c_1st_Mortgage_Ownership_Mortgage_Info"> </pt-collapse>
                        </h5>
                        <div class="ss_border" uib-collapse="DocSearch.LeadResearch.c_1st_Mortgage_Ownership_Mortgage_Info">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item " ng-show="true">
                                    <label class="ss_form_input_title ">Has 1st Mortgage *</label>
                                    <pt-radio name="OwnershipMortgageInfo_Hasc1stMortgage0" model="DocSearch.LeadResearch.Has_c_1st_Mortgage_c_1st_Mortgage"></pt-radio>
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.Has_c_1st_Mortgage_c_1st_Mortgage">
                                    <label class="ss_form_input_title ">Amount</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.mortgageAmount">
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">2nd Mortgage                                       
                            <pt-collapse model="DocSearch.LeadResearch.c_2nd_Mortgage_Ownership_Mortgage_Info"> </pt-collapse>
                        </h5>
                        <div class="ss_border" uib-collapse="DocSearch.LeadResearch.c_2nd_Mortgage_Ownership_Mortgage_Info">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item " ng-show="true">
                                    <%-- ||owner.Bankruptcy===undefined --%>
                                    <label class="ss_form_input_title " 
                                        ng-class="{ss_warning:DivError.(boolValidate.LeadResearch,'Has_c_2nd_Mortgage_c_2nd_Mortgage')}" 
                                        data-message="Please check there is 2nd Mortgage or not."
                                        >Has 2nd Mortgage *</label>
                                    <pt-radio name="OwnershipMortgageInfo_Hasc2ndMortgage0" model="DocSearch.LeadResearch.Has_c_2nd_Mortgage_c_2nd_Mortgage"></pt-radio>
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.Has_c_2nd_Mortgage_c_2nd_Mortgage">
                                    <label class="ss_form_input_title ">Amount</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.secondMortgageAmount">
                                </li>
                            </ul>
                        </div>
                    </div>
                    <%-- other mortage --%>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">Other Mortgage                                 
                        <pt-collapse model="DocSearch.LeadResearch.OtherMortgageDiv"> </pt-collapse>
                        </h5>
                        <div uib-collapse="DocSearch.LeadResearch.OtherMortgageDiv" class="ss_border">
                            <%-- case we use ng if fix bug so the mutiple mybe can not have yes no
                                 by steven
                            --%>
                            <div class="ss_form ">
                                <ul class="ss_form_box clearfix">
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title "
                                            ng-class="{ss_warning:DivError.multipleValidated(DocSearch.LeadResearch,'Has_Other_Mortgage','OtherMortgage')}" 
                                            data-message="Please check Other Mortgage selected and if it's select make sure there are at least one mortgage been filled .">Has Other Mortgage *</label>
                                        <pt-radio name="OwnershipMortgageInfo_HasOtherMortgage2" model="DocSearch.LeadResearch.Has_Other_Mortgage"></pt-radio>
                                    </li>
                                </ul>
                            </div>
                            <div init-grid="DocSearch.BBLE" ng-if="DocSearch.LeadResearch.Has_Other_Mortgage" dx-data-grid='{
                                bindingOptions: {
                                    dataSource: "DocSearch.LeadResearch.OtherMortgage"
                                },
                                paging: {
                                    pageSize: 10
                                },
                                pager: {
                                    showPageSizeSelector: true,
                                    allowedPageSizes: [5, 10, 20],
                                    showInfo: true
                                },
                                editing: {
                                    editMode: "cell",
                                    editEnabled: true,
                                    insertEnabled: true,
                                    removeEnabled: true
                                },
                                columns: ["Amount"]
                            }'>
                            </div>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">Other Liens                                 
                        <pt-collapse model="DocSearch.LeadResearch.OtherLiensDiv"> </pt-collapse>
                        </h5>
                        <div uib-collapse="DocSearch.LeadResearch.OtherLiensDiv" class="ss_border">
                            <div class="ss_form ">
                                <ul class="ss_form_box clearfix">
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title ">Has Other Liens *</label>
                                        <pt-radio name="OwnershipMortgageInfo_Has_Other_Liens2" model="DocSearch.LeadResearch.Has_Other_Liens"></pt-radio>
                                    </li>
                                </ul>
                            </div>
                            <div init-grid="DocSearch.BBLE" ng-if="DocSearch.LeadResearch.Has_Other_Liens" dx-data-grid='{
                                bindingOptions: {
                                    dataSource: "DocSearch.LeadResearch.OtherLiens"
                                },
                                paging: {
                                    pageSize: 10
                                },
                                pager: {
                                    showPageSizeSelector: true,
                                    allowedPageSizes: [5, 10, 20],
                                    showInfo: true
                                },
                                editing: {
                                    editMode: "cell",
                                    editEnabled: true,
                                    insertEnabled: true,
                                    removeEnabled: true
                                },
                                columns: ["Lien","Amount","Date"],
                            }'
                                ng-show="newVersion">
                            </div>
                        </div>

                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">Tax Lien Certificate                                
                        <pt-collapse model="DocSearch.LeadResearch.TaxLienCertificateDiv"> </pt-collapse>
                        </h5>

                        <div uib-collapse="DocSearch.LeadResearch.TaxLienCertificateDiv" class="ss_border">
                            <div class="ss_form ">
                                <ul class="ss_form_box clearfix">
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title ">Has Tax Lien Certificate  *</label>
                                        <pt-radio name="OwnershipMortgageInfo_Has_TaxLiensCertifcate3" model="DocSearch.LeadResearch.Has_TaxLiensCertifcate"></pt-radio>
                                    </li>
                                </ul>
                            </div>
                            <div ng-if="DocSearch.LeadResearch.Has_TaxLiensCertifcate" init-grid="DocSearch.BBLE" dx-data-grid='{
                                    bindingOptions: {
                                        dataSource: "DocSearch.LeadResearch.TaxLienCertificate"
                                    },
                                    paging: {
                                        pageSize: 10
                                    },
                                    pager: {
                                        showPageSizeSelector: true,
                                        allowedPageSizes: [5, 10, 20],
                                        showInfo: true
                                    },
                                    editing: {
                                        editMode: "cell",
                                        editEnabled: true,
                                        insertEnabled: true,
                                        removeEnabled: true
                                    },
                                    columns: ["Year","Amount"],
                                }'>
                            </div>
                        </div>

                    </div>

                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">COS Recorded                                
                        <pt-collapse model="DocSearch.LeadResearch.COSRecordedDiv"> </pt-collapse>
                        </h5>

                        <div uib-collapse="DocSearch.LeadResearch.COSRecordedDiv" class="ss_border">
                            <div class="ss_form ">
                                <ul class="ss_form_box clearfix">
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title ">Has COS Recorded *</label>
                                        <pt-radio name="OwnershipMortgageInfo_Has_COS_Recorded2" model="DocSearch.LeadResearch.Has_COS_Recorded"></pt-radio>
                                    </li>
                                </ul>
                            </div>
                            <div ng-if="DocSearch.LeadResearch.Has_COS_Recorded" init-grid="DocSearch.BBLE" dx-data-grid='{
                                        bindingOptions: {
                                            dataSource: "DocSearch.LeadResearch.COSRecorded"
                                        },
                                        paging: {
                                            pageSize: 10
                                        },
                                        pager: {
                                            showPageSizeSelector: true,
                                            allowedPageSizes: [5, 10, 20],
                                            showInfo: true
                                        },
                                        editing: {
                                            editMode: "cell",
                                            editEnabled: true,
                                            insertEnabled: true,
                                            removeEnabled: true
                                        },
                                        columns: ["Date","Buyer"],
                                    }'>
                            </div>
                        </div>

                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">Deed Recorded                                
                        <pt-collapse model="DocSearch.LeadResearch.DeedRecordedDiv"> </pt-collapse>
                        </h5>

                        <div uib-collapse="DocSearch.LeadResearch.DeedRecordedDiv" class="ss_border" >
                            <div class="ss_form ">
                                <ul class="ss_form_box clearfix">
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title ">Has Deed Recorded *</label>
                                        <pt-radio name="OwnershipMortgageInfo_Has_Deed_Recorded1" model="DocSearch.LeadResearch.Has_Deed_Recorded"></pt-radio>
                                    </li>
                                </ul>
                            </div>
                            <div ng-if="DocSearch.LeadResearch.Has_Deed_Recorded" init-grid="DocSearch.BBLE" dx-data-grid='{
                                        bindingOptions: {
                                            dataSource: "DocSearch.LeadResearch.DeedRecorded"
                                        },
                                        paging: {
                                            pageSize: 10
                                        },
                                        pager: {
                                            showPageSizeSelector: true,
                                            allowedPageSizes: [5, 10, 20],
                                            showInfo: true
                                        },
                                        editing: {
                                            editMode: "cell",
                                            editEnabled: true,
                                            insertEnabled: true,
                                            removeEnabled: true
                                        },
                                        columns: ["Date","Buyer"],
                                    }'>
                            </div>
                        </div>

                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">Last Assignment                                       
                            <pt-collapse model="DocSearch.LeadResearch.Last_Assignment_Ownership_Mortgage_Info"> </pt-collapse>
                        </h5>
                        <div class="ss_border" uib-collapse="DocSearch.LeadResearch.Last_Assignment_Ownership_Mortgage_Info">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item " ng-show="true">
                                    <label class="ss_form_input_title ">has Last Assignment *</label>
                                    <pt-radio name="OwnershipMortgageInfo_hasLastAssignment0" model="DocSearch.LeadResearch.has_Last_Assignment_Last_Assignment"></pt-radio>
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.has_Last_Assignment_Last_Assignment">
                                    <label class="ss_form_input_title ">Assignment date</label>
                                    <input class="ss_form_input " ss-date ng-model="DocSearch.LeadResearch.Assignment_date_Last_Assignment">
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.has_Last_Assignment_Last_Assignment">
                                    <label class="ss_form_input_title ">Assigned To</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Assigned_To_Last_Assignment">
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">LP Index #                                       
                            <pt-collapse model="DocSearch.LeadResearch.LP_Index___Num_Ownership_Mortgage_Info"> </pt-collapse>
                        </h5>
                        <div class="ss_border" uib-collapse="DocSearch.LeadResearch.LP_Index___Num_Ownership_Mortgage_Info">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">LP Index #</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.LP_Index___Num_LP_Index___Num">
                                </li>
                                <li class="clear-fix"></li>
                                <li class="ss_form_item_line">
                                    <label class="ss_form_input_title ">notes</label>
                                    <textarea class="edit_text_area text_area_ss_form " model="DocSearch.LeadResearch.notes_LP_Index___Num"></textarea>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <ul class="ss_form_box clearfix">

                        <li class="ss_form_item ">
                            <label class="ss_form_input_title "><a href="http://nycprop.nyc.gov/nycproperty/nynav/jsp/selectbbl.jsp" target="_blank">Servicer </a></label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.servicer">
                        </li>
                        <li class="clear-fix"></li>
                        <li class="ss_form_item_line">
                            <label class="ss_form_input_title ">Servicer notes</label>
                            <textarea class="edit_text_area text_area_ss_form " model="DocSearch.LeadResearch.Servicer_notes"></textarea>
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">
                                <a href="https://www.knowyouroptions.com/loanlookup" target="_blank">Fannie *</a>

                            </label>
                            <pt-radio name="OwnershipMortgageInfo_Fannie0" model="DocSearch.LeadResearch.fannie"></pt-radio>
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">
                                <a href="https://ww3.freddiemac.com/loanlookup/" target="_blank">Freddie Mac *</a>
                            </label>
                            <pt-radio name="OwnershipMortgageInfo_FreddieMac0" model="DocSearch.LeadResearch.Freddie_Mac_"></pt-radio>
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">FHA *</label>
                            <pt-radio name="OwnershipMortgageInfo_FHA0" model="DocSearch.LeadResearch.fha"></pt-radio>
                        </li>
                    </ul>
                </div>
            </div>

            <%-- Property Dues Violations --%>
            <div class="ss_form  ">
                <h4 class="ss_form_title ">Property Dues Violations                               
                    <pt-collapse model="DocSearch.LeadResearch.Property_Dues_Violations"></pt-collapse>
                </h4>


                <div class="ss_border" uib-collapse="DocSearch.LeadResearch.Property_Dues_Violations">
                    <div>
                        <ul class="ss_form_box clearfix">
                            <li class="ss_form_item ">
                                <label class="ss_form_input_title ">NYCSERV </label>
                                <button class="btn btn-secondary" type="button">
                                    <a href="http://nycserv.nyc.gov/NYCServWeb/NYCSERVMain" target="_blank">Go to NYCSERV</a>
                                </button>
                            </li>
                            <li class="ss_form_item ">
                                <label class="ss_form_input_title ">DOB </label>
                                <button class="btn btn-secondary" type="button">
                                    <a href="http://www1.nyc.gov/site/buildings/index.page" target="_blank">Go to DOB</a>
                                </button>
                            </li>
                            <li class="ss_form_item ">
                                <label class="ss_form_input_title ">HPD </label>
                                <button class="btn btn-secondary" type="button">
                                    <a href="https://hpdonline.hpdnyc.org/HPDonline/provide_address.aspx" target="_blank">Go to HPD</a>
                                </button>
                            </li>
                        </ul>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">Property Taxes                                       
                            <pt-collapse model="DocSearch.LeadResearch.Property_Taxes_Due_Property_Dues_Violations"> </pt-collapse>
                        </h5>
                        <div class="ss_border" uib-collapse="DocSearch.LeadResearch.Property_Taxes_Due_Property_Dues_Violations">


                            <ul class="ss_form_box clearfix">

                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Has Due *</label>
                                    <pt-radio name="PropertyDuesViolations_HasDue2" model="DocSearch.LeadResearch.Has_Due_Property_Taxes_Due"></pt-radio>
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.Has_Due_Property_Taxes_Due">
                                    <label class="ss_form_input_title ">Property Taxes per YR</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Property_Taxes_per_YR_Property_Taxes_Due">
                                </li>

                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.Has_Due_Property_Taxes_Due">
                                    <label class="ss_form_input_title ">Amount</label>
                                    <input class="ss_form_input " money-mask ng-model="DocSearch.LeadResearch.propertyTaxes">
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">Water Charges Due                                       
                            <pt-collapse model="DocSearch.LeadResearch.Water_Charges_Due_Property_Dues_Violations"> </pt-collapse>
                        </h5>
                        <div class="ss_border" uib-collapse="DocSearch.LeadResearch.Water_Charges_Due_Property_Dues_Violations">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Has Due *</label>
                                    <pt-radio name="PropertyDuesViolations_HasDue0" model="DocSearch.LeadResearch.Has_Due_Water_Charges_Due"></pt-radio>
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.Has_Due_Water_Charges_Due">
                                    <label class="ss_form_input_title ">Amount</label>
                                    <input class="ss_form_input " money-mask ng-model="DocSearch.LeadResearch.waterCharges">
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">ECB Violoations                                       
                            <pt-collapse model="DocSearch.LeadResearch.ECB_Violoations_Property_Dues_Violations"> </pt-collapse>
                        </h5>
                        <div class="ss_border" uib-collapse="DocSearch.LeadResearch.ECB_Violoations_Property_Dues_Violations">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item " ng-show="true">
                                    <label class="ss_form_input_title ">Has Open *</label>
                                    <pt-radio name="PropertyDuesViolations_HasOpen0" model="DocSearch.LeadResearch.Has_Open_ECB_Violoations"></pt-radio>
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.Has_Open_ECB_Violoations">
                                    <label class="ss_form_input_title ">Count</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Count_ECB_Violoations">
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.Has_Open_ECB_Violoations">
                                    <label class="ss_form_input_title ">Amount</label>
                                    <input class="ss_form_input " money-mask ng-model="DocSearch.LeadResearch.ecbViolation">
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">DOB Violoations                                       
                            <pt-collapse model="DocSearch.LeadResearch.DOB_Violoations_Property_Dues_Violations"> </pt-collapse>
                        </h5>
                        <div class="ss_border" uib-collapse="DocSearch.LeadResearch.DOB_Violoations_Property_Dues_Violations">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item " ng-show="true">
                                    <label class="ss_form_input_title ">Has Open *</label>
                                    <pt-radio name="PropertyDuesViolations_HasOpen3" model="DocSearch.LeadResearch.Has_Open_DOB_Violoations"></pt-radio>
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.Has_Open_DOB_Violoations">
                                    <label class="ss_form_input_title ">Count</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Count_DOB_Violoations">
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.Has_Open_DOB_Violoations">
                                    <label class="ss_form_input_title ">Amount</label>
                                    <input class="ss_form_input " money-mask ng-model="DocSearch.LeadResearch.dobWebsites">
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">C O                                       
                            <pt-collapse model="DocSearch.LeadResearch.C_O_Property_Dues_Violations"> </pt-collapse>
                        </h5>
                        <div class="ss_border" uib-collapse="DocSearch.LeadResearch.C_O_Property_Dues_Violations">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item " ng-show="true">
                                    <label class="ss_form_input_title ">Has CO *</label>
                                    <pt-radio name="PropertyDuesViolations_HasCO4" model="DocSearch.LeadResearch.hasCO"></pt-radio>
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.hasCO">
                                    <label class="ss_form_input_title "># of Units</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.___Num_of_Units_C_O">
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">HPD Violations                                       
                            <pt-collapse model="DocSearch.LeadResearch.HPD_Violations_Property_Dues_Violations"> </pt-collapse>
                        </h5>
                        <div class="ss_border" uib-collapse="DocSearch.LeadResearch.HPD_Violations_Property_Dues_Violations">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item " ng-show="true">
                                    <label class="ss_form_input_title ">Has Violations *</label>
                                    <pt-radio name="PropertyDuesViolations_HasViolations6" model="DocSearch.LeadResearch.Has_Violations_HPD_Violations"></pt-radio>
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.Has_Violations_HPD_Violations">
                                    <label class="ss_form_input_title ">A Class</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.A_Class_HPD_Violations">
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.Has_Violations_HPD_Violations">
                                    <label class="ss_form_input_title ">B Class</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.B_Class_HPD_Violations">
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.Has_Violations_HPD_Violations">
                                    <label class="ss_form_input_title ">C Class</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.C_Class_HPD_Violations">
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.Has_Violations_HPD_Violations">
                                    <label class="ss_form_input_title ">I Class</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.I_Class_HPD_Violations">
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">HPD Charges Not Paid Transferred                                       
                            <pt-collapse model="DocSearch.LeadResearch.HPD_Charges_Not_Paid_Transferred_Property_Dues_Violations"> </pt-collapse>
                        </h5>
                        <div class="ss_border" uib-collapse="DocSearch.LeadResearch.HPD_Charges_Not_Paid_Transferred_Property_Dues_Violations">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item " ng-show="true">
                                    <label class="ss_form_input_title ">Is Open *</label>
                                    <pt-radio name="PropertyDuesViolations_IsOpen7" model="DocSearch.LeadResearch.Is_Open_HPD_Charges_Not_Paid_Transferred"></pt-radio>
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.Is_Open_HPD_Charges_Not_Paid_Transferred">
                                    <label class="ss_form_input_title ">Open Amount</label>
                                    <input class="ss_form_input " money-mask ng-model="DocSearch.LeadResearch.Open_Amount_HPD_Charges_Not_Paid_Transferred">
                                </li>
                            </ul>
                        </div>
                    </div>
                    <ul class="ss_form_box clearfix">

                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Tax Classification</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Tax_Classification">
                        </li>

                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">HPD Number of Units</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.HPD_Number_of_Units">
                        </li>

                    </ul>
                </div>
            </div>

            <div class="ss_form  ">
                <h4 class="ss_form_title ">Judgements & Liens                               
                    <pt-collapse model="DocSearch.LeadResearch.Judgements_Liens"> </pt-collapse>
                </h4>


                <div class="ss_border" uib-collapse="DocSearch.LeadResearch.Judgements_Liens">

                    <div>
                        <ul class="ss_form_box clearfix">
                            <li class="ss_form_item ">
                                <label class="ss_form_input_title ">NY Data</label>
                                <button class="btn btn-secondary" type="button">
                                    <a href="https://oma.edatatrace.com/oma/" target="_blank">Go to NY Data</a>
                                </button>
                            </li>
                        </ul>
                    </div>

                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">Personal Judgments                                       
                            <pt-collapse model="DocSearch.LeadResearch.Personal_Judgments_Judgements_Liens"> </pt-collapse>
                        </h5>
                        <div class="ss_border" uib-collapse="DocSearch.LeadResearch.Personal_Judgments_Judgements_Liens">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item " ng-show="true">
                                    <label class="ss_form_input_title ">has Judgments *</label>
                                    <pt-radio name="JudgementsLiens_hasJudgments0" model="DocSearch.LeadResearch.has_Judgments_Personal_Judgments"></pt-radio>
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.has_Judgments_Personal_Judgments">
                                    <label class="ss_form_input_title ">Count</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Count_Personal_Judgments">
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.has_Judgments_Personal_Judgments">
                                    <label class="ss_form_input_title ">Amount</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Amount_Personal_Judgments" money-mask>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">HPD Judgments                                       
                            <pt-collapse model="DocSearch.LeadResearch.HPD_Judgments_Judgements_Liens"> </pt-collapse>
                        </h5>
                        <div class="ss_border" uib-collapse="DocSearch.LeadResearch.HPD_Judgments_Judgements_Liens">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item " ng-show="true">
                                    <label class="ss_form_input_title ">has Judgments *</label>
                                    <pt-radio name="JudgementsLiens_hasJudgments2" model="DocSearch.LeadResearch.has_Judgments_HPD_Judgments"></pt-radio>
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.has_Judgments_HPD_Judgments">
                                    <label class="ss_form_input_title ">Count</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Count_HPD_Judgments">
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.has_Judgments_HPD_Judgments">
                                    <label class="ss_form_input_title ">Amount</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.HPDjudgementAmount" money-mask>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">IRS Tax Lien                                       
                            <pt-collapse model="DocSearch.LeadResearch.IRS_Tax_Lien_Judgements_Liens"> </pt-collapse>
                        </h5>
                        <div class="ss_border" uib-collapse="DocSearch.LeadResearch.IRS_Tax_Lien_Judgements_Liens">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item " ng-show="true">
                                    <label class="ss_form_input_title ">has IRS Tax Lien *</label>
                                    <pt-radio name="JudgementsLiens_hasIRSTaxLien0" model="DocSearch.LeadResearch.has_IRS_Tax_Lien_IRS_Tax_Lien"></pt-radio>
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.has_IRS_Tax_Lien_IRS_Tax_Lien">
                                    <label class="ss_form_input_title ">Count</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Count_IRS_Tax_Lien">
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.has_IRS_Tax_Lien_IRS_Tax_Lien">
                                    <label class="ss_form_input_title ">Amount</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.irsTaxLien" money-mask>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">NYS Tax Lien                                       
                            <pt-collapse model="DocSearch.LeadResearch.NYS_Tax_Lien_Judgements_Liens"> </pt-collapse>
                        </h5>
                        <div class="ss_border" uib-collapse="DocSearch.LeadResearch.NYS_Tax_Lien_Judgements_Liens">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item " ng-show="true">
                                    <label class="ss_form_input_title ">has NYS Tax Lien *</label>
                                    <pt-radio name="JudgementsLiens_hasNYSTaxLien0" model="DocSearch.LeadResearch.hasNysTaxLien"></pt-radio>
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.hasNysTaxLien">
                                    <label class="ss_form_input_title ">Count</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Count_NYS_Tax_Lien">
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.hasNysTaxLien">
                                    <label class="ss_form_input_title ">Amount</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Amount_NYS_Tax_Lien" money-mask>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">Sidewalk Liens                                       
                            <pt-collapse model="DocSearch.LeadResearch.Sidewalk_Liens_Judgements_Liens"> </pt-collapse>
                        </h5>
                        <div class="ss_border" uib-collapse="DocSearch.LeadResearch.Sidewalk_Liens_Judgements_Liens">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item " ng-show="true">
                                    <label class="ss_form_input_title ">has Sidewalk Liens *</label>
                                    <pt-radio name="JudgementsLiens_hasSidewalkLiens0" model="DocSearch.LeadResearch.has_Sidewalk_Liens_Sidewalk_Liens"></pt-radio>
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.has_Sidewalk_Liens_Sidewalk_Liens">
                                    <label class="ss_form_input_title ">Count</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Count_Sidewalk_Liens">
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.has_Sidewalk_Liens_Sidewalk_Liens">
                                    <label class="ss_form_input_title ">Amount</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Amount_Sidewalk_Liens" money-mask>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">Vacate Order                                       
                            <pt-collapse model="DocSearch.LeadResearch.Vacate_Order_Judgements_Liens"> </pt-collapse>
                        </h5>
                        <div class="ss_border" uib-collapse="DocSearch.LeadResearch.Vacate_Order_Judgements_Liens">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item " ng-show="true">
                                    <label class="ss_form_input_title ">has Vacate Order *</label>
                                    <pt-radio name="JudgementsLiens_hasVacateOrder0" model="DocSearch.LeadResearch.has_Vacate_Order_Vacate_Order"></pt-radio>
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.has_Vacate_Order_Vacate_Order">
                                    <label class="ss_form_input_title ">Count</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Count_Vacate_Order">
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.has_Vacate_Order_Vacate_Order">
                                    <label class="ss_form_input_title ">Amount</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Amount_Vacate_Order" money-mask>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">ECB Tickets                                       
                            <pt-collapse model="DocSearch.LeadResearch.ECB_Tickets_Judgements_Liens"> </pt-collapse>
                        </h5>
                        <div class="ss_border" uib-collapse="DocSearch.LeadResearch.ECB_Tickets_Judgements_Liens">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item " ng-show="true">
                                    <label class="ss_form_input_title ">has ECB Tickets *</label>
                                    <pt-radio name="JudgementsLiens_hasECBTickets0" model="DocSearch.LeadResearch.has_ECB_Tickets_ECB_Tickets"></pt-radio>
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.has_ECB_Tickets_ECB_Tickets">
                                    <label class="ss_form_input_title ">Count</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Count_ECB_Tickets">
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.has_ECB_Tickets_ECB_Tickets">
                                    <label class="ss_form_input_title ">Amount</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Amount_ECB_Tickets" money-mask>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">ECB on Name other known address                                       
                            <pt-collapse model="DocSearch.LeadResearch.ECB_on_Name_other_known_address_Judgements_Liens"> </pt-collapse>
                        </h5>
                        <div class="ss_border" uib-collapse="DocSearch.LeadResearch.ECB_on_Name_other_known_address_Judgements_Liens">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item " ng-show="true">
                                    <label class="ss_form_input_title ">has ECB on Name *</label>
                                    <pt-radio name="JudgementsLiens_hasECBonName0" model="DocSearch.LeadResearch.has_ECB_on_Name_ECB_on_Name_other_known_address"></pt-radio>
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.has_ECB_on_Name_ECB_on_Name_other_known_address">
                                    <label class="ss_form_input_title ">Count</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Count_ECB_on_Name_other_known_address">
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.has_ECB_on_Name_ECB_on_Name_other_known_address">
                                    <label class="ss_form_input_title ">Amount</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Amount_ECB_on_Name_other_known_address" money-mask>
                                </li>
                            </ul>
                        </div>
                    </div>



                </div>
            </div>

            <hr />
            <div class="ss_form" ng-show="DocSearch.Status!=1">

                <div>
                    <ul class="ss_form_box clearfix">
                        <li class="ss_form_item " style="visibility: hidden">
                            <label class="ss_form_input_title">Documents Received</label>
                        </li>
                        <li class="ss_form_item " style="visibility: hidden">
                            <label class="ss_form_input_title">Documents Received On</label>

                        </li>

                        <li class="ss_form_item ">
                            <label class="ss_form_input_title">&nbsp;</label>
                            <input type="button" value="Complete" class="rand-button rand-button-blue rand-button-pad" ng-click="SearchComplete()">
                        </li>

                    </ul>
                </div>
            </div>
        </div>

    </div>
</div>
