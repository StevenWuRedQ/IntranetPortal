/**
 * @return {[class]}                 AssignCorp class
 */
angular.module('PortalApp').factory('AssignCorp', function (ptBaseResource, CorpEntity, $http, DivError) {
    var _class = function ()
    {
        this.onAssignSucceed = null;
        this.BBLE = null;
    }
    
    _class.prototype.test = function()
    {
        this.text = "1234555";
    }

    _class.prototype.selectTeamChange = function ()
    {
        var team = this.Name;
        this.Signer = null;
        me = this;
        $http.get('/api/CorporationEntities/CorpSigners?team=' + team).success(function (signers) {
            me.signers = signers
        });
    }

    _class.prototype.assginCorpClick = function () {

        var _assignCrop = this;

        var eMessages = new DivError('assignBtnForm').getMessage();
        //var eMessages = $scope.getErrorMessage('assignBtnForm');
        if (_.any(eMessages)) {
            AngularRoot.alert(eMessages.join(' <br />'));
            return false;
        }

        //var assignApi = '/api/CorporationEntities/AvailableCorp?team=' + _assignCrop.Name + '&wellsfargo=' + _assignCrop.isWellsFargo;
        var assignApi = "/api/CorporationEntities/AvailableCorpBySigner?team=" + _assignCrop.Name + "&signer=" + _assignCrop.Signer;

        var confirmMsg = ' THIS PROCESS CANNOT BE REVERSED. Please confirm - The team is ' + _assignCrop.Name + ', and servicer is not Wells Fargo.';

        if (_assignCrop.isWellsFargo) {

            confirmMsg = ' THIS PROCESS CANNOT BE REVERSED. Please confirm - The team is ' + _assignCrop.Name + ', and Wells Fargo signer is ' + _assignCrop.Signer + '';
        }
        
        $http.get(assignApi).success(function (data) {

            AngularRoot.confirm(confirmMsg).then(function (r) {
                if (r) {
                    _assignCrop.assignCorpSuccessed(data);
                }
            });
        });
    }

    _class.prototype.assignCorpSuccessed = function (data) {
        var _assignCrop = this;
        $http.post('/api/CorporationEntities/Assign?bble=' + _assignCrop.BBLE, JSON.stringify(data)).success(function () {
            _assignCrop.Crop = data.CorpName;
            _assignCrop.CropData = data;

            if (_assignCrop.onAssignSucceed) {
                _assignCrop.onAssignSucceed(data);               
            } else {
                console.log("onAssignSucceed not implement.")
            }
        });
    }

    /**
     * This is not right have parent ID
     * */
    _class.prototype.newOfferId = 0    
    return _class;
});