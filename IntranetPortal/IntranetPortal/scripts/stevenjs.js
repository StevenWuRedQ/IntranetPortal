function clickCollapse(e, id) {
    var buttonClassName = e.className;
    var openClass = "-minus";
    var clossClass = "-plus";

    var isOpen = buttonClassName.indexOf(openClass) > 0;
    var toSwich = !isOpen;
    var changeToClass = isOpen ? buttonClassName.replace(openClass, clossClass) : buttonClassName.replace(clossClass, openClass);
    e.className = changeToClass;

    $("#" + id).css("display", toSwich ? "initial" : "none");
}

var wx_deubg = true;
/*band data in short Sale*/
function d_alert(s) {
    if (wx_deubg) {
        alert(s);
    }
}

function get_sub_property(obj,id_str)
{
   
    var props = id_str.split(".");

    if (props.length < 1)
    {
        return obj[id_str];
    }
    var t_obj = obj;
    for (var i = 0; i < props.length;i++)
    {
        var prop = props[i];
        if (t_obj[prop] == null)
        {
            return "null";
        }
        t_obj = t_obj[prop];
    }
    return t_obj;
}

function ShortSaleDataBand() {
    if (ShortSaleCaseData == null) {
        d_alert("ShortSaleCaseData is null");
        return;
    }
   
    if (ShortSaleCaseData.PropertyInfo == null)
    {
        d_alert("ShortSaleCaseData.PropertyInfo  is null");
        return;
    }
    var ss_data = ShortSaleCaseData;
    //var field_name = "PropertyInfo.Number";
    var inputs = $(".ss_form_input");
    inputs.each(function (index) {

        var field = ($(this).attr("data-field"));
        if (!field)
        {
            return;
        }
        var elem = $(this);

       

        var data_value = get_sub_property(ss_data, field);
        if (elem.is("select")) {
           
            initSelectByElem(elem, data_value);
        }
        else {
            /*input type*/
          
            if (this.type == "radio")
            {               
                /*radio input*/
                /*in radio check box there need add a data-radio="1" in middle*/
                elem.prop("checked", elem.attr("data-radio") == "Y" ? data_value : !data_value)
            }
            else if (this.type == "checkbox")
            {
                elem.prop("checked", data_value);
            }
            else
            {
                elem.val(data_value);
            }
       
        }
    });
    
    /*band short sale arrary item*/
    ShorSaleArrayDataBand()
}

function ShorSaleArrayDataBand()
{
    var array_divs = $(".ss_array");
    array_divs.each(function (index) {
        var field = ($(this).attr("data-field"));
        if (!field) {
            return;
        }
        var elem = $(this);
        var data_value = get_sub_property(ShortSaleCaseData, field);
        var _index = $(this).attr("data-array-index");

        data_value = data_value[_index];

        elem.find("[data-item-type=1]").each(function (ind) {
            var item_field = $(this).attr("data-item");
            var item_value = data_value[item_field]
            $(this).val(item_value);
        });

    });
}

function collectDate(objCase) {
    var obj = new Object();
    if (wx_deubg)
        alert(JSON.stringify(objCase));

    if (objCase) {
        obj = objCase;
    }
    else {
        alert("objCase is null")
    }

    $('.ss_form_input').each(function () {

        var id = $(this).attr("id");
        var debug = wx_deubg && id == "key_PropertyInfo_select_BuildingType"; //debug switch
        if (id != null && id.length > 0) {

            var t_id = null;
            var t_data = $(this).val();
            var t_key = null;
            if (id.indexOf("key_") == 0) {
                id = id.replace("key_", "");

                t_key = id.split("_")[0];
                id = id.replace(t_key + "_", "");

            }
            if (debug)
                alert("id after repleace =" + id)
            if (id.indexOf("select_") == 0) {
                t_id = id.split("_")[1];
                t_data = $(this).find(":selected").text();
                if (debug)
                    alert("id = " + id + "is checked =" + t_data)
            } else if (id.indexOf("checkYes_") == 0) {
                t_id = id.split("_")[1];
                t_data = $(this).prop("checked");
            }

            else {
                t_id = id;
            }
            /*when id start with none_ then don't add it in backend data*/
            if (id.indexOf("none_") != 0) {
                if (t_key != null) {
                    if (obj[t_key] == null) {
                        obj[t_key] = new Object();
                    }
                    obj[t_key][t_id] = t_data

                } else {
                    obj[t_id] = t_data;
                }

            }


        }
    });
    delete obj.pdf_check_no21;
    return obj;
}

function swich_edit_model(s, objCase) {
    var inputs = $(".ss_form_input");

    var checks = $(".input_with_check");
    if ($(s).val() == "Edit") {
        inputs.addClass("color_blue_edit");
        checks.addClass("color_blue_edit");
        $(s).val("Save");
    } else {

        getShortSaleInstanceClient.PerformCallback($("#short_sale_case_id").val());

        //inputs.removeClass("color_blue_edit");
        //checks.removeClass("color_blue_edit");
        //s.val("Edit");
    }


}
function initToolTips() {
    if ($(".tooltip-examples").tooltip) {
        $(".tooltip-examples").tooltip({
            placement: 'bottom'
        });
    } else {
        alert('tooltip function can not found' + $(".tooltip-examples").tooltip);
    }
}
function initSelect(id, dValue) {
    for (var i = 0; i < $('#' + id).children('option').length; i++) {

        var option = $('#' + id + ' :nth-child(' + i + ')');
        option.prop('selected', option.text() == dValue);
    }
}
function initSelectByElem(e, dValue)
{
    var options = e.children('option');
    for (var i = 0; i < options.length; i++) {
        var option = $(options[i]);
        option.prop('selected', option.text() == dValue);
    }
}

$(document).ready(function () {
    initToolTips();

});