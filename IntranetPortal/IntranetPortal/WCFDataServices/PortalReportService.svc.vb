Imports System.ServiceModel.Web


' NOTE: You can use the "Rename" command on the context menu to change the class name "PortalReportService" in code, svc and config file together.
' NOTE: In order to launch WCF Test Client for testing this service, please select PortalReportService.svc or PortalReportService.svc.vb at the Solution Explorer and start debugging.
Public Class PortalReportService
    Implements IPortalReportService

    Public Function GetUserReports() As List(Of EmpData) Implements IPortalReportService.GetUserReports
        Return (From obj In {New EmpData With {.Name = "Test1", .Count = 123}, New EmpData With {.Name = "Test2", .Count = 343}}
                Select obj).ToList
    End Function

    Public Function EmployeeReports() As List(Of CallTrackingService.EmployeeStatisticData) Implements IPortalReportService.EmployeeReports
        Using client As New CallTrackingService.CallTrackingServiceClient
            Return client.EmployeeReports().ToList
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
End Class

Public Class EmpData
    Public Property Name As String
    Public Property Count As Integer
End Class

Public Class LeadsStatusData
    Public Property Status As String
    Public Property Count As Integer
End Class
