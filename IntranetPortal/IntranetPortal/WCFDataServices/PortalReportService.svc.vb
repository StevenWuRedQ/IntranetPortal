Imports System.ServiceModel.Web
Imports System.Runtime.CompilerServices
Imports System.IO
Imports System.ServiceModel
Imports System.ServiceModel.Activation

' NOTE: You can use the "Rename" command on the context menu to change the class name "PortalReportService" in code, svc and config file together.
' NOTE: In order to launch WCF Test Client for testing this service, please select PortalReportService.svc or PortalReportService.svc.vb at the Solution Explorer and start debugging.
<AspNetCompatibilityRequirements(RequirementsMode:=AspNetCompatibilityRequirementsMode.Allowed)>
Public Class PortalReportService
    Implements IPortalReportService

    Public Function EmployeeReports() As Channels.Message Implements IPortalReportService.EmployeeReports
        Using client As New CallTrackingService.CallTrackingServiceClient
            Return client.EmployeeStatisticData({"*"}).Where(Function(a) Not String.IsNullOrEmpty(a.EmployeeName) And a.Count > 10 And a.EmployeeName <> "Test").ToList.ToJson
        End Using
    End Function

    Public Function EmployeeCallLog(empName As String) As System.ServiceModel.Channels.Message Implements IPortalReportService.EmployeeCallLog
        Using client As New CallTrackingService.CallTrackingServiceClient
            Return client.EmployeeReports(empName).ToList.ToJson
        End Using
    End Function

    Public Function LoadAgentLeadsReport(agentName As String) As Channels.Message Implements IPortalReportService.LoadAgentLeadsReport
        Return GetProcessStatusReport({agentName})
    End Function

    Public Function LoadTeamLeadsReport(teamName As String) As Channels.Message Implements IPortalReportService.LoadTeamLeadsReport
        Dim emps = UserInTeam.GetTeamUsersArray(teamName)
        Return GetProcessStatusReport(emps)
    End Function

    Public Function LoadTeamInProcessReport(teamName As String) As List(Of LeadsStatusData) Implements IPortalReportService.LoadTeamInProcessReport
        Return GetInProcessReport(UserInTeam.GetTeamUsersArray(teamName))
    End Function

    Public Function LoadAgentInProcessReport(agentName As String) As List(Of LeadsStatusData) Implements IPortalReportService.LoadAgentInProcessReport
        Return GetInProcessReport({agentName})
    End Function

    Public Function LoadTeamInfo(teamName As String) As System.ServiceModel.Channels.Message Implements IPortalReportService.LoadTeamInfo
        Dim users = UserInTeam.GetTeamUsersArray(teamName)
        Dim inProcessCount = Utility.GetMgrLeadsCount(LeadStatus.InProcess, users)
        Dim info = New With {
                .TeamName = teamName,
                .TeamAgentCount = users.Count,
                .Users = users,
                .TotalDeals = inProcessCount,
                .EffeciencyScore = ""
            }
        Return info.ToJson
    End Function

    Public Function LoadAgentActivityReport(teamName As String, startDate As String, endDate As String) As Channels.Message Implements IPortalReportService.LoadAgentActivityReport
        Dim dtStart = DateTime.Parse(startDate)
        Dim dtEnd = DateTime.Parse(endDate)
        Return PortalReport.LoadTeamAgentActivityReport(teamName, dtStart, dtEnd).ToJson

        'Using ctx As New Entities
        '    Dim actionTypes = {LeadsActivityLog.EnumActionType.CallOwner,
        '                       LeadsActivityLog.EnumActionType.Comments,
        '                       LeadsActivityLog.EnumActionType.DoorKnock,
        '                       LeadsActivityLog.EnumActionType.FollowUp,
        '                       LeadsActivityLog.EnumActionType.SetAsTask,
        '                       LeadsActivityLog.EnumActionType.Appointment}

        '    Dim logSql = ctx.LeadsActivityLogs.Where(Function(al) users.Contains(al.EmployeeName) And al.ActivityDate < dtEnd And al.ActivityDate > dtStart AndAlso actionTypes.Contains(al.ActionType))
        '    Dim logs = logSql.ToList

        '    Dim result As New List(Of Object)
        '    For Each user In users
        '        'Dim actionTypes = {LeadsActivityLog.EnumActionType.CallOwner, LeadsActivityLog.EnumActionType.Comments, LeadsActivityLog.EnumActionType.DoorKnock,
        '        '                   LeadsActivityLog.EnumActionType.FollowUp, LeadsActivityLog.EnumActionType.SetAsTask, LeadsActivityLog.EnumActionType.Appointment}
        '        Dim userLogs = logs.Where(Function(l) l.EmployeeName = user)

        '        result.Add(New With {
        '                   .Name = user,
        '                   .CallOwner = userLogs.Where(Function(l) l.ActionType.HasValue AndAlso l.ActionType = LeadsActivityLog.EnumActionType.CallOwner).Count,
        '                   .Comments = userLogs.Where(Function(l) l.ActionType.HasValue AndAlso l.ActionType = LeadsActivityLog.EnumActionType.Comments).Count,
        '                   .DoorKnock = userLogs.Where(Function(l) l.ActionType.HasValue AndAlso l.ActionType = LeadsActivityLog.EnumActionType.DoorKnock).Count,
        '                   .FollowUp = userLogs.Where(Function(l) l.ActionType.HasValue AndAlso l.ActionType = LeadsActivityLog.EnumActionType.FollowUp).Count,
        '                   .SetAsTask = userLogs.Where(Function(l) l.ActionType.HasValue AndAlso l.ActionType = LeadsActivityLog.EnumActionType.SetAsTask).Count,
        '                   .Appointment = userLogs.Where(Function(l) l.ActionType.HasValue AndAlso l.ActionType = LeadsActivityLog.EnumActionType.Appointment).Count,
        '                   .UniqueBBLE = userLogs.Select(Function(l) l.BBLE).Distinct.Count
        '                   })
        '    Next

        '    Return result.ToJson
        'End Using
    End Function
    Public Function UnicodeToAscii(ByVal unicodeString As String) As String


        Dim ascii As Encoding = Encoding.ASCII
        Dim unicode As Encoding = Encoding.Unicode
        ' Convert the string into a byte array. 
        Dim unicodeBytes As Byte() = unicode.GetBytes(unicodeString)

        ' Perform the conversion from one encoding to the other. 
        Dim asciiBytes As Byte() = Encoding.Convert(unicode, ascii, unicodeBytes)

        ' Convert the new byte array into a char array and then into a string. 
        Dim asciiChars(ascii.GetCharCount(asciiBytes, 0, asciiBytes.Length) - 1) As Char
        ascii.GetChars(asciiBytes, 0, asciiBytes.Length, asciiChars, 0)
        Dim asciiString As New String(asciiChars)
        Return asciiString
    End Function

    Public Function ChangeDateFormatToASCII(dt As String) As String
        Dim asciiBtye As Byte() = System.Text.Encoding.ASCII.GetBytes(dt)
        asciiBtye = asciiBtye.Where(Function(b) b <> 63).ToArray
        Dim asciiStr = System.Text.ASCIIEncoding.ASCII.GetString(asciiBtye)
        Return asciiStr
    End Function

    Public Function LoadAgentSummaryReport(agentName As String, startDate As String, endDate As String) As Channels.Message Implements IPortalReportService.LoadAgentSummaryReport
        Dim dtStart = DateTime.MinValue

        If Not DateTime.TryParse(startDate, dtStart) Then
            If Not DateTime.TryParse(ChangeDateFormatToASCII(startDate), dtStart) Then
                dtStart = New DateTime(DateTime.Now.Year, DateTime.Now.Month, 1)
            End If
        End If

        Dim dtEnd = DateTime.Today
        If Not DateTime.TryParse(endDate, dtEnd) Then
            If Not DateTime.TryParse(ChangeDateFormatToASCII(endDate), dtEnd) Then
                dtEnd = DateTime.Today.AddDays(1)
            End If
        End If

        Dim teamName = UserInTeam.GetUserTeam(agentName)

        Dim result = New List(Of Object)
        Dim allData = New List(Of PortalReport.AgentActivityData)
        Dim agentData As PortalReport.AgentActivityData

        If Not String.IsNullOrEmpty(teamName) Then
            allData = PortalReport.LoadTeamAgentActivityReport(teamName, dtStart, dtEnd)
            agentData = allData.Where(Function(a) a.Name = agentName).FirstOrDefault

            If agentData Is Nothing Then
                agentData = PortalReport.LoadAgentActivityReport(agentName, dtStart, dtEnd)
            End If
        Else
            agentData = PortalReport.LoadAgentActivityReport(agentName, dtStart, dtEnd)
        End If

        If agentData IsNot Nothing Then
            If allData.Count = 0 Then
                allData.Add(agentData)
            End If

            result.AddRange({New With {
                              .Category = "CallOwner",
                              .User = agentData.CallOwner,
                              .Avg = CInt(allData.Where(Function(a) a.CallOwner >= 10).Select(Function(a) a.CallOwner).DefaultIfEmpty(0).Average())
                          },
                                    New With {
                              .Category = "Comments",
                              .User = agentData.Comments,
                              .Avg = CInt(allData.Where(Function(a) a.Comments >= 10).Select(Function(a) a.Comments).DefaultIfEmpty(0).Average())
                                        },
                                      New With {
                              .Category = "FollowUp",
                              .User = agentData.FollowUp,
                              .Avg = CInt(allData.Where(Function(a) a.FollowUp >= 10).Select(Function(a) a.FollowUp).DefaultIfEmpty(0).Average())
                                        },
                                     New With {
                              .Category = "UniqueBBLE",
                              .User = agentData.UniqueBBLE,
                              .Avg = CInt(allData.Where(Function(a) a.UniqueBBLE >= 10).Select(Function(a) a.UniqueBBLE).DefaultIfEmpty(0).Average())
                                        }
                                    })
        End If

        Return result.ToJson
    End Function

    Public Function LoadAgentActivityLeads(agentName As String, action As String, startDate As String, endDate As String) As Channels.Message Implements IPortalReportService.LoadAgentActivityLeads
        Return LeadsGridJson(LeadsDataByActivityAction({agentName}, action, startDate, endDate))
    End Function

    Public Function LoadTeamActivityLeads(teamName As String, action As String, startDate As String, endDate As String) As Channels.Message Implements IPortalReportService.LoadTeamActivityLeads
        Return LeadsGridJson(LeadsDataByActivityAction(UserInTeam.GetTeamUsersArray(teamName), action, startDate, endDate))
    End Function

    Public Function LoadAgentLeadsData(agentName As String, status As String) As Channels.Message Implements IPortalReportService.LoadAgentLeadsData
        Dim leadsData = Lead.GetUserLeadsData(agentName, CInt(status))
        Return LeadsGridJson(leadsData)
    End Function

    Public Function LoadTeamLeadsData(teamName As String, status As String) As Channels.Message Implements IPortalReportService.LoadTeamLeadsData
        Dim leadsData = Team.GetTeam(teamName).GetLeadsByStatus(CInt(status))
        Return LeadsGridJson(leadsData)
    End Function

#Region "Private methods"

    Private Function LeadsDataByActivityAction(names As String(), action As String, startDate As String, endDate As String) As List(Of Lead)
        Dim dtStart = DateTime.Parse(startDate)
        Dim dtEnd = DateTime.Parse(endDate)

        Dim actionTypes = {LeadsActivityLog.EnumActionType.CallOwner,
                             LeadsActivityLog.EnumActionType.Comments,
                             LeadsActivityLog.EnumActionType.DoorKnock,
                             LeadsActivityLog.EnumActionType.FollowUp,
                             LeadsActivityLog.EnumActionType.SetAsTask,
                             LeadsActivityLog.EnumActionType.Appointment}

        Dim actionType As LeadsActivityLog.EnumActionType
        If [Enum].TryParse(Of LeadsActivityLog.EnumActionType)(action, actionType) Then
            actionTypes = {actionType}
        End If

        Using ctx As New Entities
            Dim leads = (From bble In ctx.LeadsActivityLogs.Where(Function(al) names.Contains(al.EmployeeName) And al.ActivityDate < dtEnd And al.ActivityDate > dtStart AndAlso actionTypes.Contains(al.ActionType)).Select(Function(al) al.BBLE).Distinct
                        Join ld In ctx.Leads On ld.BBLE Equals bble
                        Order By ld.LastUpdate Descending
                        Select ld).ToList

            Return leads
        End Using

        Return Nothing
    End Function

    Private Function LeadsGridJson(leadsData As List(Of Lead)) As Channels.Message
        Dim result As New List(Of Object)
        For Each ld In leadsData
            result.Add(New With {
                       .BBLE = ld.BBLE,
                       .LeadsName = ld.LeadsName,
                       .EmployeeName = ld.EmployeeName,
                       .LastUpdate = ld.LastUpdate,
                       .Callback = ld.CallbackDate,
                       .DeadReason = If(ld.DeadReason.HasValue, CType(ld.DeadReason, Lead.DeadReasonEnum).ToString, ""),
                       .Description = ld.Description
                       })
        Next

        Return result.ToJson
    End Function

    Private Function GetProcessStatusReport(users As String()) As Channels.Message
        Using Context As New Entities
            Dim source = (From ld In Context.Leads.Where(Function(ld) users.Contains(ld.EmployeeName))
                         Group ld By Status = ld.Status Into Count()).ToDictionary(Function(l) l.Status, Function(l) l.Count)

            Dim statusToShow = New Dictionary(Of Integer, Object)
            statusToShow.Add(0, "New Leads")
            statusToShow.Add(1, "Hot Leads")
            statusToShow.Add(2, "Doorknocks")
            statusToShow.Add(3, "Follow Up")
            statusToShow.Add(4, "Dead End")
            statusToShow.Add(5, "In Process")

            'NewLead = 0
            'Priority = 1
            'DoorKnocks = 2
            'Callback = 3
            'DeadEnd = 4
            'InProcess = 5

            Dim result As New List(Of LeadsStatusData)
            For Each item In statusToShow
                result.Add(New LeadsStatusData With {
                           .Status = item.Value,
                           .Count = If(source.ContainsKey(item.Key), source(item.Key), 0),
                           .StatusKey = item.Key
                           })
            Next

            Return result.ToJson
        End Using
    End Function

    Private Function GetInProcessReport(users As String()) As List(Of LeadsStatusData)
        Dim result As New List(Of LeadsStatusData)
        Using Context As New Entities
            Dim source = Context.Leads.Where(Function(ld) users.Contains(ld.EmployeeName) And ld.Status = LeadStatus.InProcess).Select(Function(ld) ld.BBLE).ToList
            Dim shortSale = IntranetPortal.Data.ShortSaleCase.GetCaseByBBLEs(source).Select(Function(s) s.BBLE).ToList
            Dim EvictionCase = IntranetPortal.Data.EvictionCas.GetCaseByBBLEs(source).Select(Function(s) s.BBLE).ToList
            Dim others = (From ld In source
                         Where Not shortSale.Contains(ld) AndAlso Not EvictionCase.Contains(ld)).Distinct.Count
            result.Add(New LeadsStatusData With {.Status = "Short Sale", .Count = shortSale.Count})
            result.Add(New LeadsStatusData With {.Status = "Eviction", .Count = EvictionCase.Count})
            result.Add(New LeadsStatusData With {.Status = "Others", .Count = others})
        End Using

        Return result
    End Function
#End Region

End Class

Public Module JsonExtension
    <Extension()>
    Public Function ToJson(ByVal obj As Object) As System.ServiceModel.Channels.Message
        Dim json = Newtonsoft.Json.JsonConvert.SerializeObject(obj)
        Dim ms As New MemoryStream(New UTF8Encoding().GetBytes(json))
        ms.Position = 0
        Return WebOperationContext.Current.CreateStreamResponse(ms, "application/json")
    End Function

    <Extension()>
    Public Function ToJsonString(ByVal obj As Object) As String
        Dim json = Newtonsoft.Json.JsonConvert.SerializeObject(obj)
        Return json
    End Function
End Module


Public Class EmpData
    Public Property Name As String
    Public Property Count As Integer
End Class

Public Class LeadsStatusData
    Public Property Status As String
    Public Property Count As Integer
    Public Property StatusKey As Integer
End Class
