angular.module('PortalApp')
    /**
     * @author steven
     * @date   8/12/2016
     * @returns class of Eaves dropper 
     */
    .factory('DocNewVersionConfig', function () {
        CONSTANT_DATE = '8/11/2016';
        var docNewVersionConfig = function()
        {
            this.date = CONSTANT_DATE;
        }

        docNewVersionConfig.getInstance = function()
        {
            return new docNewVersionConfig();
        }
        
        return docNewVersionConfig
    })