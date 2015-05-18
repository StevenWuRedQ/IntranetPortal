<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LegalSecondaryActions.ascx.vb" Inherits="IntranetPortal.LegalSecondaryActions" %>
<%-- Legal Secondary actions in Legal and need check in Leads UI--%>

<style>
    .legal_action_div
    {
        /*display:none;*/
    }
</style>
<div id="Estate" class="legal_action_div">
    <div class="ss_form">
        <h4 class="ss_form_title">Estate</h4>
        <ul class="ss_form_box clearfix">


            <li class="ss_form_item">
                <label class="ss_form_input_title">hold Reason</label>
                <select class="ss_form_input" data-field="PropertyInfo.Number">
                    <option>Tenants in common</option>
                    <option>Joint Tenants w/right of survivorship</option>
                    <option>Tenancy by the entirety</option>
                </select>
            </li>

            <li class="ss_form_item">
                <span class="ss_form_input_title">Estate set up</span>

                <select class="ss_form_input">
                    <option>Unknown</option>
                    <option>Yes</option>
                    <option>No</option>
                </select>
                <%--<input type="checkbox" id="pdf_check_yes108" name="1" class="ss_form_input" value="YES">
                                                                                        <label for="pdf_check_yes108" class="input_with_check">
                                                                                            <span class="box_text">Yes </span>
                                                                                        </label>--%>
            </li>
            <li class="ss_form_item">

                <span class="ss_form_input_title">borrower Died</span>
                <select class="ss_form_input">
                    <option>Unknown</option>
                    <option>Yes</option>
                    <option>No</option>
                </select>
                <%--<input type="radio" id="pdf_check110" name="1" class="ss_form_input" value="YES">
                                                                                        <label for="pdf_check110" class="input_with_check">
                                                                                            <span class="box_text">Yes </span>
                                                                                        </label>
                                                                                        <input type="radio" id="pdf_check111" name="1" class="ss_form_input" value="YES">
                                                                                        <label for="pdf_check111" class="input_with_check">
                                                                                            <span class="box_text">NO </span>
                                                                                        </label>--%>

            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">prior action</label>
                <input class="ss_form_input" data-field="PropertyInfo.Number">
            </li>

        </ul>
    </div>
</div>

<div id="Partition" class="legal_action_div">
    <div class="ss_form">
        <h4 class="ss_form_title">Partition</h4>
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">Owner</label>
                <input class="ss_form_input" data-field="PropertyInfo.Number" />
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">parties 1</label>
                <input class="ss_form_input" data-field="PropertyInfo.Number" />
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">parties 2</label>
                <input class="ss_form_input" data-field="PropertyInfo.Number" />
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Action</label>
                <select class="ss_form_input" data-field="PropertyInfo.Number">
                    <option>Action1                     </option>
                    <option>Action2 </option>

                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">held reson</label>
                <select class="ss_form_input" data-field="PropertyInfo.Number">
                    <option>Tenants in common                     </option>
                    <option>Joint Tenants w/right of survivorship </option>
                    <option>Tenancy by the entirety               </option>
                </select>
            </li>
        </ul>
    </div>
</div>


<div id="Breach_of_Contract" class="legal_action_div">
    <div class="ss_form">
        <h4 class="ss_form_title">Breach of Contract</h4>
        <ul class="ss_form_box clearfix">


            <li class="ss_form_item">
                <label class="ss_form_input_title">parties 1</label>
                <input class="ss_form_input" data-field="PropertyInfo.Number" />
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">parties 2</label>
                <input class="ss_form_input" data-field="PropertyInfo.Number" />
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Breach type</label>
                <select class="ss_form_input" data-field="PropertyInfo.Number">
                    <option>Breach  type 1 </option>
                    <option>Breach  type 2 </option>

                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">date </label>
                <input class="ss_form_input ss_date" data-field="PropertyInfo.Number" />
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">breach learned </label>
                <input class="ss_form_input" data-field="PropertyInfo.Number" />
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">money damages amount</label>
                <input class="ss_form_input currency_input" data-field="PropertyInfo.Number" />
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">money damages for</label>
                <input class="ss_form_input currency_input" data-field="PropertyInfo.Number" />
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">money damages check Id</label>
                <input class="ss_form_input currency_input" data-field="PropertyInfo.Number" />
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Action</label>
                <select class="ss_form_input" data-field="PropertyInfo.Number">
                    <option>Action1 </option>
                    <option>Action2 </option>

                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">held reson</label>
                <select class="ss_form_input" data-field="PropertyInfo.Number">
                    <option>Tenants in common                     </option>
                    <option>Joint Tenants w/right of survivorship </option>
                    <option>Tenancy by the entirety               </option>
                </select>
            </li>
        </ul>
    </div>
    <style>
        .checktoggle {
        }
    </style>

    <div class="ss_form">
        <h4 class="ss_form_title" style="width: 59%; display: inline-block">Breach of Contract money damages </h4>
        <div style="display: inline-block">
            <input type="checkbox" id="checkshow" name="1" class="ss_form_input checktoggle" value="YES">
            <label for="checkshow" class="input_with_check">
                <span class="box_text">Yes </span>
            </label>
        </div>
        <ul class="ss_form_box clearfix" style="display: none">
            <li class="ss_form_item">
                <label class="ss_form_input_title">amount</label>
                <input class="ss_form_input currency_input" data-field="PropertyInfo.Number" />
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Reason</label>
                <input class="ss_form_input " data-field="PropertyInfo.Number" />
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">check Id</label>
                <input class="ss_form_input " data-field="PropertyInfo.Number" />
            </li>
        </ul>
    </div>
</div>

<script>

    $(".checktoggle").click(function () {
        var box = $(this).parents(".ss_form").children(".ss_form_box");
        if (this.checked) {
            box.slideDown();
        } else {
            box.slideUp();
        }
    })
</script>
<div></div>

<div id="Quiet_Title" class="legal_action_div">
    <div class="ss_form">
        <h4 class="ss_form_title">Quiet Title</h4>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">LP date</label>
                <input class="ss_form_input ss_date" data-field="PropertyInfo.Number" />
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Default date</label>
                <input class="ss_form_input ss_date" data-field="PropertyInfo.Number" />
            </li>
            <li class="ss_form_item">
                <span class="ss_form_input_title">foreclosure active</span>
                <input type="checkbox" id="pdf_check_yes121" name="1" class="ss_form_input" value="YES">
                <label for="pdf_check_yes121" class="input_with_check">
                    <span class="box_text">Yes </span>
                </label>

            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">foreclosure Action</label>
                <select class="ss_form_input ">
                    <option>foreclosure action 1</option>
                    <option>foreclosure action 2</option>

                </select>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Prior Plaintiff</label>
                <input class="ss_form_input " data-field="PropertyInfo.Number" />
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Prior attorney</label>
                <input class="ss_form_input " data-field="PropertyInfo.Number" />
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Last payment date</label>
                <input class="ss_form_input " data-field="PropertyInfo.Number" />
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Credit Report</label>
                <input class="ss_form_input " data-field="PropertyInfo.Number" />
            </li>
            <li class="ss_form_item">
                <%--Who owns mortgage?--%>
                <label class="ss_form_input_title">Lender</label>
                <input class="ss_form_input " data-field="PropertyInfo.Number" />
            </li>
            <li class="ss_form_item">
                <%--Do we know who owns the Note--%>
                <label class="ss_form_input_title">Note owner</label>
                <input class="ss_form_input " data-field="PropertyInfo.Number" />
            </li>
            <li class="ss_form_item">
                <%--Do we have the Deed--%>
                <span class="ss_form_input_title">Deed</span>
                <select class="ss_form_input">
                    <option>Unknown</option>
                    <option>Yes</option>
                    <option>No</option>
                </select>
                <%-- <input type="checkbox" id="pdf_check_yes122" name="1" class="ss_form_input" value="YES">
                                                                                        <label for="pdf_check_yes122" class="input_with_check">
                                                                                            <span class="box_text">Yes </span>
                                                                                        </label>--%>
            </li>
            <li class="ss_form_item">
                <%--Who is bringing the action--%>
                <label class="ss_form_input_title">Action User</label>
                <input class="ss_form_input " data-field="PropertyInfo.Number" />
            </li>

        </ul>
    </div>
</div>


<%-- --------------------------------------------------------------%>