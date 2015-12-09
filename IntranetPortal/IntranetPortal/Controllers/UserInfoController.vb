Imports System.Net
Imports System.Web.Http

Namespace Controllers
    Public Class UserInfoController
        Inherits ApiController

        <Route("api/UserInfo/IsActive")>
        Function GetIsActive() As IHttpActionResult
            Dim isActive = OnlineUser.IsActive(HttpContext.Current.User.Identity.Name)
            If Not isActive Then
                Core.SystemLog.Log("AutoLogout", "WillAutoLogout", Core.SystemLog.LogCategory.Operation, Nothing, HttpContext.Current.User.Identity.Name)
            End If
            Return Ok(isActive)
        End Function

        <Route("api/UserInfo/UpdateRefreshTime")>
        Function GetUpdateRefreshTime() As IHttpActionResult
            Core.SystemLog.Log("AutoLogout", "CancelLogout", Core.SystemLog.LogCategory.Operation, Nothing, HttpContext.Current.User.Identity.Name)
            Return Ok()
        End Function

    End Class
End Namespace