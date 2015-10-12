Imports System.Net
Imports System.Web.Http

Namespace Controllers
    Public Class UserInfoController
        Inherits ApiController

        <Route("api/UserInfo/IsActive")>
        Function GetIsActive() As IHttpActionResult
            Return Ok(OnlineUser.IsActive(HttpContext.Current.User.Identity.Name))
        End Function

        <Route("api/UserInfo/UpdateRefreshTime")>
        Function GetUpdateRefreshTime() As IHttpActionResult
            Return Ok()
        End Function

    End Class
End Namespace