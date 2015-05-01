Imports System.Web.SessionState
Imports DevExpress.Web.ASPxClasses
Imports System.Web.Routing
Imports System.Web.Security
Imports Microsoft.AspNet.SignalR
Imports System.Threading

Public Class Global_asax
    Inherits System.Web.HttpApplication

    Sub Application_Start(ByVal sender As Object, ByVal e As EventArgs)
        AddHandler DevExpress.Web.ASPxClasses.ASPxWebControl.CallbackError, AddressOf Application_Error

        Dim users As New List(Of OnlineUser)
        Application("Users") = users
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
    End Sub


    Sub Application_BeginRequest(ByVal sender As Object, ByVal e As EventArgs)
        'Debug.WriteLine("BeginRequest:" & DateTime.Now.ToString("MM/dd/yyyy hh:mm:ss.fff tt"))
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

            Try
                'UserMessage.AddNewMessage("Portal", "Error in Portal Application", String.Format("Message:{0}, Stack: {1}", ex.Message, ex.StackTrace), "")
                IntranetPortal.Core.SystemLog.Log("Error in Portal Application", String.Format("Message:{0}, Stack: {1}", ex.Message, ex.StackTrace), "Error", "", HttpContext.Current.User.Identity.Name)
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
