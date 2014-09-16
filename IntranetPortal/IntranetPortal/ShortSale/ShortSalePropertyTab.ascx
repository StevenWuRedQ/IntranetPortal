<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ShortSalePropertyTab.ascx.vb" Inherits="IntranetPortal.ShortSalePropertyTab" %>
<div class="clearfix">
    <div style="float: right">
        <dx:ASPxButton runat="server" Text="Edit" AutoPostBack="false" CssClass="rand-button" HoverStyle-BackColor="#3993c1" BackColor="#99bdcf">
        </dx:ASPxButton>
    </div>
</div>

<div>
    <h4 class="ss_form_title">Property</h4>
    <ul class="ss_form_box clearfix">

        <li class="ss_form_item">
            <label class="ss_form_input_title">Street Number</label>
            <input class="ss_form_input" value="151-04">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Street Name</label>
            <input class="ss_form_input" value="Main St">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">City</label>
            <input class="ss_form_input" value="Flushing">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">State</label>
            <input class="ss_form_input" value="NY">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Zip</label>
            <input class="ss_form_input" value="11367">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value=" ">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">BLOCK</label>
            <input class="ss_form_input" value="3341">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Lot</label>
            <input class="ss_form_input" value="72">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Building type</label>
            <select class="ss_form_input">
                <option value="0">House</option>
                <option value="1">apartment</option>
                <option value="2">condo</option>
                <option value="3">cottage/cabin</option>
                <option value="4">duplex</option>
                <option value="5">flat</option>

                <option value="7">in-law</option>
                <option value="8">loft</option>
                <option value="9">townhouse</option>
                <option value="10">manufactured</option>
                <option value="11">assisted living</option>
                <option value="12">land</option>
            </select>
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title"># Of stories</label>
            <input class="ss_form_input" type="number" value="1">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title"># Of Unit</label>
            <input class="ss_form_input" value="72">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Accessibility</label>

            <select class="ss_form_input">
                <option value="0">Lockbox-LOC</option>
                <option value="0">Accessibility type 2</option>
            </select>
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Tax Class</label>
            <input class="ss_form_input" value="1">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title"># of Families</label>
            <input class="ss_form_input" value="1">
        </li>
        <li class="ss_form_item">
            <span class="ss_form_input_title">c/o(<span class="link_pdf">pdf</span>)</span>

            <input type="radio" id="pdf_check_yes21" name="1" value="YES">
            <label for="pdf_check_yes21" class="input_with_check">Yes</label>

            <input type="radio" id="pdf_check_no21" name="1" value="NO">
            <label for="pdf_check_no21" class="input_with_check">No</label>

        </li>
        <li class="ss_form_item">
            <span class="ss_form_input_title">FHA</span>

            <input type="radio" id="pdf_check_yes25" name="1" value="YES">
            <label for="pdf_check_yes25" class="input_with_check">Yes</label>

            <input type="radio" id="pdf_check_no25" name="1" value="NO">
            <label for="pdf_check_no25" class="input_with_check">No</label>

        </li>
        <li class="ss_form_item">
            <span class="ss_form_input_title">Fannie MAE</span>

            <input type="radio" id="pdf_check_yes22" name="1" value="YES">
            <label for="pdf_check_yes22" class="input_with_check">Yes</label>

            <input type="radio" id="pdf_check_no23" name="1" value="NO">
            <label for="pdf_check_no23" class="input_with_check">No</label>

        </li>
        <li class="ss_form_item">
            <span class="ss_form_input_title">Freddie Mac</span>

            <input type="radio" id="pdf_check_yes24" name="1" value="YES">
            <label for="pdf_check_yes24" class="input_with_check">Yes</label>

            <input type="radio" id="pdf_check_no24" name="1" value="NO">
            <label for="pdf_check_no24" class="input_with_check">No</label>

        </li>

        <li class="ss_form_item" style="visibility: hidden">
            <label class="ss_form_input_title">Block</label>
            <input class="ss_form_input" value="1795548554">
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
