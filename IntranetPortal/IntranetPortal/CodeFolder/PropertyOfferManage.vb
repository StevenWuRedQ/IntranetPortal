Imports System.IO
Imports System.IO.Compression
Imports Newtonsoft.Json.Linq
Imports Novacode
Imports IntranetPortal.Data
Imports iTextSharp.text.pdf
Imports ClosedXML.Excel

''' <summary>
''' The action realted to PropertyOffer
''' </summary>
Public Class PropertyOfferManage

    ''' <summary>
    ''' The office manager view enum
    ''' </summary>
    Public Class ManagerView
        Inherits Status
        ''' <summary>
        ''' Represents the New Offer Completed status
        ''' </summary>
        ''' <returns></returns>
        Public Shared Property AllCompleted As New ManagerView With {
        .Key = 0, .Name = "All"}
        ''' <summary>
        ''' Represents the New Offer Completed status
        ''' </summary>
        ''' <returns></returns>
        Public Shared Property Completed As New ManagerView With {
        .Key = 1, .Name = "New Offer"}
        ''' <summary>
        ''' Represents the InProcess Status
        ''' </summary>
        ''' <returns></returns>
        Public Shared Property InProcess As New ManagerView With {
        .Key = 2, .Name = "In Process"}
        ''' <summary>
        ''' Represents the ShortSale Accepted Status
        ''' </summary>
        ''' <returns></returns>
        Public Shared Property SSAccepted As New ManagerView With {
        .Key = 3, .Name = "SS Accepted"}

        Public Shared Widening Operator CType(ByVal status As Integer) As ManagerView
            Select Case status
                Case 0
                    Return AllCompleted
                Case 1
                    Return Completed
                Case 2
                    Return InProcess
                Case 3
                    Return SSAccepted
            End Select

            Return Nothing
        End Operator

        Public Shared Narrowing Operator CType(v As ManagerView) As Integer
            Return v.Key
        End Operator

        Public Shared Operator =(ByVal v As ManagerView, ByVal i As Integer?) As Boolean
            If Not i.HasValue Then
                Return False
            End If

            Return v.Key = i
        End Operator

        Public Shared Operator <>(ByVal v As ManagerView, ByVal i As Integer?) As Boolean
            If Not i.HasValue Then
                Return True
            End If

            Return v.Key <> i
        End Operator
    End Class

    ''' <summary>
    ''' Return offer list that return manager
    ''' </summary>
    ''' <param name="name">The manager name</param>
    ''' <param name="view">The view type</param>
    ''' <returns></returns>
    Public Shared Function GetOffersByManagerView(name As String, view As ManagerView, isSummary As Boolean) As PropertyOffer()
        Dim emps = New List(Of String)
        emps.Add(name)

        If IsManager(name) Then
            emps.AddRange(Employee.GetAllEmps)
        Else
            emps.AddRange(Employee.GetControledDeptEmployees(name))
            emps.AddRange(Team.GetTeamUsersByAssistant(name))
        End If

        Select Case view
            Case ManagerView.AllCompleted
                Dim offers = PropertyOffer.GetAllCompleted(emps.ToArray)
                offers.ForEach(Function(o)
                                   If o.ShortSaleStatus > 0 Then
                                       Return InitData(o, ManagerView.SSAccepted)
                                   End If

                                   If o.LeadsStatus = 5 Then
                                       Return InitData(o, ManagerView.InProcess)
                                   End If

                                   Return InitData(o, ManagerView.Completed)
                               End Function)
                Return offers
            Case Else
                Return OffersByManagerView(emps.ToArray, view, isSummary)
        End Select

        Return Nothing
    End Function

    Friend Shared Function getPerformance(startDate As Date, endDate As Date, empName As String, teamName As String) As Object

        If startDate = Nothing OrElse endDate = Nothing OrElse empName Is Nothing OrElse teamName Is Nothing Then
            Throw New Exception("Parameters cannot be empty.")
        End If


        Dim count = getAcceptedCount(startDate, endDate, empName, teamName)
        ' Dim rank = getrank(startDate, endDate, empName, teamName)
        ' Dim commision = getCommision(startDate, endDate, empName, teamName)
        ' Dim history = getHistory(startDate, endDate, empName, teamName)

        Dim result = New With {
            .totalaccepted = count
        }
        Return result
    End Function

    Private Shared Function getHistory(startDate As Date, endDate As Date, empName As String, teamName As String) As Object
        Return Nothing

    End Function

    Private Shared Function getCommision(startDate As Date, endDate As Date, empName As String, teamName As String) As Object
        Return Nothing
    End Function

    Private Shared Function getrank(startDate As Date, endDate As Date, empName As String, teamName As String) As Object
        Return Nothing
    End Function

    Private Shared Function getAcceptedCount(startDate As Date, endDate As Date, empName As String, teamName As String) As Integer
        If String.IsNullOrEmpty(empName) Then
            Return 0
        ElseIf empName = "All" Then
            Dim t = Team.GetTeam(teamName)
            Dim users = t.ActiveUsers
            Return PropertyOffer.GetSSAccepted(users, startDate, endDate).Count
        Else
            Return PropertyOffer.GetSSAccepted(New String() {empName}, startDate, endDate).Count
        End If
    End Function

    ''' <summary>
    ''' Return completed NewOffers which are not move to InProcess for over 7 days
    ''' </summary>
    ''' <param name="teamName">Team Name</param>
    ''' <returns></returns>
    Public Shared Function CompletedNewOfferDue(teamName As String, Optional summary As Boolean = True) As PropertyOffer()
        Dim dt = DateTime.Today
        Dim offers = OffersByManagerView(Team.GetTeamUsers(teamName), ManagerView.Completed, summary)
        Return offers.Where(Function(o) o.UpdateDate < dt.AddDays(-7)).ToArray
    End Function

    ''' <summary>
    ''' Return if the given team has completed NewOffer due today
    ''' </summary>
    ''' <param name="teamName"></param>
    ''' <returns></returns>
    Public Shared Function HasCompletedNewOfferDue(teamName As String) As Boolean
        Return CompletedNewOfferDue(teamName).Count > 0
    End Function

    ''' <summary>
    ''' Return InProcess NewOffers which are not move to ShortSale for over 7 days
    ''' </summary>
    ''' <param name="teamName">The employee lists</param>
    ''' <returns></returns>
    Public Shared Function InProcessNewOfferDue(teamName As String, Optional summary As Boolean = True) As PropertyOffer()
        Dim dt = DateTime.Today
        Dim offers = OffersByManagerView(Team.GetTeamUsers(teamName), ManagerView.InProcess, summary)
        Return offers.Where(Function(o) o.InProcessDate < dt.AddDays(-7)).ToArray
    End Function

    ''' <summary>
    ''' Return if the given team has InProcess new offer due today
    ''' </summary>
    ''' <param name="teamName">Team Name</param>
    ''' <returns></returns>
    Public Shared Function HasInProcessNewOfferDue(teamName As String) As Boolean
        Return InProcessNewOfferDue(teamName).Count > 0
    End Function

    ''' <summary>
    ''' Return the properties that underwriting was accepted but new offer was not created for over 2 ydays
    ''' </summary>
    ''' <param name="teamName">Team name</param>
    ''' <returns></returns>
    Public Shared Function PendingNewOfferDue(teamName As String) As UnderwritingTrackingView()
        Return PropertyOffer.PendingForNewOffer(Team.GetTeamUsers(teamName))
    End Function

    ''' <summary>
    ''' Return if the given team has due on new offer creating
    ''' </summary>
    ''' <param name="teamName"></param>
    ''' <returns></returns>
    Public Shared Function HasPendingNewOfferDue(teamName As String) As Boolean
        Return PendingNewOfferDue(teamName).Count > 0
    End Function

    ''' <summary>
    ''' Return property offers by ManagerView
    ''' </summary>
    ''' <param name="emps">The Employee Names</param>
    ''' <param name="view">The ManagerView</param>
    ''' <param name="isSummary">The Summary Indicator</param>
    ''' <returns></returns>
    Public Shared Function OffersByManagerView(emps As String(), view As ManagerView, isSummary As Boolean) As PropertyOffer()
        Dim offer() As PropertyOffer = {}
        Select Case view
            Case ManagerView.Completed
                offer = PropertyOffer.GetCompleted(emps)
            Case ManagerView.InProcess
                offer = PropertyOffer.GetInProcess(emps.ToArray)
            Case ManagerView.SSAccepted
                offer = PropertyOffer.GetSSAccepted(emps.ToArray)
        End Select

        If Not isSummary Then
            offer.ForEach(Function(d)
                              Return InitData(d, view)
                          End Function)
        End If

        Return offer
    End Function

    ''' <summary>
    ''' Return accepted shortsale last two weeks
    ''' </summary>
    ''' <returns></returns>
    Public Shared Function GetSSAcceptedOfferLastWeek(userTeam As String, ByRef dtStart As DateTime, ByRef dtEnd As DateTime) As PropertyOffer()
        Dim dayofWeek = DateTime.Today.DayOfWeek - 1
        dtStart = DateTime.Today.AddDays(-7 - dayofWeek)
        dtEnd = DateTime.Today.AddDays(-dayofWeek)
        Dim emps = New List(Of String)

        If userTeam = "*" Then
            For Each tm In Team.GetActiveTeams
                emps.AddRange(tm.AllUsers)
            Next
        Else
            emps.AddRange(Team.GetTeam(userTeam).AllUsers)
        End If

        Dim data = PropertyOffer.GetSSAccepted(emps.ToArray, dtStart, dtEnd)
        data.ForEach(Function(d)
                         Return InitData(d, ManagerView.SSAccepted)
                     End Function)
        Return data
    End Function

    ''' <summary>
    ''' Return Complated property offers
    ''' </summary>
    ''' <param name="names"></param>
    ''' <returns></returns>
    Public Shared Function CompletedPropertyOffers(names As String()) As PropertyOffer()
        Dim offer = PropertyOffer.GetCompleted(names)

        offer.ForEach(Function(d)
                          Return InitData(d, ManagerView.Completed)
                      End Function)
        Return offer
    End Function

    ''' <summary>
    ''' Return propertyoffers which is in process 
    ''' but not accepted by shortsale
    ''' </summary>
    ''' <param name="names">The Owner Names</param>
    ''' <returns></returns>
    Public Shared Function InProcessOffers(names As String()) As PropertyOffer()
        Dim offer = PropertyOffer.GetInProcess(names)
        offer.ForEach(Function(d)
                          Return InitData(d, ManagerView.InProcess)
                      End Function)
        Return offer
    End Function

    ''' <summary>
    ''' Return completed property offers which were accepted by ShortSale
    ''' </summary>
    ''' <param name="names">The Owner Names</param>
    ''' <returns></returns>
    Public Shared Function SSAcceptedOffers(names As String()) As PropertyOffer()
        Dim offer = PropertyOffer.GetSSAccepted(names)
        offer.ForEach(Function(d)
                          Return InitData(d, ManagerView.SSAccepted)
                      End Function)
        Return offer
    End Function

    Private Shared Function InitData(offer As PropertyOffer, view As ManagerView) As PropertyOffer
        offer.OfferStage = view.ToString
        ' offer.LeadsOwner = Lead.GetLeadsOwner(offer.BBLE)
        offer.Team = Employee.GetEmpTeam(offer.LeadsOwner)
        Return offer
    End Function

    Public Shared Function IsManager(name As String) As Boolean
        Return Roles.IsUserInRole(name, "Admin") OrElse Roles.IsUserInRole(name, "OfficeExecutive")
    End Function

    ''' <summary>
    ''' Check the pre conditions for new offer
    ''' </summary>
    ''' <param name="bble">The property BBLE</param>
    ''' <returns></returns>
    Public Shared Function CheckPreConditions(bble As String) As Boolean
        Dim record = PreSignRecord.GetInstanceByBBLE(bble)
        If record Is Nothing Then
            Return False
        End If

        If record.NeedSearch Then
            Dim search = LeadInfoDocumentSearch.GetInstance(bble)
            If search Is Nothing Then
                Return False
            End If

            If search.Status <> LeadInfoDocumentSearch.SearchStatus.Completed Then
                Return False
            End If
        End If

        Return True
    End Function

    ''' <summary>
    ''' Return if hoi list can be viewable by current user
    ''' </summary>
    ''' <param name="username">the user name</param>
    ''' <returns></returns>
    Public Shared Function Viewable(username As String) As Boolean
        Return Employee.IsAdmin(username) OrElse Roles.IsUserInRole(username, "NewOffer-Viewer")
    End Function

    ''' <summary>
    ''' Check the pre conditions for new offer
    ''' </summary>
    ''' <param name="bble">The property BBLE</param>
    ''' <returns></returns>
    Public Shared Function CheckOfferIsReady(bble As String) As Boolean
        Dim record = PreSignRecord.GetInstanceByBBLE(bble)
        If record Is Nothing Then
            Return False
        End If

        If record.NeedSearch Then
            Dim search = LeadInfoDocumentSearch.GetInstance(bble)
            If search Is Nothing Then
                Return False
            End If

            If search.Status <> LeadInfoDocumentSearch.SearchStatus.Completed Then
                Return False
            End If
        End If

        Return True
    End Function

    ''' <summary>
    ''' Generate Offer Package
    ''' </summary>
    ''' <param name="bble">The property BBLE</param>
    ''' <param name="data">The offer related data</param>
    ''' <param name="offerDocPath">The offer document path</param>
    ''' <param name="destPath">The destination path</param>
    ''' <returns>Return the filename of generated package</returns>
    Public Shared Function GeneratePackage(bble As String, data As JObject, offerDocPath As String, destPath As String) As String

        Dim path = offerDocPath 'HttpContext.Current.Server.MapPath("~/App_Data/OfferDoc")
        Dim targetPath = destPath & bble ' HttpContext.Current.Server.MapPath("~/TempDataFile/OfferDoc/" & bble)
        Dim zipPath = IO.Path.Combine(destPath, bble & ".zip")

        Try
            Dim generator As New DocumentGenerator(data, bble)
            Dim direcotry = New IO.DirectoryInfo(path)

            If Not Directory.Exists(targetPath) Then
                Directory.CreateDirectory(targetPath)
            End If

            Dim files = direcotry.GetFiles()

            Dim deedType = CType(data.SelectToken("DeadType"), JObject)
            For Each doc In deedType.Properties
                If CBool(deedType.GetValue(doc.Name).ToString) Then
                    Dim config = generator.LoadFileConfigration(doc.Name)
                    If config IsNot Nothing Then
                        Dim f = files.Where(Function(a) a.Name = config.FileName).First

                        Dim finalpath = IO.Path.Combine(targetPath, f.Name)

                        Select Case config.Type
                            Case GenerateFileConfig.FileType.Word
                                Using d = DocX.Load(f.FullName)
                                    generator.GenerateDocument(d, config)
                                    d.SaveAs(finalpath)
                                End Using
                            Case GenerateFileConfig.FileType.Pdf
                                Dim pdfReader As New PdfReader(f.FullName)
                                Dim pdfNewFile = New PdfStamper(pdfReader, New FileStream(finalpath, FileMode.Create))

                                Dim pdfFormFields = pdfNewFile.AcroFields
                                generator.GeneratePdf(pdfFormFields, config)
                                pdfNewFile.FormFlattening = False
                                pdfNewFile.Close()
                        End Select
                    End If
                End If
            Next

            If File.Exists(zipPath) Then
                File.Delete(zipPath)
            End If

            ZipFile.CreateFromDirectory(targetPath, zipPath)

            If Directory.Exists(targetPath) Then
                For Each file In Directory.GetFiles(targetPath)
                    System.IO.File.SetAttributes(file, FileAttributes.Normal)
                    System.IO.File.Delete(file)
                Next
                Directory.Delete(targetPath, True)
            End If

            Return String.Format("{0}.zip", bble)
        Catch ex As Exception
            Throw ex
        End Try
    End Function
End Class

''' <summary>
''' The document generator, support word and pdf
''' </summary>
Public Class DocumentGenerator
    ''' <summary>
    ''' The JSON data
    ''' </summary>
    ''' <returns></returns>
    Public Property Data As JObject
    ''' <summary>
    ''' The file path
    ''' </summary>
    ''' <returns></returns>
    Public Property Path As String
    ''' <summary>
    ''' The document related property BBLE
    ''' </summary>
    ''' <returns></returns>
    Public Property BBLE As String

    Public Sub New(data As JObject, bble As String)
        Me.Data = data
        Me.BBLE = bble
    End Sub

    ''' <summary>
    ''' Generate the PDF by file config
    ''' </summary>
    ''' <param name="pdfFormFields">The pdf field collections</param>
    ''' <param name="config"></param>
    Public Sub GeneratePdf(pdfFormFields As AcroFields, config As GenerateFileConfig)
        For Each ph In config.PlaceHolders
            pdfFormFields.SetField(ph.FieldName, GetValue(ph))
        Next
    End Sub

    Public Sub GenerateExcel(wb As IXLWorksheet, config As GenerateFileConfig)
        For Each ph In config.PlaceHolders
            wb.Cell(ph.FieldName).Value = GetValue(ph)
        Next
    End Sub


    ''' <summary>
    ''' Generate word document by file config
    ''' </summary>
    ''' <param name="doc">The document name</param>
    ''' <param name="config">The file configration</param>
    Public Sub GenerateDocument(doc As DocX, config As GenerateFileConfig)
        Me.Data = Data

        For Each ph In config.PlaceHolders
            Try
                doc.ReplaceText(String.Format("[{0}]", ph.FieldName), GetValue(ph))
            Catch ex As Exception
                Console.Write(ex.Message)
            End Try
        Next
    End Sub

    ''' <summary>
    ''' load file configratins by config name
    ''' </summary>
    ''' <param name="configName"></param>
    ''' <returns></returns>
    Public Function LoadFileConfigration(configName As String) As GenerateFileConfig
        If _fileConfigures Is Nothing Then
            InitConfigures()
        End If

        Dim config = _fileConfigures.Where(Function(fc) fc.ConfigKey = configName).SingleOrDefault

        Return config
    End Function

    Private Shared _fileConfigures As List(Of GenerateFileConfig)

    ''' <summary>
    ''' Init file configuration and fields mapping
    ''' </summary>
    Private Sub InitConfigures()
        If _fileConfigures IsNot Nothing Then
            Return
        End If

        _fileConfigures = New List(Of GenerateFileConfig)

        'Memo
        Dim file = New GenerateFileConfig With {.FileName = "MemorandumOfContract.docx", .ConfigKey = "Memo"}
        Dim phs = {
            New DocumentPlaceHolder("TODAY"),
            New DocumentPlaceHolder("DAY"),
            New DocumentPlaceHolder("MONTH"),
            New DocumentPlaceHolder("YEAR"),
            New DocumentPlaceHolder("DATE"),
            New DocumentPlaceHolder("PROPERTYADDRESS", "PropertyAddress"),
            New DocumentPlaceHolder("BLOCK"),
            New DocumentPlaceHolder("LOT"),
            New DocumentPlaceHolder("SELLERNAMES", Function(data As JObject)
                                                       Dim names = data.SelectToken("DealSheet.ContractOrMemo.Sellers").Select(Function(s) s.SelectToken("Name").ToString).Where(Function(s) Not String.IsNullOrEmpty(s)).ToArray
                                                       Return String.Join(" & ", names)
                                                   End Function),
           New DocumentPlaceHolder("SELLER1NAME", "DealSheet.ContractOrMemo.Sellers[0].Name"),
           New DocumentPlaceHolder("SELLERADDRESS", "DealSheet.ContractOrMemo.Sellers[0].Address"),
           New DocumentPlaceHolder("SELLER2NAME", "DealSheet.ContractOrMemo.Sellers[1].Name"),
           New DocumentPlaceHolder("SELLER3NAME", "DealSheet.ContractOrMemo.Sellers[2].Name"),
           New DocumentPlaceHolder("BUYERNAME", "DealSheet.ContractOrMemo.Buyer.CorpName"),
           New DocumentPlaceHolder("BUYERNAMESIGNER", Function(data As JObject)
                                                          Dim result = data.SelectToken("DealSheet.ContractOrMemo.Buyer.CorpName")

                                                          If result IsNot Nothing Then

                                                              Dim signer = data.SelectToken("DealSheet.ContractOrMemo.Buyer.Signer")
                                                              If signer IsNot Nothing Then
                                                                  Return String.Format("{0} by {1}", result.ToString, signer.ToString)
                                                              End If

                                                              Return result.ToString
                                                          End If

                                                          Return ""
                                                      End Function),
           New DocumentPlaceHolder("BUYERADDRESS", "DealSheet.ContractOrMemo.Buyer.Address")
        }
        file.PlaceHolders = phs.ToList
        _fileConfigures.Add(file)

        ' Sales Contract
        file = New GenerateFileConfig With {.FileName = "SalesContract.docx", .ConfigKey = "Contract"}
        file.PlaceHolders = phs.ToList
        file.PlaceHolders.Add(New DocumentPlaceHolder("CONTRACTPRICE", Function(data As JObject)
                                                                           Dim contractPrice = data.SelectToken("DealSheet.ContractOrMemo.contractPrice")
                                                                           If contractPrice IsNot Nothing Then
                                                                               Dim price = 0
                                                                               If Decimal.TryParse(contractPrice, price) Then
                                                                                   Return String.Format("{0:N2}", price)
                                                                               End If
                                                                           End If
                                                                           Return ""
                                                                       End Function))
        file.PlaceHolders.Add(New DocumentPlaceHolder("DOWNPAYMENT", Function(data As JObject)
                                                                         Dim downPayment = data.SelectToken("DealSheet.ContractOrMemo.downPayment")
                                                                         If downPayment IsNot Nothing Then
                                                                             Dim price = 0
                                                                             If Decimal.TryParse(downPayment, price) Then
                                                                                 Return String.Format("{0:N2}", price)
                                                                             End If
                                                                         End If
                                                                         Return ""
                                                                     End Function))
        file.PlaceHolders.Add(New DocumentPlaceHolder("BALANCE", Function(data As JObject)
                                                                     Dim contractPrice = data.SelectToken("DealSheet.ContractOrMemo.contractPrice")
                                                                     Dim downPayment = data.SelectToken("DealSheet.ContractOrMemo.downPayment")
                                                                     If contractPrice IsNot Nothing AndAlso downPayment IsNot Nothing Then
                                                                         Dim cPrice = contractPrice.ToString
                                                                         If cPrice.Contains("$") Then
                                                                             cPrice = cPrice.Replace("$", "")
                                                                         End If

                                                                         Dim dPrice = downPayment.ToString
                                                                         If dPrice.Contains("$") Then
                                                                             dPrice = dPrice.Replace("$", "")
                                                                         End If

                                                                         Dim balance = CDec(cPrice) - CDec(dPrice)
                                                                         Return String.Format("{0:N2}", balance)
                                                                     End If
                                                                     Return ""
                                                                 End Function))
        file.PlaceHolders.Add(New DocumentPlaceHolder("SELLER2NAME", "DealSheet.ContractOrMemo.Sellers[1].Name"))
        file.PlaceHolders.Add(New DocumentPlaceHolder("SELLER3NAME", "DealSheet.ContractOrMemo.Sellers[2].Name"))
        file.PlaceHolders.Add(New DocumentPlaceHolder("SELLERATTORNEY", "DealSheet.ContractOrMemo.Sellers[0].sellerAttorneyObj.Name"))
        file.PlaceHolders.Add(New DocumentPlaceHolder("SELLERATTORNEYADDRESS", "DealSheet.ContractOrMemo.Sellers[0].sellerAttorneyObj.Office"))
        file.PlaceHolders.Add(New DocumentPlaceHolder("SELLERATTORNEYTEL", "DealSheet.ContractOrMemo.Sellers[0].sellerAttorneyObj.OfficeNO"))
        file.PlaceHolders.Add(New DocumentPlaceHolder("SELLERATTORNEYFAX", "DealSheet.ContractOrMemo.Sellers[0].sellerAttorneyObj.Fax"))

        file.PlaceHolders.Add(New DocumentPlaceHolder("BUYERATTORNEY", "DealSheet.ContractOrMemo.Buyer.buyerAttorneyObj.Name"))
        file.PlaceHolders.Add(New DocumentPlaceHolder("BUYERATTORNEYADDRESS", "DealSheet.ContractOrMemo.Buyer.buyerAttorneyObj.Office"))
        file.PlaceHolders.Add(New DocumentPlaceHolder("BUYERATTORNEYTEL", "DealSheet.ContractOrMemo.Buyer.buyerAttorneyObj.OfficeNO"))
        file.PlaceHolders.Add(New DocumentPlaceHolder("BUYERATTORNEYFAX", "DealSheet.ContractOrMemo.Buyer.buyerAttorneyObj.Fax"))
        _fileConfigures.Add(file)

        'Deed 
        file = New GenerateFileConfig With {.FileName = "BargainandSaleDeedwithCovenants.docx", .ConfigKey = "Deed"}
        phs = {
            New DocumentPlaceHolder("DAY"),
            New DocumentPlaceHolder("MONTH"),
            New DocumentPlaceHolder("YEAR"),
            New DocumentPlaceHolder("BLOCK"),
            New DocumentPlaceHolder("LOT"),
            New DocumentPlaceHolder("SELLERNAMES", Function(data As JObject)
                                                       Dim names = data.SelectToken("DealSheet.Deed.Sellers").Select(Function(s) s.SelectToken("Name").ToString).Where(Function(s) Not String.IsNullOrEmpty(s)).ToArray
                                                       Return String.Join(" & ", names)
                                                   End Function),
            New DocumentPlaceHolder("SELLERADDRESS", "DealSheet.Deed.Sellers[0].Address"),
            New DocumentPlaceHolder("BUYERNAME", "DealSheet.Deed.Buyer.CorpName"),
            New DocumentPlaceHolder("BUYERADDRESS", "DealSheet.Deed.Buyer.Address"),
            New DocumentPlaceHolder("PROPERTYADDRESS", "DealSheet.Deed.PropertyAddress"),
            New DocumentPlaceHolder("SELLER1NAME", "DealSheet.Deed.Sellers[0].Name"),
            New DocumentPlaceHolder("SELLER2NAME", "DealSheet.Deed.Sellers[1].Name")
            }
        file.PlaceHolders = phs.ToList
        _fileConfigures.Add(file)

        'Correction deed
        file = New GenerateFileConfig With {.FileName = "SaleDeedwithCovenantsCorrection.docx", .ConfigKey = "CorrectionDeed"}
        phs = {
            New DocumentPlaceHolder("DAY"),
            New DocumentPlaceHolder("MONTH"),
            New DocumentPlaceHolder("YEAR"),
            New DocumentPlaceHolder("BLOCK"),
            New DocumentPlaceHolder("LOT"),
            New DocumentPlaceHolder("SELLERNAMES", Function(data As JObject)
                                                       Dim names = data.SelectToken("DealSheet.CorrectionDeed.Sellers").Select(Function(s) s.SelectToken("Name").ToString).Where(Function(s) Not String.IsNullOrEmpty(s)).ToArray
                                                       Return String.Join(" & ", names)
                                                   End Function),
            New DocumentPlaceHolder("SELLERADDRESS", "DealSheet.CorrectionDeed.Sellers[0].Address"),
            New DocumentPlaceHolder("BUYERNAME", "DealSheet.CorrectionDeed.Buyers[0].Name"),
            New DocumentPlaceHolder("BUYERADDRESS", "DealSheet.CorrectionDeed.Buyers[0].Address"),
            New DocumentPlaceHolder("PROPERTYADDRESS", "DealSheet.CorrectionDeed.PropertyAddress"),
            New DocumentPlaceHolder("SELLER1NAME", "DealSheet.CorrectionDeed.Sellers[0].Name"),
            New DocumentPlaceHolder("SELLER2NAME", "DealSheet.CorrectionDeed.Sellers[1].Name")
            }
        file.PlaceHolders = phs.ToList
        _fileConfigures.Add(file)

        ' POA File
        file = New GenerateFileConfig With {.FileName = "PowerofAttorney.docx", .ConfigKey = "POA"}
        phs = {
                New DocumentPlaceHolder("DAY"),
                New DocumentPlaceHolder("MONTH"),
                New DocumentPlaceHolder("GIVINGPOANAME", "DealSheet.GivingPOA.Name"),
                New DocumentPlaceHolder("GIVINGPOAADDRESS", "DealSheet.GivingPOA.Address"),
                New DocumentPlaceHolder("RECEIVINGPOANAME", "DealSheet.ReceivingPOA.name"),
                New DocumentPlaceHolder("RECEIVINGPOAADDRESS", "DealSheet.ReceivingPOA.address")
            }
        file.PlaceHolders = phs.ToList
        _fileConfigures.Add(file)

        ' ShortSale PDF Package
        'file = New GenerateFileConfig With {.FileName = "ShortSalePackage.pdf", .ConfigKey = "ShortSalePackage", .Type = GenerateFileConfig.FileType.Pdf}
        'phs = {
        '       New DocumentPlaceHolder("Property Address", "PropertyAddress")
        '    }
        'file.PlaceHolders = phs.ToList
        '_fileConfigures.Add(file)

        ' ShortSale Package
        file = New GenerateFileConfig With {.FileName = "ShortSalePackage.docx", .ConfigKey = "ShortSale"}
        phs = {New DocumentPlaceHolder("PROPERTYADDRESS", "PropertyAddress")}
        file.PlaceHolders = phs.ToList

        ' Add Seller
        Dim sellerProps = {"Name", "SSN|SSN", "Address", "DOB", "Email", "Phone|Phone",
                           "Employed", "Bankaccount|YesNo", "TaxReturn|YesNo", "Bankruptcy|YesNo", "ActiveMilitar|YesNo"}
        For i = 0 To 3
            For Each item In sellerProps
                Dim data = item.Split("|")
                Dim prop = data(0)
                Dim place = String.Format("SELLER{0}{1}", i + 1, prop.ToUpper)
                Dim holder = String.Format("SsCase.PropertyInfo.Owners[{0}].{1}", i, prop)
                Dim ph = New DocumentPlaceHolder(place, holder)

                If data.Count > 1 Then
                    ph.Format = data(1)
                End If

                file.PlaceHolders.Add(ph)
            Next

            'phs = {
            '        New DocumentPlaceHolder(String.Format("SELLER{0}NAME", i + 1),
            '                                String.Format("SsCase.PropertyInfo.Owners[0].Name", i)),
            '        New DocumentPlaceHolder("SELLER1SSN", "SsCase.PropertyInfo.Owners[0].SSN"),
            '        New DocumentPlaceHolder("SELLER1ADDRESS", "SsCase.PropertyInfo.Owners[0].Address"),
            '        New DocumentPlaceHolder("SELLER1DOB", "SsCase.PropertyInfo.Owners[0].DOB"),
            '        New DocumentPlaceHolder("SELLER1EMAIL", "SsCase.PropertyInfo.Owners[0].Email"),
            '        New DocumentPlaceHolder("SELLER1PHONE", "SsCase.PropertyInfo.Owners[0].Phone"),
            '        New DocumentPlaceHolder("SELLER1EMPLOYED", "SsCase.PropertyInfo.Owners[0].Employed"),
            '        New DocumentPlaceHolder("SELLER1BANKACCOUNT", "SsCase.PropertyInfo.Owners[0].Bankaccount"),
            '        New DocumentPlaceHolder("SELLER1TAXRETURNS", "SsCase.PropertyInfo.Owners[0].TaxReturn"),
            '        New DocumentPlaceHolder("SELLER1BANKRUPTCY", "SsCase.PropertyInfo.Owners[0].Bankruptcy"),
            '        New DocumentPlaceHolder("SELLER1MILITARY", "SsCase.PropertyInfo.Owners[0].ActiveMilitar")
            '    }
            'file.PlaceHolders.AddRange(phs.ToList)
        Next

        ' Add mortgage
        Dim mortProps = {"LenderName", "Loan", "LoanAmount|Currency"}

        For i = 0 To 3
            For Each item In mortProps
                Dim data = item.Split("|")
                Dim prop = data(0)
                Dim place = String.Format("MORTGAGE{0}{1}", i + 1, prop.ToUpper)
                Dim holder = String.Format("SsCase.Mortgages[{0}].{1}", i, prop)
                Dim ph = New DocumentPlaceHolder(place, holder)

                If data.Count > 1 Then
                    ph.Format = data(1)
                End If

                file.PlaceHolders.Add(ph)
            Next
        Next

        ' Add Referral info
        file.PlaceHolders.Add(New DocumentPlaceHolder("REFERRALOFFICE", "assignCrop.Name"))
        file.PlaceHolders.Add(New DocumentPlaceHolder("REFERRALAGENT", Function(data As JObject)
                                                                           Dim bble = data.SelectToken("BBLE")
                                                                           If bble IsNot Nothing Then
                                                                               Dim ld = Lead.GetInstance(bble.ToString)
                                                                               If ld IsNot Nothing Then
                                                                                   Return ld.EmployeeName
                                                                               End If
                                                                           End If
                                                                           Return ""
                                                                       End Function))

        file.PlaceHolders.Add(New DocumentPlaceHolder("REFERRALATTORNEY", "DealSheet.ContractOrMemo.Sellers[0].sellerAttorney"))
        file.PlaceHolders.Add(New DocumentPlaceHolder("REFERRALATTORNEYNUM", "DealSheet.ContractOrMemo.Sellers[0].sellerAttorneyObj.Cell"))
        ' Add buyer info
        file.PlaceHolders.Add(New DocumentPlaceHolder("BUYERNAME", "DealSheet.ContractOrMemo.Buyer.CorpName"))
        file.PlaceHolders.Add(New DocumentPlaceHolder("BUYERSIGNER", "DealSheet.ContractOrMemo.Buyer.Signer"))
        file.PlaceHolders.Add(New DocumentPlaceHolder("BUYERFORMATIONDATE", "DealSheet.ContractOrMemo.Buyer.FillingDate|Date"))
        file.PlaceHolders.Add(New DocumentPlaceHolder("BUYERADDRESS", "DealSheet.ContractOrMemo.Buyer.Address"))
        file.PlaceHolders.Add(New DocumentPlaceHolder("BUYERATTORNEY", "DealSheet.ContractOrMemo.Buyer.buyerAttorney"))
        file.PlaceHolders.Add(New DocumentPlaceHolder("BUYERATTORNEYNUM", "DealSheet.ContractOrMemo.Buyer.buyerAttorneyObj.Cell"))
        file.PlaceHolders.Add(New DocumentPlaceHolder("TODAY"))
        file.PlaceHolders.Add(New DocumentPlaceHolder("BLOCK"))
        file.PlaceHolders.Add(New DocumentPlaceHolder("LOT"))
        file.PlaceHolders.Add(New DocumentPlaceHolder("DAY"))
        file.PlaceHolders.Add(New DocumentPlaceHolder("MONTH"))
        file.PlaceHolders.Add(New DocumentPlaceHolder("SELLERNAMES", Function(data As JObject)
                                                                         Dim names = data.SelectToken("DealSheet.ContractOrMemo.Sellers").Select(Function(s) s.SelectToken("Name").ToString).Where(Function(s) Not String.IsNullOrEmpty(s)).ToArray
                                                                         Return String.Join(" & ", names)
                                                                     End Function))
        _fileConfigures.Add(file)

        'Acris info
        file = New GenerateFileConfig With {.FileName = "AcrisPreparing.docx", .ConfigKey = "Acris"}
        phs = {
                New DocumentPlaceHolder("PROPERTYADDRESS", "PropertyAddress"),
                New DocumentPlaceHolder("BLOCK"),
                New DocumentPlaceHolder("LOT"),
                New DocumentPlaceHolder("SELLER1NAME", "DealSheet.ContractOrMemo.Sellers[0].Name"),
                New DocumentPlaceHolder("SELLER2NAME", "DealSheet.ContractOrMemo.Sellers[1].Name"),
                New DocumentPlaceHolder("SELLER3NAME", "DealSheet.ContractOrMemo.Sellers[2].Name"),
                New DocumentPlaceHolder("SELLERADDRESS", "DealSheet.ContractOrMemo.Sellers[0].Address"),
                New DocumentPlaceHolder("OWNEREMAIL", "DealSheet.ContractOrMemo.Sellers[0].Email"),
                New DocumentPlaceHolder("BUYERNAME", "DealSheet.ContractOrMemo.Buyer.CorpName"),
                New DocumentPlaceHolder("BUYERNAMESIGNER", "DealSheet.ContractOrMemo.Buyer.Signer"),
                New DocumentPlaceHolder("BUYERADDRESS", "DealSheet.ContractOrMemo.Buyer.Address")
            }
        file.PlaceHolders = phs.ToList
        _fileConfigures.Add(file)
    End Sub

    ''' <summary>
    ''' Load placeholder value
    ''' </summary>
    ''' <param name="ph">The Placeholder value</param>
    ''' <returns></returns>
    Public Function GetValue(ph As DocumentPlaceHolder) As String
        Select Case ph.Type
            Case DocumentPlaceHolder.ValueType.Predefined
                Return PredefinedValue(ph.FieldName)
            Case DocumentPlaceHolder.ValueType.JSON
                Dim field = Me.Data.SelectToken(ph.ValueField)
                If field IsNot Nothing Then
                    Select Case ph.Format
                        Case "YesNo"
                            Dim result As Boolean = False
                            If Boolean.TryParse(field.ToString, result) Then
                                If result Then
                                    Return "Yes"
                                Else
                                    Return "No"
                                End If
                            End If

                            Return field.ToString
                        Case "Currency"
                            Dim result = 0
                            If Decimal.TryParse(field.ToString, result) Then
                                Return String.Format("{0:N2}", result)
                            End If
                            Return field.ToString
                        Case "Date"
                            Dim result As DateTime
                            If DateTime.TryParse(field.ToString, result) Then
                                Return String.Format("{0:d}", result)
                            End If

                            Return field.ToString
                        Case "SSN"
                            Dim result = field.ToString
                            If result.Length = 9 Then
                                Return String.Format("{0}-{1}-{2}", result.Substring(0, 3), result.Substring(3, 2), result.Substring(5))
                            End If

                        Case "Phone"
                            Return Utility.FormatPhone(field.ToString)
                    End Select

                    Return field.ToString
                End If

                Return ""
            Case DocumentPlaceHolder.ValueType.FixedString
                Return ph.ValueField
            Case DocumentPlaceHolder.ValueType.Custom
                Return ph.CustomFunction.Invoke(Data)
            Case Else
                Return Nothing
        End Select
    End Function

    Private _predefinedValues As Dictionary(Of String, String)

    Private ReadOnly Property PredefinedValue() As Dictionary(Of String, String)
        Get
            If _predefinedValues Is Nothing Then
                _predefinedValues = New Dictionary(Of String, String)
                Dim td = DateTime.Today
                _predefinedValues.Add("DAY", td.Day)
                _predefinedValues.Add("MONTH", MonthName(td.Month))
                _predefinedValues.Add("YEAR", td.Year)
                _predefinedValues.Add("DATE", String.Format("{0:M}", td))
                _predefinedValues.Add("TODAY", String.Format("{0:d}", td))

                If Not String.IsNullOrEmpty(BBLE) Then

                    Dim li = LeadsInfo.GetInstance(BBLE)
                    If li IsNot Nothing Then
                        _predefinedValues.Add("BLOCK", li.Block)
                        _predefinedValues.Add("LOT", li.Lot)
                    End If
                End If
            End If

            Return _predefinedValues
        End Get
    End Property
End Class

''' <summary>
''' The document configuration object
''' </summary>
Public Class GenerateFileConfig
    ''' <summary>
    ''' The config key
    ''' </summary>
    ''' <returns></returns>
    Public Property ConfigKey As String
    ''' <summary>
    ''' The file name
    ''' </summary>
    ''' <returns></returns>
    Public Property FileName As String
    ''' <summary>
    ''' The related place holders
    ''' </summary>
    ''' <returns></returns>
    Public Property PlaceHolders As List(Of DocumentPlaceHolder)
    ''' <summary>
    ''' The file tag data
    ''' </summary>
    ''' <returns></returns>
    Public Property TagData As String
    ''' <summary>
    ''' the file content type
    ''' </summary>
    ''' <returns></returns>
    Public Property Type As FileType

    ''' <summary>
    ''' The content type
    ''' </summary>
    Public Enum FileType
        Word
        Pdf
    End Enum
End Class

''' <summary>
''' The placeholder object
''' </summary>
Public Class DocumentPlaceHolder
    ''' <summary>
    ''' Create predefined placeholder
    ''' </summary>
    ''' <param name="name">Predefined holder name</param>
    Public Sub New(name As String)
        Me.FieldName = name
        Me.Type = ValueType.Predefined
    End Sub

    ''' <summary>
    ''' Create JSON placeholder
    ''' </summary>
    ''' <param name="name">The field name</param>
    ''' <param name="value">The JOSN value and format data: [jsonvalue|format]</param>
    Public Sub New(name As String, value As String)
        Me.FieldName = name
        Me.Type = ValueType.JSON

        Dim data = value.Split("|")
        Me.ValueField = data(0)

        If data.Count > 1 Then
            Me.Format = data(1)
        End If
    End Sub

    ''' <summary>
    ''' The placeholder with specific value type
    ''' </summary>
    ''' <param name="name">The field name</param>
    ''' <param name="value">The value</param>
    ''' <param name="type">The value type </param>
    Public Sub New(name As String, value As String, type As ValueType)
        Me.FieldName = name
        Me.ValueField = value
        Me.Type = type
    End Sub

    ''' <summary>
    ''' The placeholder with custom function
    ''' </summary>
    ''' <param name="name">The field name</param>
    ''' <param name="customeFun">The custom function</param>
    Public Sub New(name As String, customeFun As Func(Of Object, String))
        Me.FieldName = name
        Me.Type = ValueType.Custom
        Me.CustomFunction = customeFun
    End Sub

    ''' <summary>
    ''' The field name
    ''' </summary>
    ''' <returns></returns>
    Public Property FieldName As String
    ''' <summary>
    ''' The value fields 
    ''' </summary>
    ''' <returns></returns>
    Public Property ValueField As String
    ''' <summary>
    ''' The custom format
    ''' </summary>
    ''' <returns></returns>
    Public Property ValueFormat As String
    ''' <summary>
    ''' The value type
    ''' </summary>
    ''' <returns></returns>
    Public Property Type As ValueType
    ''' <summary>
    ''' The format info
    ''' </summary>
    ''' <returns></returns>
    Public Property Format As String
    ''' <summary>
    ''' The custom function to provide the placeholder data
    ''' </summary>
    ''' <returns></returns>
    Public Property CustomFunction As Func(Of Object, String)

    ''' <summary>
    ''' The value type enum
    ''' </summary>
    Public Enum ValueType
        JSON
        Predefined
        FixedString
        Custom
    End Enum
End Class