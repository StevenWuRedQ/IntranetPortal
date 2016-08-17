/**
 * @return {[class]}                 DivError class
 */
angular.module('PortalApp').factory('DivError', function () {
    var _class = function (id) {
        this.id = id;
    }
    
    _class.prototype.getMessage = function () {
        var eMessages = [];
        /*ignore every parent of has form-ignore */
        $('#' + this.id + ' ul:not(.form_ignore) .ss_warning:not(.form_ignore)').each(function () {
            eMessages.push($(this).attr('data-message'));
        });
        return eMessages;
    }

    /**
     * @returns {boolen} true if the div pass the validate 
     */
    _class.prototype.passValidate = function()
    {
        return this.getMessage().length == 0;
    }
    

    return _class;
});