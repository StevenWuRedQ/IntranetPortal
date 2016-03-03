Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal.Data
Imports System.Web.Http
Imports IntranetPortal
Imports IntranetPortal.RulesEngine

''' <summary>
''' The unit test for legal case object
''' </summary>
<TestClass()> Public Class LegalUnitTest

    Dim bble = "1004490003"

    <TestMethod()> Public Sub DataStatusTest()

        Dim statusList = DataStatu.LoadDataStatus(LegalCase.ForeclosureStatusCategory)
        Assert.IsTrue(statusList.Count > 0)
        Assert.IsFalse(statusList.Any(Function(a) a.Active = False))

        Dim lcase = LegalCase.GetCase(bble)
        Dim dStatu = DataStatu.Instance(LegalCase.ForeclosureStatusCategory, lcase.LegalStatus)
        Assert.AreEqual(lcase.LegalStatusString, dStatu.Name)
        Assert.IsTrue(lcase.LegalStatusString = "Judgment Granted")
    End Sub

    <TestMethod()> Public Sub DataStatusSaveTest()
        Dim dStatu = New DataStatu With {
            .Category = LegalCase.ForeclosureStatusCategory,
            .Status = -1,
            .Name = "Testing",
            .Active = True
            }

        dStatu.Save()

        Assert.IsTrue(dStatu.Status > 0)

        dStatu.Delete()

        Dim instance = DataStatu.Instance(LegalCase.ForeclosureStatusCategory, dStatu.Status)
        Assert.IsNull(instance)
    End Sub

    <TestMethod()> Public Sub DataStatusControllerTest()
        Dim controller = New IntranetPortal.Controllers.LegalController
        Dim status = controller.GetForeclosureStatus()
        Assert.IsInstanceOfType(status, GetType(IHttpActionResult))
        Assert.IsInstanceOfType(status, GetType(Results.OkNegotiatedContentResult(Of DataStatu())))
        Dim statusArray = CType(status, Results.OkNegotiatedContentResult(Of DataStatu())).Content
        Assert.IsTrue(statusArray.Count > 0)
    End Sub

    <TestMethod()> Public Sub SaveHistoryTest()
        Dim controller = New IntranetPortal.Controllers.LegalController
        Dim history = controller.GetSaveHistories(bble)
        Assert.IsInstanceOfType(history, GetType(IHttpActionResult))
        Assert.IsInstanceOfType(history, GetType(Results.OkNegotiatedContentResult(Of IntranetPortal.Core.SystemLog())))
        Dim logs = CType(history, Results.OkNegotiatedContentResult(Of IntranetPortal.Core.SystemLog())).Content
        Assert.IsTrue(logs.Count > 0)
    End Sub

    <TestMethod()> Public Sub GetSavedHistoryTest()
        Dim controller = New IntranetPortal.Controllers.LegalController
        Dim logs = CType(controller.GetSaveHistories(bble), Results.OkNegotiatedContentResult(Of IntranetPortal.Core.SystemLog())).Content
        Dim history = controller.GetSavedHistory(logs(0).LogId)

        Assert.IsInstanceOfType(history, GetType(IHttpActionResult))
        Dim caseData = CType(history, Results.OkNegotiatedContentResult(Of String)).Content

        Assert.IsTrue(Not String.IsNullOrEmpty(caseData))
        Dim jsCase = Newtonsoft.Json.Linq.JObject.Parse(caseData)
        Assert.AreEqual(jsCase("PropertyInfo")("BBLE").ToString.Trim, bble)

        history = controller.GetSavedHistory(0)
        caseData = CType(history, Results.OkNegotiatedContentResult(Of String)).Content
        Assert.AreEqual("{}", caseData)
    End Sub

    <TestMethod> Public Sub GetCaseOwner_returnOwnerName()
        Dim lcase = LegalCase.GetCase(bble)

        lcase.Attorney = "Chris Yan"
        Assert.AreEqual(lcase.Attorney, LegalCaseManage.GetCaseOwner(bble))
        Assert.AreEqual("Amy Beckwith", LegalCaseManage.GetCaseOwner("2022870021"))
        Assert.IsNull(LegalCaseManage.GetCaseOwner("2022890122"))
        Assert.IsNull(LegalCaseManage.GetCaseOwner("12321321321"))
    End Sub
    <TestMethod> Public Sub GetPassErrorTest()
        Dim index = "123/1234"

        Assert.AreEqual(LegalCase.DeCodeIndexNumber(index), "000123/1234")
        'Dim rule = New NoticeECourtRule()
        'rule.NotifyECourtParseError()

    End Sub

    Private caseData As String = <string>
                                     <![CDATA[
                                     {"PreQuestions":{"PartitionReview":{"RefusingMaintenHome":false,"IsDuringOrPriorMarriage":false,"IsDivorceDecree":false,"IsContract":false,"IsContractViewable":false,"IsOfferMoney":false,"IsFC":false,"IsRefusingWorkout":false,"IsLegal":false},"DeedReversionReview":{"WasDeedTransferred":false,"HasHolderMadeImprovment":false,"WasAttorneyPresent":false,"WasAttorneySignOffDeed":false},"QuietTitleReview":{"IsSignedDeed":false,"RecordSaidDeed":false,"SignQuietTitle":false,"ClientAppliedLoanBefore":false,"ClientRecievedCorrespondence":false},"SpecificReview":{"ShortSaleApproval":false,"haveSaidCheck":false,"EffortGetClientBack":false},"IsTenents":false,"IsTenentsPayRent":false,"IsFCReview":true},"PropertyInfo":{"BBLE":"1020570051 ","IsLisPendens":null,"IsOtherLiens":null,"IsTaxesOwed":null,"IsWaterOwed":null,"IsECBViolations":null,"IsDOBViolations":null,"C1stMotgrAmt":1495000,"C2ndMotgrAmt":null,"TaxesAmt":null,"TaxesOrderStatus":null,"TaxesOrderTime":null,"TaxesOrderDeliveryTime":null,"WaterAmt":null,"WaterOrderStatus":null,"WaterOrderTime":null,"WaterOrderDeliveryTime":null,"ECBViolationsAmt":null,"ECBOrderStatus":null,"ECBOrderTime":null,"ECBOrderDeliveryTime":null,"DOBViolationsAmt":null,"DOBOrderStatus":null,"DOBOrderTime":null,"DOBOrderDeliveryTime":null,"AcrisOrderStatus":null,"AcrisOrderTime":null,"AcrisOrderDeliveryTime":null,"LastPaid":null,"IsCoOnFile":null,"TypeOfCo":null,"Owner":"STALLWORTH, FELICIA","CoOwner":"","Date":null,"PropertyAddress":"464 W 141 ST, Manhattan,NY 10031","SaleDate":"1999-04-29T00:00:00","TaxClass":"1","SaleType":null,"Condition":null,"Block":"2057 ","Lot":"51  ","DOBViolation":null,"Remark1":null,"Remark2":null,"Remark3":null,"Remark4":null,"Deed":null,"LPindex":null,"CreateDate":"2015-03-04T13:39:06.407","CreateBy":"Loop Search Import","LastUpdate":"2015-03-04T17:45:23.867","UpdateBy":"Dataloop","YearBuilt":"1901","NumFloors":4,"BuildingDem":"18'x68'","LotDem":"18'x99.92'","EstValue":null,"Number":"464","StreetName":"W 141 ST","NeighName":"HARLEM-UPPER","State":"NY","ZipCode":"10031","Borough":"1","Zoning":"R7-2     ","MaxFar":"3.44","ActualFar":"2.59","NYCSqft":4896,"UnbuiltSqft":1292.5599999999995,"PropertyClass":"C0","Type":1,"C3rdMortgrAmt":null,"BuildingBBLE":null,"UnitNum":null,"Latitude":null,"Longitude":null,"InShortSale":true,"LisPens":[{"Type":"Foreclosure","Effective":"2010-07-27T00:00:00","Expiration":"","Index":"109886/2010","LisPenID":5300,"BBLE":"1020570051 ","Active":null,"Docket_Number":"109886    ","CountyNum":1,"County":"Manhattan","Section":null,"Block":"2057 ","Lot":"51  ","Number":"464       ","ST_Name":"W 141 ST                      ","Zip":"10031","NEIGH_NAME":"HARLEM-UPPER             ","FileDate":"2010-07-27T00:00:00","Original_Mortgage":0,"Mortgage_Date":"2007-01-05T00:00:00","Interest_Rate":0,"Monthly_Payment":0,"Defendant":"Stallworth,  Felicia                                                                      ","Plaintiff":"US Bank National Asso                                                                     ","Attorney":"Davidson                                                    ","Attorney_Phone":"585 760-8218        ","Terms":"none                          ","CollectedOn":"2014-04-14T12:44:17.65"}],"BoroughName":"Manhattan","HomeOwners":null,"Neighborhood":"HARLEM-UPPER","IsRecycled":false,"BlockLot":"2057 /51  ","Content":"<p data-reactid=\".167j2juz8jk.$render-target-default.0.0.2.4.0.0.$Col1-0-ContentCanvasProxy.$Col1-0-ContentCanvas.0.4.0:$4\" data-type=\"text\">add new line</p>\n\n<p data-reactid=\".167j2juz8jk.$render-target-default.0.0.2.4.0.0.$Col1-0-ContentCanvasProxy.$Col1-0-ContentCanvas.0.4.0:$4\" data-type=\"text\">add second line</p>\n\n<p data-reactid=\".167j2juz8jk.$render-target-default.0.0.2.4.0.0.$Col1-0-ContentCanvasProxy.$Col1-0-ContentCanvas.0.4.0:$4\" data-type=\"text\">That&rsquo;s the kind of question so incredible that I didn&rsquo;t&nbsp;even need an answer to squeeze some enjoyment from it. But here&rsquo;s the thing &mdash; I got an answer anyway. Quora user Kynan Eng decided to break the question down in terms of both actual, real-life movie budgets and the estimated costs of bringing the fictional characters played by Damon home.</p>\n\n<p data-reactid=\".167j2juz8jk.$render-target-default.0.0.2.4.0.0.$Col1-0-ContentCanvasProxy.$Col1-0-ContentCanvas.0.4.0:$5\" data-type=\"text\">Here&rsquo;s what he came up:</p>\n\n<blockquote data-reactid=\".167j2juz8jk.$render-target-default.0.0.2.4.0.0.$Col1-0-ContentCanvasProxy.$Col1-0-ContentCanvas.0.4.0:$6\" data-type=\"blockquote\">\n<p data-reactid=\".167j2juz8jk.$render-target-default.0.0.2.4.0.0.$Col1-0-ContentCanvasProxy.$Col1-0-ContentCanvas.0.4.0:$6.0\">&nbsp;</p>\n\n<p><b>Movie Budgets</b><br/>\n<em>Courage Under Fire</em>: $46m<br/>\n<em>Saving Private Ryan</em>: $70m<br/>\n<em>Titan A.E.</em>: $75m<br/>\n<em>Syriana</em>: $50m<br/>\n<em>Green Zone</em>: $100m<br/>\n<em>Elysium</em>: $115m<br/>\n<em>Interstellar</em>: $165m<br/>\n<em>The Martian</em>: $108m<br/>\n<b>TOTAL: $729m</b></p>\n\n<p><b>Fictional Costs</b><br/>\n<b>My estimates, costs are in 2015 currency</b><br/>\n<em>Courage Under Fire</em>&nbsp;(Gulf War 1 helicopter rescue): $300k<br/>\n<em>Saving Private Ryan</em>&nbsp;(WW2 Europe search party): $100k<br/>\n<em>Titan A.E.</em>&nbsp;(Earth evacuation spaceship): $200B<br/>\n<em>Syriana</em>&nbsp;(Middle East private security return flight): $50k<br/>\n<em>Green Zone</em>&nbsp;(US Army transport from Middle East): $50k<br/>\n<em>Elysium</em>&nbsp;(Space station security deployment and damages): $100m<br/>\n<em>Interstellar</em>&nbsp;(Interstellar spaceship): $500B<br/>\n<em>The Martian</em>&nbsp;(Mars mission): $200B<br/>\n<b>TOTAL: $900B plus change</b></p>\n</blockquote>\n"},"CreateDate":"2015-12-18T10:22:33.9323009-05:00","CreateBy":"Chris Yan","UpdateDate":"2015-12-18T10:22:33.9323009-05:00","UpdateBy":"Chris Yan","CaseName":"464 W 141 ST - STALLWORTH, FELICIA","BBLE":"1020570051 ","LegalComments":[],"ForeclosureInfo":{"AffidavitOfServices":[{"$$hashKey":"object:149","ClientPersonallyServed":true,"NailAndMail":false,"BorrowerLiveInAddrAtTimeServ":true,"BorrowerEverLiveHere":false,"IsServerHasNegativeInfo":false,"AffidavitServiceFiledIn20Day":true}],"Assignments":[{"$$hashKey":"object:164","IsMortageHasAssignment":true,"HasDocDraftedByDOCXLLC":false}],"MembersOfEstate":[{"$$hashKey":"object:147"}],"EveryOneIn":false,"BankruptcyDischarged":false,"AnswerClientFiledBefore":false,"NoteIsPossess":false,"PlainTiffSameAsOriginal":false,"NoteEndoresed":false,"AccelerationLetterReview":false,"StevenJAttny":false,"PlaintiffHaveAtCommencement":false,"AffirmationReviewerByCompany":false,"MortNoteAssInCert":false,"CertificateReviewerByCompany":false,"DocumentsRedacted":false,"ItemsRedacted":false,"HAMPSubmitted":false,"Plantiff":"Richard Chin","PlantiffAttorney":"Chris Yan"},"SecondaryTypes":[],"CaseStauts":"157"}
                                     ]]>
                                 </string>

    ''' <summary>
    ''' Unit test for GetCaseJsonObject, should return json object with all the data inside
    ''' </summary>
    <TestMethod> Public Sub GetCaseJsonObject_returnJsonObject()
        Dim lcase = New LegalCase
        lcase.CaseData = caseData

        Dim jObject = lcase.GetCaseJsonObject
        Assert.IsInstanceOfType(jObject, GetType(Newtonsoft.Json.Linq.JObject))
        Assert.IsTrue(jObject.Count > 0)
        Assert.AreEqual("PreQuestions", jObject.Properties()(0).Name)
    End Sub

    ''' <summary>
    ''' Unit Test for GetFieldValue, should return related field value
    ''' Nothing will return if the data is not found
    ''' </summary>
    <TestMethod> Public Sub GetFieldValue_returnFieldValue()
        Dim lcase = New LegalCase
        lcase.CaseData = <string>
                             <![CDATA[
                        {
                           "PreQuestions":{
                              "PartitionReview":{
                                 "RefusingMaintenHome":false,
                                 "IsDuringOrPriorMarriage":false,
                                 "IsDivorceDecree":false,
                                 "IsContract":false,
                                 "IsContractViewable":false,
                                 "IsOfferMoney":false,
                                 "IsFC":false,
                                 "IsRefusingWorkout":false,
                                 "IsLegal":false
                              },
                              "DeedReversionReview":{
                                 "WasDeedTransferred":false,
                                 "HasHolderMadeImprovment":false,
                                 "WasAttorneyPresent":false,
                                 "WasAttorneySignOffDeed":false
                              },
                              "QuietTitleReview":{
                                 "IsSignedDeed":false,
                                 "RecordSaidDeed":false,
                                 "SignQuietTitle":false,
                                 "ClientAppliedLoanBefore":false,
                                 "ClientRecievedCorrespondence":false
                              },
                              "SpecificReview":{
                                 "ShortSaleApproval":false,
                                 "haveSaidCheck":false,
                                 "EffortGetClientBack":false
                              },
                              "IsTenents":false,
                              "IsTenentsPayRent":false,
                              "IsFCReview":true
                           },
                           "PropertyInfo":{
                              "BBLE":"1020570051 ",
                              "IsLisPendens":null,
                              "IsOtherLiens":null,
                              "IsTaxesOwed":null,
                              "IsWaterOwed":null,
                              "IsECBViolations":null,
                              "IsDOBViolations":null,
                              "C1stMotgrAmt":1495000,
                              "C2ndMotgrAmt":null,
                              "TaxesAmt":null,
                              "TaxesOrderStatus":null,
                              "TaxesOrderTime":null,
                              "TaxesOrderDeliveryTime":null,
                              "WaterAmt":null,
                              "WaterOrderStatus":null,
                              "WaterOrderTime":null,
                              "WaterOrderDeliveryTime":null,
                              "ECBViolationsAmt":null,
                              "ECBOrderStatus":null,
                              "ECBOrderTime":null,
                              "ECBOrderDeliveryTime":null,
                              "DOBViolationsAmt":null,
                              "DOBOrderStatus":null,
                              "DOBOrderTime":null,
                              "DOBOrderDeliveryTime":null,
                              "AcrisOrderStatus":null,
                              "AcrisOrderTime":null,
                              "AcrisOrderDeliveryTime":null,
                              "LastPaid":null,
                              "IsCoOnFile":null,
                              "TypeOfCo":null,
                              "Owner":"STALLWORTH, FELICIA",
                              "CoOwner":"",
                              "Date":null,
                              "PropertyAddress":"464 W 141 ST, Manhattan,NY 10031",
                              "SaleDate":"1999-04-29T00:00:00",
                              "TaxClass":"1",
                              "SaleType":null,
                              "Condition":null,
                              "Block":"2057 ",
                              "Lot":"51  ",
                              "DOBViolation":null,
                              "Remark1":null,
                              "Remark2":null,
                              "Remark3":null,
                              "Remark4":null,
                              "Deed":null,
                              "LPindex":null,
                              "CreateDate":"2015-03-04T13:39:06.407",
                              "CreateBy":"Loop Search Import",
                              "LastUpdate":"2015-03-04T17:45:23.867",
                              "UpdateBy":"Dataloop",
                              "YearBuilt":"1901",
                              "NumFloors":4,
                              "BuildingDem":"18'x68'",
                              "LotDem":"18'x99.92'",
                              "EstValue":null,
                              "Number":"464",
                              "StreetName":"W 141 ST",
                              "NeighName":"HARLEM-UPPER",
                              "State":"NY",
                              "ZipCode":"10031",
                              "Borough":"1",
                              "Zoning":"R7-2     ",
                              "MaxFar":"3.44",
                              "ActualFar":"2.59",
                              "NYCSqft":4896,
                              "UnbuiltSqft":1292.5599999999995,
                              "PropertyClass":"C0",
                              "Type":1,
                              "C3rdMortgrAmt":null,
                              "BuildingBBLE":null,
                              "UnitNum":null,
                              "Latitude":null,
                              "Longitude":null,
                              "InShortSale":true,
                              "LisPens":[
                                 {
                                    "Type":"Foreclosure",
                                    "Effective":"2010-07-27T00:00:00",
                                    "Expiration":"",
                                    "Index":"109886/2010",
                                    "LisPenID":5300,
                                    "BBLE":"1020570051 ",
                                    "Active":null,
                                    "Docket_Number":"109886    ",
                                    "CountyNum":1,
                                    "County":"Manhattan",
                                    "Section":null,
                                    "Block":"2057 ",
                                    "Lot":"51  ",
                                    "Number":"464       ",
                                    "ST_Name":"W 141 ST                      ",
                                    "Zip":"10031",
                                    "NEIGH_NAME":"HARLEM-UPPER             ",
                                    "FileDate":"2010-07-27T00:00:00",
                                    "Original_Mortgage":0,
                                    "Mortgage_Date":"2007-01-05T00:00:00",
                                    "Interest_Rate":0,
                                    "Monthly_Payment":0,
                                    "Defendant":"Stallworth,  Felicia                                                                      ",
                                    "Plaintiff":"US Bank National Asso                                                                     ",
                                    "Attorney":"Davidson                                                    ",
                                    "Attorney_Phone":"585 760-8218        ",
                                    "Terms":"none                          ",
                                    "CollectedOn":"2014-04-14T12:44:17.65"
                                 }
                              ],
                              "BoroughName":"Manhattan",
                              "HomeOwners":null,
                              "Neighborhood":"HARLEM-UPPER",
                              "IsRecycled":false,
                              "BlockLot":"2057 /51  ",
                              "Content":"<p data-reactid=\".167j2juz8jk.$render-target-default.0.0.2.4.0.0.$Col1-0-ContentCanvasProxy.$Col1-0-ContentCanvas.0.4.0:$4\" data-type=\"text\">add new line</p>\n\n<p data-reactid=\".167j2juz8jk.$render-target-default.0.0.2.4.0.0.$Col1-0-ContentCanvasProxy.$Col1-0-ContentCanvas.0.4.0:$4\" data-type=\"text\">add second line</p>\n\n<p data-reactid=\".167j2juz8jk.$render-target-default.0.0.2.4.0.0.$Col1-0-ContentCanvasProxy.$Col1-0-ContentCanvas.0.4.0:$4\" data-type=\"text\">That&rsquo;s the kind of question so incredible that I didn&rsquo;t&nbsp;even need an answer to squeeze some enjoyment from it. But here&rsquo;s the thing &mdash; I got an answer anyway. Quora user Kynan Eng decided to break the question down in terms of both actual, real-life movie budgets and the estimated costs of bringing the fictional characters played by Damon home.</p>\n\n<p data-reactid=\".167j2juz8jk.$render-target-default.0.0.2.4.0.0.$Col1-0-ContentCanvasProxy.$Col1-0-ContentCanvas.0.4.0:$5\" data-type=\"text\">Here&rsquo;s what he came up:</p>\n\n<blockquote data-reactid=\".167j2juz8jk.$render-target-default.0.0.2.4.0.0.$Col1-0-ContentCanvasProxy.$Col1-0-ContentCanvas.0.4.0:$6\" data-type=\"blockquote\">\n<p data-reactid=\".167j2juz8jk.$render-target-default.0.0.2.4.0.0.$Col1-0-ContentCanvasProxy.$Col1-0-ContentCanvas.0.4.0:$6.0\">&nbsp;</p>\n\n<p><b>Movie Budgets</b><br/>\n<em>Courage Under Fire</em>: $46m<br/>\n<em>Saving Private Ryan</em>: $70m<br/>\n<em>Titan A.E.</em>: $75m<br/>\n<em>Syriana</em>: $50m<br/>\n<em>Green Zone</em>: $100m<br/>\n<em>Elysium</em>: $115m<br/>\n<em>Interstellar</em>: $165m<br/>\n<em>The Martian</em>: $108m<br/>\n<b>TOTAL: $729m</b></p>\n\n<p><b>Fictional Costs</b><br/>\n<b>My estimates, costs are in 2015 currency</b><br/>\n<em>Courage Under Fire</em>&nbsp;(Gulf War 1 helicopter rescue): $300k<br/>\n<em>Saving Private Ryan</em>&nbsp;(WW2 Europe search party): $100k<br/>\n<em>Titan A.E.</em>&nbsp;(Earth evacuation spaceship): $200B<br/>\n<em>Syriana</em>&nbsp;(Middle East private security return flight): $50k<br/>\n<em>Green Zone</em>&nbsp;(US Army transport from Middle East): $50k<br/>\n<em>Elysium</em>&nbsp;(Space station security deployment and damages): $100m<br/>\n<em>Interstellar</em>&nbsp;(Interstellar spaceship): $500B<br/>\n<em>The Martian</em>&nbsp;(Mars mission): $200B<br/>\n<b>TOTAL: $900B plus change</b></p>\n</blockquote>\n"
                           },
                           "CreateDate":"2015-12-18T10:22:33.9323009-05:00",
                           "CreateBy":"Chris Yan",
                           "UpdateDate":"2015-12-18T10:22:33.9323009-05:00",
                           "UpdateBy":"Chris Yan",
                           "CaseName":"464 W 141 ST - STALLWORTH, FELICIA",
                           "BBLE":"1020570051 ",
                           "LegalComments":[

                           ],
                           "ForeclosureInfo":{
                              "AffidavitOfServices":[
                                 {
                                    "$$hashKey":"object:149",
                                    "ClientPersonallyServed":true,
                                    "NailAndMail":false,
                                    "BorrowerLiveInAddrAtTimeServ":true,
                                    "BorrowerEverLiveHere":false,
                                    "IsServerHasNegativeInfo":false,
                                    "AffidavitServiceFiledIn20Day":true
                                 }
                              ],
                              "Assignments":[
                                 {
                                    "$$hashKey":"object:164",
                                    "IsMortageHasAssignment":true,
                                    "HasDocDraftedByDOCXLLC":false
                                 }
                              ],
                              "MembersOfEstate":[
                                 {
                                    "$$hashKey":"object:147"
                                 }
                              ],
                              "EveryOneIn":false,
                              "BankruptcyDischarged":false,
                              "AnswerClientFiledBefore":false,
                              "NoteIsPossess":false,
                              "PlainTiffSameAsOriginal":false,
                              "NoteEndoresed":false,
                              "AccelerationLetterReview":false,
                              "StevenJAttny":false,
                              "PlaintiffHaveAtCommencement":false,
                              "AffirmationReviewerByCompany":false,
                              "MortNoteAssInCert":false,
                              "CertificateReviewerByCompany":false,
                              "DocumentsRedacted":false,
                              "ItemsRedacted":false,
                              "HAMPSubmitted":false,
                              "Plantiff":"Richard Chin",
                              "PlantiffAttorney":"Chris Yan"
                           },
                           "SecondaryTypes":[

                           ],
                           "CaseStauts":"157"
}                             ]]>
                         </string>

        Assert.AreEqual("Richard Chin", lcase.GetFieldValue(Of String)("ForeclosureInfo.Plantiff"))
        Assert.AreEqual("Chris Yan", lcase.GetFieldValue(Of String)("ForeclosureInfo.PlantiffAttorney"))
        Assert.AreEqual(157, lcase.GetFieldValue(Of Integer)("CaseStauts"))
        Assert.AreEqual(Of Decimal)(1495000, lcase.GetFieldValue(Of Decimal)("PropertyInfo.C1stMotgrAmt"))
        Assert.AreEqual(18, lcase.GetFieldValue(Of DateTime)("CreateDate").Day)
        Assert.IsNull(lcase.GetFieldValue(Of String)("PropertyInfo.IsLisPendens"))

        Assert.AreEqual(0, lcase.GetFieldValue(Of Integer)("test"))
        Assert.IsNull(lcase.GetFieldValue(Of String)("test"))
    End Sub

    ''' <summary>
    ''' Unit Test for GetSecondaryActions
    ''' </summary>
    <TestMethod> Public Sub GetSecondaryActions_returnActionList()
        Dim lcase = New LegalCase
        lcase.CaseData = <string>
                             <![CDATA[
                        {                                                  
                           "ForeclosureInfo":{                                                                                          
                              "EveryOneIn":false,
                              "BankruptcyDischarged":false,
                              "AnswerClientFiledBefore":false,
                              "NoteIsPossess":false,
                              "PlainTiffSameAsOriginal":false,
                              "NoteEndoresed":false,
                              "AccelerationLetterReview":false,
                              "StevenJAttny":false,
                              "PlaintiffHaveAtCommencement":false,
                              "AffirmationReviewerByCompany":false,
                              "MortNoteAssInCert":false,
                              "CertificateReviewerByCompany":false,
                              "DocumentsRedacted":false,
                              "ItemsRedacted":false,
                              "HAMPSubmitted":false,
                              "Plantiff":"Richard Chin",
                              "PlantiffAttorney":"Chris Yan"
                           },
                           "SecondaryInfo":{
                              "Owner":"test",
                              "PartitionAction":"Action1",
                              "PartitionHeldReason":"Tenants in common ",
                              "CourtAddress":"Test 123",
                              "Defendant":"1234",
                              "DefendantAttorneyName":"Carl Belgrave",
                              "DefendantAttorneyId":128,
                              "SelectedType":"Statute Of Limitations",
                              "SelectTypes":[
                                 "Quiet Title",
                                 "Statute Of Limitations",
                                 "Estate",
                                 "Miscellaneous"
                              ],
                              "PlaintiffAttorneyName":"Jeffrey L Weinstein, Esq.",
                              "PlaintiffAttorneyId":941,
                              "DeedReversionDefendants":[

                              ],
                              "DeedReversionPlantiff":"testpltiff",
                              "DeedReversionPlantiffAttorney":"David Testing",
                              "DeedReversionPlantiffAttorneyId":1358,
                              "DeedReversionIndexNum":"ss",
                              "DeedReversionDefendant":"PartitionsPlantiffAttorneyId",
                              "OSC_Defendants":[

                              ],
                              "SPComplaint_Defendants":[

                              ],
                              "SPComplaint_Plantiff":"tes",
                              "SPComplaint_PlantiffAttorney":"Diane Bernstein",
                              "SPComplaint_PlantiffAttorneyId":570,
                              "SPComplaint_IndexNum":"12344",
                              "SPComplaint_Defendant":"Carl Belgrave",
                              "PartitionsPlantiffAttorney":"Andre Shlomovich",
                              "PartitionsPlantiffAttorneyId":559,
                              "QTA_Plantiff":"test",
                              "PartitionsPlantiff":"testPlantiff",
                              "PartitionsDefendant1":"tD1",
                              "PartitionsDefendant":"testD",
                              "PartitionsIndexNum":"123456/1234",
                              "PartitionsMortgageDate":"11/18/2015",
                              "PartitionsMortgageAmount":"5111",
                              "PartitionsDateOfRecording":"11/18/2015",
                              "PartitionsCRFN":"CRFN84116a",
                              "PartitionsOriginalLender":"BOA"
                           },
                           "SecondaryTypes":[
                                  1,
                                  5,
                                  4,
                                  2,
                                  3,
                                  7,
                                  8,
                                  6
                           ],
                           "CaseStauts":"157"
                                }            
                 ]]>
                         </string>

        Dim actions = lcase.GetSecondaryActions()

        Assert.IsInstanceOfType(actions, GetType(List(Of LegalCase.SecondaryAction)))
        Assert.AreEqual(8, actions.Count)

        Dim qta = actions.Where(Function(act) act.Id = 3).SingleOrDefault
        Assert.IsNull(qta.Defendant)
        Assert.AreEqual("test", qta.Plaintiff)

        Dim partition = actions.Where(Function(act) act.Id = 2).SingleOrDefault
        Assert.AreEqual("testD", partition.Defendant)
        Assert.IsNull(partition.DefendantAttorney)
        Assert.AreEqual("testPlantiff", partition.Plaintiff)
        Assert.AreEqual("Andre Shlomovich", partition.PlaintiffAttorney)

        Dim fc = actions.Where(Function(act) act.Id = 1).SingleOrDefault
        Assert.AreEqual("1234", fc.Defendant)
        Assert.AreEqual("Carl Belgrave", fc.DefendantAttorney)
        Assert.AreEqual("Richard Chin", fc.Plaintiff)
        Assert.AreEqual("Chris Yan", fc.PlaintiffAttorney)

    End Sub

End Class