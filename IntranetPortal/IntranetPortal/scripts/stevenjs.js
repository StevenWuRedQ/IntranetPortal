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

function d_assert(cond, s) {
    if (cond) {
        d_alert(s);
    }
}

/*when has value then is send object by value */
function get_sub_property(obj, id_str, value) {

    if (value != null) {
        value = currency2Number(value)
    }
    var props = id_str.split(".");

    if (props.length < 1) {
        if (value != null) {
            obj[id_str] = value
        }
        else {
            return obj[id_str];
        }

    }

    var t_obj = obj;
    for (var i = 0; i < props.length; i++) {
        var prop = props[i];
        //d_assert(prop == "Lender", "find object is " + JSON.stringify(t_obj))
        //if (t_obj == null)
        //{
        //    t_obj = new Object();
        //}
        if (t_obj[prop] == null) {

            if (value != null) {
                //d_alert("create new property" + prop);
                t_obj[prop] = new Object();
            } else {
                //wx_deubg ? "null" :
                return "";
            }

        }
        /* give a property a value */

        if (i == props.length - 1) {
            if (value != null) {
                // d_alert("value a new value to " + id_str + " = " + value);
                if (value instanceof Date) {
                    d_alert("the date is data" + value);
                }
                t_obj[prop] = value;
            }
        }

        t_obj = t_obj[prop];
    }

    return t_obj;
}
function expand_array_item(e)
{
    $(".collapse_div").css("display:none");
    var current_div = $(e).parents(".ss_array").find(".collapse_div");
    d_alert("find collapse_div " + current_div.length);
    current_div.css("display", "inline");
}
/*
*data_stauts == 1 then save data
*/
function ShortSaleDataBand(data_stauts) {

    /*use for ui*/
    onRefreashDone();
    /**/
    var is_save = data_stauts == 1;
    if (ShortSaleCaseData == null) {
        d_alert("ShortSaleCaseData is null");
        return;
    }

    if (ShortSaleCaseData.PropertyInfo == null) {
        d_alert("ShortSaleCaseData.PropertyInfo is null");
        return;
    }
    var ss_data = ShortSaleCaseData;
    //var field_name = "PropertyInfo.Number";
    var inputs = $(".ss_form_input");
    inputs.each(function (index) {

        var field = ($(this).attr("data-field"));
        if (!field) {
            return;
        }
        var elem = $(this);
        var data_value = null;
        if (is_save) {
            data_value = get_sub_property(ShortSaleCaseData, field, ss_field_data(elem, null));
        }
        data_value = get_sub_property(ss_data, field, null);
        ss_field_data(elem, data_value);
    });

    /*band short sale arrary item*/
    ShorSaleArrayDataBand(data_stauts)
}

function refreshDiv(field, obj) {
    get_sub_property(ShortSaleCaseData, field, obj);
    ShortSaleDataBand(2);
}
wx_show_bug = false;
/*set or get short sale data if value is null get data*/
function ss_field_data(elem, value) {

    if (elem.is("select")) {

        return initSelectByElem(elem, value);
    }
    else {
        /*input type*/

        if (elem.attr("type") == "radio") {
            /*radio input*/
            /*in radio check box there need add a data-radio="1" in middle*/

            if (value == null) {
                if (elem.attr("data-radio") != "Y") {
                    return null;
                }
                return elem.prop("checked");
            }
            //d_alert("elem.attr radio id = " + elem.attr("id") + "set value is " + elem.prop("checked"));
            elem.prop("checked", elem.attr("data-radio") == "Y" ? value : !value)

        }
        else if (elem.attr("type") == "checkbox") {
            if (value == null) {
                return elem.prop("checked");
            }
            elem.prop("checked", value);
        }
        else {

            if (value == null) {
                //d_alert("number value is= " + elem.val());

                return elem.val();
            }

            if (elem.attr("type") == "date") {
                if (!wx_show_bug)
                    value = toDateValue(new Date(parseInt(value.substr(6))));

            }

            elem.val(value);
        }

    }
    return null;
}

function currency2Number(value) {
    if (typeof (value) == "string") {
        if (value.indexOf("$") == 0) {
            var r_val = value
            r_val = r_val.replace(/\$/g, "");
            r_val = r_val.replace(/\,/g, "");
            return parseFloat(r_val);
        }
    }
    return value;
}
function toDateValue(date) {
    var now = date;

    var day = ("0" + now.getDate()).slice(-2);
    var month = ("0" + (now.getMonth() + 1)).slice(-2);
    return now.getFullYear() + "-" + (month) + "-" + (day);
}
function delete_array_item(button) {
    var ss_obj = ShortSaleCaseData;
    var arr_item = $(button).parents(".ss_array");

    var field = $(arr_item).attr("data-field");
    var data_value = get_sub_property(ss_obj, field);
    var index = $(arr_item).attr("data-array-index")
    data_value[index].DataStatus = 3;
    arr_item.remove();
    //getShortSaleInstanceComplete(null, null);
}
function clearArray(array)
{
    if (array == null || array.length == 0)
    {
        d_alert("clear empty array");
        return;
    }
    if (!(array instanceof Array))
    {
        d_alert("array is not array");
        return;
    }
   
    for (var i = array.length; i >= 0; i--)
    {
        var obj = array[i];
        if(obj!=null && obj.DataStatus &&obj.DataStatus==3)
        {
            array.splice(i, 1);
        }
    }
    
}
function ShorSaleArrayDataBand(data_stauts) {

    var is_save = data_stauts == 1;
    if (!is_save) {
        prepareArrayDivs(is_save);
    }

    var array_divs = $(".ss_array");

    array_divs.each(function (index) {
        var field = ($(this).attr("data-field"));
        if (!field) {
            return;
        }
        var elem = $(this);

        var data_value = get_sub_property(ShortSaleCaseData, field);
        //d_assert(data_value.length == 0, "create new field" + field + "data" + data_value);
        /*prepare frist element frist */
        if (data_value.length == 0) {
            data_value = new Array();
            get_sub_property(ShortSaleCaseData, field, data_value);
            data_value[0] = new Object();
        }
        var _index = $(this).attr("data-array-index");

        data_value = data_value[_index];

        elem.find("[data-item-type=1]").each(function (ind) {
            var item_field = $(this).attr("data-item");

            if (is_save) {
                //d_assert(_index == 4, "the data_value is " + JSON.stringify(data_value));
                get_sub_property(data_value, item_field, $(this).val());
            }

            var item_value = get_sub_property(data_value, item_field);
            $(this).val("");
            //if (!$(this).parents(".ss_array").css("display")=="none")
            $(this).val(item_value);
        });

    });
}

function prepareArrayDivs(is_save) {
    if (!is_save) {
        var needDelete = $(".ss_array");
        needDelete.each(function (index) {
            if ($(this).css("display") != "none") {

                $(this).remove();
            }
        });
    }
    else {
        alert("not delete the data");
    }

    var array_divs = $(".ss_array");
    array_divs.each(function (index) {
        var field = ($(this).attr("data-field"));
        if (!field) {
            return;
        }
        var elem = $(this);

        var data_value = get_sub_property(ShortSaleCaseData, field);

        /*there default have a empty div start add div below */
        var add_div = elem;
        /*when there is no data new a data */
        if (data_value.length == 0) {
            addCloneTo(elem, elem, 0);
        }
        for (var i = 0; i < data_value.length; i++) {

            var clone_div = addCloneTo(elem, add_div, i);
            add_div = clone_div;
        }
    });
}

/*add item in div array */
function AddArraryItem(e) {
    var array_div = $(e).parents(".ss_array");
    if (array_div == null) {
        d_alert(" can't find arrary" + $(e).attr("class"));
    }

    var field = array_div.attr("data-field");

    var data_value = get_sub_property(ShortSaleCaseData, field, null);
    var len = data_value.length;
    data_value[len] = new Object();
    var lastdiv = $(".ss_array[data-field='" + field + "']:last");

    var template = get_template_div(field);

    var add_div = addCloneTo(template, lastdiv, len );
    add_div.find("ss_form_input").each(function (ind) {
        $(this).val("");
    });

}

function get_template_div(field) {
    var template = $(".ss_array[data-field='" + field + "']:contains('__index__'):last");
    return template;
}
function addCloneTo(elem, add_div, index) {
    var clone_div = elem.clone();
    var i = index;
    clone_div.attr("data-array-index", i);
    clone_div = setArraryTitle(clone_div, i);

    var last
    clone_div.insertAfter(add_div);
    return clone_div
}

function setArraryTitle(div, a_index) {
    var oldhtml = div.html();
    var _idx = parseInt(a_index) + 1;

    var newhtml = oldhtml.replace(/__index__/g, " " + _idx);

    div.html(newhtml);
    div.css("display", "inline");
    return div;

}

function collectDate(objCase) {
    var obj = new Object();

    d_alert(JSON.stringify(objCase));

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

function switch_edit_model(s, objCase) {
    var inputs = $(".ss_form_input, .input_with_check");

    if ($(s).val() == "Edit") {
        inputs.addClass("color_blue_edit");

        $(".ss_form_input").prop("disabled", false);
        $(s).val("Save");
    } else {
        getShortSaleInstanceComplete(null, null);
        //getShortSaleInstanceClient.PerformCallback($("#short_sale_case_id").val());

        inputs.removeClass("color_blue_edit");

        $(s).val("Edit");
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
function initSelectByElem(e, dValue) {
    if (dValue == null) {
        return e.val();
    }
    var options = e.children('option');
    for (var i = 0; i < options.length; i++) {
        var option = $(options[i]);

        option.prop('selected', option.text() == dValue);
    }
    return null;
}

$(document).ready(function () {
    initToolTips();

});