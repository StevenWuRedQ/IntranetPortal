/*should have name space like this dxModel.dxGridModel.confg.dxGridColumnModel */

function dxModel() {


}

//function dxGridModel() {



//}


/**
 * [dxGridColumnModel description]
 * @param  {dxGridColumn Option} opt [dxGridColumn Option]
 * @return {[dxGridColumnModel]}     [return model have dx Grid column with special handler]
 */
function dxGridColumnModel(opt) {

    _.extend(this, opt);
    if (this.dataType == 'date') {

        this.customizeText = this.customizeTextDateFunc;
    }

}
dxGridColumnModel.prototype.customizeTextDateFunc = function(e) {

    var date = e.value
    if (date) {
        return PortalUtility.FormatISODate(new Date(date));
    } 
    return ''
}
