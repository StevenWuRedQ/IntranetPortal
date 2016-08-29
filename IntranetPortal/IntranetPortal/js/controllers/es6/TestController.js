class TestController {

    constructor($scope){
        $scope.helloworld = 'HelloWorld';
    }
}

TestController.$inject=['$scope']
export default TestController;