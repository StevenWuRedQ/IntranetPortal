Imports System.Net
Imports System.Web.Http

Namespace Controllers
    Public Class UserInfoController
        Inherits ApiController

        <Route("api/UserInfo/IsActive")>
        Function GetIsActive() As IHttpActionResult
            Return Ok(OnlineUser.IsActive(HttpContext.Current.User.Identity.Name))
        End Function
    End Class
End Namespace