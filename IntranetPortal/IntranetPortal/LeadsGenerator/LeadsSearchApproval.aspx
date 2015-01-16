<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LeadsSearchApproval.aspx.vb" Inherits="IntranetPortal.LeadsSearchApproval" MasterPageFile="~/Content.Master" %>

<asp:Content runat="server" ContentPlaceHolderID="MainContentPH">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/2.0.0/handlebars.min.js"></script>
    <script>
        var SearchData = '<%= SearchData%>'
    </script>
    <style>
        .title_with_line {
            margin: 0px;
        }
    </style>
    <script id="entry-template" type="text/x-handlebars-template">
        <div>
            <div class="ss_array">
                <h4 class="ss_form_title title_with_line">
                    <span class="title_index title_span upcase_text">Location</span>&nbsp;
                    
                </h4>
                <div>
                    <table class="table table-striped">
                        {{#if Location}}
                        <tr>
                            <td>BOROUGH :</td>
                            <td>{{Location}}</td>
                        </tr>
                        {{/if}}
                        {{#if Zips}}
                        <tr>

                            <td>ZIP :</td>
                            <td>{{Zips}}</td>

                        </tr>
                        {{/if}}
                         {{#if Neighborhoods}}
                        <tr>
                            <td>NEIGHBORHOOD :</td>
                            <td>{{Neighborhoods}}</td>
                        </tr>
                        {{/if}}
                    </table>
                </div>
            </div>
            <div class="ss_array">
                <h4 class="ss_form_title title_with_line">
                    <span class="title_index title_span upcase_text">PROPERTY CHARACTERISTICS</span>&nbsp;
                    
                </h4>
                <div>
                    <table class="table table-striped">
                        {{#if PeropertyClasses}}
                        <tr>
                            <td>PROPERTY CLASS :</td>
                            <td>{{PeropertyClasses}}</td>
                        </tr>
                        {{/if}}

                        {{#if Zonings}}
                        <tr>
                            <td>ZONING :</td>
                            <td>{{Zonings}}</td>
                        </tr>
                        {{/if}}

                        {{#ifCond UnbuiltSqft}}
                        <tr>
                            <td>UNBUILT SQFT :</td>
                            <td>{{#if UnbuiltSqft.min}} min: {{UnbuiltSqft.min}}  {{/if}}  {{#if UnbuiltSqft.max}} , max: {{UnbuiltSqft.max}}  {{/if}}</td>
                        </tr>
                        {{/ifCond}}

                        {{#ifCond NYCsqft}}
                        <tr>
                            <td>NYC SQFT :</td>
                            <td>{{#if NYCsqft.min}} min: {{NYCsqft.min}}  {{/if}}  {{#if NYCsqft.max}} min: {{NYCsqft.max}}  {{/if}}</td>
                        </tr>
                        {{/ifCond}}

                         {{#ifCond LotSqft}}
                        <tr>
                            <td>Lot SQFT :</td>
                            <td>{{#if LotSqft.min}} min: {{LotSqft.min}}  {{/if}}  {{#if LotSqft.max}} min: {{LotSqft.max}}  {{/if}}</td>
                        </tr>
                        {{/ifCond}}
                         {{#ifCond YearBuild}}
                         <tr>
                             <td>YEAR BUILT :</td>
                             <td>{{#if YearBuild.min}} min: {{YearBuild.min}}  {{/if}}  {{#if YearBuild.max}} min: {{YearBuild.max}}  {{/if}}</td>
                         </tr>
                        {{/ifCond}}

                    </table>
                </div>
            </div>
            <div class="ss_array">
                <h4 class="ss_form_title title_with_line">
                    <span class="title_index title_span upcase_text">FINANCIAL</span>
                </h4>
                <div class="">
                    <table class="table table-striped">
                        {{#if Servicers}}
                        <tr>
                            <td>SERVICER :</td>
                            <td>{{Servicers}}</td>
                        </tr>
                        {{/if}}
                       {{#ifCond Mortgage}}
                        <tr>
                            <td>MORTGAGES (SUM) :</td>
                            <td>{{#if Mortgage.min}} min: {{Mortgage.min}}  {{/if}}  {{#if Mortgage.max}} min: {{Mortgage.max}}  {{/if}}</td>
                        </tr>
                        {{/ifCond}}
                         {{#ifCond Value}}
                        <tr>
                            <td>VALUE : </td>
                            <td>{{#if Value.min}} min: {{Value.min}}  {{/if}}  {{#if Value.max}} min: {{Value.max}}  {{/if}}</td>
                        </tr>
                        {{/ifCond}}
                         {{#ifCond Equity}}
                        <tr>
                            <td>EQUITY :</td>
                            <td>{{#if Equity.min}} min: {{Equity.min}}  {{/if}}  {{#if Equity.max}} min: {{Equity.max}}  {{/if}}</td>
                        </tr>
                        {{/ifCond}}
                        {{#ifCond Tax}}
                        <tr>
                            <td>TAXES :</td>
                            <td>{{#if Tax.min}} min: {{Tax.min}}  {{/if}}  {{#if Tax.max}} min: {{Tax.max}}  {{/if}}</td>
                        </tr>
                        {{/ifCond}}
                        {{#ifCond ECB_DOB}}
                        <tr>
                            <td>ECB/DOB :</td>
                            <td>{{#if ECB_DOB.min}} min: {{ECB_DOB.min}}  {{/if}}  {{#if ECB_DOB.max}} min: {{ECB_DOB.max}}  {{/if}}</td>
                        </tr>
                        {{/ifCond}}
                         {{#if isLis}}
                        <tr>
                            <td>LIS PENDENS :</td>
                            <td>{{isLis}}</td>
                        </tr>
                        {{/if}}
                        {{#if DocketYear}}
                        <tr>
                            <td>DOCKET / YEAR :</td>

                            <td>{{DocketYear}}</td>
                        </tr>
                        {{/if}}
                  
                    </table>

                </div>

            </div>
        </div>
    </script>

    <div style="padding: 30px; color: #2e2f31; height: 100%">
        <div style="margin-bottom: 30px;">
            <i class="fa fa-search-plus title_icon color_gray"></i>
            <span class="title_text">Leads Search - <%= ActivityName%></span>
        </div>
        <table>
            <tr>
                <td>Applicant: </td>
                <td><%= Me.Applicant%></td>
            </tr>
            <tr>
                <td>Name: </td>
                <td>
                    <%= SearchName%>
                </td>
            </tr>

            <tr>
                <td>Criteria: </td>
                <td>
                    <div id="reslut"></div>
                </td>
            </tr>
            <tr>
                <td colspan="2">&nbsp;</td>
            </tr>
            <tr>
                <td colspan="2">
                    <button type="button" class="rand-button rand-button-pad bg_orange button_margin" onclick="cbApproval.PerformCallback('Approve')">Approve</button>
                    <button type="button" class="rand-button rand-button-pad bg_color_gray button_margin" onclick="cbApproval.PerformCallback('Decline')">Decline</button>
                </td>
            </tr>
        </table>
    </div>
    <dx:ASPxCallback runat="server" ID="cbApproval" ClientInstanceName="cbApproval" OnCallback="cbApproval_Callback">
        <ClientSideEvents EndCallback="function(s,e){
            alert('Submited');
            }" />
    </dx:ASPxCallback>
    <script>
        function hasValue(v)
        {
            if (v == null)
            {
                return false;
            }
            function v_has_value(_v)
            {
                return _v != null && _v != ""
            }
            if (v_has_value(v["min"]))
            {
                return true;
            }
            if (v_has_value(v["max"])) {
                return true;
            }
            
            return false;
        }
        Handlebars.registerHelper('ifCond', function (v1, options) {
            if (hasValue(v1)) {
                return options.fn(this);
            }
            return options.inverse(this);
        });
       
        var source = $("#entry-template").html();
        var template = Handlebars.compile(source);


        var data = JSON.parse(SearchData);
        
        var result = template(data);
        $("#reslut").html(result)
    </script>
</asp:Content>
