Imports DevExpress.Web
Imports System.IO
Imports System.Threading
Imports System.Web.Script.Serialization
Imports System.Reflection

Public Class LeadsDataManage
    Inherits System.Web.UI.Page

    Private Const UploadDirectory As String = "~/TempDataFile/"
    Private Const DataFileName As String = "tempDataFile.xlsx"
    Const KEY As String = "DataService"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            cbEmployee.DataSource = Employee.GetAllEmps()
            cbEmployee.DataBind()
        End If
    End Sub

    Protected Sub uplImage_FileUploadComplete(sender As Object, e As DevExpress.Web.FileUploadCompleteEventArgs) Handles uplImage.FileUploadComplete
        e.CallbackData = SavePostedFile(e.UploadedFile)
    End Sub

    Private Function SavePostedFile(ByVal uploadedFile As UploadedFile) As String
        'Dim bble = Request.QueryString("b").ToString

        If (Not uploadedFile.IsValid) Then
            Return String.Empty
        End If
        Dim fileName As String = Path.Combine(MapPath(UploadDirectory), uploadedFile.FileName)
        uploadedFile.SaveAs(fileName)
        Return uploadedFile.FileName
    End Function

    Protected Sub gridLeadsData_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs)
        Dim fileName = e.Parameters
        ImportLeads(LoadDataFromExcel(fileName))
        gridLeadsData.DataBind()
    End Sub

    Protected Sub gridLeadsData_RowUpdating(sender As Object, e As DevExpress.Web.Data.ASPxDataUpdatingEventArgs)
        Using Context As New Entities
            Dim prop = Context.Agent_Properties.Find(e.Keys("ID"))

            If prop IsNot Nothing Then
                prop.Type = e.NewValues("Type")
                prop.Agent_Name = e.NewValues("Agent_Name")
                prop.ScheduleDate = e.NewValues("ScheduleDate")

                Context.SaveChanges()
            End If
        End Using

        e.Cancel = True
    End Sub

    Protected Sub gridLeadsData_DataBinding(sender As Object, e As EventArgs)
        If gridLeadsData.DataSource Is Nothing Then
            Using Context As New Entities
                gridLeadsData.DataSource = Context.Agent_Properties.Where(Function(ap) ap.BBLE IsNot Nothing And (ap.Active = True Or Not ap.Active.HasValue)).ToList
            End Using
        End If
    End Sub

    Protected Sub gridNewLeads_DataBinding(sender As Object, e As EventArgs) Handles gridNewLeads.DataBinding
        If gridNewLeads.DataSource Is Nothing Then
            Dim dataservice = LeadsDataService.GetInstance

            If cbLeadsType.Text = "Employee" Then
                gridNewLeads.DataSource = dataservice.LeadDataSource(cbEmployee.Text)
            Else
                gridNewLeads.DataSource = dataservice.LeadDataSource(cbLeadsType.Text)
            End If
        End If
    End Sub

    Protected Sub gridNewLeads_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridViewCustomCallbackEventArgs)
        gridNewLeads.DataBind()
    End Sub

    Protected Sub callBackService_Callback(source As Object, e As DevExpress.Web.CallbackEventArgs)
        If e.Parameter.StartsWith("Start") Then
            StartService()
        End If

        If e.Parameter.StartsWith("Stop") Then
            LeadsDataService.GetInstance().StopService()
        End If

        If e.Parameter.StartsWith("Loop") Then
            Dim type = e.Parameter.Split("|")(1)
            LeadsDataService.GetInstance.DataLoop(type)
        End If

        If e.Parameter.StartsWith("GeneralInfoLoop") Then
            Dim type = e.Parameter.Split("|")(1)
            LeadsDataService.GetInstance.DataLoop(type, True)
        End If

        If e.Parameter.StartsWith("ServicerLoop") Then
            Dim type = e.Parameter.Split("|")(1)
            LeadsDataService.GetInstance.DataLoop(type, False, True)
        End If
    End Sub

    Protected Sub callbackLogs_Callback(source As Object, e As DevExpress.Web.CallbackEventArgs) Handles callbackLogs.Callback
        Dim leadsDs = LeadsDataService.GetInstance()
        Dim logs = UserMessage.GetUserMessages(KEY)

        For Each log In logs
            UserMessage.ReadMsg(log.UserName, log.MsgID)
        Next
        e.Result = JSONString(logs)
    End Sub

    Protected Sub checkProgress_Callback(source As Object, e As DevExpress.Web.CallbackEventArgs)
        Dim leadsDs = LeadsDataService.GetInstance()
        e.Result = JSONString(leadsDs)
    End Sub

    Sub StartService()
        Dim ds = LeadsDataService.GetInstance()
        ds.Start()
    End Sub

    Function JSONString(obj As Object)
        Dim json As New JavaScriptSerializer
        Return json.Serialize(obj)
    End Function

    Sub ImportLeads(dt As DataTable)
        Using Context As New Entities
            For Each dr As DataRow In dt.Rows
                Dim prop As New Agent_Properties
                If Not IsDBNull(dr("BBLE")) Then
                    prop.BBLE = dr("BBLE")

                    If Not IsDBNull(dr("Agent")) Then
                        prop.Agent_Name = dr("Agent")
                    End If

                    If Not IsDBNull(dr("Type")) Then
                        prop.Type = dr("Type")
                    End If

                    If Not IsDBNull(dr("Schedule")) Then
                        prop.ScheduleDate = CDate(dr("Schedule"))
                    End If

                    prop.Active = True

                    Context.Agent_Properties.Add(prop)
                End If
            Next

            Context.SaveChanges()
        End Using
    End Sub

    Function LoadDataFromExcel(fileName As String) As DataTable
        Dim cn As System.Data.OleDb.OleDbConnection
        Dim cmd As System.Data.OleDb.OleDbDataAdapter
        Dim fullName = Path.Combine(MapPath(UploadDirectory), fileName)
        cn = New System.Data.OleDb.OleDbConnection(String.Format("provider=Microsoft.ACE.OLEDB.12.0;" & "data source={0};Extended Properties=Excel 12.0;", fullName))
        ' Select the data from Sheet1 of the workbook.
        cmd = New System.Data.OleDb.OleDbDataAdapter("select * from [Sheet1$]", cn)
        cn.Open()
        Dim dt As New DataTable
        cmd.Fill(dt)
        cn.Close()
        Return dt
    End Function

    Public Class LeadsDataService
        Private Sub New()
        End Sub

        'Const KEY As String = "DataService"
        Shared appStatus As HttpApplicationState
        Private Property ThreadPool As New List(Of Thread)

        Private _status As ServiceStatus = ServiceStatus.Stoped
        Public Property Status As ServiceStatus
            Get
                Return _status
            End Get
            Set(value As ServiceStatus)
                _status = value
                Save()
            End Set
        End Property

        Public ReadOnly Property StatusString As String
            Get
                Return _status.ToString
            End Get
        End Property


        Public Property TotalCount As Integer
        Public Property CurrentIndex As Integer

        Private Property LeadsData As List(Of Agent_Properties)

        Public Shared Function GetInstance() As LeadsDataService
            If HttpContext.Current IsNot Nothing Then
                Return GetInstance(HttpContext.Current.Application)
            End If

            Throw New Exception("HttpContext.Current is nothing")
        End Function

        Public Shared Function GetInstance(app As HttpApplicationState) As LeadsDataService
            appStatus = app
            If appStatus(KEY) Is Nothing Then
                appStatus.Lock()
                appStatus(KEY) = New LeadsDataService
                appStatus.UnLock()
            End If
            Return CType(appStatus(KEY), LeadsDataService)
        End Function

        Public Sub Start()
            Status = ServiceStatus.Runing
            AssginLeads()
            DataLoop("New")
        End Sub

        Public Sub Suspend()
            Status = ServiceStatus.Suspend

            If ThreadPool.Count > 0 Then
                For Each th In ThreadPool
                    If th.IsAlive Then
                        th.Abort()
                    End If
                Next
            End If
        End Sub

        Public Sub StopService()
            Status = ServiceStatus.Stoped

            If ThreadPool.Count > 0 Then
                For Each th In ThreadPool
                    If th.IsAlive Then
                        th.Abort()
                    End If
                Next
            End If

        End Sub

        Public Function LeadDataSource(type As String) As List(Of LeadsInfo)
            Dim newLeads As New List(Of LeadsInfo)
            Using Context As New Entities

                Select Case type
                    Case ""
                        newLeads = Context.LeadsInfoes.ToList
                    Case "Unassign"
                        newLeads = Context.LeadsInfoes.Where(Function(ld) ld.Lead Is Nothing).ToList
                    Case "New"
                        newLeads = Context.LeadsInfoes.Where(Function(ld) String.IsNullOrEmpty(ld.PropertyAddress)).ToList
                    Case "HomeOwner"
                        newLeads = Context.LeadsInfoes.Where(Function(ld) String.IsNullOrEmpty(ld.Owner)).ToList
                    Case "MotgrAmt"
                        newLeads = Context.LeadsInfoes.Where(Function(ld) ld.C1stMotgrAmt Is Nothing).OrderByDescending(Function(ld) ld.CreateDate).ToList
                    Case "Existed"
                        newLeads = Context.LeadsInfoes.Where(Function(ld) Not String.IsNullOrEmpty(ld.Owner)).ToList
                    Case Else
                        newLeads = (From li In Context.LeadsInfoes
                                   Join ld In Context.Leads On ld.BBLE Equals li.BBLE
                                   Where ld.EmployeeName = type
                                   Select li).ToList
                End Select
            End Using
            Return newLeads
        End Function

        Public Sub DataLoop(datatype As String, Optional onlyGeneralInfo As Boolean = False, Optional servicer As Boolean = False)
            UserMessage.AddNewMessage("Service Message", "Data Loop", "Data loop start. Type: " & datatype, "", DateTime.Now, KEY)
            Dim bbles = LeadDataSource(datatype).Select(Function(b) b.BBLE).ToArray

            If Not Status = ServiceStatus.InLoop Then
                Status = ServiceStatus.InLoop
                Dim ctx = HttpContext.Current
                TotalCount = bbles.Count
                CurrentIndex = 0

                ThreadPool.Clear()

                For i = 0 To 1
                    Dim TestThread As New System.Threading.Thread(New ThreadStart(Sub()
                                                                                      HttpContext.Current = ctx
                                                                                      InitialData(bbles, onlyGeneralInfo, servicer)
                                                                                  End Sub))
                    ThreadPool.Add(TestThread)
                    TestThread.Start()
                Next
            End If
        End Sub

        Public Sub InitialData(bbles As String(), Optional onlyGeneralInfo As Boolean = False, Optional OnlyServicer As Boolean = False)
            Dim count = 0

            While count < bbles.Length

                'count = CInt(appState("Proces
                'appState("Processed") = count + 1
                'appState.UnLock()
                count = CurrentIndex
                CurrentIndex = count + 1

                If count >= bbles.Length Then
                    Continue While
                End If

                Dim bble = bbles(count)
                Dim attemps = 0
InitialLine:
                attemps += 1
                Try
                    'check if server is busy
                    While DataWCFService.IsServerBusy
                        Thread.Sleep(30000)
                    End While

                    If OnlyServicer Then
                        DataWCFService.UpdateServicer(bble)
                        DataWCFService.UpdateTaxLiens(bble)
                        UserMessage.AddNewMessage("Service Message", "Initial Data Message " & bble, String.Format("Servicer info and Taxlien BBLE: {0} data is Update. ", bble), bble, DateTime.Now, KEY)
                        Continue While
                    End If

                    If onlyGeneralInfo Then
                        DataWCFService.UpdateAssessInfo(bble)
                        UserMessage.AddNewMessage("Service Message", "Initial Data Message " & bble, String.Format("General info BBLE: {0} data is Update. ", bble), bble, DateTime.Now, KEY)
                        Continue While
                    End If

                    Dim lead = LeadsInfo.GetInstance(bble)
                    If String.IsNullOrEmpty(lead.Owner) Then
                        If DataWCFService.UpdateLeadInfo(bble, True, True, True, True, True, False, True) Then
                            UserMessage.AddNewMessage("Service Message", "Initial Data Message " & bble, String.Format("All BBLE: {0} data is loaded. ", bble), bble, DateTime.Now, KEY)
                        End If
                    Else
                        If Not lead.C1stMotgrAmt.HasValue Then
                            If DataWCFService.UpdateLeadInfo(bble, False, True, True, True, True, False, True) Then
                                UserMessage.AddNewMessage("Service Message", "Initial Data Message " & bble, String.Format("BBLE: {0} Morgatage data is loaded. ", bble), bble, DateTime.Now, KEY)
                            End If
                        Else
                            If lead.IsUpdating Then
                                If DataWCFService.UpdateLeadInfo(bble, False, True, True, True, True, False, True) Then
                                    UserMessage.AddNewMessage("Service Message", "Initial Data Message " & bble, String.Format("Refresh BBLE: {0} data is Finished. ", bble), bble, DateTime.Now, KEY)
                                End If
                            Else
                                If Not lead.HasOwnerInfo Then
                                    If DataWCFService.UpdateLeadInfo(bble, False, False, False, False, False, False, True) Then
                                        UserMessage.AddNewMessage("Service Message", "Initial Data Message " & bble, String.Format("Refresh BBLE: {0} homeowner info is finished.", bble), bble, DateTime.Now, KEY)
                                    End If
                                End If
                            End If
                        End If
                    End If
                    'Thread.Sleep(1000)
                Catch ex As Exception
                    UserMessage.AddNewMessage("Service Error", "Initial Data Error " & bble & " Attemps: " & attemps, "Error: " & ex.Message & " StackTrace: " & ex.StackTrace, bble, DateTime.Now, KEY)
                    Select Case attemps
                        Case 1
                            Thread.Sleep(30000)
                        Case 2
                            Thread.Sleep(60000)
                        Case 3
                            Thread.Sleep(300000)
                        Case Else
                            Thread.Sleep(1000000)
                    End Select

                    GoTo InitialLine
                End Try
            End While

            Status = ServiceStatus.LoopFinish
        End Sub

        Public Sub Save()
            appStatus.Lock()
            appStatus(KEY) = Me
            appStatus.UnLock()
        End Sub

        Private Sub LoadLeadsData()

            Using Context As New Entities
                LeadsData = Context.Agent_Properties.Where(Function(ap) ap.BBLE IsNot Nothing And (ap.Active = True Or Not ap.Active.HasValue) And (ap.ScheduleDate Is Nothing Or ap.ScheduleDate < DateTime.Now)).ToList
            End Using
            UserMessage.AddNewMessage("Service Message", "Load Leads Data finish. Total count: " + LeadsData.Count, "Load Leads Data", "", DateTime.Now, KEY)
        End Sub

        Private Sub AssginLeads()
            UserMessage.AddNewMessage("Service Message", "AssignLeads Start", "AssignLeads start.", "", DateTime.Now, KEY)
            Using Context As New Entities
                Dim count = 0
                For Each prop In Context.Agent_Properties.Where(Function(ap) ap.BBLE IsNot Nothing And (ap.Active = True Or Not ap.Active.HasValue) And (ap.ScheduleDate Is Nothing Or ap.ScheduleDate < DateTime.Now))
                    Try
                        Dim li = Context.LeadsInfoes.Where(Function(l) l.BBLE = prop.BBLE).SingleOrDefault
                        If li Is Nothing Then

                            li = New LeadsInfo
                            li.PropertyAddress = prop.Property_Address
                            li.BBLE = prop.BBLE
                            li.CreateBy = KEY
                            li.CreateDate = DateTime.Now

                            If Not String.IsNullOrEmpty(prop.Type) Then
                                li.Type = li.GetLeadsType(prop.Type)
                            End If

                            If Context.LeadsInfoes.Local.Where(Function(tmp) tmp.BBLE = li.BBLE).Count = 0 Then
                                Context.LeadsInfoes.Add(li)
                                count += 1
                            End If

                            If Not String.IsNullOrEmpty(prop.Agent_Name) Then
                                Dim emp = Employee.GetInstance(prop.Agent_Name)

                                If emp IsNot Nothing Then
                                    Dim newlead = Context.Leads.Where(Function(ld) ld.BBLE = prop.BBLE).SingleOrDefault
                                    If newlead Is Nothing Then
                                        newlead = New Lead() With {
                                                          .BBLE = prop.BBLE,
                                                          .LeadsName = li.LeadsName,
                                                          .Neighborhood = li.NeighName,
                                                          .EmployeeID = emp.EmployeeID,
                                                          .EmployeeName = emp.Name,
                                                          .Status = LeadStatus.NewLead,
                                                          .AssignDate = DateTime.Now,
                                                          .AssignBy = KEY
                                                          }

                                        If Context.Leads.Local.Where(Function(tmp) tmp.BBLE = prop.BBLE).Count = 0 Then
                                            Context.Leads.Add(newlead)
                                        End If
                                    End If
                                End If
                            End If
                        End If
                        prop.Active = False
                    Catch ex As Exception
                        UserMessage.AddNewMessage("Service Error", "Assign Leads Data", "Create Leadsinfo error. BBLE: " & prop.BBLE, "", DateTime.Now, KEY)
                    End Try
                Next
                Context.SaveChanges()
                UserMessage.AddNewMessage("Service Message", "Assign Leads Data End", "Assign Leads Data Finish. Total Leads Count: " & count, "", DateTime.Now, KEY)
            End Using
        End Sub

        Enum ServiceStatus
            Runing
            InLoop
            Stoped
            InError
            Suspend
            LoopFinish
        End Enum
    End Class

    Protected Sub LoadLeagl_Click(sender As Object, e As EventArgs)
        BindgridLegalCase()
    End Sub

    Protected Sub Button1_Click(sender As Object, e As EventArgs)
        For Each c In Data.LegalCase.GetAllCases()
            c.SaveData(Page.User.Identity.Name)
        Next
        BindgridLegalCase()
    End Sub
    Sub BindgridLegalCase()
        If (gridLegalCase.DataSource Is Nothing) Then
            gridLegalCase.DataSource = Data.LegalCase.GetAllCases()
            gridLegalCase.DataBind()
        End If
    End Sub
End Class