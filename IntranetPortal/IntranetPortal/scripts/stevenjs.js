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

function collectDate()
{
    var obj = new Object();
    $('.ss_form_input').each(function () {
        
        var id = $(this).attr("id");
        if (id != null && id.length > 0) {
            
            var t_id = null;
            var t_data = $(this).val();
          
            if (id.indexOf("select_")==0) {
                t_id = id.split("_")[1];
                t_data = $(this).find(":selected").text();
            } else if (id.indexOf("checkYes_") == 0)
            {
                t_id = id.split("_")[1];
                t_data = $(this).prop("checked");
            }
            else {
                t_id = id;
            }
            obj[t_id] = t_data;

        }
    });
   
    //for(var ele in inputs)
    //{
    //    var id = ele.id;
       
    //    if(id!=null &&id.length>0)
    //    {
    //        alert(id);
    //        var t_id = null;
    //        var t_data = id.text();
    //        if(id.startsWith("select_"))
    //        {
    //            t_id = id.split("_")[1];
    //            t_data = $(ele).find(":selected").text();
    //        }
    //        else
    //        {
    //            t_id = id;
    //        }
    //        obj[t_id] = t_data;

    //    }
    //}
    return obj;
}

function swich_edit_model(s, e) {
    var inputs = $(".ss_form_input");
    inputs.addClass("color_blue_edit");
    var checks = $(".input_with_check");
    if (s.GetText() == "Edit") {
        inputs.addClass("color_blue_edit");
        checks.addClass("color_blue_edit");
        s.SetText("Save");
    } else {
        alert(JSON.stringify( collectDate()));
        propertyTablCallbackClinet.PerformCallback(JSON.stringify(collectDate()));

        //inputs.removeClass("color_blue_edit");
        //checks.removeClass("color_blue_edit");
        //s.SetText("Edit");
    }


}
function initToolTips()
{
    if ($(".tooltip-examples").tooltip) {
        $(".tooltip-examples").tooltip({
            placement: 'bottom'
        });
    } else {
        alert('tooltip function can not found' + $(".tooltip-examples").tooltip);
    }
}
function initSelect(id,dValue)
{
    for (var i = 0; i < $('#'+id).children('option').length; i++) {

        var option = $('#'+id+' :nth-child(' + i + ')');
        option.prop('selected', option.text() == dValue);
    }
}
$(document).ready(function () {
    initToolTips();
    
});