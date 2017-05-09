angular.module('PortalApp')
    .controller('GPAOfferDetailController', ['$scope', '$location', '$http',
        'ptUnderwriting', 'ptCom', 'UserGradeDataService', function ($scope, $location, $http,
            ptUnderwriting, ptCom, UserGradeDataService) {
            $scope.data = {};
            $scope.form = {};
            $scope.gradeData = {};
            $scope.panelState = 0;
            $scope.modalTitle = "";
            $scope.isLoadedOpinion = false;
            $scope.loadedUserGradeData = {}

            $scope.switchPanel = switchPanel;
            $scope.loadUserGradeData = loadUserGradeData;

            $scope.$watch(function () {
                return $location.path();
            }, function (nval, oval) {
                load(nval);
            });

            function _init_() {
                $scope.data = ptUnderwriting.create(); 
                $scope.bble = "";
                $scope.isComparables = false;
                $('.affix-top').affix({ offset: { top: 148 } });
            }
            function bindData(data) {
                if (data) {
                    $scope.data.gradeData = data;
                    $scope.data.Grade = $scope.data.gradeData.Grade;
                    $scope.data.PropertyInfo = $scope.data.gradeData.PropertyInfo;
                    $scope.data.RehabInfo = $scope.data.gradeData.RehabInfo;
                    $scope.data.LienInfo = $scope.data.gradeData.LienInfo;
                    $scope.data.LienCosts = $scope.data.gradeData.LienCosts;
                    $scope.data.RentalInfo = $scope.data.gradeData.RentalInfo;
                    $scope.data.MinimumBaselineScenario = $scope.data.gradeData.MinimumBaselineScenario;
                    $scope.data.BestCaseScenario = $scope.data.gradeData.BestCaseScenario;
                    $scope.data.Summary = $scope.data.gradeData.Summary;
                    $scope.data.CashScenario = $scope.data.gradeData.CashScenario;
                    $scope.data.LoanScenario = $scope.data.gradeData.LoanScenario;
                    $scope.data.FlipScenario = $scope.data.gradeData.FlipScenario;
                    $scope.data.RentalModel = $scope.data.gradeData.RentalModel;
                }
            }
            function load(pathVal) {
                if (pathVal == null || pathVal == "") {
                    _init_();
                } else {
                    _init_();
                    parts = pathVal.split('/')
                    $scope.bble = parts[1];
                    $scope.offerId = parts[2];
                    UserGradeDataService.get($scope.offerId)
                        .then(function (d) {
                            if(d && d.data){
                                $scope.redqGradeDataString = d.data.gradeDataString;
                                bindData(angular.fromJson(d.data.gradeDataString));
                            }
                        }, onError)
                    getUserGradeDataList($scope.bble);
                }

            }
            function onError(e) {
                console.log(e);
            }
            function switchPanel(id) {
                $scope.panelState = id;
            }
            function getUserGradeDataList(bble) {
                UserGradeDataService
                    .getList(bble)
                    .then(function (resp) {
                        $scope.userGradeDataList = resp.data;
                    })
            }
            function getAllLatestUserGradeData(username) {
                UserGradeDataService
                    .getLatest(username)
                    .then(function (resp) {
                        $scope.allLatestUserGradeData = resp.data;
                    })
            }

            /**
             * Load json data from local usergradedata list
             * @param {any} id
             */
            function loadUserGradeData(id) {
                var filtered = _.filter($scope.userGradeDataList, function (d) { return d.id == id })
                $scope.loadedUserGradeData = filtered[0];
                if (filtered[0] && filtered[0].gradeDataString) {
                    var gradeData = angular.fromJson(filtered[0].gradeDataString);
                    bindData(gradeData);
                }
                $scope.form.title = $scope.loadedUserGradeData.title;
                $scope.form.offer = $scope.loadedUserGradeData.offerPrice;
                $scope.form.comments = $scope.loadedUserGradeData.comments;

                $scope.isLoadedOpinion = true;
                $("#grading-modal").modal('hide');
            }

            function showUserGradeDataList() {
                $scope.modalTitle = "Opinion List";
                $scope.modalMode = 1;
                $("#grading-modal").modal('show');
            }
            function showCreateUserGradeData() {
                $scope.modalTitle = "Create My Opinion"
                $scope.modalMode = 0;
                $("#grading-modal").modal('show');
            }
            function onError(e) {
                ptCom.alert(e, 'warning')
            }


        }]);