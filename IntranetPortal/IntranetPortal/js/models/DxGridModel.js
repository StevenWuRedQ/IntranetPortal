angular.module('PortalApp').factory('DxGridModel', function ($location, $routeParams) {

    var dxGridModel = function (opt, texts) {
        angular.extend(this, opt);
        if (texts) {
            this.editing = texts;
        }
        this.initFormUrl();

    }

    var EditingModel = function (texts) {
        this.editMode = "cell";
        if (texts)
        {
            this.texts = texts;
        }
        
    }
   
    
    // dxGridModel.prototype.editing = new EditingModel();

    dxGridModel.prototype.setNewText = function(texts)
    {
        this.editing = new EditingModel(texts);
    }
    /**
     * In devextrme grid view model 
     * The eidt permission should be handle by itself
     **/
    dxGridModel.prototype.initFormUrl = function () {
        var path = '';

        path = $location.path();

        if (path.indexOf('view') >= 0) {
            console.log("in view UI all input should be disabled");
            return;
        }

        if (path.indexOf('new') >= 0 || parseInt($routeParams['itemId']) >= 0) {
            this.editing.insertEnabled = true;
            this.editing.removeEnabled = true;
            this.editing.editEnabled = true;
        }
    }

    return dxGridModel;
});