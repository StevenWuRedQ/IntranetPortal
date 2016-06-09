
angular.module('PortalApp').factory('DxGridModel', function ($location, $routeParams) {


    var dxGridModel = function (opt) {
        angular.extend(this, opt);
        this.initFormUrl();
    }
    dxGridModel.prototype.editing = { editMode: "cell" };

    /**
     * In devextrme grid view model 
     * The eidt permission should be handle by itself
     **/
    dxGridModel.prototype.initFormUrl = function () {
        var path = '';

        path = $location.path();

        if (path.indexOf('new') >= 0 || parseInt($routeParams['itemId']) >= 0) {
            this.editing.insertEnabled = true;
            this.editing.removeEnabled = true;
            this.editing.editEnabled = true;
        }

    }

    return dxGridModel;
});