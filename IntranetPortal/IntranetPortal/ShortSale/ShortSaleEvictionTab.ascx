<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ShortSaleEvictionTab.ascx.vb" Inherits="IntranetPortal.ShortSaleEvictionTab" %>
<div class="clearfix">
    <div style="float: right">
        <input type="button" class="rand-button short_sale_edit" value="Edit" onclick='switch_edit_model(this, short_sale_case_data)' />

    </div>
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/2.0.0/handlebars.min.js"></script>
<div class="ss_form">
    <h4 class="ss_form_title">Occupancy</h4>
    <ul class="ss_form_box clearfix">

        <li class="ss_form_item">
            <label class="ss_form_input_title">Occupied by </label>
            <select class="ss_form_input" data-field="OccupiedBy">
                <option value="Vacant">Vacant</option>
                <option value="Homeowner">Homeowner</option>
                <option value="Tenant (Coop)">Tenant (Coop)</option>
                <option value="Tenant (Non Coop)">Tenant (Non Coop)</option>
            </select>

        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Eviction</label>
            <input class="ss_form_input" data-field="Evivtion">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Date started</label>
            <input class="ss_form_input ss_date" id="Date_started" data-field="DateStarted">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Lock box code</label>
            <input class="ss_form_input" data-field="LockBoxCode">
        </li>

    </ul>
</div>
<div style="margin-top: 30px">&nbsp;</div>
<input id="CurrentUser" type="hidden"  value='<%= Page.User.Identity.Name%>' />
<div data-array-index="0" data-field="Occupants" class="ss_array" style="display: none">
    <%--<h3 class="title_with_line"><span class="title_index title_span">Mortgages </span></h3>--%>
    <h4 class="ss_form_title title_with_line">
        <span class="title_index title_span">Occupant __index__1</span> &nbsp;
        <i class="fa fa-expand expand_btn color_blue icon_btn color_blue tooltip-examples" onclick="expand_array_item(this)" title="Expand or Collapse"></i>
        <i class="fa fa-plus-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="AddArraryItem(event,this)" title="Add"></i>
        <i class="fa fa-times-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="delete_array_item(this)" title="Delete"></i>
    </h4>

    <div class="collapse_div">
        <div>

            <ul class="ss_form_box clearfix">

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Occupant Name</label>
                    <input class="ss_form_input" data-item="Name" data-item-type="1">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Occupant #</label>
                    <input class="ss_form_input ss_phone" data-item="Phone" data-item-type="1">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">&nbsp;</label>
                    <input class="ss_form_input ss_form_hidden" value="">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Floor</label>
                    <input class="ss_form_input" data-item="Floor" data-item-type="1">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Apt #</label>
                    <input class="ss_form_input" data-item="AptNo" data-item-type="1">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Lease</label>
                    <input class="ss_form_input " data-item="Lease" data-item-type="1">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Program</label>
                    <input class="ss_form_input " data-item="Program" data-item-type="1">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Last Rent</label>
                    <input class="ss_form_input " data-item="LastRent" data-item-type="1">
                </li>
                <li class="ss_form_item">
                    <span class="ss_form_input_title">Military</span>

                    <input type="radio" id="key_Military_yes___index__" data-item="Military" data-radio="Y" class="ss_form_input" name="Military___index__" value="YES">
                    <label for="key_Military_yes___index__" class="input_with_check"><span class="box_text">Yes</span></label>

                    <input type="radio" id="none_pdf_checkey_no___index__" data-item="Military" class="ss_form_input" name="Military___index__" value="NO">
                    <label for="none_pdf_checkey_no___index__" class="input_with_check"><span class="box_text">No</span></label>

                </li>
                <li class="ss_form_item">
                    <span class="ss_form_input_title">30 Day Notice</span>

                    <input type="radio" id="key_Notice30Day_yes__index__" data-item="Notice30Day" data-radio="Y" class="ss_form_input" name="Notice30Day__index__" value="YES">
                    <label for="key_Notice30Day_yes__index__" class="input_with_check"><span class="box_text">Yes</span></label>

                    <input type="radio" id="none_Notice30Day_no__index__" data-item="Notice30Day" name="Notice30Day__index__" value="NO" class="ss_form_input">
                    <label for="none_Notice30Day_no__index__" class="input_with_check"><span class="box_text">No</span></label>

                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Cash For Keys ($)</label>
                    <input class="ss_form_input currency_input" data-item="CFK" data-item-type="1" onblur="$(this).formatCurrency();">
                </li>
                <%-- <li class="ss_form_item">
                    <label class="ss_form_input_title">Type of Payment</label>
                    <input class="ss_form_input " data-item="TypeOfPayment" data-item-type="1">
                </li>--%>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Date to Vacate</label>
                    <input class="ss_form_input ss_date" data-item="DateToVacate" data-item-type="1">
                </li>
                <li class="ss_form_item">

                    <span class="ss_form_input_title">Completed</span>

                    <input type="radio" id="key_Completed_yes__index__" data-item="Completed" data-radio="Y" class="ss_form_input" name="Completed__index__" value="YES">
                    <label for="key_Completed_yes__index__" class="input_with_check"><span class="box_text">Yes</span></label>

                    <input type="radio" id="none_Completed_no__index__" data-item="Completed" class="ss_form_input" name="Completed__index__" value="NO">
                    <label for="none_Completed_no__index__" class="input_with_check"><span class="box_text">No</span></label>
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">&nbsp;</label>
                    <input class="ss_form_input ss_form_hidden" value="">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Attorney</label>
                    <input class="ss_form_input " data-item="Attorney" data-item-type="1">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Attorney #</label>
                    <input class="ss_form_input " data-item="AttorneyPhone" data-item-type="1">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Date Served</label>
                    <input class="ss_form_input ss_date" data-item="DateServed" data-item-type="1">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Court Date</label>
                    <input class="ss_form_input ss_date" data-item="CourtDate" data-item-type="1">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Stip Date</label>
                    <input class="ss_form_input ss_date" data-item="StipDate" data-item-type="1">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Amount</label>
                    <input class="ss_form_input " data-item="Amount" data-item-type="1">
                </li>




            </ul>
            <div class="ss_form" style="padding-bottom:20px;">
                <h4 class="ss_form_title">Notes <i class="fa fa-plus-circle  color_blue_edit collapse_btn tooltip-examples" title="Add" onclick="addOccupantNoteClick( __index__  ,this);"></i></h4>
                <%--clearence list--%>

                <div class="note_input" style="display: none" data-index="__index__">

                    <%--index 1--%>
                    {{#Notes}}
                    <div class="clearence_list_item">
                        <div class="clearence_list_content clearfix" style="margin-bottom:10px">
                            <div class="clearence_list_text" style="margin-top:0px;">
                                <div class="clearence_list_text14">
                                    <i class="fa fa-caret-right clearence_caret_right_icon"></i>
                                    <i class="fa fa-times color_blue_edit icon_btn tooltip-examples" title="Delete" style="float:right" onclick="deleteAccoupantNote(__index__,{{id}})"></i>
                                    <span class="clearence_list_text14">{{Notes}}
                                            <br />
                                        
                                        <span class="clearence_list_text12">{{CreateDate}} by {{CreateBy}}
                                        </span>
                                    </span>
                                    
                                </div>
                            </div>
                        </div>
                    </div>
                    {{/Notes}}
                </div>
                <div class="note_output">
                </div>
            </div>
        </div>
    </div>
</div>
<dx:ASPxPopupControl ClientInstanceName="aspxAddOccupantNotes" Width="500px" Height="50px" ID="AddOccupantNotes"
    HeaderText="Add Notes" ShowHeader="false" OnWindowCallback="AddOccupantNotes_WindowCallback"
    runat="server" EnableViewState="false" PopupHorizontalAlign="OutsideRight" PopupVerticalAlign="Middle" EnableHierarchyRecreation="True">
    <ContentCollection>
        <dx:PopupControlContentControl>
            <table>
                <tr style="padding-top: 3px;">
                    <td style="width: 380px; vertical-align: central">
                        <input type="text" class="form-control" id="txtAddOccupantNotes">
                    </td>
                    <td style="text-align: right">
                        <div style="margin-left:10px">
                            <dx:ASPxButton runat="server" ID="btnAdd" Text="Add" UseSubmitBehavior="false" AutoPostBack="false" CssClass="rand-button" BackColor="#3993c1">
                                <ClientSideEvents Click="function(s,e){AddOccupantsNote();}" />
                            </dx:ASPxButton>
                        </div>
                    </td>
                </tr>
            </table>
        </dx:PopupControlContentControl>
    </ContentCollection>
    <ClientSideEvents EndCallback="function(s,e){aspxAddOccupantNotes.Hide();}" />
</dx:ASPxPopupControl>
<script>
    
    var tempOccupantIndx = null;
    function addOccupantNoteClick(aIndex,e)
    {
        var Occupant = GetOccupant(aIndex);
        if (Occupant == null || Occupant.OccupantId==null)
        {
            alert("Add Notes need save frist ! Please click save button above.")
            return;
        }
        $("#txtAddOccupantNotes").val("");
        tempOccupantIndx = aIndex;
        aspxAddOccupantNotes.ShowAtElement(e);

    }
    function GetOccupant(aIndex)
    {
        ShortSaleCaseData.Occupants = ShortSaleCaseData.Occupants || []
        var Occupant = ShortSaleCaseData.Occupants[aIndex]
        return Occupant;
    }
    function AddOccupantsNote() {
        //debugger;
        //$("#txtAddOccupantNotes").val("");
        //tempOccupantIndx = aIndex;
        var aIndex = tempOccupantIndx;
        var Occupant = GetOccupant(aIndex);
        var tempOccupantID = 0
        
        tempOccupantID = Occupant.OccupantId;
        var createDate = (new Date()).toLocaleString();
        createDate = createDate.replace(",", "")
        var notes = Occupant.Notes != null ? JSON.parse(Occupant.Notes) : [];
        notes.push({ Notes: $("#txtAddOccupantNotes").val(), CreateDate: createDate, CreateBy: $("#CurrentUser").val(), id: notes.length });
        Occupant.Notes = JSON.stringify(notes);
        aspxAddOccupantNotes.PerformCallback(tempOccupantID + "|" + Occupant.Notes);
        LoadOccupantNotes();
    }
    function deleteAccoupantNote(aIndex,noteId)
    {
        var Occupant = GetOccupant(aIndex);
        tempOccupantID = Occupant.OccupantId;
        var notes = Occupant.Notes != null ? JSON.parse(Occupant.Notes) : [];
        for (var i = 0 ; i < notes.length; i++)
        {
            if (notes[i].id == noteId)
            {
                notes.splice(i, 1);
            }
           
        }
        
        Occupant.Notes = JSON.stringify(notes);
        aspxAddOccupantNotes.PerformCallback(tempOccupantID + "|" + Occupant.Notes);
        LoadOccupantNotes();
    }
    function LoadOccupantNotes() {
        var Occupants = ShortSaleCaseData.Occupants 
        $(".note_input").each(function () {
            var source = $(this).html();
            var template = Handlebars.compile(source);
            var index = $(this).attr("data-index");
            var notes = (Occupants != null && Occupants[index] != null && Occupants[index].Notes != null) ? JSON.parse(Occupants[index].Notes) : null
            var data = { Notes: notes } //{ Notes: [{ test: 1111 }, {test:222222}]};
            var result = template(data);
            $(this).parent().children(".note_output").html(result)
        }
        )

    }
    

</script>
