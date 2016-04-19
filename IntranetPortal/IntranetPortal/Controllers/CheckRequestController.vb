Imports System.Net
Imports System.Web.Http
Imports System.Web.Http.Description
Imports IntranetPortal.Data

Namespace Controllers
    Public Class CheckRequestController
        Inherits ApiController

        ''' <summary>
        ''' Get check request instance
        ''' </summary>
        ''' <returns></returns>
        <ResponseType(GetType(CheckRequest))>
        <Route("api/CheckRequests")>
        Public Function GetCheckRequest(checkId As Integer) As IHttpActionResult
            Try
                Dim cr = CheckRequest.GetInstance(checkId)

                If cr Is Nothing Then
                    Return StatusCode(HttpStatusCode.NotFound)
                End If

                Return Ok(cr)
            Catch ex As Exception
                Throw ex
            End Try
        End Function

        ''' <summary>
        ''' Put check request instance
        ''' </summary>
        ''' <returns></returns>
        <ResponseType(GetType(CheckRequest))>
        <Route("api/CheckRequests")>
        Public Function PostCheckRequest(check As CheckRequest) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            If String.IsNullOrEmpty(check.BBLE) Then
                Return BadRequest("BBLE cann't be empty.")
            End If

            Try
                check.Save(HttpContext.Current.User.Identity.Name)
                Return Ok(check)
            Catch ex As Exception
                Throw ex
            End Try
        End Function




    End Class

End Namespace