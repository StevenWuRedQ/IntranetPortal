
/**
 * @return {[class]}                 PreSign class
 */
angular.module('PortalApp').factory('PreSign', function (ptBaseResource,CheckRequest,LeadsInfo) {

    var preSign = ptBaseResource('PreSign', 'Id', null, {
        getByBBLE: {
            method: "GET",
            url: '/api/PreSign/BBLE/:BBLE',
            params: {
                BBLE: '@BBLE',
            },
            options: { noError: true }
        },
        financeList: {
            method: "GET", url: '/api/PreSign/CheckRequests', isArray: true
        }
  
    });
    /*** here use class desgin super key work spend 3 hours ***/

    preSign.prototype.validation = function ()
    {
        this.clearErrorMsg();
        if (!this.ExpectedDate) {
            this.pushErrorMsg("Please fill expected date !");
            // throw "Please fill expected date !";
           
        }
        if ((!this.Parties) || this.Parties.length < 1) {
            //$scope.alert("Please fill at least one Party !");
            this.pushErrorMsg("Please fill at least one Party !");
        }
        this.CheckRequestData = preSign.CType(this.CheckRequestData, CheckRequest);

        if (this.NeedCheck &&  this.CheckRequestData.Checks.length < 1) {
           this.pushErrorMsg("Check Request is enabled. Please enter checks to be issued.");
           
        }

        if (this.CheckRequestData && this.CheckRequestData.getTotalAmount() > this.DealAmount) {
           this.pushErrorMsg("The check's total amount must less than the deal amount, Please correct! ");           
        }

        if (!this.ApprovalFile) {
            this.pushErrorMsg("Please attach the approval file.");

        }

        return this.hasErrorMsg() == false;
    }
    /** init Id in font end model**/
    // preSign.prototype.Id = 0;
    preSign.prototype.BBLE = '';

    //preSign.prototype.Parties = [];
    //Later will change to Checks to Check Class
    //preSign.prototype.CheckRequestData = new CheckRequest();

    //preSign.prototype.NeedSearch = true;
    //preSign.prototype.NeedCheck = true;


    return preSign;
});