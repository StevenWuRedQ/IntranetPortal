Imports System.Net
Imports System.Web.Http
Imports IntranetPortal.Data
Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq

Namespace Controllers
    Public Class EmployeeController
        Inherits ApiController

        <Route("api/employeenames")>
        Public Function GetEmployees() As IHttpActionResult
            Dim employees As String()
            employees = Employee.GetAllActiveEmps
            Return Ok(employees)
        End Function

        <Route("api/employeenames")>
        Public Function GetEmployees(<FromUri> type As String) As IHttpActionResult
            Dim employees As String()
            Select Case type
                Case "all"
                    employees = Employee.GetAllEmps
                Case Else
                    employees = Employee.GetAllActiveEmps
            End Select
            Return Ok(employees)
        End Function

        <Route("api/employees/")>
        Public Function GetEmployeeByRole(<FromUri> role As String) As IHttpActionResult
                Dim emp =  EmployeeManage.FindEmployeesInRole(role)
                return OK(emp)
        End Function
    End Class
End Namespace