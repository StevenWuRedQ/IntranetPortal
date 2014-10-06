<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ShortSalePropertyTab.ascx.vb" Inherits="IntranetPortal.ShortSalePropertyTab" %>
<%@ Import Namespace="IntranetPortal" %>

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
            <input class="ss_form_input" data-field="PropertyInfo.Number" >
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Street Name</label>
            <input class="ss_form_input" data-field="PropertyInfo.StreetName">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">City</label>
            <input class="ss_form_input" data-field="PropertyInfo.City" >
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">State</label>
            <input class="ss_form_input" data-field="PropertyInfo.State">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Zip</label>
            <input class="ss_form_input"  data-field="PropertyInfo.Zipcode" >
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value=" ">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">BLOCK</label>
            <input class="ss_form_input" data-field="PropertyInfo.Block" >
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Lot</label>
            <input class="ss_form_input" data-field="PropertyInfo.Lot" >
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
            <input class="ss_form_input" data-field="PropertyInfo.NumOfUnit">
        </li>
        <li class="ss_form_item" >
            <label class="ss_form_input_title">Accessibility</label>

            <select class="ss_form_input" data-field="PropertyInfo.Accessibility" >
                <option value="Lockbox-LOC">Lockbox-LOC</option>
                <option value="Master Key">Master Key</option>
                <option value="Homeowner's key">Homeowner's key</option>

            </select>

        </li>
        <li class="ss_form_item">
            <span class="ss_form_input_title">c/o(<span class="linkey_pdf">pdf</span>)</span>

            <input type="radio" class="ss_form_input" data-field="PropertyInfo.CO" data-radio="Y" id="key_PropertyInfo_checkYes_CO" name="pdf" value="YES" >
            <label for="key_PropertyInfo_checkYes_CO" class="input_with_check">
                <span class="box_text">Yes</span>
            </label>

            <input type="radio" class="ss_form_input"  data-field="PropertyInfo.CO" id="none_pdf_checkey_no21" name="pdf" value="NO" >
            <label for="none_pdf_checkey_no21" class="input_with_check">
                <span class="box_text"><span class="box_text">No</span></span>
            </label>

        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Tax Class</label>
            <input class="ss_form_input" data-field="PropertyInfo.TaxClass" >
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title"># of Families</label>
            <input class="ss_form_input" data-field="PropertyInfo.NumOfFamilies">
        </li>

        <li class="ss_form_item">
            <span class="ss_form_input_title">FHA</span>

            <input type="radio" id="key_PropertyInfo_checkYes_FHA" data-field="PropertyInfo.FHA"  data-radio="Y" class="ss_form_input" name="FHA1" value="YES" >
            <label for="key_PropertyInfo_checkYes_FHA" class="input_with_check"><span class="box_text">Yes</span></label>

            <input type="radio" id="none_pdf_checkey_no25" data-field="PropertyInfo.FHA" name="FHA1" value="NO">
            <label for="none_pdf_checkey_no25" class="input_with_check"><span class="box_text">No</span></label>

        </li>
        <li class="ss_form_item">
            <span class="ss_form_input_title">Fannie MAE</span>

            <input type="radio" id="key_PropertyInfo_checkYes_FannieMae" data-field="PropertyInfo.FannieMae" data-radio="Y" name="Fannie_Mae1" value="YES" >
            <label for="key_PropertyInfo_checkYes_FannieMae" class="input_with_check"><span class="box_text">Yes</span></label>

            <input type="radio" id="none_pdf_checkey_no23" data-field="PropertyInfo.FannieMae" name="Fannie_Mae1" value="NO">
            <label for="none_pdf_checkey_no23" class="input_with_check"><span class="box_text">No</span></label>

        </li>
        <li class="ss_form_item">
            <span class="ss_form_input_title">Freddie Mac</span>

            <input type="radio" id="key_PropertyInfo_checkYes_FreddieMac" data-field="PropertyInfo.FreddieMac" data-radio="Y" name="Freddie_Mac1" value="YES">
            <label for="key_PropertyInfo_checkYes_FreddieMac" class="input_with_check"><span class="box_text">Yes</span></label>

            <input type="radio" id="none_pdf_checkey_no24" data-field="PropertyInfo.FreddieMac" name="Freddie_Mac1" value="NO">
            <label for="none_pdf_checkey_no24" class="input_with_check"><span class="box_text">No</span></label>

        </li>

    </ul>
</div>
<div class="ss_form" id="home_breakdown_table">
    <h4 class="ss_form_title">Home Breakdown</h4>
    <%-- log tables--%>
    <div>
        <table class="table">
            <thead>
                <tr>
                    <th>Effective</th>
                    <th>Basement</th>
                    <th>1 st floor</th>
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
        </table>

    </div>
    <%------end-------%>
</div>

<script src="/scripts/mindmup-editabletable.js"></script>
<script>
   function onRefreashDone ()
    {
       $("#home_breakdown_table").editableTableWidget();
       //$(".ss_form_input").prop("disabled", true);
    }
    //$(document).ready(function () {
    //    // Handler for .ready() called.
    //    d_alert("rund edit ");
    //    $("#home_breakdown_table").editableTableWidget();
    //});
   
</script>