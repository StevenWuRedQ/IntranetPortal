Imports System.Net
Imports System.Web.Http
Imports System.Web.Http.Description

Namespace Controllers
    <Authorize(Roles:="Admin,Auction-Manager,OfficeManager-*")>
    Public Class LeadsController
        Inherits ApiController

        <Route("api/Leads/Assign/{bble}")>
        <ResponseType(GetType(Void))>
        Public Function PostAssignLeads(bble As String, <FromBody> userName As String) As IHttpActionResult
            Try
                If String.IsNullOrEmpty(userName) Then
                    Return BadRequest("User name can't be empty.")
                End If

                Lead.AssignLeads(bble, userName, HttpContext.Current.User.Identity.Name)
                Return Ok()
            Catch ex As Exception
                Throw
            End Try
        End Function

        <Route("api/Leads/ManagedAgents")>
        <ResponseType(GetType(String()))>
        Public Function GetManagedAgents() As IHttpActionResult
            Try
                Dim userName = HttpContext.Current.User.Identity.Name
                Dim emps = Employee.GetMyEmployees(userName)
                Return Ok(emps.Select(Function(e) e.Name).ToArray)
            Catch ex As Exception
                Throw
            End Try
        End Function
    End Class
End Namespace