Imports log4net
Imports log4net.Config

''' <summary>
''' The Service Log singleton class
''' </summary>
Public Class ServiceLog
    Public Delegate Sub WriteLog(msg As String)
    Public Delegate Sub WriteException(msg As String, ex As Exception)

    Public Event OnWriteException As WriteException
    Public Event OnWriteLog As WriteLog

    Public Shared Property Debug As Boolean = CBool(System.Configuration.ConfigurationManager.AppSettings("Debug"))

    Private Sub New()

    End Sub

    Private Shared logInstance As ServiceLog
    ''' <summary>
    ''' Get Singleton instance
    ''' </summary>
    ''' <returns></returns>
    Public Shared Function GetInstance() As ServiceLog
        If logInstance Is Nothing Then
            logInstance = New ServiceLog
        End If

        Return logInstance
    End Function

    Public Shared Sub Log(msg As String)
        Dim log = GetInstance()
        log.WriteServiceLog(msg)
    End Sub

    Public Shared Sub Log(msg As String, ex As Exception)
        Dim log = GetInstance()
        log.WriteServiceError(msg, ex)
    End Sub

    Private Sub WriteServiceError(msg As String, ex As Exception)
        Logger.Log.Error(msg, ex)
        RaiseEvent OnWriteException(msg, ex)
    End Sub

    Private Sub WriteServiceLog(msg As String)
        Logger.Log.Info(msg)
        RaiseEvent OnWriteLog(msg)
    End Sub
End Class

Public NotInheritable Class Logger
    Private Sub New()
    End Sub
    Private Shared ReadOnly m_log As ILog = LogManager.GetLogger(GetType(Logger))
    Private Shared _configured As Boolean
    Private Shared _lock As New Object()
    Public Shared ReadOnly Property Log() As ILog
        Get
            If Not _configured Then
                SyncLock _lock
                    If Not _configured Then
                        InitLogger()
                        _configured = True
                    End If
                End SyncLock
            End If
            Return m_log
        End Get
    End Property

    Public Shared Sub InitLogger()
        XmlConfigurator.Configure()
    End Sub
End Class
