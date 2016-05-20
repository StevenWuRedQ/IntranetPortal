Imports System.Net
Imports System.Web.Http

Namespace Controllers
    Public Class LeadsInfoController
        Inherits ApiController
        <Route("api/LeadsInfo/Verify")>
        Public Function PostVerify(leadInfo As LeadsInfo) As IHttpActionResult
            Try
                leadInfo.verifiyAddress()

            Catch ex As Exception
                Throw ex
            End Try

            Return Ok(leadInfo)
        End Function

        <Route("api/LeadsInfo/{bble}")>
        Public Function GetLeadsInfo(bble As String) As IHttpActionResult
            Try
                Dim li = LeadsInfo.GetInstance(bble)
                Return Ok(li)
            Catch ex As Exception
                Throw
            End Try
        End Function
    End Class
End Namespace