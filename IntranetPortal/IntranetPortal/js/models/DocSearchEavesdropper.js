

angular.module('PortalApp')
    /**
     * @author steven
     * @date   8/12/2016
     * @returns class of Eaves dropper 
     */
    .factory('DocSearchEavesdropper', function () {
        var docSearchEavesdropper = function () {

        }

        /**
         * @author steven
         * @date   8/12/2016
         * @description:
         *  set evaesdrapper
         */
        docSearchEavesdropper.prototype.setEavesdropper(_eavesdropper)
        {
            this.eavesDropper = _eavesdropper;
        }

        /**
         * @author steven
         * @date   8/12/2016
         * @description:
         *  endorse evaesdrapper
         */
        docSearchEavesdropper.prototype.endorse = function()
        {
            if (!this.eavesDropper)
                console.error('unable to eavesdropper it not set yet');

            this.eavesDropper.endorseCheckDate = "";
        }

        /**
         * @author steven
         * @date   8/12/2016
         * @description:
         *  unendorse evaesdrapper
         */
        docSearchEavesdropper.prototype.unendorse = function () {
            this.eavesDropper = null;
        }

        return docSearchEavesdropper;
    });