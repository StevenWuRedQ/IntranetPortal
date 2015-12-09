<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ShortSalePropertyTab.ascx.vb" Inherits="IntranetPortal.ShortSalePropertyTab" %>
<%@ Import Namespace="IntranetPortal" %>
<script>
    
</script>
<div class="clearfix">
    <div style="float: right">
        <input type="button" class="rand-button short_sale_edit" value="Edit" onclick='switch_edit_model(this, short_sale_case_data)' />
    </div>
</div>

<div>
    <h4 class="ss_form_title">Property</h4>
    <ul class="ss_form_box clearfix">

        <li class="ss_form_item">
            <label class="ss_form_input_title">Street Number</label>
            <input class="ss_form_input" data-field="PropertyInfo.Number" readonly="readonly">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Street Name</label>
            <input class="ss_form_input" data-field="PropertyInfo.StreetName" readonly="readonly">
        </li>
         <li class="ss_form_item">
            <label class="ss_form_input_title">Apt #</label>
            <input class="ss_form_input" data-field="PropertyInfo.AptNo" readonly="readonly">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">City</label>
            <input class="ss_form_input" data-field="PropertyInfo.City" readonly="readonly">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">State</label>
            <input class="ss_form_input" data-field="PropertyInfo.State" readonly="readonly">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Zip</label>
            <input class="ss_form_input" data-field="PropertyInfo.Zipcode" readonly="readonly">
        </li>
        
        <li class="ss_form_item">
            <label class="ss_form_input_title">BLOCK</label>
            <input class="ss_form_input" data-field="PropertyInfo.Block" readonly="readonly">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Lot</label>
            <input class="ss_form_input" data-field="PropertyInfo.Lot" readonly="readonly">
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
            <label class="ss_form_input_title"># Of stories</label>
            <input class="ss_form_input" type="number" data-field="PropertyInfo.NumOfStories">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title"># Of Unit</label>
            <input class="ss_form_input" type="number" data-field="PropertyInfo.NumOfUnit">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Accessibility</label>
            <input class="ss_form_input" type="number" data-field="PropertyInfo.Accessibility">
            <%--<select class="ss_form_input" data-field="PropertyInfo.Accessibility">
                <option value="Lockbox-LOC">Lockbox-LOC</option>
                <option value="Master Key">Master Key</option>
                <option value="Homeowner's key">Homeowner's key</option>

            </select>--%>


        </li>
         <li class="ss_form_item">
            <label class="ss_form_input_title">Investor</label>
            <select class="ss_form_input" data-field="PropertyInfo.Investor">
                <option >Investor 1</option>
                <option >Investor 2</option>
                <option >Investor 3</option>

            </select>
           
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

        <li class="ss_form_item">
            <span class="ss_form_input_title">Freddie Mac</span>

            <input type="radio" id="key_PropertyInfo_checkYes_FreddieMac" class="ss_form_input" data-field="PropertyInfo.FreddieMac" data-radio="Y" name="Freddie_Mac1" value="YES">
            <label for="key_PropertyInfo_checkYes_FreddieMac" class="input_with_check"><span class="box_text">Yes</span></label>

            <input type="radio" id="none_pdf_checkey_no24" class="ss_form_input" data-field="PropertyInfo.FreddieMac" name="Freddie_Mac1" value="NO">
            <label for="none_pdf_checkey_no24" class="input_with_check"><span class="box_text">No</span></label>

        </li>

    </ul>
</div>

<div class="ss_form" id="home_breakdown_table">
    <h4 class="ss_form_title">Home Breakdown</h4>
    <%-- log tables--%>
    <asp:HiddenField ID="hfBble" runat="server" />
    <asp:HiddenField ID="hfCaseId" runat="server" />
    <div>
        <dx:ASPxGridView ID="home_breakdown_gridview" runat="server" KeyFieldName="BBLE;FloorId" SettingsBehavior-AllowDragDrop="false" SettingsBehavior-AllowSort="false" OnRowInserting="home_breakdown_gridview_RowInserting" OnRowDeleting="home_breakdown_gridview_RowDeleting" OnRowUpdating="home_breakdown_gridview_RowUpdating" >
            <Columns>
                <dx:GridViewCommandColumn ShowEditButton="true" ShowNewButtonInHeader="true" ShowDeleteButton="True" />
                <%--<dx:GridViewDataColumn FieldName="FloorId" VisibleIndex="1" Caption="Floor" 
                    
                    />--%>


                <dx:GridViewDataColumn FieldName="FloorId" VisibleIndex="1" Caption="Floor" ReadOnly="true">
                    <EditItemTemplate>
                        <span>
                            <%# GetFloorId(Eval("FloorId"))%>
                        </span>
                    </EditItemTemplate>
                    
                </dx:GridViewDataColumn>
                <dx:GridViewDataColumn FieldName="Bedroom" VisibleIndex="1" />
                <dx:GridViewDataColumn FieldName="Bathroom" VisibleIndex="2" />
                <dx:GridViewDataColumn FieldName="Livingroom" VisibleIndex="3" />
                <dx:GridViewDataColumn FieldName="Kitchen" VisibleIndex="4" />
                <dx:GridViewDataColumn FieldName="Diningroom" VisibleIndex="5" />
                <dx:GridViewDataColumn FieldName="Occupied" VisibleIndex="5" />
                <%--<dx:GridViewDataColumn FieldName="Lease" VisibleIndex="5" />
                <dx:GridViewDataColumn FieldName="Type" VisibleIndex="5" />
                <dx:GridViewDataColumn FieldName="Rent" VisibleIndex="5" />

                <dx:GridViewDataColumn FieldName="BoilerRoom" VisibleIndex="5" />--%>
            </Columns>
            <SettingsEditing Mode="PopupEditForm" />


        </dx:ASPxGridView>

        <%--   <table class="table">
            <thead>
                <tr>
                    <th>Bedrooms</th>
                    <th>Bathrooms</th>
                    <th>Living Room</th>
                    <th>Kitcken</th>
                    <th>Dining Room</th>
                    <th>Whatever</th>
                    <th>Effective</th>
                    <th>Basement</th>
                    <th>1st floor</th>
                    <th>2nd floor</th>
                    <th>3rd floor</th>
                    <th>4th floor</th>
                </tr>
            </thead>
            <tbody>
                <tr class="font_14">
                    <td>Bedrooms</td>
                    <td>1</td>
                    <td>1</td>
                    <td>1</td>
                    <td>1</td>
                    <td>1</td>
                </tr>
                <tr class="font_14">
                    <td>Bathrooms</td>
                    <td>2</td>
                    <td>2</td>
                    <td>2</td>
                    <td>2</td>
                    <td>2</td>
                </tr>
                <tr class="font_14">
                    <td>Living Room</td>
                    <td>3</td>
                    <td>3</td>
                    <td>3</td>
                    <td>3</td>
                    <td>3</td>
                </tr>
                <tr class="font_14">
                    <td>Kitcken</td>
                    <td>4</td>
                    <td>4</td>
                    <td>4</td>
                    <td>4</td>
                    <td>4</td>
                </tr>
                <tr class="font_14">
                    <td>Dining Room</td>
                    <td>6</td>
                    <td>6</td>
                    <td>6</td>
                    <td>6</td>
                    <td>6</td>
                </tr>
                <tr class="font_14">
                    <td>Occupied</td>
                    <td>Homeowner</td>
                    <td>Homeowner</td>
                    <td>Homeowner</td>
                    <td>Homeowner</td>
                    <td>Homeowner</td>
                </tr>
                <tr class="font_14">
                    <td>Lease</td>
                    <td>N/A</td>
                    <td>N/A</td>
                    <td>N/A</td>
                    <td>N/A</td>
                    <td>N/A</td>
                </tr>
                <tr class="font_14">
                    <td>Rent</td>
                    <td>N/A</td>
                    <td>N/A</td>
                    <td>N/A</td>
                    <td>N/A</td>
                    <td>N/A</td>
                </tr>
                <tr class="font_14">
                    <td>Type</td>
                    <td>Whatever</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr class="font_14">
                    <td>Boiler Room</td>
                    <td>1</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
            </tbody>
        </table>--%>
    </div>
    <%------end-------%>
</div>

<script src="/bower_components/editable-table/mindmup-editabletable.js"></script>
<script>
    function onRefreashDone() {
        //$("#home_breakdown_table").editableTableWidget();
        $(".ss_form_input, .input_with_check").not(".ss_allow_eidt").prop("disabled", true);
        initToolTips();

        format_input();
        //$("#prioity_content").mCustomScrollbar(
        //      {
        //          theme: "minimal-dark"
        //      }
        //      );
        //$("#home_owner_content").mCustomScrollbar(
        //    {
        //        theme: "minimal-dark"
        //    }
        // );

        //$(".dxgvCSD").mCustomScrollbar(
        //    {
        //        theme: "minimal-dark",

        //    }
        // );
    }
    //$(document).ready(function () {
    //    // Handler for .ready() called.
    //    d_alert("rund edit ");
    //    $("#home_breakdown_table").editableTableWidget();
    //});

</script>
