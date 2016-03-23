Imports System.Net
Imports System.Web.Http
Imports System.Web.Http.Description

Namespace Controllers
    <Authorize(Roles:="Admin,Auction-Manager,OfficeManager-*")>
    Public Class LeadsController
        Inherits ApiController

        ''' <summary>
        ''' Return vacant leads list
        ''' </summary>
        ''' <returns></returns>
        <Route("api/Leads/VacantLeads")>
        Public Function GetVacantLeads() As IHttpActionResult
            Try
                Dim vacantleads = LeadsInfo.GetLeadsInfoByType(LeadsInfo.LeadsType.VacantLand)
                Dim result = vacantleads.Select(Function(ld) New With {ld.BBLE, ld.PropertyAddress}).ToList
                Return Ok(result)
            Catch ex As Exception
                Throw
            End Try
        End Function

        ''' <summary>
        ''' Return leadsinfo data
        ''' </summary>
        ''' <param name="bble"></param>
        ''' <returns></returns>
        <Route("api/Leads/LeadsInfo/{bble}")>
        Public Function GetLeadsInfo(bble As String) As IHttpActionResult
            Try
                Dim li = LeadsInfo.GetInstance(bble)
                Return Ok(li)
            Catch ex As Exception
                Throw
            End Try
        End Function

        ''' <summary>
        ''' Action to assign leads to user
        ''' </summary>
        ''' <param name="bble"></param>
        ''' <param name="userName"></param>
        ''' <returns></returns>
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

        ''' <summary>
        ''' Return agent list managered by current user
        ''' </summary>
        ''' <returns></returns>
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