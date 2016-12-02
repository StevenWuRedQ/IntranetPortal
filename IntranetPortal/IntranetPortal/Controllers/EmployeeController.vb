Imports System.Net
Imports System.Web.Http

Namespace Controllers
    Public Class EmployeeController
        Inherits ApiController


        <Route("api/employeenames")>
        Public Function getEmployees() As IHttpActionResult
            Dim employees = Employee.GetAllEmps
            Return Ok(employees)
        End Function

    End Class
End Namespace