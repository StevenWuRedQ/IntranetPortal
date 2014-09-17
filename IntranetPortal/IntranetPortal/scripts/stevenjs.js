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