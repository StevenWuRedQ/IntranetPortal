<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ShortSalePropertyTab.ascx.vb" Inherits="IntranetPortal.ShortSalePropertyTab" %>
<%@ Import Namespace="IntranetPortal" %>

<div class="clearfix">
    <div style="float: right">
       <input type="button" class="rand-button short_sale_edit" value="Edit" onclick='swich_edit_model(this, short_sale_case_data)' />
    </div>
</div>

<div>
    <h4 class="ss_form_title">Property</h4>
    <ul class="ss_form_box clearfix">

        <li class="ss_form_item">
            <label class="ss_form_input_title">Street Number</label>
            <input class="ss_form_input" id="key_PropertyInfo_Number" value="<%= propertyInfo.Number %>">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Street Name</label>
            <input class="ss_form_input" id="key_PropertyInfo_StreetName"  value="<%= propertyInfo.StreetName %>">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">City</label>
            <input class="ss_form_input" id="key_PropertyInfo_City" value="<%= propertyInfo.City %>">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">State</label>
            <input class="ss_form_input" id="key_PropertyInfo_State" value="<%= propertyInfo.State %>">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Zip</label>
            <input class="ss_form_input" id="key_PropertyInfo_Zipcode" value="<%= propertyInfo.Zipcode %>">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value=" ">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">BLOCK</label>
            <input class="ss_form_input" id="key_PropertyInfo_Block" value="<%= propertyInfo.Block %>">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Lot</label>
            <input class="ss_form_input" id="key_PropertyInfo_Lot" value="<%=propertyInfo.Lot%>">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Building type</label>
            <select class="ss_form_input" id="key_PropertyInfo_select_BuildingType">
                <option value="0">House</option>
                <option value="1">Apartment</option>
                <option value="2">Condo</option>
                <option value="3">Cottage/cabin</option>
                <option value="4">Duplex</option>
                <option value="5">Flat</option>
                <option value="7">In-Law</option>
                <option value="8">Loft</option>
                <option value="9">Townhouse</option>
                <option value="10">Manufactured</option>
                <option value="11">Assisted living</option>
                <option value="12">Land</option>
            </select>
            <script>
                
                initSelect("key_PropertyInfo_select_BuildingType", '<%=propertyInfo.BuildingType%>');
                
            </script>
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title"># Of stories</label>
            <input class="ss_form_input" type="number" value="<%=propertyInfo.NumOfStories%>">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title"># Of Unit</label>
            <input class="ss_form_input"  value="<%=propertyInfo.NumOfUnit%>">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Accessibility</label>

            <select class="ss_form_input" id="key_PropertyInfo_select_Accessibility">
                <option value="0">Lockbox-LOC</option>
                <option value="0">Master Key</option>
                <option value="0">Homeowner's key</option>
            
            </select>
            <script>
                initSelect("key_PropertyInfo_select_Accessibility", '<%=propertyInfo.Accessibility%>')
            </script>
        </li>
         <li class="ss_form_item">
            <span class="ss_form_input_title">c/o(<span class="linkey_pdf">pdf</span>)</span>

            <input type="radio" class="ss_form_input" id="key_PropertyInfo_checkYes_CO" name="pdf" value="YES" <%=ShortSalePage.CheckBox(propertyInfo.CO)%>>
            <label for="key_PropertyInfo_checkYes_CO" class="input_with_check" >
                 <span class="box_text">Yes</span>
            </label>

            <input type="radio"  class="ss_form_input" id="none_pdf_checkey_no21" name="pdf" value="NO" <%=ShortSalePage.CheckBox(Not propertyInfo.CO) %>>
            <label for="none_pdf_checkey_no21" class="input_with_check">
                <span class="box_text"><span class="box_text">No</span></span>
                </label>

        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Tax Class</label>
            <input class="ss_form_input" id="key_PropertyInfo_TaxClass" value="<%=propertyInfo.TaxClass %>">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title"># of Families</label>
            <input class="ss_form_input" value="<%=propertyInfo.NumOfFamilies %>">
        </li>
       
        <li class="ss_form_item">
            <span class="ss_form_input_title">FHA</span>

            <input type="radio" id="key_PropertyInfo_checkYes_FHA"  class="ss_form_input" name="FHA1" value="YES" <%=ShortSalePage.CheckBox(propertyInfo.FHA) %>>
            <label for="checkYes_FHA" class="input_with_check"><span class="box_text">Yes</span></label>

            <input type="radio" id="none_pdf_checkey_no25" name="FHA1" value="NO"  <%=ShortSalePage.CheckBox( Not propertyInfo.FHA) %> >
            <label for="none_pdf_checkey_no25" class="input_with_check"><span class="box_text">No</span></label>

        </li>
        <li class="ss_form_item">
            <span class="ss_form_input_title">Fannie MAE</span>

            <input type="radio" id="key_PropertyInfo_checkYes_FannieMae" name="Fannie_Mae1" value="YES" <%=ShortSalePage.CheckBox(propertyInfo.FannieMae)%>>
            <label for="checkYes_FannieMae" class="input_with_check"><span class="box_text">Yes</span></label>

            <input type="radio" id="none_pdf_checkey_no23" name="Fannie_Mae1" value="NO" <%=ShortSalePage.CheckBox(Not propertyInfo.FannieMae)%>>
            <label for="none_pdf_checkey_no23" class="input_with_check"><span class="box_text">No</span></label>

        </li>
        <li class="ss_form_item">
            <span class="ss_form_input_title">Freddie Mac</span>

            <input type="radio" id="key_PropertyInfo_checkYes_FreddieMac" name="Freddie_Mac1" <%=ShortSalePage.CheckBox(propertyInfo.FreddieMac) %> value="YES">
            <label for="checkYes_FreddieMac" class="input_with_check"><span class="box_text">Yes</span></label>

            <input type="radio" id="none_pdf_checkey_no24" name="Freddie_Mac1"  <%=ShortSalePage.CheckBox(Not propertyInfo.FreddieMac) %>  value="NO">
            <label for="none_pdf_checkey_no24" class="input_with_check"><span class="box_text">No</span></label>

        </li>

        

    </ul>
</div>
<div class="ss_form">
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
                    <td>Livint Room</td>
                    <td>3</td>
                    <td>3</td>
                    <td>3</td>
                    <td>3</td>
                    <td>3</td>
                </tr>
                <tr class="font_14">
                    <td>Kicken</td>
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
