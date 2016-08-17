/**
 * @author Steven
 * @date   8/17/2016 
 * @todo
 *  right now we using this in contoller javascript code
 *  but it better warp it to Angular directive let it handle by itself.  
 * @description
 *  DivError model class
 * @return {DivError Class}
 */

angular.module('PortalApp')
    .factory('DivError', function () {
    var _class = function (id) {
        this.id = id;
    }
    /**
     * @author Steven
     * @date   8/16/2016
     * @description
     *  return all error messages under div
     *  which need validate
     */
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
    _class.prototype.passValidate = function () {
        return this.getMessage().length == 0;
    }

    /**
     * @author steven
     * @date   8/17/2016
     * @description
     *  check both have yes no and have related array must have at lest one
     *  row of date
     * 
     * @return {boolen} true if it pass validate
     */
    _class.prototype.multipleValidated = function (base, boolKey, arraykey) {
            var boolVal = base[boolKey];
            var arrayVal = base[arraykey];
            /**
             * bugs over here boolVal can not check with null
             * @see to Jira issue PORTAL-378 https://myidealprop.atlassian.net/browse/PORTAL-378
             * @solution
             * 
             */
            var hasWarning = (boolVal === null) || (boolVal && arrayVal == false);
            return hasWarning;
        }


    return _class;
});