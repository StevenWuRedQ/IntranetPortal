Imports System.Net
Imports System.Web.Http
Imports IntranetPortal.Data

Namespace Controllers
    Public Class BusinessCheckController
        Inherits ApiController


        Public Function PutBusinessCheck(id As Integer, check As BusinessCheck) As IHttpActionResult

            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            If Not id = check.CheckId Then
                Return BadRequest()
            End If

            Try
                check.Save(HttpContext.Current.User.Identity.Name)
            Catch ex As Exception
                Throw ex
            End Try

            Return StatusCode(HttpStatusCode.NoContent)
        End Function

        Public Function PostBusinessCheck(check As BusinessCheck) As IHttpActionResult

            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            Try
                check.Save(HttpContext.Current.User.Identity.Name)
            Catch ex As Exception
                Throw ex
            End Try

            Return Ok(check)
        End Function

        Public Function DeleteBusinessCheck(ByVal id As String) As IHttpActionResult
            Dim check = BusinessCheck.GetInstance(id)
            If IsNothing(check) Then
                Return NotFound()
            End If

            check.Status = BusinessCheck.CheckStatus.Canceled

            Try
                check.Save(HttpContext.Current.User.Identity.Name)
            Catch ex As Exception
                Throw ex
            End Try

            Return Ok(check)
        End Function

    End Class
End Namespace