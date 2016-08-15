

angular.module('PortalApp')
    /**
     * @author steven
     * @date   8/12/2016
     * @returns class of Eaves dropper 
     */

    .factory('DocSearchEavesdropper', function (DocNewVersionConfig) {
        var docSearchEavesdropper = function () {

        }

        /**
         * @author steven
         * @date   8/12/2016
         * @description:
         *  set evaesdrapper public function very import
         */
        docSearchEavesdropper.prototype.setEavesdropper = function(_eavesdropper,revFunc)
        {
            this.eavesDropper = _eavesdropper;
            this.endorseCheckFuncs();
            this._registerCheckFuncs();
            this.endorse(revFunc);
        }

        /**
         * @author steven
         * @date   8/12/2016
         * @description:
         *  endorse evaesdropper
         */
        docSearchEavesdropper.prototype.endorse = function (revFunc) {
            if (!this.eavesDropper) {
                console.error('unable to eavesdropper it not set yet');
            }

            if (typeof revFunc != 'function')
                console.error("set rev function have been set up");

            this.endorseCheckFuncs();
            
            this.revFunc = revFunc;
        }

        /**
         * @author steven
         * @date   8/12/2016
         * @description: 
         *  public function very import start function
         */
        docSearchEavesdropper.prototype.start2Eaves = function () {
            this.endorseCheckFuncs();

            if (this.endorseCheckDate(DocNewVersionConfig.getInstance().date)
                || this.endorseCheckVersion())
            {
                this.revFunc(true);
            } else {
                this.revFunc(false);
            }
            
        }

        /**
         * @author steven
         * @date   8/12/2016
         * @description:
         *  check all necessary check function registered
         */
        docSearchEavesdropper.prototype.endorseCheckFuncs = function () {
            var eaves = this.eavesDropper;
           
            if ( typeof eaves.endorseCheckDate != 'function')
            {
                console.error("eavesDropper functions is not null");
            }

            if (typeof eaves.endorseCheckVersion != 'function') {
                console.error("eavesDropper functions is not null");
            }
           
        }
        /**
         * @author steven
         * @date   8/12/2016
         * @description:
         *  registerd check functions
         */
        docSearchEavesdropper.prototype._registerCheckFuncs = function()
        {
            var eaves = this.eavesDropper;
            this.endorseCheckFuncs();

            this.endorseCheckDate = eaves.endorseCheckDate;
            this.endorseCheckVersion = eaves.endorseCheckVersion;
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