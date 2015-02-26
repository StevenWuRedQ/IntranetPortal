Imports System.ServiceModel.Web
Imports System.Runtime.CompilerServices
Imports System.IO


' NOTE: You can use the "Rename" command on the context menu to change the class name "PortalReportService" in code, svc and config file together.
' NOTE: In order to launch WCF Test Client for testing this service, please select PortalReportService.svc or PortalReportService.svc.vb at the Solution Explorer and start debugging.
Public Class PortalReportService
    Implements IPortalReportService

    Public Function EmployeeReports() As List(Of CallTrackingService.EmployeeStatisticData) Implements IPortalReportService.EmployeeReports
        Using client As New CallTrackingService.CallTrackingServiceClient
            Return client.EmployeeStatisticData({"*"}).ToList
        End Using
    End Function

    Public Function EmployeeCallLog(empName As String) As System.ServiceModel.Channels.Message Implements IPortalReportService.EmployeeCallLog
        Using client As New CallTrackingService.CallTrackingServiceClient
            Return client.EmployeeReports(empName).ToList.ToJson
        End Using
    End Function

    Public Function LoadLeadsStatusReport(teamName As String) As List(Of LeadsStatusData) Implements IPortalReportService.LoadLeadsStatusReport
        Using ctx As New Entities
            Using Context As New Entities
                Dim emps = Employee.GetDeptUsers(teamName)

                Dim source = (From ld In Context.Leads.Where(Function(ld) emps.Contains(ld.EmployeeName))
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
                               .Count = If(source.ContainsKey(item.Key), source(item.Key), 0)
                               })
                Next

                Return result
            End Using
        End Using
    End Function
    Public Function LoadLeadsInProcessReport(teamName As String) As List(Of LeadsStatusData) Implements IPortalReportService.LoadLeadsInProcessReport
        Dim result As New List(Of LeadsStatusData)
        Using Context As New Entities
            Dim emps = Employee.GetDeptUsers(teamName)
            Dim source = Context.Leads.Where(Function(ld) emps.Contains(ld.EmployeeName) And ld.Status = LeadStatus.InProcess).Select(Function(ld) ld.BBLE).ToList
            Dim shortSale = IntranetPortal.ShortSale.ShortSaleCase.GetCaseByBBLEs(source)
            Dim EvictionCase = IntranetPortal.ShortSale.EvictionCas.GetCaseByBBLEs(source)
            result.Add(New LeadsStatusData With {.Status = "Short Sale", .Count = shortSale.Count})
            result.Add(New LeadsStatusData With {.Status = "Eviction", .Count = EvictionCase.Count})
            result.Add(New LeadsStatusData With {.Status = "In Process", .Count = source.Count})
        End Using

        Return result
    End Function
End Class

Public Module JsonExtension
    <Extension()>
    Public Function ToJson(ByVal obj As Object) As System.ServiceModel.Channels.Message
        Dim json = Newtonsoft.Json.JsonConvert.SerializeObject(obj)
        Dim ms As New MemoryStream(New UTF8Encoding().GetBytes(json))
        ms.Position = 0
        Return WebOperationContext.Current.CreateStreamResponse(ms, "application/json")
    End Function
End Module


Public Class EmpData
    Public Property Name As String
    Public Property Count As Integer
End Class

Public Class LeadsStatusData
    Public Property Status As String
    Public Property Count As Integer
End Class
