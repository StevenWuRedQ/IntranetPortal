Imports System.Net
Imports System.Web.Http

Namespace Controllers
    Public Class TwilioController
        Inherits ApiController



        <Route("api/twilio/sendmms/")>
        Public Function PostSendMMS(number As String, <FromBody> msg As String) As IHttpActionResult



            Return Ok()
        End Function


    End Class
End Namespace
