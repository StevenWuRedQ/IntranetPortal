Imports System.ComponentModel
Imports System.Globalization
Imports DevExpress.Web.ASPxHtmlEditor
Imports IntranetPortal

Public Enum LeadStatus
    NewLead = 0
    Priority = 1
    DoorKnocks = 2
    Callback = 3
    DeadEnd = 4
    InProcess = 5
    Task = 6
    Closed = 7
    Create = 10
    Deleted = 11
    MgrApproval = 12
    ALL = 13
    MgrApprovalInWf = 14
    Declined = 15
    Publishing = 16
    Published = 17
    LoanMod = 20
    Warmer = 21
End Enum

Public Class LeadSubStatus
    Inherits Status

    Public Shared Property LoanModInProcess As New LeadSubStatus With {
        .Key = 0, .Name = "LoanMod In Process"}
    Public Shared Property LoanModCompleted As New LeadSubStatus With {
        .Key = 1, .Name = "LoanMod Completed"}

    Public Shared Widening Operator CType(ByVal status As Integer) As LeadSubStatus
        Select Case status
            Case 0
                Return LoanModInProcess
            Case 1
                Return LoanModCompleted
        End Select

        Return New Status
    End Operator

    Public Shared Narrowing Operator CType(v As LeadSubStatus) As Integer
        Return v.Key
    End Operator
End Class

Public Class Status
    Protected Property Key As Integer
    Protected Property Name As String
    Protected Property DisplayName As String

    Public Overrides Function ToString() As String
        Return Name
    End Function
End Class

''' <summary>
''' The Portal Utility Class
''' </summary>
Public Class Utility

    ''' <summary>
    ''' Get leads status by status name
    ''' </summary>
    ''' <param name="cateName">The Status Name</param>
    ''' <returns></returns>
    Public Shared Function GetLeadStatus(cateName As String) As LeadStatus
        Dim category As Integer = LeadStatus.NewLead
        Select Case cateName
            Case "New Leads"
                category = LeadStatus.NewLead
            Case "Priority", "Hot Leads"
                category = LeadStatus.Priority
            Case "Door Knock"
                category = LeadStatus.DoorKnocks
            Case "Call Back", "Follow Up"
                category = LeadStatus.Callback
            Case "Dead Lead"
                category = LeadStatus.DeadEnd
            Case "In Process"
                category = LeadStatus.InProcess
            Case "Task"
                category = LeadStatus.Task
            Case "Closed"
                category = LeadStatus.Closed
            Case "Create" 'Save as new leads
                category = LeadStatus.NewLead
            Case Else
                If [Enum].TryParse(Of LeadStatus)(cateName, category) Then
                    Return category
                End If
        End Select

        For Each o In [Enum].GetValues(GetType(LeadStatus))
            If cateName.Equals(o.ToString) Then
                category = o
            End If
        Next

        Return category
    End Function

    Public Shared Function getLeadStatusByCode(statusCode As String) As LeadStatus
        Return CType([Enum].Parse(GetType(LeadStatus), statusCode), LeadStatus)
    End Function

    ''' <summary>
    ''' Convert enum type tp dictionary type
    ''' </summary>
    ''' <param name="cEnum">The enum type</param>
    ''' <returns>The dictionary type</returns>
    Public Shared Function Enum2Dictinary(cEnum As Type) As Dictionary(Of Integer, String)
        Dim VenderTypes = New Dictionary(Of Integer, String)

        Dim vals = [Enum].GetValues(cEnum)
        For Each v In vals
            VenderTypes.Add(CInt(v), Core.Utility.GetEnumDescription(v))
        Next
        Return VenderTypes
    End Function

    Public Shared Function GetLeadsCustomStatus() As LeadStatus()
        Dim vals = [Enum].GetValues(GetType(LeadStatus)).Cast(Of LeadStatus).Where(Function(l) l >= 20)
        Return vals.ToArray
    End Function

    ''' <summary>
    ''' Convert borough id (1,2,3,4,5) to borough name
    ''' </summary>
    ''' <param name="borough">The borough id</param>
    ''' <returns>The borough name</returns>
    Public Shared Function Borough2BoroughName(borough As String) As String
        Dim boroughName = "undefine borough"
        Dim arraryDic As New Dictionary(Of String, String)
        arraryDic.Add("1", "Manhattan")
        arraryDic.Add("2", "Bronx")
        arraryDic.Add("3", "Brooklyn")
        arraryDic.Add("4", "Queens")
        arraryDic.Add("5", "Staten Island")

        If (borough IsNot Nothing AndAlso arraryDic.Item(borough) IsNot Nothing) Then
            Return arraryDic.Item(borough)
        End If
        Return boroughName
    End Function

    Public Shared Function IsAny(Of T)(data As IEnumerable(Of T)) As Boolean
        Return data IsNot Nothing AndAlso data.Any()
    End Function

    ''' <summary>
    ''' Check if portal is on testing mode
    ''' </summary>
    ''' <returns></returns>
    Public Shared Function IsTesting() As Boolean
        Dim result = False
        If Boolean.TryParse(System.Configuration.ConfigurationManager.AppSettings("IsTesting"), result) Then
            Return result
        End If

        Return result
    End Function

    ''' <summary>
    ''' Return leads display name from leads info
    ''' </summary>
    ''' <param name="leadData">Leads Info</param>
    ''' <returns>Leads Display Name</returns>
    Public Shared Function GetLeadsName(leadData As LeadsInfo) As String
        Dim leadsName = ""

        If leadData IsNot Nothing AndAlso Not String.IsNullOrEmpty(leadData.PropertyAddress) Then
            If String.IsNullOrEmpty(leadData.Owner) Then
                Return leadData.PropertyAddress
            End If

            If Not String.IsNullOrEmpty(leadData.UnitNum) Then
                leadsName = String.Format("{0} {1} #{3} - {2}", leadData.Number, leadData.StreetName, leadData.Owner.TrimEnd, leadData.UnitNum)
            Else
                leadsName = String.Format("{0} {1} - {2}", leadData.Number, leadData.StreetName, leadData.Owner.TrimEnd)
            End If

            leadsName = leadsName.TrimStart(" ")

            If Not String.IsNullOrEmpty(leadData.CoOwner) AndAlso leadData.Owner.TrimStart.TrimEnd <> leadData.CoOwner.TrimStart.TrimEnd Then
                leadsName += "; " & leadData.CoOwner.TrimEnd
            End If
        End If

        Return leadsName
    End Function

    Public Shared Function HtmlBlackInfo(leadData As String) As String
        Dim symble = "-"

        Dim strArry As String() = leadData.Split(New Char() {symble})
        If strArry Is Nothing Or strArry.Length < 2 Then
            Return leadData
        End If
        Dim FontStr As String = ""
        Dim EndStr As String = ""

        FontStr = strArry(0)

        EndStr = strArry(1)

        If strArry.Length > 2 Then
            FontStr = FontStr + "-" + EndStr
            EndStr = strArry(2)
        End If

        Return String.Format("<span style=""font-weight: 900;"">{0}</span>-{1}", FontStr, EndStr)
        'Return "<span style=""font-weight: 900;""> 720 QUINCY ST</span> - " & leadData
    End Function

    ''' <summary>
    ''' Return count of employee's leads under certain status
    ''' </summary>
    ''' <param name="status">The Leads Status</param>
    ''' <param name="emp">The Employee Name</param>
    ''' <returns>The Count of Leads</returns>
    Public Shared Function GetLeadsCount(status As LeadStatus, emp As String) As Integer
        Using context As New Entities
            Return context.Leads.Where(Function(l) l.EmployeeName = emp And l.Status = status).Count
        End Using
    End Function

    Public Shared Function CreateCustomToolbar(ByVal name As String) As HtmlEditorToolbar
        Return New HtmlEditorToolbar(name,
                                     New ToolbarFontSizeEdit(),
                                     New ToolbarJustifyLeftButton(True),
                                     New ToolbarJustifyCenterButton(),
                                     New ToolbarJustifyRightButton(),
                                     New ToolbarJustifyFullButton(),
                                     New ToolbarBoldButton(),
                                     New ToolbarItalicButton(),
                                     New ToolbarUnderlineButton(),
                                     New ToolbarBackColorButton(),
                                     New ToolbarFontColorButton()).CreateDefaultItems()
    End Function

    ''' <summary>
    ''' Get leads count of multiple employees under the given status
    ''' </summary>
    ''' <param name="status">Leads Status</param>
    ''' <param name="emp">The Employee list</param>
    ''' <returns></returns>
    Public Shared Function GetMgrLeadsCount(status As LeadStatus, emp As String()) As Integer
        Using context As New Entities
            If status = LeadStatus.ALL Then
                Return context.Leads.Where(Function(l) emp.Contains(l.EmployeeName)).Count
            End If

            Return context.Leads.Where(Function(l) emp.Contains(l.EmployeeName) And l.Status = status).Count
        End Using
    End Function

    ''' <summary>
    ''' Get the count of leads under given status and office/team
    ''' </summary>
    ''' <param name="status">The leads status</param>
    ''' <param name="officeName">Office/Team Name</param>
    ''' <returns></returns>
    Public Shared Function GetOfficeLeadsCount(status As LeadStatus, officeName As String) As Integer
        If status = LeadStatus.InProcess Then
            Return GetMgrLeadsCount(status, Employee.GetAllDeptUsers(officeName))
        End If

        If status = LeadStatus.ALL Then
            Return GetMgrLeadsCount(status, Employee.GetDeptUsers(officeName)) + GetMgrLeadsCount(LeadStatus.InProcess, Employee.GetUnActiveUser(officeName))
        End If

        Dim emps = Employee.GetDeptUsers(officeName)
        Return GetMgrLeadsCount(status, emps)
    End Function

    ''' <summary>
    ''' Get the count of leads under certain teams and status
    ''' </summary>
    ''' <param name="status">Leads Status</param>
    ''' <param name="teamId">Team Id</param>
    ''' <returns></returns>
    Public Shared Function GetTeamLeadsCount(status As LeadStatus, teamId As Integer) As Integer
        If status = LeadStatus.InProcess Then
            Return GetMgrLeadsCount(status, Employee.GetTeamUsers(teamId))
        End If

        If status = LeadStatus.ALL Then
            Return GetMgrLeadsCount(status, Employee.GetTeamUsers(teamId))
        End If

        Dim emps = Employee.GetTeamUsers(teamId)
        Return GetMgrLeadsCount(status, emps)
    End Function

    ''' <summary>
    ''' Get the count of Unassigned leads under given team
    ''' </summary>
    ''' <param name="teamId">Team Id</param>
    ''' <returns></returns>
    Public Shared Function GetTeamUnAssignedLeadsCount(teamId As Integer) As Integer
        Return Team.GetTeam(teamId).AssignLeadsCount
    End Function

    ''' <summary>
    ''' Get the count of manager's unassigned leads
    ''' </summary>
    ''' <param name="teamMgr">The Manager Name</param>
    ''' <returns></returns>
    Public Shared Function GetTeamUnAssignedLeadsCount(teamMgr As String) As Integer
        Using context As New Entities
            Return context.LeadsInfoes.Where(Function(li) li.Lead.EmployeeName = teamMgr And li.Lead.Status = LeadStatus.NewLead).Count
        End Using
    End Function

    ''' <summary>
    ''' Get the count of current user's unassign leads 
    ''' </summary>
    ''' <param name="userContext">The Httpcontext object</param>
    ''' <returns></returns>
    Public Shared Function GetUnAssignedLeadsCount(Optional userContext As HttpContext = Nothing) As Integer
        Using context As New Entities
            If userContext Is Nothing AndAlso HttpContext.Current IsNot Nothing Then
                userContext = HttpContext.Current
            End If

            If userContext.User.IsInRole("Admin") Then
                Return context.LeadsInfoes.Where(Function(li) li.Lead Is Nothing).Count
            Else
                If Employee.IsManager(userContext.User.Identity.Name) Then
                    Dim name = userContext.User.Identity.Name
                    Return context.LeadsInfoes.Where(Function(li) li.Lead.EmployeeName = name And li.Lead.Status = LeadStatus.NewLead).Count
                End If
            End If

            Return 0
        End Using
    End Function

    ''' <summary>
    ''' Get the count of unassign leads under given office/team
    ''' </summary>
    ''' <param name="office">Office/Team Name</param>
    ''' <returns></returns>
    Public Shared Function GetUnAssignedLeadsCount(office As String) As Integer
        Using context As New Entities
            Dim officeName = office & " Office"
            Dim unActiveUser = Employee.GetDeptUnActiveUserList(office).Select(Function(emp) emp.Name).ToArray

            Dim count = (From ld In context.Leads
                         Where ld.EmployeeName = officeName Or (unActiveUser.Contains(ld.EmployeeName) And ld.Status <> LeadStatus.InProcess)
                         Select ld).Count
            Return count
        End Using
    End Function

    Public Shared Function TotalLeadsCount() As Integer
        Using Context As New Entities
            Dim subOridates = Employee.GetSubOrdinate(HttpContext.Current.User.Identity.Name)
            Return Context.Leads.Where(Function(ld) subOridates.Contains(ld.EmployeeID)).Count
        End Using
    End Function

    Public Shared Function TotalDealsCount() As Integer
        Return GetLeadsCount(LeadStatus.InProcess, HttpContext.Current.User.Identity.Name)
    End Function


    Public Shared Function FormatPhoneNumber(ByVal myNumber As String)
        Dim mynewNumber As String
        mynewNumber = ""
        myNumber = myNumber.Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "")
        If myNumber.Length < 10 Then
            mynewNumber = myNumber
        ElseIf myNumber.Length = 10 Then
            mynewNumber = "(" & myNumber.Substring(0, 3) & ") " &
                    myNumber.Substring(3, 3) & "-" & myNumber.Substring(6, 4)
        ElseIf myNumber.Length > 10 Then
            mynewNumber = "(" & myNumber.Substring(0, 3) & ") " &
                    myNumber.Substring(3, 3) & "-" & myNumber.Substring(6, 4) & " " &
                    myNumber.Substring(10)
        End If
        Return mynewNumber
    End Function

    ''' <summary>
    '''  returned formats are: 
    '''  example1               (620) 123-4567 Ext: 890
    '''  example2                     123-4567 Ext: 890
    '''  example3               (620) 123-4567 
    '''  example4                     123-4567
    '''  The user can input a 7 or 10 digit number followed by a character(s) and digits for the extension
    ''' 
    ''' </summary>
    ''' <param name="OriginalNumber"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function FormatPhone(ByVal OriginalNumber As String) As String

        Dim sReturn As String
        Dim tester() As String
        Dim R As Regex
        Dim M As Match
        Dim sTemp As String

        sReturn = ""
        ' removes anything that is not a digit or letter
        sTemp = UnFormatPhone(OriginalNumber)
        ' splits sTemp based on user input of character(s) to signify an extension i.e. x or ext or anything else you can think of (abcdefg...)
        tester = Regex.Split(sTemp, "\D+")
        ' if the string was split then replace sTemp with the first part, i.e. the phone number less the extension
        If tester.Count > 1 Then
            sTemp = tester(0)
        End If
        ' Based on the NANP (North American Numbering Plan),  we better have a 7 or 10 digit number.  anything else will not parse
        If sTemp.Length = 7 Then
            R = New Regex("^(?<First>\d{3})(?<Last>\d{4})")
        ElseIf sTemp.Length = 10 Then
            R = New Regex("^(?<AC>\d{3})(?<First>\d{3})(?<Last>\d{4})")
        Else
            Return OriginalNumber
        End If
        ' now format the phone number nice and purtee...
        M = R.Match(sTemp)
        If M.Groups("AC").Length > 0 Then
            sReturn &= String.Format("({0}) {1}-{2}", CStr(M.Groups("AC").Value), CStr(M.Groups("First").Value), CStr(M.Groups("Last").Value))
        Else
            sReturn &= String.Format("{0}-{1}", CStr(M.Groups("First").Value), CStr(M.Groups("Last").Value))
        End If
        If tester.Count > 1 Then
            sReturn &= " Ext: " + tester(1)
        End If
        Return sReturn

    End Function

    ''' <summary>
    ''' Strips NON ALPHANUMERICS from a string
    ''' 
    ''' </summary>
    ''' <param name="sTemp"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function UnFormatPhone(ByVal sTemp As String) As String
        sTemp = ClearNull(sTemp)
        Dim sb As New System.Text.StringBuilder
        For Each ch As Char In sTemp
            If Char.IsLetterOrDigit(ch) OrElse ch = " "c Then
                sb.Append(ch)
            End If
        Next
        UnFormatPhone = sb.ToString

    End Function

    ''' <summary>
    ''' Returns a trimmed string with vbNullChar replaced by a blank
    ''' </summary>
    ''' <param name="sTemp"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function ClearNull(ByRef sTemp As String) As String
        sTemp = Replace(sTemp, vbNullChar, "")
        ClearNull = Trim(sTemp)
    End Function

    Public Shared Function RemoveHtmlTags(html As String) As String
        Dim text = Regex.Replace(html, "<[^>]*>", String.Empty)
        Return text
    End Function

    Public Shared Function IsSimilarName(name1 As String, name2 As String) As Boolean

        If String.IsNullOrEmpty(name1) Or String.IsNullOrEmpty(name2) Then
            Return False
        End If

        name1 = name1.Trim.ToLower
        name2 = name2.Trim.ToLower

        If String.IsNullOrEmpty(name1) Or String.IsNullOrEmpty(name2) Then
            Return False
        End If

        Dim strCompare = name1.Replace(",", "").Replace("&", " ").Replace("-", " ").Replace("/", "").Split(" ").Where(Function(a) Not String.IsNullOrEmpty(a.Trim)).ToArray
        name2 = name2.Replace(",", "").Replace("&", " ").Replace("-", " ").Replace("/", "")
        Dim nameArray = name2.Split(" ").Where(Function(a) Not String.IsNullOrEmpty(a.Trim)).ToArray
        Dim result = strCompare.Where(Function(a) nameArray.Contains(a)).Count / strCompare.Length

        Return result > 0.9
    End Function

    Public Shared Function FormatUserName(name As String)
        name = name.Trim
        Return StrConv(name, VbStrConv.ProperCase)
    End Function

    Public Shared Function BuildUsername(firstName As String, middleName As String, lastName As String)
        Return String.Format("{0} {1}{2}", firstName, middleName & " ", lastName)
    End Function

    Public Shared Function SaveChangesObj(oldObj As Object, newObj As Object) As Object
        Dim type = oldObj.GetType()

        For Each prop In type.GetProperties
            Dim newValue = prop.GetValue(newObj)
            If newValue IsNot Nothing Then
                Dim oldValue = prop.GetValue(oldObj)
                If Not newValue.Equals(oldValue) Then
                    If prop.CanWrite Then
                        prop.SetValue(oldObj, newValue)
                    End If
                End If
            End If
        Next

        Return oldObj
    End Function

    Public Shared Function IsCompany(name As String) As Boolean
        If (String.IsNullOrEmpty(name)) Then
            Return False
        End If
        'regex match the comany like LLC Corp Etc. regex store in database

        Dim regexStr = Core.PortalSettings.GetValue("CompanyRegex")
        Dim match = Regex.Match(name, regexStr)

        Return match.Success
    End Function

    ''' <summary>
    ''' Check if log in user in role or role group
    ''' </summary>
    ''' <param name="UserName">Log in user name </param>
    ''' <param name="rls">role if containt * then check group </param>
    ''' <returns></returns>
    Public Shared Function IsUserInRoleGroup(UserName As String, ParamArray rls() As String) As Boolean
        Dim aRoles = Roles.GetRolesForUser(UserName)
        Dim _viewable = False

        Dim viewableRoles = rls

        If aRoles.Any(Function(a) viewableRoles.Any(Function(r) a.StartsWith(r.Replace("*", "")))) Then
            _viewable = True
        End If
        Return _viewable
    End Function
    Public Shared Function GetBoroughByZip(zip As String) As String
        If String.IsNullOrEmpty(zip) Then
            Return ""
        End If

        Select Case zip.Substring(0, 3)
            Case "100"
                Return "1"
            Case "104"
                Return "2"
            Case "112"
                Return "3"
            Case "110", "111", "113", "114", "116"
                Return "4"
            Case "103"
                Return "5"
            Case Else
                Return ""
        End Select
    End Function
End Class
