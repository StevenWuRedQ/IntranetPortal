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

function d_assert(cond,s)
{
    if(cond)
    {
        d_alert(s);
    }
}
/*when has value then is send object by value */
function get_sub_property(obj, id_str, value) {

    var props = id_str.split(".");

    if (props.length < 1) {
        if (value!=null)
        {
            obj[id_str] = value
        }
        else
        {
            return obj[id_str];
        }
        
    }

    var t_obj = obj;
    for (var i = 0; i < props.length; i++) {
        var prop = props[i];
        if (t_obj[prop] == null) {
            if (value != null) {
                //d_alert("create new property" + prop);
                t_obj[prop] = new Object();
            } else
            {
                return wx_deubg ? "null" : " ";
            }
            
        }
        /* give a property a value */

        if (i == props.length - 1)
        {
            if (value != null) {
                // d_alert("value a new value to " + id_str + " = " + value);
                if (value instanceof Date)
                {
                    alert("the date is data");
                }
                t_obj[prop] = value;
            }
        }

        t_obj = t_obj[prop];
    }
   
    return t_obj;
}

function ShortSaleDataBand(is_save) {
    /*use for ui*/
    onRefreashDone();
    /**/
    if (ShortSaleCaseData == null) {
        d_alert("ShortSaleCaseData is null");
        return;
    }

    if (ShortSaleCaseData.PropertyInfo == null) {
        d_alert("ShortSaleCaseData.PropertyInfo  is null");
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
    ShorSaleArrayDataBand(is_save)
}
function testrefreshDiv()
{
    data = {
        Name:"test name",
        Cell: "test cell",
        Email:"testmail@email.com"
    }
    refreshDiv("AssignedProcessor", data);
}
function refreshDiv(field,obj)
{
    get_sub_property(ShortSaleCaseData, field, obj);
    ShortSaleDataBand(false);
}
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
                if (elem.attr("data-radio") != "Y")
                {
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
            elem.val(value);
        }

    }
    return null;
}

function ShorSaleArrayDataBand(is_save) {
    if (!is_save)
        prepareArrayDivs();

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
            if (is_save) {
                //d_assert(_index == 4, "the data_value is " + JSON.stringify(data_value));
                get_sub_property(data_value, item_field, $(this).val());
            }
            var item_value = data_value[item_field]
            
            $(this).val(item_value);
        });

    });
}
/*add item in div array */
function AddArraryItem(e) {
    var array_div = $(e).parents(".ss_array");
    if (array_div == null) {
        d_alert(" can't find arrary" + $(e).attr("class"));
    }

    var field = array_div.attr("data-field");
    alert("get field is " + field);
    var data_value = get_sub_property(ShortSaleCaseData, field, null);
    var len = data_value.length;
    data_value[len] = new Object();
    addCloneTo($(".ss_array[data-field='" + field + "']:last"), len);


}
function prepareArrayDivs() {
    var array_divs = $(".ss_array");
    array_divs.each(function (index) {
        var field = ($(this).attr("data-field"));
        if (!field) {
            return;
        }
        var elem = $(this);
        setArraryTitle(elem, 0);

        var data_value = get_sub_property(ShortSaleCaseData, field);

        /*there default have a empty div start add div below */
        var add_div = elem;
        for (var i = 1; i < data_value.length; i++) {
            
            var clone_div = addCloneTo(add_div, i);
            add_div = clone_div;
        }
    });
}
function addCloneTo(add_div,index)
{
    var clone_div = add_div.clone();
    var i = index;
    clone_div.attr("data-array-index", i);
    setArraryTitle(clone_div, i);
    clone_div.insertAfter(add_div);
    return clone_div
}

function setArraryTitle(div,a_index)
{
    var titles = div.find(".title_index");
    titles.each(function (index) {
        var _idx = parseInt(a_index) + 1;
        //alert("_idx =" + _idx + "a_index = " + a_index);
        $(this).text($(this).text().replace( /[0-9]/g, ""+_idx));
    });
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

function swich_edit_model(s, objCase) {
    var inputs = $(".ss_form_input");

    var checks = $(".input_with_check");
    if ($(s).val() == "Edit") {
        inputs.addClass("color_blue_edit");
        checks.addClass("color_blue_edit");
        $(s).val("Save");
    } else {
        getShortSaleInstanceComplete(null, null);
        //getShortSaleInstanceClient.PerformCallback($("#short_sale_case_id").val());

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