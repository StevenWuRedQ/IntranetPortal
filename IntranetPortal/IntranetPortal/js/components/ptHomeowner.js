angular.module('PortalApp').component('ptHomeowner', {

    templateUrl: '/js/Views/LeadDocSearch/searchOwner.tpl.html',
    controller: function ($http, ptCom) {
        this.init = function (bble) {
            var that = this;
            if (bble) {
                $http({
                    method: 'GET',
                    url: '/api/homeowner/' + bble,
                }).then(function (r) {
                    that.rawdata = r.data;
                })
            }
        }

        this.parseDate = function (dateField) {
            if (dateField) {
                return (dateField.yearField ? dateField.yearField : 'xxxx') +
                       "/" + (dateField.monthField ? dateField.monthField : 'xx') +
                       "/" + (dateField.dayField ? dateField.dayField : 'xx');
            }

        } 

        this.parseAddress = function (addressField) {
            if (addressField) {
                return (addressField.line1Field ? addressField.line1Field + ' ' : '') +
                       (addressField.line2Field ? addressField.line2Field + ' ' : '') +
                       (addressField.line3Field ? addressField.line3Field + ' ' : '') +
                       ', ' +
                       (addressField.cityField ? addressField.cityField + ', ' : 'Unknown City,') +
                       (addressField.stateField ? addressField.stateField + ', ' : 'Unknown State,') +
                       (addressField.zipField ? addressField.zipField : '')
            }
        }

        this.BBLE = ptCom.getGlobal("BBLE") || ptCom.parseSearch(location.search).BBLE || "";
        this.init(this.BBLE);
    }
});