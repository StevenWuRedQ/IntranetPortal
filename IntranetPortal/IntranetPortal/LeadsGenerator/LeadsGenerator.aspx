<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LeadsGenerator.aspx.vb" Inherits="IntranetPortal.LeadsGenerator" MasterPageFile="~/Content.Master" %>


<asp:Content ContentPlaceHolderID="head" runat="server">
    <link href='http://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.6.3/css/bootstrap-select.css' rel='stylesheet' type='text/css' />
    <script src="http://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.6.3/js/bootstrap-select.js"></script>

</asp:Content>
<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <script>
        function SearchLeads() {
            var filter = {}
            filter.Location = $("#IdLocation").val();
            filter.Zips = $("#IdZips").val();
            filter.Neighborhoods = $("#IDNeighborhods").val();
            filter.PeropertyClasses = $("#IDPeropertyClass").val();
            filter.Zonings = $("#IdZoning").val();
            filter.UnbuiltSqft = { min: $("#IdUnbuiltSqftmin").val(), max: $("#IdUnbuiltSqftmax").val() }
            filter.NYCsqft = { min: $("#IdNYCsqftMin").val(), max: $("#IdNYCsqftMax").val() }

            filter.LotSqft = { min: $("#IdLotSqftMin").val(), max: $("#IdLotSqftMax").val() }
            filter.Servicers = $("#IdServicer").val();
            filter.Mortgage = { min: $("#IdMortgageMin").val(), max: $("#IdMortgageMax").val() }

            filter.Value = { min: $("#IDValueMin").val(), max: $("#IDValueMax").val() }
            filter.Equity = { min: $("#IdEquityMin").val(), max: $("#IdEquityMax").val() }

            filter.Tax = { min: $("#IdTaxesMin").val(), max: $("#IdTaxesMax").val() }
            filter.ECB_DOB = { min: $("#IdECB_DOBMin").val(), max: $("#IdECB_DOBMax").val() }
            filter.isLis = $("#Lis_Pendens_yes").val();
            filter.DocketYear = $("#IdDocket_Year").val();
            popUpSearch(filter);
            debugger;
        }
        function popUpSearch(filter)
        {
            SaveSearchPopupClient.Show();
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
                            <span class="font_18" style="color: #234b60;">Load a previously saved search</span>
                            <div class="form-group under_line_div" style="margin-top: 10px; padding-bottom: 20px; border-width: 2px">

                                <div class="form-inline">
                                    <select class="selectpicker form-control query_input_60percent" multiple>
                                        <optgroup label="Borough">
                                            <option value="Borough">All</option>
                                            <option value="Borough">Bronx</option>
                                        </optgroup>
                                        <option value="Borough">Borough</option>
                                        <option value="Zip">Zip</option>
                                    </select>
                                    <button type="button" class="rand-button rand-button-pad bg_orange button_margin">Load</button>
                                    <button type="button" class="rand-button rand-button-pad bg_orange button_margin">Create New</button>
                                </div>

                            </div>
                            <div style="margin-top: 30px; padding-bottom: 10px;">
                                <div>
                                    <div style="display: inline-block; padding-right: 10px; border-right: 1px solid #dde0e7; color: #234b60; font-size: 18px;">Or... create new search criteria below</div>
                                    <div style="font-size: 12px; display: inline-block; line-height: 18px;">
                                        <span class="color_blue icon_btn button_margin" onclick="collapse_all(true)">Expand All </span>
                                        <span class="color_blue icon_btn button_margin" onclick="collapse_all(true)">Collapse All</span>

                                    </div>
                                </div>
                            </div>
                            <div style="height: 75%; padding-right: 15px;" id="lead_search_left">
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
                                                            <select class=" selectpicker form-control width_100percent" id="IdLocation" multiple>
                                                                <option>Manhattan</option>
                                                                <option>Bronx</option>
                                                                <option>Brooklyn</option>
                                                                <option>Queens</option>
                                                                <option>Staten Island</option>
                                                            </select>
                                                        </div>
                                                        <div class="inline_block  query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block">Zip</label>
                                                            <select class=" selectpicker form-control width_100percent" id="IdZips" multiple>
                                                                <% For Each zip In ZipCodes%>
                                                                <option><%= zip %></option>

                                                                <% Next%>
                                                            </select>
                                                        </div>
                                                    </div>

                                                </div>
                                                <div class="form-group">
                                                    <div class="form-inline">
                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block">Neighborhood</label>
                                                            <select class="selectpicker form-control width_100percent" id="IDNeighborhods" multiple>
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
                                                        <div class="inline_block " style="width: 68%">
                                                            <label class="upcase_text font_black" style="display: block">Property Class</label>
                                                            <select class="selectpicker form-control width_100percent" id="IDPeropertyClass" multiple>

                                                                <option>All</option>
                                                                <option>Condo</option>
                                                                <option>Loft</option>
                                                                <option>Single Family Home</option>
                                                                <option>Coop</option>
                                                                <option>Townhome </option>
                                                                <option>TIC  </option>
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
                                                        <div class="inline_block  " style="width: 28%">
                                                            <label class="upcase_text font_black" style="display: block">Zoning</label>
                                                            <select class=" selectpicker form-control width_100percent" id="IdZoning" multiple>
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
                                                            <select class="selectpicker form-control width_100percent" id="IdUnbuiltSqftmin">
                                                                <option>Min Sqft</option>
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
                                                            <select class="selectpicker form-control width_100percent" id="IdUnbuiltSqftmax">
                                                                <option>Max Sqft</option>
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
                                                            <select class="selectpicker form-control width_100percent" id="IdNYCsqftMin">
                                                                <option>Min Sqft</option>
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
                                                            <select class="selectpicker form-control width_100percent" id="IdNYCsqftMax">
                                                                <option>Max Sqft</option>
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
                                                            <select class="selectpicker form-control width_100percent" id="IdLotSqftMin">
                                                                <option>Min Sqft</option>
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
                                                            <select class="selectpicker form-control width_100percent" id="IdLotSqftMax">
                                                                <option>Max Sqft</option>
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
                                                            <select class="selectpicker form-control width_100percent" id="IdYearBuildMin">
                                                                <option>From</option>
                                                                <%For i = 1900 To Date.Now.Year%>
                                                                <option><%=i %></option>

                                                                <%Next%>
                                                            </select>
                                                        </div>
                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block"></label>
                                                            <select class="selectpicker form-control width_100percent" id="IdYearBuildMax">
                                                                <option>To</option>
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
                                                            <select class="selectpicker form-control width_100percent" id="IdServicer" multiple>
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
                                                            <select class="selectpicker form-control width_100percent" id="IdMortgageMin">
                                                                <option>Mini Value</option>

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
                                                            <select class="selectpicker form-control width_100percent" id="IdMortgageMax">
                                                                <option>Max Value</option>
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
                                                <%--<div class="form-group">
                                                    <div class="form-inline">
                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block">Mortgages (Sum)</label>
                                                            <select class="selectpicker form-control width_100percent">
                                                                <option>Mini Value</option>
                                                                <option>$1000</option>
                                                                <option>$2000</option>
                                                            </select>
                                                        </div>

                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block"></label>
                                                            <select class="selectpicker form-control width_100percent" >
                                                                <option>Max Value</option>
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
                                                            <select class="selectpicker form-control width_100percent" id="IDValueMin">
                                                                <option>Mini Value</option>

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
                                                            <select class="selectpicker form-control width_100percent" id="IDValueMax">
                                                                <option>Max Value</option>

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
                                                            <select class="selectpicker form-control width_100percent" id="IdEquityMin">
                                                                <option>Mini Value</option>
                                                                <option>$1000</option>
                                                                <option>$2000</option>
                                                            </select>
                                                        </div>
                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block"></label>
                                                            <select class="selectpicker form-control width_100percent" id="IdIdEquityMax">
                                                                <option>Max Value</option>
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
                                                            <select class="selectpicker form-control width_100percent" id="IdTaxesMin">
                                                                <option>Mini Value</option>
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
                                                            <select class="selectpicker form-control width_100percent" id="IdTaxesMax">
                                                                <option>Max Value</option>
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
                                                            <select class="selectpicker form-control width_100percent" id="IdECB_DOBMin">
                                                                <option>Mini Value</option>
                                                                <option>$1000</option>
                                                                <option>$2000</option>
                                                            </select>
                                                        </div>
                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block"></label>
                                                            <select class="selectpicker form-control width_100percent" id="IdECB_DOBMax">
                                                                <option>Max Value</option>
                                                                <option>$3000</option>
                                                                <option>$4000</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="form-group">
                                                    <div class="form-inline">
                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block">Lis Pendens</label>
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
                                                        <div class="inline_block query_input_50_percent">
                                                            <label class="upcase_text font_black" style="display: block">Docket / Year</label>
                                                            <select class="selectpicker form-control width_100percent" id="IdDocket_Year" multiple>

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
                                            <div style="padding: 30px">
                                                <div style="margin: 0 10px; font-size: 36px">
                                                    <i class="fa fa-folder-open color_gray"></i>&nbsp;<span class="font_black">5 Results</span>
                                                </div>
                                                <div style="margin-top: 30px">
                                                    <dx:ASPxGridView ID="QueryResultsGrid" runat="server" Width="100%" KeyFieldName="BBLE" SettingsPager-PageSize="20">
                                                        <Columns>
                                                            <dx:GridViewCommandColumn ShowSelectCheckbox="True" VisibleIndex="0" SelectAllCheckboxMode="AllPages">
                                                            </dx:GridViewCommandColumn>
                                                            <dx:GridViewDataColumn FieldName="LeadsName" VisibleIndex="1" />
                                                        </Columns>
                                                        <Styles>
                                                            <SelectedRow BackColor="#d9f1fd" ForeColor="#3993c1">
                                                            </SelectedRow>
                                                        </Styles>
                                                        <Settings />
                                                    </dx:ASPxGridView>
                                                </div>
                                            </div>


                                        </div>
                                        <div role="tabpanel" class="tab-pane" id="map_view">map view</div>

                                    </div>
                                </div>
                            </dx:SplitterContentControl>
                        </ContentCollection>
                    </dx:SplitterPane>

                </Panes>
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

                <div class="pop_up_header_margin">
                    <i class="fa fa-floppy-o with_circle pop_up_header_icon"></i>
                    <span class="pop_up_header_text">Save Search</span>
                    <%--<div style="display: inline-block; font-size: 12px;">
                    <div>50 Leads</div>
                    <div>to be assigned</div>
                </div>--%>
                </div>
                <div class="pop_up_buttons_div">
                    <i class="fa fa-times icon_btn" onclick="SaveSearchPopupClient.Hide()"></i>
                </div>
            </div>
        </HeaderTemplate>
        <ContentCollection>
            <dx:PopupControlContentControl>
                <div style="padding:0 10px;">
                    <div class="input-group" style="width:100%">
                        <label class="ss_form_input_title"> name the search</label>
                        
                        <input type="text" class="form-control"  style="border-radius:4px;margin-top:3px;">
                    </div>
                </div>
            </dx:PopupControlContentControl>
        </ContentCollection>
        <FooterContentTemplate> 

            <div style="float: right; padding-bottom: 20px;">
                <input style="margin-right: 20px;" type="button" class="rand-button rand-button-padding bg_color_blue" value="Assign" onclick="OnSearchSaveClick()">
                <input type="button" class="rand-button rand-button-padding bg_color_gray" value="Close" onclick="SaveSearchPopupClient.Hide()">
            </div>

        </FooterContentTemplate>
    </dx:ASPxPopupControl>

    <script>
        $(document).ready(function () {
            $('.selectpicker').selectpicker();
            $('#lead_search_left').mCustomScrollbar({
                theme: "minimal-dark"
            });

        });


    </script>
</asp:Content>
