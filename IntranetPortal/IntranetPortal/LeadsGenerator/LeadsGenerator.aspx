<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LeadsGenerator.aspx.vb" Inherits="IntranetPortal.LeadsGenerator" MasterPageFile="~/Content.Master" %>

<%@ Import Namespace="IntranetPortal" %>

<%@ Register Src="~/PopupControl/MapsPopup.ascx" TagPrefix="uc1" TagName="MapsPopup" %>



<asp:Content ContentPlaceHolderID="head" runat="server">
    <link href="//cdnjs.cloudflare.com/ajax/libs/select2/4.0.0-beta.3/css/select2.min.css" rel='stylesheet' type='text/css' />
    <script src="//cdnjs.cloudflare.com/ajax/libs/select2/4.0.0-beta.3/js/select2.min.js"></script>

</asp:Content>
<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <script type="text/javascript">
        function SearchLeads() {

            popUpSearch();
            var filter = GetSearchFields();
            var scStr = JSON.stringify(removeEmpty(filter)).replace("{", "").replace("}", "");
            $("#Search_scenario").html(scStr);

        }
        function GetSearchFields() {
            var filter = {}
            filter.Location = $("#IdLocation").val();
            filter.Zips = $("#IdZips").val();
            filter.Neighborhoods = $("#IDNeighborhods").val();
            filter.PeropertyClasses = $("#IDPeropertyClass").val();
            filter.PeropertyClassesCode = $("#IdPropertyClassCode").val();
            filter.Zonings = $("#IdZoning").val();
            filter.UnbuiltSqft = { min: $("#IdUnbuiltSqftmin").val(), max: $("#IdUnbuiltSqftmax").val() }
            filter.NYCsqft = { min: $("#IdNYCsqftMin").val(), max: $("#IdNYCsqftMax").val() }

            filter.LotSqft = { min: $("#IdLotSqftMin").val(), max: $("#IdLotSqftMax").val() }
            filter.Servicers = $("#IdServicer").val();

            filter.Mortgage = { min: $("#IdMortgageMin").val(), max: $("#IdMortgageMax").val() };

            filter.Value = { min: $("#IDValueMin").val(), max: $("#IDValueMax").val() }
            filter.Equity = { min: $("#IdEquityMin").val(), max: $("#IdEquityMax").val() }

            filter.Tax = { min: $("#IdTaxesMin").val(), max: $("#IdTaxesMax").val() }
            filter.ECB_DOB = { min: $("#IdECB_DOBMin").val(), max: $("#IdECB_DOBMax").val() }
            filter.isLis = $("#Lis_Pendens_yes").prop("checked");
            filter.isLPMOD = $("#LPMOD_yes").prop("checked");
            filter.DocketYear = $("#IdDocket_Year").val();
            filter.YearBuild = { min: $("#IdYearBuildMin").val(), max: $("#IdYearBuildMax").val() }
            return filter;
        }

        function removeEmpty(test) {
            for (var i in test) {
                if (test[i] === null || test[i] === undefined || test[i] === "" || test[i] == false) {

                    delete test[i];
                } else if (typeof test[i] == 'object') {
                    var o = removeEmpty(test[i])
                    if ($.isEmptyObject(o)) {
                        delete test[i];
                    }
                }
            }
            return test;
        }
        function popUpSearch() {
            $("#TxtSearchTaskName").val("");
            SaveSearchPopupClient.Show();

        }
        function OnSearchSaveClick() {
            var searchTaskName = $("#TxtSearchTaskName").val();
            var SearchType = $("#SearchType").val();
            if (searchTaskName == null || searchTaskName.length == 0) {
                alert("please input name !");
                return;
            }
            
            if (SearchType == null || SearchType.length == 0)
            {
                alert("Please select search type !");
                return;
            }
            var filter = GetSearchFields();

            loadFunction("SaveSearchPopup_WindowCallback|" + searchTaskName + ',' + SearchType + "|" + JSON.stringify(filter))
            //tableViewClinetCallBack.PerformCallback();
            //SaveSearchPopupClient.Hide();
        }
        function expand_array_all(e, isopen) {

            var div = $(e).parents(".ss_array");
            var current_div = div.find(".collapse_div")
            //var isopen = current_div.css("display") != "none";
            var field = div.attr("data-field");


            control_array_div(div, isopen);


        }
        function control_all(isopen) {
            $(".expand_btn").each(
                function () {
                    if (isopen) {
                        if ($(this).hasClass("fa-expand")) {
                            expand_array_item(this);
                        }
                    } else {

                        if ($(this).hasClass("fa-compress")) {
                            expand_array_item(this);
                        }
                    }

                }

            )
        }

        function OnLoadClick() {
            var searchName = encodeURIComponent($("#LoadSearchName").val());
            tableViewClinetCallBack.PerformCallback( decodeURI( $("#LoadSearchName").val()));
        }
        loadCallBack = {}
        loadCallBack.ClosePupUp = function () {
            SaveSearchPopupClient.Hide();
            ;
        }
        function LoadCallBackCompleted() {
            var message = ErrorMessageClient.Get("hidden_value");
            if (message != null && message != '') {
                if (message.indexOf("_call_func") >= 0) {
                    var funcName = message.split("_call_func")[1];
                    loadCallBack[funcName]();
                    message = message.substring(0, message.indexOf("_call_func"));
                }
                //alert(message);
                $("#messageBody").html(message);

                $('#msgModal').modal();
                ErrorMessageClient.Set("hidden_value", "");
            }
            //QueryResultsGridClient.Refresh();


        }
        function loadFunction(funName) {
            tableViewClinetCallBack.PerformCallback("loadFunction|" + funName);
        }
        function filterOutExitChange(e) {
            loadFunction('dxfilterOutExist_CheckedChanged|' + e.checked);
        }
        function gridSelect() {
            $("#SelectCount").html(QueryResultsGridClient.GetSelectedRowCount());
        }
    </script>

    <dx:ASPxSplitter ID="ASPxSplitter1" runat="server" Width="100%" Height="100%" ClientInstanceName="sampleSplitter" FullscreenMode="true">
        <Styles>
            <Pane>
                <Paddings Padding="0px" />
            </Pane>
        </Styles>
        <Panes>
            <dx:SplitterPane Size="520px" MinSize="520px" Name="listBoxContainer" ShowCollapseBackwardButton="True">
                <ContentCollection>
                    <dx:SplitterContentControl runat="server">
                        <div style="padding: 30px; color: #2e2f31; height: 100%">
                            <div style="margin-bottom: 30px;">
                                <i class="fa fa-search-plus title_icon color_gray"></i>
                                <span class="title_text">Leads Search</span>
                            </div>
                            <span class="font_18" style="color: #234b60;">Load search results  <%--Load a previously saved search--%></span>
                            <div class="form-group under_line_div" style="margin-top: 10px; padding-bottom: 20px; border-width: 2px">

                                <div class="form-inline">
                                    <select class=" form-control query_input_60percent" id="LoadSearchName">
                                        <% For Each st In CompletedTask%>
                                        <option value='<%= HttpUtility.UrlEncode(st.TaksName).Replace("+","%20")%>'><%= st.TaksName %></option>
                                        <% Next%>
                                        <option></option>
                                        
                                        <%--<option value="Borough">All</option>
                                        <option value="Borough">Bronx</option>
                                        <option value="Borough">Borough</option>
                                        <option value="Zip">Zip</option>--%>
                                    </select>
                                    <input type="button" class="rand-button rand-button-pad bg_orange button_margin" onclick="OnLoadClick()" value="Load">
                                    <%-- <button type="button" class="rand-button rand-button-pad bg_orange button_margin">Create New</button>--%>
                                </div>

                            </div>
                            <div style="margin-top: 30px; padding-bottom: 10px;">
                                <div>
                                    <div style="display: inline-block; padding-right: 10px; border-right: 1px solid #dde0e7; color: #234b60; font-size: 18px;">Or... create new search criteria below</div>
                                    <div style="font-size: 12px; display: inline-block; line-height: 18px;">
                                        <span class="color_blue icon_btn button_margin" onclick="control_all(true)">Expand All </span>
                                        <span class="color_blue icon_btn button_margin" onclick="control_all(false)">Collapse All</span>

                                    </div>
                                </div>
                            </div>
                            <div style="height: 75%; padding-right: 15px; overflow: auto" id="lead_search_left">
                                <div>
                                    <div style="margin-top: 30px" class="clearfix">
                                        <div style="float: right">
                                            <button class="rand-button bg_color_blue rand-button-padding" type="button" style="margin-right: 10px" onclick="SearchLeads()">Search</button>
                                            <button type="button" class="rand-button rand-button-padding bg_color_gray">Clear All</button>
                                        </div>
                                    </div>
                                    <div>
                                        <div class="ss_array">
                                            <h4 class="ss_form_title title_with_line">
                                                <span class="title_index title_span upcase_text">Location</span>&nbsp;
                                                <i class="fa fa-compress expand_btn color_blue icon_btn color_blue tooltip-examples" onclick="expand_array_item(this)" title="Expand or Collapse"></i>
                                            </h4>
                                            <div class="collapse_div">
                                                <div class="form-group">
                                                    <div class="form-inline">
                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block">Borough</label>
                                                            <select class=" selectpicker form-control query_control" style="width: 98%" id="IdLocation" multiple>
                                                                <option>Manhattan</option>
                                                                <option>Bronx</option>
                                                                <option>Brooklyn</option>
                                                                <option>Queens</option>
                                                                <option>Staten Island</option>
                                                            </select>
                                                        </div>
                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block">Zip</label>
                                                            <select class=" selectpicker form-control query_control" style="width: 98%" id="IdZips" multiple>
                                                                <% For Each zip In ZipCodes%>
                                                                <option><%= zip %></option>

                                                                <% Next%>
                                                            </select>
                                                        </div>
                                                    </div>

                                                </div>
                                                <div class="form-group">
                                                    <div class="form-inline">
                                                        <div class="inline_block query_input_50_percent" style="width: 100%">
                                                            <label class="upcase_text font_black" style="display: block">Neighborhood</label>
                                                            <select class="selectpicker form-control width_100percent" style="width: 100%" id="IDNeighborhods" multiple data-size="8">
                                                                <%For Each neighName In AllNeighName%>
                                                                <option><%= neighName%></option>

                                                                <% Next%>
                                                            </select>
                                                        </div>

                                                    </div>

                                                </div>
                                            </div>
                                        </div>
                                        <div class="ss_array " style="/*background: #f5f5f5; */padding-top: 10px">
                                            <h4 class="ss_form_title title_with_line">
                                                <span class="title_index title_span upcase_text">Property Characteristics</span>&nbsp;
                                                <i class="fa fa-compress expand_btn color_blue icon_btn color_blue tooltip-examples" onclick="expand_array_item(this)" title="Expand or Collapse"></i>

                                            </h4>
                                            <div class="collapse_div">
                                                <div class="form-group">
                                                    <div class="form-inline">
                                                        <div class="inline_block " style="width: 100%">
                                                            <label class="upcase_text font_black" style="display: block">Property Class</label>
                                                            <select class="selectpicker form-control width_100percent" style="width: 98%" id="IDPeropertyClass" multiple data-size="8">

                                                                <option value="**">All</option>
                                                                <option value="R0-8">Condo</option>
                                                                <option value="D*">Large Residential</option>
                                                                <option value="a*">Single Family Home</option>
                                                                <option value="b*,c0,c3">2-4 Family</option>
                                                                <option value="c2">5-6 Family</option>
                                                                <option value="c1">7+ Family</option>
                                                                <option value="M*">Church / Synagogue</option>

                                                                <option value="c6,c8,d0,r9">Co-Op</option>
                                                                <option value="v*">Vacant Land</option>
                                                                <option value="g0-2,g6-8">Garage</option>
                                                                <option value="o1-5">Office Building</option>
                                                                <option value="c7,k1-5,s0-5,s9">Residential w/ Store</option>

                                                                <option value="e*,f*">Warehouse/Factory</option>



                                                            </select>
                                                            <%-- <button type="button" id="btn" onclick="AddOption()" value="Add" >Add</button>
                                                    <script type="text/javascript">
                                                        function AddOption()
                                                        {
                                                            var x = document.getElementById("selOption");
                                                            var option = document.createElement("option");
                                                            option.text = "Kiwi";
                                                            x.add(option);
                                                            $("#selOption").selectpicker('refresh');
                                                        }

                                                        function changeValue(e)
                                                        {
                                                           var vas= $(e).val();
                                                           debugger;
                                                        }
                                                    </script>--%>
                                                        </div>

                                                    </div>

                                                </div>
                                                <div class="form-group">
                                                    <div class="form-inline">
                                                        <div class="inline_block  query_input_50_percent" style="width: 100%">
                                                            <label class="upcase_text font_black" style="display: block">Class Code</label>
                                                            <select class=" selectpicker form-control width_100percent" style="width: 97%" id="IdPropertyClassCode" multiple data-size="8">
                                                                <% For Each classCode In AllPropertyCode%>
                                                                <option><%= classCode%> </option>

                                                                <% Next%>
                                                            </select>
                                                        </div>
                                                        <div class="inline_block  query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block">Zoning</label>
                                                            <select class=" selectpicker form-control width_100percent" style="width: 98%" id="IdZoning" multiple data-size="8">
                                                                <% For Each zoning In AllZoning%>
                                                                <option><%= zoning%> </option>

                                                                <% Next%>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="form-inline">
                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block">Unbuilt Sqft</label>
                                                            <select class="selectpicker form-control width_100percent" style="width: 98%" id="IdUnbuiltSqftmin">
                                                                <option value="">Min Sqft</option>
                                                                <option>500</option>
                                                                <option>600</option>
                                                                <option>700</option>
                                                                <option>800</option>
                                                                <option>900</option>
                                                                <option>1000</option>
                                                                <option>1250</option>
                                                                <option>1500</option>
                                                                <option>2000</option>
                                                                <option>2500</option>
                                                                <option>3000</option>
                                                                <option>3500</option>
                                                                <option>4000</option>
                                                                <option>5000</option>
                                                            </select>
                                                        </div>
                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block"></label>
                                                            <select class="selectpicker form-control width_100percent" style="width: 98%" id="IdUnbuiltSqftmax">
                                                                <option value="">Max Sqft</option>
                                                                <option>500 sqft</option>
                                                                <option>600 sqft</option>
                                                                <option>700 sqft</option>
                                                                <option>800 sqft</option>
                                                                <option>900 sqft</option>
                                                                <option>1000 sqft</option>
                                                                <option>1250 sqft</option>
                                                                <option>1500 sqft</option>
                                                                <option>2000 sqft</option>
                                                                <option>2500 sqft</option>
                                                                <option>3000 sqft</option>
                                                                <option>3500 sqft</option>
                                                                <option>4000 sqft</option>
                                                                <option>5000 sqft</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="form-inline">
                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block">NYC Sqft</label>
                                                            <select class="selectpicker form-control width_100percent" style="width: 98%" id="IdNYCsqftMin">
                                                                <option value="">Min Sqft</option>
                                                                <option>500 sqft</option>
                                                                <option>600 sqft</option>
                                                                <option>700 sqft</option>
                                                                <option>800 sqft</option>
                                                                <option>900 sqft</option>
                                                                <option>1000 sqft</option>
                                                                <option>1250 sqft</option>
                                                                <option>1500 sqft</option>
                                                                <option>2000 sqft</option>
                                                                <option>2500 sqft</option>
                                                                <option>3000 sqft</option>
                                                                <option>3500 sqft</option>
                                                                <option>4000 sqft</option>
                                                                <option>5000 sqft</option>

                                                            </select>
                                                        </div>
                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block"></label>
                                                            <select class="selectpicker form-control width_100percent" style="width: 98%" id="IdNYCsqftMax">
                                                                <option value="">Max Sqft</option>
                                                                <option>500 sqft</option>
                                                                <option>600 sqft</option>
                                                                <option>700 sqft</option>
                                                                <option>800 sqft</option>
                                                                <option>900 sqft</option>
                                                                <option>1000 sqft</option>
                                                                <option>1250 sqft</option>
                                                                <option>1500 sqft</option>
                                                                <option>2000 sqft</option>
                                                                <option>2500 sqft</option>
                                                                <option>3000 sqft</option>
                                                                <option>3500 sqft</option>
                                                                <option>4000 sqft</option>
                                                                <option>5000 sqft</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <div class="form-inline">
                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block">Lot Sqft</label>
                                                            <select class="selectpicker form-control width_100percent" style="width: 98%" id="IdLotSqftMin">
                                                                <option value="">Min Sqft</option>
                                                                <option>500 sqft</option>
                                                                <option>600 sqft</option>
                                                                <option>700 sqft</option>
                                                                <option>800 sqft</option>
                                                                <option>900 sqft</option>
                                                                <option>1000 sqft</option>
                                                                <option>1250 sqft</option>
                                                                <option>1500 sqft</option>
                                                                <option>2000 sqft</option>
                                                                <option>2500 sqft</option>
                                                                <option>3000 sqft</option>
                                                                <option>3500 sqft</option>
                                                                <option>4000 sqft</option>
                                                                <option>5000 sqft</option>

                                                            </select>
                                                        </div>
                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block"></label>
                                                            <select class="selectpicker form-control width_100percent" style="width: 98%" id="IdLotSqftMax">
                                                                <option value="">Max Sqft</option>
                                                                <option>500 sqft</option>
                                                                <option>600 sqft</option>
                                                                <option>700 sqft</option>
                                                                <option>800 sqft</option>
                                                                <option>900 sqft</option>
                                                                <option>1000 sqft</option>
                                                                <option>1250 sqft</option>
                                                                <option>1500 sqft</option>
                                                                <option>2000 sqft</option>
                                                                <option>2500 sqft</option>
                                                                <option>3000 sqft</option>
                                                                <option>3500 sqft</option>
                                                                <option>4000 sqft</option>
                                                                <option>5000 sqft</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="form-group">

                                                    <div class="form-inline">
                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block">YEAR BUILT</label>
                                                            <select class="selectpicker form-control width_100percent" style="width: 98%" id="IdYearBuildMin">
                                                                <option value="">From</option>
                                                                <%For i = 1900 To Date.Now.Year%>
                                                                <option><%=i %></option>

                                                                <%Next%>
                                                            </select>
                                                        </div>
                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block"></label>
                                                            <select class="selectpicker form-control width_100percent" style="width: 98%" id="IdYearBuildMax">
                                                                <option value="">To</option>
                                                                <%For i = 1900 To Date.Now.Year%>
                                                                <option><%=i %></option>

                                                                <%Next%>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="ss_array">
                                            <h4 class="ss_form_title title_with_line">
                                                <span class="title_index title_span upcase_text">Financial</span>&nbsp;
                                        <i class="fa fa-compress expand_btn color_blue icon_btn color_blue tooltip-examples" onclick="expand_array_item(this)" title="Expand or Collapse"></i>

                                            </h4>
                                            <div class="collapse_div">

                                                <div class="form-group">
                                                    <div class="form-inline">
                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block">Servicer</label>
                                                            <select class="selectpicker form-control width_100percent" style="width: 98%" id="IdServicer" multiple>
                                                                <option>BOA</option>
                                                                <option>Servicer 2</option>
                                                            </select>
                                                        </div>

                                                    </div>

                                                </div>

                                                <div class="form-group">
                                                    <div class="form-inline">
                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block">Mortgages (Sum)</label>
                                                            <select class="selectpicker form-control width_100percent" style="width: 98%" id="IdMortgageMin">
                                                                <option value="">Min Value</option>
                                                                <% For number = 50000  to 1000000 step 50000 %>
                                                                <option value="<%= number%>"><%= FormatCurrency(number, TriState.False, , TriState.True, TriState.True)%></option>
                                                                <% Next %>

                                                                <% For number = 1200000 To 3000000 Step 200000%>
                                                                 <option value="<%= number%>"><%= FormatCurrency(number, TriState.False, , TriState.True, TriState.True)%></option>
                                                                <% Next %>
                                                                <option value="3M+">$3M+</option>
                                                            </select>
                                                        </div>
                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block"></label>
                                                            <select class="selectpicker form-control width_100percent" style="width: 98%" id="IdMortgageMax">
                                                                <option value="">Max Value</option>
                                                                <% For number = 50000  to 1000000 step 50000 %>
                                                                <option value="<%= number%>"><%= FormatCurrency(number, TriState.False, , TriState.True, TriState.True)%></option>
                                                                <% Next %>

                                                                <% For number = 1200000 To 3000000 Step 200000%>
                                                                 <option value="<%= number%>"><%= FormatCurrency(number, TriState.False, , TriState.True, TriState.True)%></option>
                                                                <% Next %>
                                                                <option value="3M+">$3M+</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>
                                                <%--<div class="form-group">
                                                    <div class="form-inline">
                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block">Mortgages (Sum)</label>
                                                            <select class="selectpicker form-control width_100percent">
                                                                <option value="">Min Value</option>
                                                                <option>$1000</option>
                                                                <option>$2000</option>
                                                            </select>
                                                        </div>

                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block"></label>
                                                            <select class="selectpicker form-control width_100percent" >
                                                                <option value="">Max Value</option>
                                                                <option>$3000</option>
                                                                <option>$4000</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>--%>
                                                <div class="form-group">
                                                    <div class="form-inline">
                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block">Value</label>
                                                            <select class="selectpicker form-control width_100percent" style="width: 98%" id="IDValueMin">
                                                                <option value="">Min Value</option>

                                                                <option value="100000">$100,000</option>
                                                                <option value="150000">$150,000</option>
                                                                <option value="200000">$200,000</option>
                                                                <option value="250000">$250,000</option>
                                                                <option value="300000">$300,000</option>
                                                                <option value="400000">$400,000</option>
                                                                <option value="500000">$500,000</option>
                                                                <option value="600000">$600,000</option>
                                                                <option value="700000">$700,000</option>
                                                                <option value="750000">$750,000</option>
                                                                <option value="800000">$800,000</option>
                                                                <option value="900000">$900,000</option>
                                                                <option value="1000000">$1,000,000</option>
                                                                <option value="1250000">$1,250,000</option>
                                                                <option value="1500000">$1,500,000</option>
                                                                <option value="1750000">$1,750,000</option>
                                                                <option value="2000000">$2,000,000</option>
                                                                <option value="2250000">$2,250,000</option>
                                                                <option value="2500000">$2,500,000</option>
                                                                <option value="2750000">$2,750,000</option>
                                                                <option value="3000000">$3,000,000</option>
                                                                <option value="3500000">$3,500,000</option>
                                                                <option value="4000000">$4,000,000</option>
                                                                <option value="4500000">$4,500,000</option>
                                                                <option value="5000000">$5,000,000</option>
                                                                <option value="6000000">$6,000,000</option>
                                                                <option value="7000000">$7,000,000</option>
                                                                <option value="8000000">$8,000,000</option>
                                                                <option value="9000000">$9,000,000</option>
                                                                <option value="10000000">$10,000,000</option>
                                                                <option value="12000000">$12,000,000</option>
                                                                <option value="14000000">$14,000,000</option>
                                                                <option value="16000000">$16,000,000</option>
                                                                <option value="20000000">$20,000,000</option>
                                                                <option value="25000000">$25,000,000</option>
                                                                <option value="30000000">$30,000,000</option>
                                                            </select>
                                                        </div>
                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block"></label>
                                                            <select class="selectpicker form-control width_100percent" style="width: 98%" id="IDValueMax">
                                                                <option value="">Max Value</option>

                                                                <option value="100000">$100,000</option>
                                                                <option value="150000">$150,000</option>
                                                                <option value="200000">$200,000</option>
                                                                <option value="250000">$250,000</option>
                                                                <option value="300000">$300,000</option>
                                                                <option value="400000">$400,000</option>
                                                                <option value="500000">$500,000</option>
                                                                <option value="600000">$600,000</option>
                                                                <option value="700000">$700,000</option>
                                                                <option value="750000">$750,000</option>
                                                                <option value="800000">$800,000</option>
                                                                <option value="900000">$900,000</option>
                                                                <option value="1000000">$1,000,000</option>
                                                                <option value="1250000">$1,250,000</option>
                                                                <option value="1500000">$1,500,000</option>
                                                                <option value="1750000">$1,750,000</option>
                                                                <option value="2000000">$2,000,000</option>
                                                                <option value="2250000">$2,250,000</option>
                                                                <option value="2500000">$2,500,000</option>
                                                                <option value="2750000">$2,750,000</option>
                                                                <option value="3000000">$3,000,000</option>
                                                                <option value="3500000">$3,500,000</option>
                                                                <option value="4000000">$4,000,000</option>
                                                                <option value="4500000">$4,500,000</option>
                                                                <option value="5000000">$5,000,000</option>
                                                                <option value="6000000">$6,000,000</option>
                                                                <option value="7000000">$7,000,000</option>
                                                                <option value="8000000">$8,000,000</option>
                                                                <option value="9000000">$9,000,000</option>
                                                                <option value="10000000">$10,000,000</option>
                                                                <option value="12000000">$12,000,000</option>
                                                                <option value="14000000">$14,000,000</option>
                                                                <option value="16000000">$16,000,000</option>
                                                                <option value="20000000">$20,000,000</option>
                                                                <option value="25000000">$25,000,000</option>
                                                                <option value="30000000">$30,000,000</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="form-inline">
                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block">Equity</label>
                                                            <select class="selectpicker form-control width_100percent" style="width: 98%" id="IdEquityMin">
                                                                <option value="">Min Value</option>
                                                                <option>$1000</option>
                                                                <option>$2000</option>
                                                            </select>
                                                        </div>
                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block"></label>
                                                            <select class="selectpicker form-control width_100percent" style="width: 98%" id="IdEquityMax">
                                                                <option value="">Max Value</option>
                                                                <option>$3000</option>
                                                                <option>$4000</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="form-inline">
                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block">Taxes</label>
                                                            <select class="selectpicker form-control width_100percent" style="width: 98%" id="IdTaxesMin">
                                                                <option value="">Min Value</option>
                                                                <option value="500">$500</option>
                                                                <option value="750">$750</option>
                                                                <option value="1000">$1,000</option>
                                                                <option value="1500">$1,500</option>
                                                                <option value="2000">$2,000</option>
                                                                <option value="2500">$2,500</option>
                                                                <option value="3000">$3,000</option>
                                                                <option value="4000">$4,000</option>
                                                                <option value="5000">$5,000</option>
                                                                <option value="6000">$6,000</option>
                                                                <option value="7000">$7,000</option>
                                                                <option value="8000">$8,000</option>
                                                                <option value="9000">$9,000</option>
                                                                <option value="10000">$10,000</option>
                                                                <option value="15000">$15,000</option>
                                                            </select>
                                                        </div>
                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block"></label>
                                                            <select class="selectpicker form-control width_100percent" style="width: 98%" id="IdTaxesMax">
                                                                <option value="">Max Value</option>
                                                                <option value="500">$500</option>
                                                                <option value="750">$750</option>
                                                                <option value="1000">$1,000</option>
                                                                <option value="1500">$1,500</option>
                                                                <option value="2000">$2,000</option>
                                                                <option value="2500">$2,500</option>
                                                                <option value="3000">$3,000</option>
                                                                <option value="4000">$4,000</option>
                                                                <option value="5000">$5,000</option>
                                                                <option value="6000">$6,000</option>
                                                                <option value="7000">$7,000</option>
                                                                <option value="8000">$8,000</option>
                                                                <option value="9000">$9,000</option>
                                                                <option value="10000">$10,000</option>
                                                                <option value="15000">$15,000</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <div class="form-inline">
                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block">ECB/DOB</label>
                                                            <select class="selectpicker form-control width_100percent" style="width: 98%" id="IdECB_DOBMin">
                                                                <option value="">Min Value</option>
                                                                <option>$1000</option>
                                                                <option>$2000</option>
                                                            </select>
                                                        </div>
                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block"></label>
                                                            <select class="selectpicker form-control width_100percent" style="width: 98%" id="IdECB_DOBMax">
                                                                <option value="">Max Value</option>
                                                                <option>$3000</option>
                                                                <option>$4000</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <div class="form-inline">
                                                        <div class="inline_block ">
                                                            <label class="upcase_text font_black" style="display: block">Lis Pendens <span style="color: red; text-transform: none; font-weight: 400">(If want Lis Pendens Data  must select below)</span></label>
                                                            <input id="Lis_Pendens_yes" type="radio" name="Lis_Pendens">
                                                            <label for="Lis_Pendens_yes">
                                                                <span class="box_text">Yes </span>
                                                            </label>
                                                            <input id="Lis_Pendens_No" type="radio" name="Lis_Pendens">
                                                            <label for="Lis_Pendens_No" style="margin-left: 30px">
                                                                <span class="box_text">No </span>
                                                            </label>
                                                        </div>

                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="form-inline">
                                                        <div class="inline_block ">
                                                            <label class="upcase_text font_black" style="display: block">Lis Pendens MOD <span style="color: red; text-transform: none; font-weight: 400">(Check if want Lis Pendens not has been renewed)</span></label>
                                                            <input id="LPMOD_yes" type="radio" name="LPMOD">
                                                            <label for="LPMOD_yes">
                                                                <span class="box_text">Yes </span>
                                                            </label>
                                                            <input id="LPMOD_yes_No" type="radio" name="LPMOD">
                                                            <label for="LPMOD_yes_No" style="margin-left: 30px">
                                                                <span class="box_text">No </span>
                                                            </label>
                                                        </div>

                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="form-inline">
                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block">Docket / Year</label>
                                                            <select class="selectpicker form-control width_100percent" style="width: 98%" id="IdDocket_Year" multiple>

                                                                <% For i = Date.Now.Year - 10 To Date.Now.Year%>
                                                                <option><%=i %></option>
                                                                <% Next%>
                                                            </select>
                                                        </div>

                                                    </div>
                                                </div>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="clearfix">
                                        <div style="float: right">
                                            <div>
                                                <button class="rand-button bg_color_blue rand-button-padding" type="button" style="margin-right: 10px" onclick="SearchLeads()">Search</button>
                                                <button class="rand-button bg_color_gray rand-button-padding" type="button">Clear All</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </dx:SplitterContentControl>
                </ContentCollection>
            </dx:SplitterPane>
            <dx:SplitterPane>
                <Panes>
                    <dx:SplitterPane Name="gridContainer" Size="80%">
                        <ContentCollection>
                            <dx:SplitterContentControl runat="server">
                                <div>
                                    <ul class="nav nav-tabs clearfix" role="tablist" style="height: 70px; background: #ff400d; font-size: 18px; color: white">
                                        <li class="active short_sale_head_tab">
                                            <a href="#table_view" role="tab" data-toggle="tab" class="tab_button_a">
                                                <i class="fa fa-file-text head_tab_icon_padding"></i>
                                                <div class="font_size_bold">Table View</div>
                                            </a>
                                        </li>
                                        <li class="short_sale_head_tab" style="display: none"><%--map view not aviable right now--%>
                                            <a href="#map_view" role="tab" data-toggle="tab" class="tab_button_a">
                                                <i class="fa fa-map-marker head_tab_icon_padding"></i>
                                                <div class="font_size_bold">Map View</div>
                                            </a>
                                        </li>

                                    </ul>
                                    <div class="tab-content">
                                        <div role="tabpanel" class="tab-pane active" id="table_view">
                                            <dx:ASPxCallbackPanel runat="server" ID="cpTableView" ClientInstanceName="tableViewClinetCallBack" OnCallback="cpTableView_Callback">
                                                <PanelCollection>

                                                    <dx:PanelContent>
                                                        <asp:HiddenField ID="hfSearchName" runat="server" />
                                                        <asp:HiddenField ID="hfSearchType" runat="server" />
                                                        <dx:ASPxHiddenField runat="server" ID="ErrorMessage" ClientInstanceName="ErrorMessageClient"></dx:ASPxHiddenField>
                                                        <div style="padding: 30px">
                                                            <div style="margin: 0 10px; font-size: 36px" class="clear-fix">
                                                                <i class="fa fa-folder-open color_gray"></i>&nbsp;<span class="font_black"><span id="ResultsCount"><%=LoadLeadsCount %></span> Results</span>
                                                                <div style="float: right">
                                                                    <%--<dx:ASPxCheckBox ID="dxfilterOutExist" AutoPostBack="true" runat="server" OnCheckedChanged="dxfilterOutExist_CheckedChanged"> </dx:ASPxCheckBox>--%>
                                                                    <asp:HiddenField runat="server" ID="hfFilterOutExist" />
                                                                    <input type="checkbox" id="cbfilterOutExist" name="cbfilterOutExist" class="font_12" onchange="filterOutExitChange(this)" <%= If( bfilterOutExist,"checked","")%> />
                                                                    <label for="cbfilterOutExist" class="font_12" style="float: left; padding-top: 26px;">
                                                                        <span class="upcase_text">Don't Show Existing Leads</span>
                                                                    </label>
                                                                    <button class="rand-button bg_color_blue fa-sh rand-button-padding" type="button" id="Select250" onclick="loadFunction('Select250_ServerClick')">Select 500 Random for me !</button>
                                                                    <button style="margin-right: 10px;" class="rand-button bg_color_blue rand-button-padding" type="button" id="ImportSelect" onclick="loadFunction('ImportSelect_ServerClick')">Import Selected</button>

                                                                    <asp:LinkButton ID="btnExport" runat="server" OnClick="btnXlsxExport_Click" Text='<i class="fa fa-file-excel-o  report_head_button report_head_button_padding tooltip-examples" title="Save Excel"></i>'>                                                                
                                                                    </asp:LinkButton>
                                                                </div>
                                                            </div>
                                                            <div style="font-size: 24px; margin-left: 53px;">
                                                                <span id="SelectCount"><%= QueryResultsGrid.GetSelectedFieldValues.Count %></span> Selected
                                                            </div>

                                                            <div style="margin-top: 30px">

                                                                <dx:ASPxGridView ID="QueryResultsGrid" runat="server"
                                                                    HeaderFilterMode="CheckedList"
                                                                    OnHtmlRowPrepared="QueryResultsGrid_HtmlRowPrepared" OnDataBinding="QueryResultsGrid_DataBinding"
                                                                    ClientInstanceName="QueryResultsGridClient" Width="100%" KeyFieldName="Id" SettingsPager-PageSize="12" OnCommandButtonInitialize="QueryResultsGrid_CommandButtonInitialize" Settings-VerticalScrollBarMode="Auto" Settings-VerticalScrollableHeight="450">
                                                                    <Columns>
                                                                        <dx:GridViewCommandColumn ShowSelectCheckbox="True" VisibleIndex="0" SelectAllCheckboxMode="AllPages">
                                                                        </dx:GridViewCommandColumn>
                                                                        <dx:GridViewDataColumn FieldName="BBLE" VisibleIndex="0">
                                                                        </dx:GridViewDataColumn>
                                                                        <dx:GridViewDataColumn FieldName="LeadsName" VisibleIndex="1" />
                                                                        <dx:GridViewDataColumn FieldName="Neigh_Name">
                                                                            <Settings HeaderFilterMode="CheckedList" />
                                                                        </dx:GridViewDataColumn>
                                                                        <dx:GridViewDataColumn FieldName="MotgCombo" />
                                                                        <dx:GridViewDataColumn FieldName="TaxCombo" />
                                                                        <dx:GridViewDataColumn FieldName="CLass">
                                                                            <Settings HeaderFilterMode="CheckedList" />
                                                                        </dx:GridViewDataColumn>
                                                                        <dx:GridViewDataColumn FieldName="ORIG_SQFT" />
                                                                        <dx:GridViewDataColumn FieldName="LOT_DIM" />
                                                                        <dx:GridViewDataColumn FieldName="Servicer">
                                                                            <Settings HeaderFilterMode="CheckedList" />
                                                                        </dx:GridViewDataColumn>
                                                                        <%--<dx:GridViewDataColumn  Caption="ShowMap" >
                                                                            <DataItemTemplate>
                                                                                <div>
                                                                                    <i class="fa fa-map-marker icon_btn" style="font-size:18px;margin-left:20px;" onclick='ShowPropertyMap("<%# Eval("BBLE") %>")'> </i>
                                                                                </div>
                                                                            </DataItemTemplate>
                                                                        </dx:GridViewDataColumn>--%>


                                                                        <dx:GridViewDataColumn FieldName="Type" />
                                                                        <dx:GridViewDataColumn FieldName="AgentInLeads" Caption="Assign To">
                                                                            <Settings HeaderFilterMode="CheckedList" />
                                                                        </dx:GridViewDataColumn>

                                                                    </Columns>

                                                                    <%-- <DataItemTemplate>
                                                                     <div>
                                                                         <% If (String.IsNullOrEmpty(Eval("AgentInLeads"))) Then%>
                                                                         Lead already assgin to <%# Eval("AgentInLeads")%>!
                                                                         <% End If%>
                                                                        
                                                                     </div>
                                                                 </DataItemTemplate>
                                                                        </dx:GridViewDataColumn>
                                                                        
                                                                    </Columns>
                                                                   

                                                                   
                                                                   <%-- <ClientSideEvents EndCallback="function(s,e) { LoadCallBackCompleted(e.result)}" />--%>
                                                                    <Styles>
                                                                        <SelectedRow BackColor="#d9f1fd" ForeColor="#3993c1">
                                                                        </SelectedRow>
                                                                    </Styles>
                                                                    <ClientSideEvents SelectionChanged="function(s,e) { gridSelect()}" />
                                                                    <SettingsPager PageSize="12"></SettingsPager>
                                                                    <Settings ShowFilterRowMenu="true" ShowGroupPanel="True" ShowFooter="True" ShowHeaderFilterButton="true" />
                                                                </dx:ASPxGridView>
                                                                <dx:ASPxGridViewExporter ID="gridExport" runat="server" GridViewID="QueryResultsGrid"></dx:ASPxGridViewExporter>
                                                                <%If AdminLogIn() Then%>
                                                                <div>
                                                                    Admin Log in must assign agent to import:
                                                                    <dx:ASPxComboBox runat="server" ID="EmployeeList" CssClass="edit_drop">
                                                                    </dx:ASPxComboBox>
                                                                </div>
                                                                <%End If%>
                                                            </div>
                                                        </div>
                                                    </dx:PanelContent>
                                                </PanelCollection>
                                                <ClientSideEvents EndCallback="function(s,e) { LoadCallBackCompleted()}" />
                                            </dx:ASPxCallbackPanel>

                                        </div>
                                        <div role="tabpanel" class="tab-pane" id="map_view">map view</div>

                                    </div>
                                </div>
                            </dx:SplitterContentControl>
                        </ContentCollection>
                    </dx:SplitterPane>

                </Panes>
                <ContentCollection>
                    <dx:SplitterContentControl runat="server"></dx:SplitterContentControl>
                </ContentCollection>
            </dx:SplitterPane>
        </Panes>

    </dx:ASPxSplitter>
    <dx:ASPxPopupControl ID="SaveSearchPopup" runat="server"
        ClientInstanceName="SaveSearchPopupClient"
        CloseAction="CloseButton" ShowFooter="true" Width="550"
        HeaderText="Save Search " Modal="true"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableViewState="false" EnableHierarchyRecreation="True">
        <HeaderTemplate>
            <div class="clearfix">
                <table style="width:100%">
                    <tr>
                        <td>
                            <div class="pop_up_header_margin">
                                <i class="fa fa-floppy-o with_circle pop_up_header_icon"></i>
                                <span class="pop_up_header_text">Save Search </span>
                                <div style="margin-top:10px">
                                    <p id="Search_scenario" class="pop_up_header_text" style="font-size: 18px; white-space: pre-wrap"></p>
                                </div>

                            </div>
                        </td>
                        <td valign ="top">
                            <div class="pop_up_buttons_div">
                                <i class="fa fa-times icon_btn" onclick="SaveSearchPopupClient.Hide()"></i>
                            </div>
                        </td>
                    </tr>
                </table>

            </div>
        </HeaderTemplate>
        <ContentCollection>
            <dx:PopupControlContentControl>
                <div style="padding: 0 10px;">
                    <div class="input-group" style="width: 100%">
                        <label class="ss_form_input_title">name the search</label>

                        <style>
                            
                        </style>
                        <input type="text" class="form-control" id="TxtSearchTaskName" style="border-radius: 4px; margin-top: 3px;">

                        <div>
                             <label class="ss_form_input_title" style="margin-top:10px" >Search Type</label>
                        <select class="form-control" style="border-radius: 4px; margin-top: 3px;" id="SearchType">
                            <option value=""> Must Select !</option>
                            <%For Each lt In AssignLeadsPopup.GetLeadsTypeList%>
                            <option value='<%=lt.Value%>' > <%= lt.Name%> </option>
                            <% Next %>
                        </select>
                        </div>
                       
                    </div>
                </div>
            </dx:PopupControlContentControl>
        </ContentCollection>
        <FooterContentTemplate>
            <div style="float: right; padding-bottom: 20px;">
                <input style="margin-right: 20px;" type="button" class="rand-button rand-button-padding bg_color_blue" value="Save" onclick="OnSearchSaveClick();">
                <input type="button" class="rand-button rand-button-padding bg_color_gray" value="Close" onclick="SaveSearchPopupClient.Hide()">
            </div>

        </FooterContentTemplate>
        <%-- <ClientSideEvents EndCallback="function(s,e){
                SaveSearchPopupClient.Hide();
                $('#msgModal').modal();
            }" />--%>
    </dx:ASPxPopupControl>

    <div class="modal fade" id="msgModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">Success</h4>
                </div>
                <div class="modal-body" id="messageBody">
                    Your request has been submitted. Estimated time is 48 hours to upload. 
                    The system will notify you upon completion.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
    <uc1:MapsPopup runat="server" ID="MapsPopup" />
    <script>
        $(document).ready(function () {

            //$('.selectpicker').selectpicker();
            $('.selectpicker').select2();
           

        });
    </script>
</asp:Content>
