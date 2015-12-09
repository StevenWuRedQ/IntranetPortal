Imports System.Net
Imports System.Web.Http
Imports System.Web.Http.Description

Namespace Controllers
    Public Class FollowUpController
        Inherits ApiController

        <ResponseType(GetType(Data.UserFollowUp))>
        <Route("api/Followup/")>
        Public Function PostFollowUp(bble As String, type As Integer, category As String, <FromBody> followUpdate As String) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            Try
                Dim dt As DateTime
                'Dim objData = e.Parameter.Split("|")(2)
                Select Case category
                    Case "Tomorrow"
                        dt = DateTime.Now.AddDays(1)
                    Case "NextWeek"
                        dt = DateTime.Now.AddDays(7)
                    Case "ThirtyDays"
                        dt = DateTime.Now.AddDays(30)
                    Case "SixtyDays"
                        dt = DateTime.Now.AddDays(60)
                    Case Else
                        If Not DateTime.TryParse(followUpdate, dt) Then
                            dt = DateTime.Now.AddDays(7)
                        End If
                End Select

                Dim followup = UserFollowUpManage.AddFollowUp(bble, HttpContext.Current.User.Identity.Name, type, dt)
                Return Ok(followup)
            Catch ex As Exception
                Throw ex
            End Try
        End Function

        <ResponseType(GetType(Data.UserFollowUp))>
        <Route("api/Followup/")>
        Public Function DeleteFollowUp(followUpId As Integer) As IHttpActionResult
            Try
                Dim fp = UserFollowUpManage.ClearFollowUp(followUpId, HttpContext.Current.User.Identity.Name)
                Return Ok(fp)
            Catch ex As Exception
                Throw ex
            End Try
        End Function

    End Class
End Namespace