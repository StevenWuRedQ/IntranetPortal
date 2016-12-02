Imports System.Net
Imports System.Web.Http

Namespace Controllers
    Public Class EmployeeController
        Inherits ApiController

        <Route("api/employeenames")>
        Public Function getEmployees() As IHttpActionResult
            Dim employees As String()
            employees = Employee.GetAllActiveEmps
            Return Ok(employees)
        End Function

        <Route("api/employeenames")>
        Public Function getEmployees(<FromUri> type As String) As IHttpActionResult
            Dim employees As String()
            Select Case type
                Case "all"
                    employees = Employee.GetAllEmps
                Case Else
                    employees = Employee.GetAllActiveEmps
            End Select

            Return Ok(employees)
        End Function

    End Class
End Namespace