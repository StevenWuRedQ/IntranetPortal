/* global LegalShowAll */
/* global angular */
angular.module('PortalApp').controller('LegalCtrl', ['$scope', '$http', 'ptContactServices', 'ptCom', 'ptTime', '$window', function ($scope, $http, ptContactServices, ptCom, ptTime, $window) {

    $scope.ptContactServices = ptContactServices;
    $scope.ptCom = ptCom;
    $scope.isPassByDays = ptTime.isPassByDays;
    $scope.isPassOrEqualByDays = ptTime.isPassOrEqualByDays;
    $scope.isLessOrEqualByDays = ptTime.isLessOrEqualByDays;
    $scope.isPassByMonths = ptTime.isPassByMonths;
    $scope.isPassOrEqualByMonths = ptTime.isPassOrEqualByMonths;

    $scope.LegalCase = {
        PropertyInfo: {},
        ForeclosureInfo: {
            PlaintiffId: 638
        },
        SecondaryInfo: {
            StatuteOfLimitations: [],
        },
        PreQuestions: {},
        SecondaryTypes: []
    };
    $scope.TestRepeatData = [];
    $scope.History = [];
    $scope.SecondaryTypeSource = ["Statute Of Limitations", "Estate", "Miscellaneous", "Deed Reversal", "Partition", "Breach of Contract", "Quiet Title", ""];
    if (typeof LegalShowAll == 'undefined' || LegalShowAll == null) {
        $scope.LegalCase.SecondaryInfo.SelectTypes = $scope.SecondaryTypeSource;
    }

    $scope.filterSelected = true;
    $scope.PickedContactId = null;

    $scope.hSummery = [
                {
                    "Name": "CaseStauts",
                    "CallFunc": "HighLightStauts(LegalCase.CaseStauts,4)",
                    "Description": "Last milestone document recorded on Clerk Minutes after O/REF. ",
                    "ArrayName": ""
                },
                {
                    "Name": "EveryOneIn",
                    "CallFunc": "LegalCase.ForeclosureInfo.WasEstateFormed != null",
                    "Description": "There is an estate.",
                    "ArrayName": ""
                },
                {
                    "Name": "BankruptcyFiled",
                    "CallFunc": "LegalCase.ForeclosureInfo.BankruptcyFiled == true",
                    "Description": "Bankruptcy filed",
                    "ArrayName": ""
                },
                {
                    "Name": "Efile",
                    "CallFunc": "LegalCase.ForeclosureInfo.Efile == true",
                    "Description": "Has E-filed",
                    "ArrayName": ""
                },
                {
                    "Name": "EfileN",
                    "CallFunc": "LegalCase.ForeclosureInfo.Efile == false",
                    "Description": "No E-filed",
                    "ArrayName": ""
                },
                {
                    "Name": "ClientPersonallyServed",
                    "CallFunc": "false",
                    "Description": "Client personally is not served. ",
                    "ArrayName": "AffidavitOfServices"
                },
                {
                    "Name": "NailAndMail",
                    "CallFunc": "true",
                    "Description": "Nail and Mail.",
                    "ArrayName": "AffidavitOfServices"
                },
                {
                    "Name": "BorrowerLiveInAddrAtTimeServ",
                    "CallFunc": "false",
                    "Description": "Borrower didn\'t live in service Address at time of Serv.",
                    "ArrayName": "AffidavitOfServices"
                },
                {
                    "Name": "BorrowerEverLiveHere",
                    "CallFunc": "false",
                    "Description": "Borrower didn\'t ever live in service address.",
                    "ArrayName": "AffidavitOfServices"
                },
                {
                    "Name": "ServerInSererList",
                    "CallFunc": "true",
                    "Description": "process server is in server list.",
                    "ArrayName": "AffidavitOfServices"
                },
                {
                    "Name": "isServerHasNegativeInfo",
                    "CallFunc": "true",
                    "Description": "Web search provide any negative information on process server. ",
                    "ArrayName": "AffidavitOfServices"
                },
                {
                    "Name": "AffidavitServiceFiledIn20Day",
                    "CallFunc": "false",
                    "Description": "Affidavit of service wasn\'t file within 20 days of service.",
                    "ArrayName": "AffidavitOfServices"
                },
                {
                    "Name": "AnswerClientFiledBefore",
                    "CallFunc": "LegalCase.ForeclosureInfo.AnswerClientFiledBefore == false",
                    "Description": "Client hasn\'t ever filed an answer before.",
                    "ArrayName": ""
                },
                {
                    "Name": "NoteIsPossess",
                    "CallFunc": "LegalCase.ForeclosureInfo.NoteIsPossess == false",
                    "Description": "We Don't possess a copy of the note.",
                    "ArrayName": ""
                },
                {
                    "Name": "NoteEndoresed",
                    "CallFunc": "LegalCase.ForeclosureInfo.NoteEndoresed == false",
                    "Description": "Note wasn\'t endores.",
                    "ArrayName": ""
                },
                {
                    "Name": "NoteEndorserIsSignors",
                    "CallFunc": "LegalCase.ForeclosureInfo.NoteEndorserIsSignors == true",
                    "Description": "The endorser is in signors list.",
                    "ArrayName": ""
                },
                {
                    "Name": "HasDocDraftedByDOCXLLC",
                    "CallFunc": "true",
                    "Description": "There are documents drafted by DOCX LLC .",
                    "ArrayName": "Assignments"
                },
                {
                    "Name": "LisPendesRegDate",
                    "CallFunc": "isPassOrEqualByDays(LegalCase.ForeclosureInfo.LisPendesDate, LegalCase.ForeclosureInfo.LisPendesRegDate, 5)",
                    "Description": "Date of registration 5 days after Lis Pendens letter",
                    "ArrayName": ""
                },
                {
                    "Name": "AccelerationLetterMailedDate",
                    "CallFunc": "isPassOrEqualByMonths(LegalCase.ForeclosureInfo.DefaultDate,LegalCase.ForeclosureInfo.AccelerationLetterMailedDate,12 )",
                    "Description": "Acceleration letter mailed to borrower after 12 months of Default Date. ",
                    "ArrayName": ""
                },
                {
                    "Name": "AccelerationLetterRegDate",
                    "CallFunc": "isPassOrEqualByDays(LegalCase.ForeclosureInfo.AccelerationLetterMailedDate,LegalCase.ForeclosureInfo.AccelerationLetterRegDate,3 )",
                    "Description": "Date of registration for Acceleration letter filed  3 days after acceleration letter mailed date",
                    "ArrayName": ""
                },
                {
                    "Name": "AffirmationFiledDate",
                    "CallFunc": "isPassByDays(LegalCase.ForeclosureInfo.JudgementDate,LegalCase.ForeclosureInfo.AffirmationFiledDate,0)",
                    "Description": "Affirmation filed after Judgement. ",
                    "ArrayName": ""
                },
                {
                    "Name": "AffirmationReviewerByCompany",
                    "CallFunc": "LegalCase.ForeclosureInfo.AffirmationReviewerByCompany == false",
                    "Description": "The affirmation reviewer wasn\'t employe by the servicing company. ",
                    "ArrayName": ""
                },
                {
                    "Name": "MortNoteAssInCert",
                    "CallFunc": "LegalCase.ForeclosureInfo.MortNoteAssInCert == false",
                    "Description": "In the Certificate of Merit, the Mortgage, Note and Assignment aren\'t included. ",
                    "ArrayName": ""
                },
                {
                    "Name": "MissInCert",
                    "CallFunc": "checkMissInCertValue()",
                    "Description": "Mortgage Note or Assignment are missing. ",
                    "ArrayName": ""
                },
                {
                    "Name": "CertificateReviewerByCompany",
                    "CallFunc": "LegalCase.ForeclosureInfo.CertificateReviewerByCompany == false",
                    "Description": "The certificate  reviewer wasn\'t employe by the servicing company. ",
                    "ArrayName": ""
                },
                {
                    "Name": "LegalCase.ItemsRedacted",
                    "CallFunc": "LegalCase.ForeclosureInfo.ItemsRedacted == false",
                    "Description": "Are items of personal information Redacted.",
                    "ArrayName": ""
                },
                {
                    "Name": "RJIDate",
                    "CallFunc": "isPassByMonths(LegalCase.ForeclosureInfo.SAndCFiledDate, LegalCase.ForeclosureInfo.RJIDate, 12)",
                    "Description": "RJI filed after 12 months of S&C.",
                    "ArrayName": ""
                },
                {
                    "Name": "ConferenceDate",
                    "CallFunc": "isLessOrEqualByDays(LegalCase.ForeclosureInfo.RJIDate, LegalCase.ForeclosureInfo.ConferenceDate, 60)",
                    "Description": "Conference date scheduled 60 days before RJI",
                    "ArrayName": ""
                },
                {
                    "Name": "OREFDate",
                    "CallFunc": "isPassByMonths(LegalCase.ForeclosureInfo.RJIDate, LegalCase.ForeclosureInfo.OREFDate, 12)",
                    "Description": "O/REF filed after 12 months after RJI.",
                    "ArrayName": ""
                },
                {
                    "Name": "JudgementDate",
                    "CallFunc": "isPassByMonths(LegalCase.ForeclosureInfo.RJIDate, LegalCase.ForeclosureInfo.OREFDate, 12)",
                    "Description": "Judgement submitted 12 months after O/REF. ",
                    "ArrayName": ""
                }];

    $scope.querySearch = function (query) {
        var createFilterFor = function (query) {
            var lowercaseQuery = angular.lowercase(query);
            return function filterFn(contact) {
                return contact.Name && (contact.Name.toLowerCase().indexOf(lowercaseQuery) !== -1);
            };
        }
        var results = query ?
            $scope.allContacts.filter(createFilterFor(query)) : [];
        return results;
    }
    $scope.loadContacts = function () {
        var contacts = AllContact ? AllContact : [];
        return contacts.map(function (c, index) {
            c.image = 'https://storage.googleapis.com/material-icons/external-assets/v1/icons/svg/ic_account_circle_black_48px.svg';
            if (c.Name) {
                c._lowername = c.Name.toLowerCase();
            }
            return c;
        });
    };
    $scope.allContacts = $scope.loadContacts();
    $scope.contacts = [$scope.allContacts[0]];
    $scope.AllJudges = AllJudges ? AllJudges : [];

    $scope.addTest = function () {
        $scope.TestRepeatData[$scope.TestRepeatData.length] = $scope.TestRepeatData.length;
    };

    $scope.RoboSingerDataSource = new DevExpress.data.DataSource({
        store: new DevExpress.data.CustomStore({
            load: function (loadOptions) {
                if (AllRoboSignor) {
                    if (loadOptions.searchValue) {
                        return AllRoboSignor.filter(function (o) { if (o.Name) { return o.Name.toLowerCase().indexOf(loadOptions.searchValue.toLowerCase()) >= 0 } return false });
                    }
                    return [];
                }
            },
            byKey: function (key) {
                if (AllRoboSignor) {
                    return AllRoboSignor.filter(function (o) { return o.ContactId == key })[0];
                }

            },
            searchExpr: ["Name"]
        })
    });
    $scope.InitContact = function (id, dataSourceName) {
        return {
            dataSource: dataSourceName ? $scope[dataSourceName] : $scope.ContactDataSource,
            valueExpr: 'ContactId',
            displayExpr: 'Name',
            searchEnabled: true,
            minSearchLength: 2,
            noDataText: "Please input to search",
            bindingOptions: { value: id }
        }
    };
    $scope.TestContactId = function (c) {
        $scope.$eval(c + '=' + '192');
    };
    $scope.GetContactById = function (id) {
        return AllContact.filter(function (o) { return o.ContactId == id })[0];
    };

    $scope.CheckPlace = function (p) {
        if (p) {
            return p === 'NY';
        }
        return false;
    };

    $scope.SaveLegal = function (scuessfunc) {
        if (!LegalCaseBBLE || LegalCaseBBLE !== leadsInfoBBLE) {
            alert("Case not load completed please wait!");
            return;
        }
        var json = JSON.stringify($scope.LegalCase);
        var data = { bble: LegalCaseBBLE, caseData: json };
        $http.post('LegalUI.aspx/SaveCaseData', data).
            success(function () {
                if (scuessfunc) {
                    scuessfunc()
                } else {
                    $scope.LogSaveChange();
                    alert("Save Successed !");
                }
                ResetCaseDataChange();
            }).
            error(function (data, status) {
                alert("Fail to save data. status " + status + "Error : " + JSON.stringify(data));
            });
    };

    $scope.CompleteResearch = function () {
        var json = JSON.stringify($scope.LegalCase);
        var data = { bble: leadsInfoBBLE, caseData: json, sn: taskSN };
        $http.post('LegalUI.aspx/CompleteResearch', data).success(function () {
            alert("Submit Success!");
            if (typeof gridTrackingClient !== 'undefined')
                gridTrackingClient.Refresh();

        }).error(function (data) {
            alert("Fail to save data :" + JSON.stringify(data));
            console.log(data);
        });
    }

    $scope.BackToResearch = function (comments) {
        var json = JSON.stringify($scope.LegalCase);

        var data = { bble: leadsInfoBBLE, caseData: json, sn: taskSN, comments: comments };
        $http.post('LegalUI.aspx/BackToResearch', data).
            success(function () {
                alert("Submit Success!");
                if (typeof gridTrackingClient !== 'undefined')
                    gridTrackingClient.Refresh();
            }).error(function (data1) {
                alert("Fail to save data :" + JSON.stringify(data1));
                console.log(data1);
            });
    }

    $scope.CloseCase = function (comments) {
        var data = { bble: leadsInfoBBLE, comments: comments };
        $http.post('LegalUI.aspx/CloseCase', data).
            success(function () {
                alert("Submit Success!");
                if (typeof gridTrackingClient !== 'undefined')
                    gridTrackingClient.Refresh();

            }).error(function (data) {
                alert("Fail to save data :" + JSON.stringify(data));
                console.log(data);
            });
    }

    $scope.AttorneyComplete = function () {
        var json = JSON.stringify($scope.LegalCase);

        var data = { bble: leadsInfoBBLE, caseData: json, sn: taskSN };
        $http.post('LegalUI.aspx/AttorneyComplete', data).
            success(function () {
                alert("Submit Success!");
                if (typeof gridTrackingClient !== 'undefined')
                    gridTrackingClient.Refresh();

            }).
            error(function () {
                alert("Fail to save data.");
            });

    }


    $scope.LogSaveChange = function () {
        for (var i in $scope.LogChange) {
            var changeObject = $scope.LogChange[i];
            var old = changeObject.old;
            var now = changeObject.now()
            if (old != now) {
                var elem = '#LealCaseStatusData'
                var OldStatus = $(elem + ' option[value="' + old + '"]').html();
                var NowStatus = $(elem + ' option[value="' + now + '"]').html();

                if (!OldStatus) {
                    AddActivityLog(changeObject.msg.replace(" from", '') + ' to ' + NowStatus);
                }
                else {
                    AddActivityLog(changeObject.msg + OldStatus + ' to ' + NowStatus);
                }

                $scope.LogChange[i].old = now;
            }
        }
    }

    $scope.LoadLeadsCase = function (BBLE) {
        ptCom.startLoading();
        var data = { bble: BBLE };
        var leadsInfoUrl = "/ShortSale/ShortSaleServices.svc/GetLeadsInfo?bble=" + BBLE;
        var shortsaleUrl = '/ShortSale/ShortSaleServices.svc/GetCaseByBBLE?bble=' + BBLE;
        var taxlienUrl = '/api/TaxLiens/' + BBLE;
        var legalecoursUrl = "/api/LegalECourtByBBLE/" + BBLE;

        $http.post('LegalUI.aspx/GetCaseData', data).
            success(function (data, status, headers, config) {
                $scope.LegalCase = $.parseJSON(data.d);
                $scope.LegalCase.BBLE = BBLE
                $scope.LegalCase.LegalComments = $scope.LegalCase.LegalComments || [];
                $scope.LegalCase.ForeclosureInfo = $scope.LegalCase.ForeclosureInfo || {};
                $scope.LogChange = {
                    'TaxLienFCStatus': { "old": $scope.LegalCase.TaxLienFCStatus, "now": function () { return $scope.LegalCase.TaxLienFCStatus; }, "msg": 'Tax Lien FC status changed from ' },
                    'CaseStauts': { "old": $scope.LegalCase.CaseStauts, "now": function () { return $scope.LegalCase.CaseStauts; }, "msg": 'Mortgage foreclosure status changed from ' }
                }

                var arrays = ["AffidavitOfServices", "Assignments", "MembersOfEstate"];
                for (a in arrays) {
                    var porp = arrays[a]
                    var array = $scope.LegalCase.ForeclosureInfo[porp];
                    if (!array || array.length === 0) {
                        $scope.LegalCase.ForeclosureInfo[porp] = [];
                        $scope.LegalCase.ForeclosureInfo[porp].push({});
                    }
                }
                $scope.LegalCase.SecondaryTypes = $scope.LegalCase.SecondaryTypes || []
                $scope.showSAndCFrom();

                LegalCaseBBLE = BBLE;
                ptCom.stopLoading();

                ResetCaseDataChange();
                CaseNeedComment = true;
            }).
            error(function () {
                ptCom.stopLoading();
                alert("Fail to load data : " + BBLE);
            });


        $http.get(shortsaleUrl)
            .success(function (data) {
                $scope.ShortSaleCase = data;
            }).error(function () {
                alert("Fail to Short sale case  data : " + BBLE);
            });



        $http.get(leadsInfoUrl)
            .success(function (data) {
                $scope.LeadsInfo = data;
                $scope.LPShow = $scope.ModelArray('LeadsInfo.LisPens');
            }).error(function (data) {
                alert("Get Short Sale Leads failed BBLE =" + BBLE + " error : " + JSON.stringify(data));
            });

        $http.get(taxlienUrl)
            .success(function (data) {
                $scope.TaxLiens = data;
                $scope.TaxLiensShow = $scope.ModelArray('TaxLiens');
            }).error(function (data) {
                alert("Get Tax Liens failed BBLE = " + BBLE + " error : " + JSON.stringify(data));
            });

        $http.get(legalecoursUrl)
            .success(function (data) {
                $scope.LegalECourt = data;
            }).error(function () {
                $scope.LegalECourt = null;
            });

    }

    $scope.ModelArray = function (model) {
        var array = $scope.$eval(model);
        return (array && array.length > 0) ? 'Yes' : '';
    }

    // return true it hight light check date  
    $scope.HighLightFunc = function (funcStr) {
        var args = funcStr.split(",");

    }

    $scope.AddSecondaryArray = function () {
        var selectType = $scope.LegalCase.SecondaryInfo.SelectedType;
        if (selectType) {
            var name = selectType.replace(/\s/g, '');
            var arr = $scope.LegalCase.SecondaryInfo[name];
            if (name === 'StatuteOfLimitations') {
                alert('match');
            }
            if (!arr || !Array.isArray($scope.LegalCase.SecondaryInfo[name])) {
                $scope.LegalCase.SecondaryInfo[name] = [];
                //arr = $scope.LegalCase.SecondaryInfo[name];
            }
            $scope.LegalCase.SecondaryInfo[name].push({});
            //$scope.LegalCase.SecondaryInfo.StatuteOfLimitations.push({});
        }
    }
    $scope.LegalCase.SecondaryInfo.SelectedType = $scope.SecondaryTypeSource[0];
    $scope.SecondarySelectType = function () {
        $scope.LegalCase.SecondaryInfo.SelectTypes = $scope.LegalCase.SecondaryInfo.SelectTypes || [];
        var selectTypes = $scope.LegalCase.SecondaryInfo.SelectTypes;
        if (!_.contains(selectTypes, $scope.LegalCase.SecondaryInfo.SelectedType)) {
            selectTypes.push($scope.LegalCase.SecondaryInfo.SelectedType);
        }

    }
    $scope.CheckShow = function (filed) {
        if (typeof LegalShowAll === 'undefined' || LegalShowAll === null) {
            return true;
        }
        if ($scope.LegalCase.SecondaryInfo) {
            return $scope.LegalCase.SecondaryInfo.SelectedType == filed;
        }

        return false;
    }

    $scope.SaveLegalJson = function () {
        $scope.LegalCaseJson = JSON.stringify($scope.LegalCase)
    }

    $scope.ShowContorl = function (m) {
        var t = typeof m;
        if (t === "string") {
            return m === 'true'
        }
        return m;

    }

    $scope.DocGenerator = function (tplName) {
        if (!$scope.LegalCase.SecondaryInfo) {
            $scope.LegalCase.SecondaryInfo = {}
        }
        var Tpls = [{
            "tplName": 'OSCTemplate.docx',
            data: {
                "Plantiff": $scope.LegalCase.ForeclosureInfo.Plantiff,
                "PlantiffAttorney": $scope.LegalCase.ForeclosureInfo.PlantiffAttorney,
                "PlantiffAttorneyAddress": $scope.LegalCase.ForeclosureInfo.PlantiffAttorneyAddress,//ptContactServices.getContact($scope.LegalCase.ForeclosureInfo.PlantiffAttorneyId, $scope.LegalCase.ForeclosureInfo.PlantiffAttorney).Address,
                "FCFiledDate": $scope.LegalCase.ForeclosureInfo.FCFiledDate,
                "FCIndexNum": $scope.LegalCase.ForeclosureInfo.FCIndexNum,
                "BoroughName": $scope.LeadsInfo.BoroughName,
                "Block": $scope.LeadsInfo.Block,
                "Lot": $scope.LeadsInfo.Lot,
                "Defendant": $scope.LegalCase.SecondaryInfo.Defendant,

                "Defendants": $scope.LegalCase.SecondaryInfo.OSC_Defendants ? ',' + $scope.LegalCase.SecondaryInfo.OSC_Defendants.map(function (o) { return o.Name }).join(",") : ' ',
                "DefendantAttorneyName": $scope.LegalCase.SecondaryInfo.DefendantAttorneyName,
                "DefendantAttorneyPhone": ptContactServices.getContact($scope.LegalCase.SecondaryInfo.DefendantAttorneyId, $scope.LegalCase.SecondaryInfo.DefendantAttorneyName).OfficeNO,
                "DefendantAttorneyAddress": ptContactServices.getContact($scope.LegalCase.SecondaryInfo.DefendantAttorneyId, $scope.LegalCase.SecondaryInfo.DefendantAttorneyName).Address,
                "CourtAddress": $scope.GetCourtAddress($scope.LeadsInfo.Borough),
                "PropertyAddress": $scope.LeadsInfo.PropertyAddress,

            }
        },
        {
            "tplName": 'DeedReversionTemplate.docx',
            data: {
                "Plantiff": $scope.LegalCase.SecondaryInfo.DeedReversionPlantiff,
                "PlantiffAttorney": $scope.LegalCase.SecondaryInfo.DeedReversionPlantiffAttorney,
                "PlantiffAttorneyAddress": $scope.ptContactServices.getContact($scope.LegalCase.SecondaryInfo.DeedReversionPlantiffAttorneyId, $scope.LegalCase.SecondaryInfo.DeedReversionPlantiffAttorney).Address,
                "PlantiffAttorneyPhone": $scope.ptContactServices.getContact($scope.LegalCase.SecondaryInfo.DeedReversionPlantiffAttorneyId, $scope.LegalCase.SecondaryInfo.DeedReversionPlantiffAttorney).OfficeNO,
                "IndexNum": $scope.LegalCase.SecondaryInfo.DeedReversionIndexNum || ' ',
                "BoroughName": $scope.LeadsInfo.BoroughName,
                "Block": $scope.LeadsInfo.Block,
                "Lot": $scope.LeadsInfo.Lot,
                "Defendant": $scope.LegalCase.SecondaryInfo.DeedReversionDefendant,
                "Defendants": $scope.LegalCase.SecondaryInfo.DeedReversionDefendants ? ',' + $scope.LegalCase.SecondaryInfo.DeedReversionDefendants.map(function (o) { return o.Name }).join(",") : ' ',
                "CourtAddress": $scope.GetCourtAddress($scope.LeadsInfo.Borough),
                "PropertyAddress": $scope.LeadsInfo.PropertyAddress,

            },


        },
        {
            "tplName": 'SpecificPerformanceComplaintTemplate.docx',
            data: {
                "Plantiff": $scope.LegalCase.SecondaryInfo.SPComplaint_Plantiff,
                "PlantiffAttorney": $scope.LegalCase.SecondaryInfo.SPComplaint_PlantiffAttorney,
                "PlantiffAttorneyAddress": $scope.ptContactServices.getContact($scope.LegalCase.SecondaryInfo.SPComplaint_PlantiffAttorneyId, $scope.LegalCase.SecondaryInfo.SPComplaint_PlantiffAttorney).Address,
                "PlantiffAttorneyPhone": $scope.ptContactServices.getContact($scope.LegalCase.SecondaryInfo.SPComplaint_PlantiffAttorneyId, $scope.LegalCase.SecondaryInfo.SPComplaint_PlantiffAttorney).OfficeNO,
                "IndexNum": $scope.LegalCase.SecondaryInfo.SPComplaint_IndexNum || ' ',
                "BoroughName": $scope.LeadsInfo.BoroughName,
                "Block": $scope.LeadsInfo.Block,
                "Lot": $scope.LeadsInfo.Lot,
                "Defendant": $scope.LegalCase.SecondaryInfo.SPComplaint_Defendant,
                "Defendants": $scope.LegalCase.SecondaryInfo.SPComplaint_Defendants ? ',' + $scope.LegalCase.SecondaryInfo.SPComplaint_Defendants.map(function (o) { return o.Name }).join(",") : ' ',
                "CourtAddress": $scope.GetCourtAddress($scope.LeadsInfo.Borough),
                "PropertyAddress": $scope.LeadsInfo.PropertyAddress,
            },

        },
        {
            "tplName": 'QuietTitleComplantTemplate.docx',
            data: {
                "Plantiff": $scope.LegalCase.SecondaryInfo.QTA_Plantiff,
                "PlantiffAttorney": $scope.LegalCase.SecondaryInfo.QTA_PlantiffAttorney,
                "PlantiffAttorneyAddress": $scope.ptContactServices.getContact($scope.LegalCase.SecondaryInfo.QTA_PlantiffAttorneyId, $scope.LegalCase.SecondaryInfo.QTA_PlantiffAttorney).Address,
                "PlantiffAttorneyPhone": $scope.ptContactServices.getContact($scope.LegalCase.SecondaryInfo.QTA_PlantiffAttorneyId, $scope.LegalCase.SecondaryInfo.QTA_PlantiffAttorney).OfficeNO,
                "OriginalMortgageLender": $scope.LegalCase.SecondaryInfo.QTA_OrgMorgLender,
                "Mortgagee": $scope.LegalCase.SecondaryInfo.QTA_Mortgagee,
                "IndexNum": $scope.LegalCase.SecondaryInfo.QTA_IndexNum || ' ',
                "BoroughName": $scope.LeadsInfo.BoroughName,
                "Block": $scope.LeadsInfo.Block,
                "Lot": $scope.LeadsInfo.Lot,
                "Defendant": $scope.LegalCase.SecondaryInfo.QTA_Defendant,
                "Defendant2": $scope.LegalCase.SecondaryInfo.QTA_Defendant2,
                "Defendants": $scope.LegalCase.SecondaryInfo.QTA_Defendants ? ',' + $scope.LegalCase.SecondaryInfo.QTA_Defendants.map(function (o) { return o.Name }).join(",") : ' ',
                "CourtAddress": $scope.GetCourtAddress($scope.LeadsInfo.Borough),
                "PropertyAddress": $scope.LeadsInfo.PropertyAddress,
                "FCFiledDate": $scope.LegalCase.ForeclosureInfo.FCFiledDate,
                "FCIndexNum": $scope.LegalCase.ForeclosureInfo.FCIndexNum,
                "DefaultDate": $scope.LegalCase.ForeclosureInfo.QTA_DefaultDate,
                "DeedToPlaintiffDate": $scope.LegalCase.SecondaryInfo.QTA_DeedToPlaintiffDate,
            },

        },
        {
            "tplName": 'Partition_Temp.docx',
            data: {
                "Plantiff": $scope.LegalCase.SecondaryInfo.PartitionsPlantiff,
                "PlantiffAttorney": $scope.LegalCase.SecondaryInfo.PartitionsPlantiffAttorney,
                "PlantiffAttorneyAddress": $scope.ptContactServices.getContact($scope.LegalCase.SecondaryInfo.PartitionsPlantiffAttorneyId, $scope.LegalCase.SecondaryInfo.PartitionsPlantiffAttorney).Address,
                "PlantiffAttorneyPhone": $scope.ptContactServices.getContact($scope.LegalCase.SecondaryInfo.PartitionsPlantiffAttorneyId, $scope.LegalCase.SecondaryInfo.PartitionsPlantiffAttorney).OfficeNO,
                "OriginalMortgageLender": $scope.LegalCase.SecondaryInfo.PartitionsOriginalLender,
                "MortgageDate": $scope.LegalCase.SecondaryInfo.PartitionsMortgageDate,
                "IndexNum": $scope.LegalCase.SecondaryInfo.PartitionsIndexNum || ' ',
                "BoroughName": $scope.LeadsInfo.BoroughName,
                "Block": $scope.LeadsInfo.Block,
                "Lot": $scope.LeadsInfo.Lot,
                "Defendant": $scope.LegalCase.SecondaryInfo.PartitionsDefendant,
                "Defendant1": $scope.LegalCase.SecondaryInfo.PartitionsDefendant1,

                "PropertyAddress": $scope.LeadsInfo.PropertyAddress,
                "MortgageAmount": $scope.LegalCase.SecondaryInfo.PartitionsMortgageAmount,
                "DateOfRecording": $scope.LegalCase.SecondaryInfo.PartitionsDateOfRecording,
                "CRFN": $scope.LegalCase.SecondaryInfo.PartitionsCRFN,
                "OriginalLender": $scope.LegalCase.SecondaryInfo.PartitionsOriginalLender,


            },

        }
        ];
        var tpl = Tpls.filter(function (o) { return o.tplName == tplName })[0]

        if (tpl) {
            for (var v in tpl.data) {
                var filed = tpl.data[v];
                if (!filed) {
                    alert("Some data missing please check " + v + "Please check!")
                    return;
                }
            }
            ptCom.DocGenerator(tpl.tplName, tpl.data, function (url) {
                //window.open(url,'blank');
                STDownloadFile(url, tpl.tplName.replace("Template", ""));
            });
        } else {
            alert("can find tlp " + tplName)
        }
    }

    $scope.CheckSecondaryTags = function (tag) {
        return $scope.LegalCase.SecondaryTypes.filter(function (t) { return t == tag })[0];
    }
    $scope.GetCourtAddress = function (boro) {
        var address = ['', '851 Grand Concourse Bronx, NY 10451', '360 Adams St. Brooklyn, NY 11201', '8811 Sutphin Boulevard, Jamaica, NY 11435'];
        return address[boro - 1];
    }

    $scope.evalVisible = function (h) {
        var result = false;
        if (h.ArrayName) {
            if ($scope.LegalCase.ForeclosureInfo[h.ArrayName]) {
                angular.forEach($scope.LegalCase.ForeclosureInfo[h.ArrayName], function (el, idx) {
                    result = result || (el[h.Name] == (h.CallFunc === 'true'));
                })
            }
        } else {
            result = $scope.$eval(h.CallFunc);
        }
        return result;
    };

    angular.forEach($scope.hSummery, function (el, idx) {
        $scope.$watch(function () { return $scope.evalVisible(el); }, function (newV) {
            el.visible = newV;
        })

    })

    $scope.GetCaseInfo = function () {
        var CaseInfo = { Name: '', Address: '' }
        var caseName = $scope.LegalCase.CaseName
        if (caseName) {
            CaseInfo.Address = caseName.replace(/-(?!.*-).*$/, '');
            var matched = caseName.match(/-(?!.*-).*$/);
            if (matched && matched[0]) {
                CaseInfo.Name = matched[0].replace('-', '')
            }
        }
        return CaseInfo;
    }

    $scope.AddArrayItem = function (model) {
        model = model || [];
        model.push({});
    }
    $scope.DeleteItem = function (model, index) {
        model.splice(index, 1);
    }

    $scope.isLess08292013 = false;
    $scope.isBigger08302013 = false;
    $scope.isBigger03012015 = false;
    $scope.showSAndCFormFlag = false;

    $scope.showSAndCFrom = function () {
        var date = new Date($scope.LegalCase.ForeclosureInfo.SAndCFiledDate);
        if (date - new Date("08/29/2013") > 0) {
            $scope.isLess08292013 = false;
        } else {
            $scope.isLess08292013 = true;
        }
        if ($scope.isLess08292013) {
            $scope.isBigger08302013 = false;
        } else {
            $scope.isBigger08302013 = true;
        } if (date - new Date("03/01/2015") > 0) {
            $scope.isBigger03012015 = true;
        } else {
            $scope.isBigger03012015 = false;
        }
        $scope.showSAndCFormFlag = $scope.isLess08292013 | $scope.isBigger08302013 | $scope.isBigger03012015;
    };
    $scope.HighLightStauts = function (model, index) {
        return parseInt(model) > index ? true : false;
    };
    $scope.addToEstateMembers = function (index) {
        $scope.LegalCase.ForeclosureInfo.MembersOfEstate.push({ "id": index, "name": $scope.LegalCase.membersText });
        $scope.LegalCase.membersText = '';
    }
    $scope.delEstateMembers = function (index) {
        $scope.LegalCase.ForeclosureInfo.MembersOfEstate.splice(index, 1);
    }
    $scope.ShowECourts = function (borough) {
        $http.post('/CallBackServices.asmx/GetBroughName', { bro: $scope.LegalCase.PropertyInfo.Borough }).success(function (data) {
            var urls = ['http://bronxcountyclerkinfo.com/law/UI/User/lne.aspx', ' http://iapps.courts.state.ny.us/kcco/', ' https://iapps.courts.state.ny.us/qcco/'];
            var url = urls[borough - 2];
            var title = $scope.LegalCase.CaseName;
            var subTitle = ' (' + 'Brough: ' + data.d + ' Block: ' + $scope.LegalCase.PropertyInfo.Block + ' Lot: ' + $scope.LegalCase.PropertyInfo.Lot + ')';
            ShowPopupMap(url, title, subTitle);
        })

    }

    $scope.missingItems = [
        { id: 1, label: "Mortgage" },
        { id: 2, label: "Note" },
        { id: 3, label: "Assignment" },
    ];

    $scope.updateMissInCertValue = function (value) {
        $scope.LegalCase.ForeclosureInfo.MissInCert = value;
    }

    $scope.checkMissInCertValue = function () {
        if ($scope.LegalCase.ForeclosureInfo.MortNoteAssInCert) return false;
        if (!$scope.LegalCase.ForeclosureInfo.MissInCert || $scope.LegalCase.ForeclosureInfo.MissInCert.length == 0)
            return true;
        else return false;
    }

    $scope.initMissInCert = function () {
        return {
            dataSource: $scope.missingItems,
            valueExpr: 'id',
            displayExpr: 'label',
            onValueChanged: function (e) {
                e.model.updateMissInCertValue(e.values);
            }
        };
    }

    $scope.ShowAddPopUp = function (event) {
        $scope.addCommentTxt = "";
        aspxAddLeadsComments.ShowAtElement(event.target);
    }

    $scope.SaveLegalComments = function () {

        $scope.LegalCase.LegalComments.push({ id: $scope.LegalCase.LegalComments.length + 1, Comment: $scope.addCommentTxt });
        $scope.SaveLegal(function () {
            console.log("ADD comments" + $scope.addCommentTxt);
            aspxAddLeadsComments.Hide();
        });
    }

    $scope.DeleteComments = function (index) {
        $scope.LegalCase.LegalComments.splice(index, 1);
        $scope.SaveLegal(function () {
            console.log("Deleted comments");
        });
    }


    $scope.AddActivityLog = function () {
        if (typeof AddActivityLog === "function") {
            AddActivityLog($scope.MustAddedComment);
        }
    }

    $scope.CheckWorkHours = function () {
        $http.get("/api/WorkingLogs/Legal/" + $scope.LegalCase.BBLE).success(function (data) {
            $scope.TotleHours = data;
            $("#WorkPopUp").modal();
        });
    }

    $scope.showHistory = function () {
        var url = "/api/legal/SaveHistories/" + $scope.LegalCase.BBLE;
        $scope.History = [];
        $http.get(url).success(function (data) {
            $scope.History = data;
            $("#HistoryPopup").modal();
        })
    }

    $scope.loadHistoryData = function (logid) {
        if (logid) {
            var url = "/api/Legal/HistoryCaseData/" + logid;
            $http.get(url).success(function (data) {
                $scope.LegalCase = $.parseJSON(data);
                var BBLE = $scope.LegalCase.BBLE;
                if (BBLE) {
                    var leadsInfoUrl = "/ShortSale/ShortSaleServices.svc/GetLeadsInfo?bble=" + BBLE;
                    var shortsaleUrl = '/ShortSale/ShortSaleServices.svc/GetCaseByBBLE?bble=' + BBLE;
                    var taxlienUrl = '/api/TaxLiens/' + BBLE;
                    var legalecoursUrl = "/api/LegalECourtByBBLE/" + BBLE;


                    $scope.LegalCase.LegalComments = $scope.LegalCase.LegalComments || [];
                    $scope.LegalCase.ForeclosureInfo = $scope.LegalCase.ForeclosureInfo || {};
                    $scope.LogChange = {
                        'TaxLienFCStatus': { "old": $scope.LegalCase.TaxLienFCStatus, "now": function () { return $scope.LegalCase.TaxLienFCStatus; }, "msg": 'Tax Lien FC Status changed from ' },
                        'CaseStauts': { "old": $scope.LegalCase.CaseStauts, "now": function () { return $scope.LegalCase.CaseStauts; }, "msg": 'Mortgae foreclosure Status changed from ' }
                    }
                    var arrays = ["AffidavitOfServices", "Assignments", "MembersOfEstate"];
                    for (a in arrays) {
                        var porp = arrays[a]
                        var array = $scope.LegalCase.ForeclosureInfo[porp];
                        if (!array || array.length === 0) {
                            $scope.LegalCase.ForeclosureInfo[porp] = [];
                            $scope.LegalCase.ForeclosureInfo[porp].push({});
                        }
                    }
                    $scope.LegalCase.SecondaryTypes = $scope.LegalCase.SecondaryTypes || []
                    $scope.showSAndCFrom();

                    $http.get(shortsaleUrl)
                        .success(function (data) {
                            $scope.ShortSaleCase = data;
                        }).error(function () {
                            alert("Fail to Short sale case  data : " + BBLE);
                        });



                    $http.get(leadsInfoUrl)
                        .success(function (data) {
                            $scope.LeadsInfo = data;
                            $scope.LPShow = $scope.ModelArray('LeadsInfo.LisPens');
                        }).error(function (data) {
                            alert("Get Short Sale Leads failed BBLE =" + BBLE + " error : " + JSON.stringify(data));
                        });

                    $http.get(taxlienUrl)
                        .success(function (data) {
                            $scope.TaxLiens = data;
                            $scope.TaxLiensShow = $scope.ModelArray('TaxLiens');
                        }).error(function (data) {
                            alert("Get Tax Liens failed BBLE = " + BBLE + " error : " + JSON.stringify(data));
                        });

                    $http.get(legalecoursUrl)
                        .success(function (data) {
                            $scope.LegalECourt = data;
                        }).error(function () {
                            $scope.LegalECourt = null;
                        });

                    LegalCaseBBLE = BBLE;
                }
            }).error(function () {
                alert("Fail to load data : ");
            });

        }


    }

    $scope.openHistoryWindow = function (logid) {
        $window.open('/LegalUI/Legalinfo.aspx?logid=' + logid, '_blank', 'width=1024, height=768')
    }
}]);