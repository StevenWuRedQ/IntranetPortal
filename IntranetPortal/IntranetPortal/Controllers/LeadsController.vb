Imports System.Net
Imports System.Web.Http
Imports System.Web.Http.Description

Namespace Controllers
    Public Class LeadsController
        Inherits ApiController

        <Route("api/Leads/Assign/{bble}")>
        <ResponseType(GetType(Void))>
        Public Function PostAssignLeads(bble As String, <FromBody> userName As String) As IHttpActionResult
            Try
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
                Return Ok({userName})
            Catch ex As Exception
                Throw
            End Try
        End Function
    End Class
End Namespace