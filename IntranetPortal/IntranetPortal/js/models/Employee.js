angular.module('PortalApp').factory('EmployeeModel', ['$resource','$http', function($resource,$http){

    var resource = $resource('/api/employees/:id');

    resource.getEmpNames = function () {
        var promise = $http({
            method: 'GET',
            url: '/api/employeenames'
        })

        return promise;
    }
    
    return resource;
}])