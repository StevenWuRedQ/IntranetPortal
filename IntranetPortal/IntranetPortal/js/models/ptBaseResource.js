angular.module('PortalApp').factory('ptBaseResource', function ($resource)
{
    var BaseUri = '/api';

    var PtBaseResource = function (apiName,key)
    {
        var uri = BaseUri + '/' + apiName + '/:' + key;
        var primaryKey = {};
        primaryKey[key] = "@"+key;
        var Resource = $resource(uri, primaryKey, { 'update': { method: 'PUT' } });
        
        //static function
        Resource.all =function()
        {

        }
        
        /*base class instance function*/
        Resource.prototype.$put = function ()
        {

        }
        
        return Resource;
       
    }

  
    //leadResearch.prototype.func
    //def function
    //leadResearch.func
    //constructor
    return PtBaseResource;
});