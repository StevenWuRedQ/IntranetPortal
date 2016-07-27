/**
 * @return {[class]}                 PropertyOffer class
 */
angular.module('PortalApp').factory('PropertyOffer', function (ptBaseResource, AssignCorp) {
    var propertyOffer = ptBaseResource('PropertyOffer', 'OfferId', null, {


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

    
    propertyOffer.prototype.Type =  'Short Sale';
    propertyOffer.prototype.FormName = 'PropertyOffer';

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