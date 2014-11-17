<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LeadsGenerator.aspx.vb" Inherits="IntranetPortal.LeadsGenerator" MasterPageFile="~/Content.Master" %>


<asp:Content ContentPlaceHolderID="head" runat="server">
    <link href='http://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.6.3/css/bootstrap-select.css' rel='stylesheet' type='text/css' />
    <script src="http://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.6.3/js/bootstrap-select.js"></script>

</asp:Content>
<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">

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
                        <div style="padding: 30px; color: #2e2f31; overflow: auto; height: 100%" id="lead_search_left">
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

                            <div style="margin-top: 30px">
                                <div>
                                    <div style="display: inline-block; padding-right: 10px; border-right: 1px solid #dde0e7; color: #234b60; font-size: 18px;">Or... create new search criteria below</div>
                                    <div style="font-size: 12px; display: inline-block; line-height: 18px;">
                                        <span class="color_blue icon_btn button_margin" onclick="collapse_all(true)">Expand All </span>
                                        <span class="color_blue icon_btn button_margin" onclick="collapse_all(true)">Collapse All</span>

                                    </div>
                                </div>
                            </div>

                            <div style="margin-top: 30px" class="clearfix">
                                <div style="float: right">
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
                                                    <select class=" selectpicker form-control width_100percent" multiple>
                                                        <option>Manhattan</option>
                                                        <option>The Bronx</option>
                                                        <option>Brooklyn</option>
                                                        <option>Queens</option>
                                                        <option>Staten Island</option>
                                                    </select>
                                                </div>
                                                <div class="inline_block  query_input_50_percent">
                                                    <label class="upcase_text font_black" style="display: block">Zip</label>
                                                    <select class=" selectpicker form-control width_100percent" multiple>
                                                        <option>10001</option>
                                                        <option>10002</option>
                                                        <option>10003</option>

                                                    </select>
                                                </div>
                                            </div>

                                        </div>
                                        <div class="form-group">
                                            <div class="form-inline">
                                                <div class="inline_block query_input_50_percent">
                                                    <label class="upcase_text font_black" style="display: block">Neighborhood</label>
                                                    <select class="selectpicker form-control width_100percent" multiple>
                                                        <option>Westbury</option>
                                                        <option>Neighborhood2</option>
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
                                                    <select class="selectpicker form-control width_100percent" id="selOption" onchange="changeValue(this)" multiple>
                                                        
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
                                                    <select class=" selectpicker form-control width_100percent" multiple>
                                                        <option>24d</option>
                                                        <option>25d</option>
                                                        <option>26d</option>
                                                        <option>Zoning 4</option>
                                                    </select>
                                                </div>
                                            </div>

                                        </div>
                                        <div class="form-group">
                                            <div class="form-inline">
                                                <div class="inline_block query_input_50_percent">
                                                    <label class="upcase_text font_black" style="display: block">Unbuilt Sqft</label>
                                                    <select class="selectpicker form-control width_100percent">
                                                        <option>Min Sqft</option>
                                                        <option>1000</option>
                                                        <option>2000</option>
                                                        <option>3000</option>
                                                    </select>
                                                </div>
                                                <div class="inline_block query_input_50_percent">
                                                    <label class="upcase_text font_black" style="display: block"></label>
                                                    <select class="selectpicker form-control width_100percent">
                                                        <option>Max Sqft</option>
                                                        <option>1000</option>
                                                        <option>2000</option>
                                                        <option>3000</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="form-inline">
                                                <div class="inline_block query_input_50_percent">
                                                    <label class="upcase_text font_black" style="display: block">Unbuilt Sqft</label>
                                                    <select class="selectpicker form-control width_100percent">
                                                        <option>Min Sqft</option>
                                                        <option>1000</option>
                                                        <option>2000</option>
                                                        <option>3000</option>
                                                    </select>
                                                </div>
                                                <div class="inline_block query_input_50_percent">
                                                    <label class="upcase_text font_black" style="display: block"></label>
                                                    <select class="selectpicker form-control width_100percent">
                                                        <option>Max Sqft</option>
                                                        <option>1000</option>
                                                        <option>2000</option>
                                                        <option>3000</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="form-inline">
                                                <div class="inline_block query_input_50_percent">
                                                    <label class="upcase_text font_black" style="display: block">Unbuilt Sqft</label>
                                                    <select class="selectpicker form-control width_100percent">
                                                        <option>Min Sqft</option>
                                                        <option>1000</option>
                                                        <option>2000</option>
                                                        <option>3000</option>
                                                    </select>
                                                </div>
                                                <div class="inline_block query_input_50_percent">
                                                    <label class="upcase_text font_black" style="display: block"></label>
                                                    <select class="selectpicker form-control width_100percent">
                                                        <option>Max Sqft</option>
                                                        <option>1000</option>
                                                        <option>2000</option>
                                                        <option>3000</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="form-inline">
                                                <div class="inline_block query_input_50_percent">
                                                    <label class="upcase_text font_black" style="display: block">NYC Sqft</label>
                                                    <select class="selectpicker form-control width_100percent">
                                                        <option>Min Sqft</option>
                                                        <option>250 sqft</option>
                                                        <option>1000 sqft</option>

                                                    </select>
                                                </div>
                                                <div class="inline_block query_input_50_percent">
                                                    <label class="upcase_text font_black" style="display: block"></label>
                                                    <select class="selectpicker form-control width_100percent">
                                                        <option>Max Sqft</option>
                                                        <option>1000 sqft</option>
                                                        <option>2000 sqft</option>
                                                        <option>3000 sqft</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <div class="form-inline">
                                                <div class="inline_block query_input_50_percent">
                                                    <label class="upcase_text font_black" style="display: block">Lot Sqft</label>
                                                    <select class="selectpicker form-control width_100percent">
                                                        <option>Min Sqft</option>
                                                        <option>250 sqft</option>
                                                        <option>1000 sqft</option>

                                                    </select>
                                                </div>
                                                <div class="inline_block query_input_50_percent">
                                                    <label class="upcase_text font_black" style="display: block"></label>
                                                    <select class="selectpicker form-control width_100percent">
                                                        <option>Max Sqft</option>
                                                        <option>1000 sqft</option>
                                                        <option>2000 sqft</option>
                                                        <option>3000 sqft</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <div class="inline_block query_input_50_percent">
                                                <label class="upcase_text font_black" style="display: block">Year built</label>
                                                <select class="selectpicker form-control width_100percent" multiple>

                                                    <option>1900</option>
                                                    <option>1901</option>
                                                    <option>1902</option>

                                                </select>
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
                                                    <select class="selectpicker form-control width_100percent" multiple>
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
                                                    <select class="selectpicker form-control width_100percent">
                                                        <option>Mini Value</option>
                                                        <option>$1000</option>
                                                        <option>$2000</option>
                                                    </select>
                                                </div>
                                                <div class="inline_block query_input_50_percent">
                                                    <label class="upcase_text font_black" style="display: block"></label>
                                                    <select class="selectpicker form-control width_100percent">
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
                                                    <label class="upcase_text font_black" style="display: block">Mortgages (Sum)</label>
                                                    <select class="selectpicker form-control width_100percent">
                                                        <option>Mini Value</option>
                                                        <option>$1000</option>
                                                        <option>$2000</option>
                                                    </select>
                                                </div>

                                                <div class="inline_block query_input_50_percent">
                                                    <label class="upcase_text font_black" style="display: block"></label>
                                                    <select class="selectpicker form-control width_100percent">
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
                                                    <label class="upcase_text font_black" style="display: block">Value</label>
                                                    <select class="selectpicker form-control width_100percent">
                                                        <option>Mini Value</option>
                                                        <option>$1000</option>
                                                        <option>$2000</option>
                                                    </select>
                                                </div>
                                                <div class="inline_block query_input_50_percent">
                                                    <label class="upcase_text font_black" style="display: block"></label>
                                                    <select class="selectpicker form-control width_100percent">
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
                                                    <label class="upcase_text font_black" style="display: block">Equity</label>
                                                    <select class="selectpicker form-control width_100percent">
                                                        <option>Mini Value</option>
                                                        <option>$1000</option>
                                                        <option>$2000</option>
                                                    </select>
                                                </div>
                                                <div class="inline_block query_input_50_percent">
                                                    <label class="upcase_text font_black" style="display: block"></label>
                                                    <select class="selectpicker form-control width_100percent">
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
                                                    <select class="selectpicker form-control width_100percent">
                                                        <option>Mini Value</option>
                                                        <option>$1000</option>
                                                        <option>$2000</option>
                                                    </select>
                                                </div>
                                                <div class="inline_block query_input_50_percent">
                                                    <label class="upcase_text font_black" style="display: block"></label>
                                                    <select class="selectpicker form-control width_100percent">
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
                                                    <label class="upcase_text font_black" style="display: block">Tax Liens</label>
                                                    <select class="selectpicker form-control width_100percent">
                                                        <option>Mini Value</option>
                                                        <option>$1000</option>
                                                        <option>$2000</option>
                                                    </select>
                                                </div>
                                                <div class="inline_block query_input_50_percent">
                                                    <label class="upcase_text font_black" style="display: block"></label>
                                                    <select class="selectpicker form-control width_100percent">
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
                                                    <label class="upcase_text font_black" style="display: block">ECB/DOB</label>
                                                    <select class="selectpicker form-control width_100percent">
                                                        <option>Mini Value</option>
                                                        <option>$1000</option>
                                                        <option>$2000</option>
                                                    </select>
                                                </div>
                                                <div class="inline_block query_input_50_percent">
                                                    <label class="upcase_text font_black" style="display: block"></label>
                                                    <select class="selectpicker form-control width_100percent">
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
                                                    <label class="upcase_text font_black" style="display: block">Water</label>
                                                    <select class="selectpicker form-control width_100percent">
                                                        <option>Mini Value</option>
                                                        <option>$1000</option>
                                                        <option>$2000</option>
                                                    </select>
                                                </div>
                                                <div class="inline_block query_input_50_percent">
                                                    <label class="upcase_text font_black" style="display: block"></label>
                                                    <select class="selectpicker form-control width_100percent">
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
                                                    <select class="selectpicker form-control width_100percent" multiple>
                                                        <option>1900</option>
                                                        <option>1901</option>
                                                        <option>1902</option>
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
                                        <button class="rand-button bg_color_blue rand-button-padding" type="button" style="margin-right: 10px">Search</button>
                                        <button class="rand-button bg_color_gray rand-button-padding" type="button">Clear All</button>
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
                                                    <dx:ASPxGridView ID="QueryResultsGrid" runat="server" Width="100%" KeyFieldName="BBLE">
                                                        <Columns>
                                                            <dx:GridViewCommandColumn ShowSelectCheckbox="True" VisibleIndex="0" SelectAllCheckboxMode="AllPages">
                                                            </dx:GridViewCommandColumn>
                                                            <dx:GridViewDataColumn FieldName="LeadsName" VisibleIndex="1" />
                                                        </Columns>
                                                        <Styles>
                                                            <SelectedRow BackColor="#d9f1fd" ForeColor="#3993c1">
                                                            </SelectedRow>
                                                        </Styles>
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


    <script>
        $(document).ready(
            function () {
                $('.selectpicker').selectpicker();
            });
        $('#lead_search_left').mCustomScrollbar({
            theme: "minimal-dark"
        });
    </script>
</asp:Content>
