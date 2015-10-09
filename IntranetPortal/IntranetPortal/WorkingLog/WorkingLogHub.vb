Imports System.Threading.Tasks
Imports IntranetPortal.Core
Imports Microsoft.AspNet.SignalR

Public Class WorkingLogHub
    Inherits Hub

    'Shared ConnectedUsers As New List(Of Core.WorkingLog)

    Public Sub Connect()

        'Clients.All.Hello(Context.User.Identity.Name)
    End Sub

    Public Sub Connect(bble As String, category As String, pageurl As String)
        Dim log = WorkingLog.Instance(bble, category, pageurl)

        If log IsNot Nothing Then
            log.Close()
            OpenFile(bble, category, pageurl)
        End If
    End Sub

    Public Sub OpenFile(bble As String, category As String, pageUrl As String)
        Dim connId = Context.ConnectionId

        If WorkingLog.Exist(connId) Then
            CloseFile(connId)
        End If

        Dim log As WorkingLog

        log = New Core.WorkingLog
        log.BBLE = bble
        log.UserName = Context.User.Identity.Name
        log.UserId = Employee.GetInstance(log.UserName).EmployeeID
        log.Category = category
        log.PageUrl = pageUrl
        log.StartTime = DateTime.Now
        log.Status = Core.WorkingLog.WorkingLogStatus.Active
        log.ConnectionId = Context.ConnectionId
        log.Save()
    End Sub

    Public Sub CloseFile(bble As String, category As String, pageUrl As String)
        Dim connId = Context.ConnectionId
        Dim log = GetWorkingLog(Context.ConnectionId)

        If log Is Nothing Then
            If Core.WorkingLog.Exist(bble, category, pageUrl) Then
                log = WorkingLog.Instance(bble, category, pageUrl)
                log.Close()
                Return
            End If
        End If

        If log IsNot Nothing Then
            log.Close()
        End If
    End Sub

    Public Sub CloseFile(connId As String)
        Dim log = GetWorkingLog(connId)

        If log IsNot Nothing Then
            log.Close()
            'ConnectedUsers.Remove(log)
        End If
    End Sub

    Public Overrides Function OnDisconnected(stopCalled As Boolean) As Task
        CloseFile(Context.ConnectionId)

        Return MyBase.OnDisconnected(stopCalled)
    End Function

    Private Function GetWorkingLog(connId As String) As Core.WorkingLog
        Return WorkingLog.Instance(connId)
    End Function
End Class