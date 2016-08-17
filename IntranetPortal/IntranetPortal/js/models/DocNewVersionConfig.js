angular.module('PortalApp')
    /**
     * @author steven
     * @date   8/12/2016
     * @returns class of DocNewVersionConfig 
     */
    .factory('DocNewVersionConfig', function () {
        CONSTANT_DATE = '8/11/2016';
        var docNewVersionConfig = function()
        {
            this.date = CONSTANT_DATE;
        }
        /**
         * CONSTANT value do not allow to change
         * @returns {DocNewVersionConfig object} 
         */
        docNewVersionConfig.getInstance = function()
        {
            return new docNewVersionConfig();
        }
        
        return docNewVersionConfig;
    })