Imports System.Web.SessionState
Imports DevExpress.Web
Imports System.Web.Routing
Imports System.Web.Security
Imports Microsoft.AspNet.SignalR
Imports System.Threading
Imports System.Web.Http

Public Class Global_asax
    Inherits System.Web.HttpApplication

    Sub Application_Start(ByVal sender As Object, ByVal e As EventArgs)
        AddHandler DevExpress.Web.ASPxWebControl.CallbackError, AddressOf Application_Error

        Dim users As New List(Of OnlineUser)
        Application("Users") = users

        WebApiConfig2.Register(GlobalConfiguration.Configuration)
        GlobalConfiguration.Configuration.EnsureInitialized()
    End Sub

    Sub Session_Start(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires when the session is started
        'If Not String.IsNullOrEmpty(User.Identity.Name) Then
        '    Application.Lock()
        '    Dim users = CType(Application("Users"), List(Of OnlineUser))
        '    If users.Where(Function(u) u.UserName = User.Identity.Name).Count = 0 Then


        '        users.Add(User.Identity.Name)
        '        Application("Users") = users
        '    End If
        '    Application.UnLock()
        'End If

        'Dim httpRequest = HttpContext.Current.Request
        'If httpRequest.Browser.IsMobileDevice Then
        '    Dim path = httpRequest.Url.PathAndQuery
        '    Dim isOnMobilePage = path.StartsWith("/Mobile/", StringComparison.OrdinalIgnoreCase)
        '    If Not isOnMobilePage Then
        '        Dim redirectTo = "~/Mobile/default.aspx"
        '        HttpContext.Current.Response.Redirect(redirectTo)
        '    End If
        'End If
    End Sub


    Sub Application_BeginRequest(ByVal sender As Object, ByVal e As EventArgs)
        'Debug.WriteLine("BeginRequest:" & DateTime.Now.ToString("MM/dd/yyyy hh:mm:ss.fff tt"))

    End Sub

    Public Sub RefreshUserTime(sessionId As Integer)
        Application.Lock()
        Dim users = CType(Application("Users"), List(Of OnlineUser))

        If users Is Nothing Then
            Application.Lock()
            Application("Users") = New List(Of OnlineUser)
            Application.UnLock()
        End If

        Dim currentUser = users.Where(Function(u) u.SessionID = sessionId).SingleOrDefault

        If currentUser IsNot Nothing Then
            currentUser.RefreshTime = DateTime.Now
        End If
        Context.Application("Users") = users
        Context.Application.UnLock()
    End Sub

    Sub Application_EndRequest(ByVal sender As Object, ByVal e As EventArgs)
        'Debug.WriteLine("EndRequest:" & DateTime.Now.ToString("MM/dd/yyyy hh:mm:ss.fff tt"))
    End Sub

    Sub Application_AuthenticateRequest(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires upon attempting to authenticate the use
    End Sub

    Sub Application_Error(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires when an error occurs

        If HttpContext.Current IsNot Nothing AndAlso HttpContext.Current.AllErrors.Length > 0 Then
            Dim ex = HttpContext.Current.AllErrors.Last

            If TypeOf ex Is ThreadAbortException Then
                Return
            End If

            If TypeOf ex Is CallbackException Then
                DevExpress.Web.ASPxWebControl.SetCallbackErrorMessage(ex.Message)
                Return
            End If

            Try
                'UserMessage.AddNewMessage("Portal", "Error in Portal Application", String.Format("Message:{0}, Stack: {1}", ex.Message, ex.StackTrace), "")
                Core.SystemLog.LogError("Error in Portal Application", ex, HttpContext.Current.Request.RawUrl, HttpContext.Current.User.Identity.Name, Nothing)
                'IntranetPortal.Core.SystemLog.Log("", String.Format("Message:{0},Request URL:{2}, Stack: {1}", ex.Message, ex.StackTrace, ), "Error", "", )
            Catch exp As Exception

            End Try
        End If

    End Sub

    Sub Session_End(ByVal sender As Object, ByVal e As EventArgs)



        ' Fires when the session ends
        'Application.Lock()
        'Dim users = CType(Application("Users"), ArrayList)
        'If users.Contains(User.Identity.Name) Then
        '    users.Remove(User.Identity.Name)
        '    Application("Users") = users
        'End If
        'Application.UnLock()
    End Sub

    Sub Application_End(ByVal sender As Object, ByVal e As EventArgs)

        ' Fires when the application ends
    End Sub


End Class
