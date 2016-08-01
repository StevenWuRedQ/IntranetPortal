
/**
 * in refactoring need spent time box 
 * on 7/27/2016 after 1:30PM
 * stop refactoring
 */
/**
 * @return {[class]}                 PropertyOffer class
 */
angular.module('PortalApp').factory('PropertyOffer', function (ptBaseResource, AssignCorp) {
    var propertyOffer = ptBaseResource('PropertyOffer', 'OfferId', null, {
        getByBBLE: {
            url: '/api/businessform/PropertyOffer/Tag/:BBLE',
            params: {
                BBLE: '@BBLE',
                //Test: '@Test'
            }
        }

    });
   
    /**
     * @todo
     * by Steven
     * worng spelling sorry about that will fix it after we refactory all 
     **/

    /**
     * @todo
     * by Steven
     * for speed it should be assignCrop type is (AssignCorp) not an Instances 
     */
    propertyOffer.prototype.assignCrop = new AssignCorp();

    /**
     * @data 7/28/2016
     * need carefully test
     * 1. in check current step called this function
     * 2. maybe in new PropertyOffer also need call this function
     */
    propertyOffer.prototype.assignOfferId = function (onAssignCorpSuccessed) {
        this.assignCrop.newOfferId = this.BusinessData.OfferId;
        this.assignCrop.BBLE = this.Tag;
        this.assignCrop.onAssignSucceed = onAssignCorpSuccessed;
       
    }
    // propertyOffer.prototype.BusinessData = new BusinessForm();

    //propertyOffer.prototype.Type = 'Short Sale';
    propertyOffer.prototype.FormName = 'PropertyOffer';

    /**
     * reload data
     * @param {type} formdata
     */
    propertyOffer.prototype.refreshSave = function (formdata) {
        this.DataId = formdata.DataId;
        this.Tag = formdata.Tag;
        this.CreateDate = formdata.CreateDate;
        this.CreateBy = formdata.CreateBy;
    }
    /**
     * @todo
     * by steven
     * for speed we define deal sheet class 
     * like this will move out when I have time
     * such as Seller class Buyer class and so on
     */
    propertyOffer.prototype.DealSheet = {
        ContractOrMemo: {
            Sellers: [{}],
            Buyers: [{}]
        },
        Deed: {
            Sellers: [{}]
        },
        CorrectionDeed: {
            Sellers: [{}],
            Buyers: [{}]
        }
    };

    return propertyOffer;
});