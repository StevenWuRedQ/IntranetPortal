Imports IntranetPortal.Data.RulesEngine
Imports System.ServiceModel
Imports System.Runtime.Serialization

Public Class RulesEngineServices
    Implements IDisposable

    Private rulesEngine As RulesEngineServicesClient

    Public Property RulesEngineServer As String

    Public Sub New(serverName As String)
        Me.RulesEngineServer = serverName
        Me.Open()
    End Sub

    Public Function Rules() As RulesEngine.BaseRule()
        If rulesEngine Is Nothing Then
            Me.Open()
        End If
        'Dim r = rulesEngine.GetRulesString
        Dim result As BaseRule() = rulesEngine.GetRules
        Return result.Where(Function(r) Not String.IsNullOrEmpty(r.StatusStr)).ToArray
    End Function

    Public Function StartRule(ruleId As String) As Boolean
        If rulesEngine Is Nothing Then
            Me.Open()
        End If

        rulesEngine.StartRule(ruleId)
        Return True
    End Function

    Public Sub StopRule(ruleId As String)
        rulesEngine.StopRule(ruleId)
    End Sub

    Private Sub Open()
        Dim binding As New NetTcpBinding
        binding.Security.Mode = SecurityMode.None
        binding.CloseTimeout = TimeSpan.Parse("00:10:00")
        binding.OpenTimeout = TimeSpan.Parse("00:10:00")
        binding.SendTimeout = TimeSpan.Parse("00:10:00")
        binding.MaxBufferPoolSize = 2147483647
        binding.MaxBufferSize = 2147483647
        binding.MaxReceivedMessageSize = 2147483647
        binding.ReaderQuotas.MaxArrayLength = 2147483647
        binding.ReaderQuotas.MaxNameTableCharCount = 2147483647
        binding.ReaderQuotas.MaxStringContentLength = 2147483647
        binding.ReaderQuotas.MaxDepth = 2147483647
        binding.ReaderQuotas.MaxBytesPerRead = 2147483647

        Dim endpointId = EndpointIdentity.CreateDnsIdentity("RulesEngineService")
        Dim myEndPoint As New EndpointAddress(New Uri(String.Format("net.tcp://{0}:8001/RulesEngineService", RulesEngineServer)), endpointId)
        rulesEngine = New RulesEngineServicesClient(binding, myEndPoint)
        rulesEngine.Open()
    End Sub

#Region "IDisposable Support"
    Private disposedValue As Boolean ' To detect redundant calls

    ' IDisposable
    Protected Overridable Sub Dispose(disposing As Boolean)
        If Not Me.disposedValue Then
            If disposing Then
                ' TODO: dispose managed state (managed objects).

            End If

            ' TODO: free unmanaged resources (unmanaged objects) and override Finalize() below.
            ' TODO: set large fields to null.
        End If

        If Me.rulesEngine IsNot Nothing AndAlso Me.rulesEngine.State = CommunicationState.Opened Then
            Me.rulesEngine.Close()
        End If

        Me.disposedValue = True
    End Sub

    ' TODO: override Finalize() only if Dispose(ByVal disposing As Boolean) above has code to free unmanaged resources.
    'Protected Overrides Sub Finalize()
    '    ' Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
    '    Dispose(False)
    '    MyBase.Finalize()
    'End Sub

    ' This code added by Visual Basic to correctly implement the disposable pattern.
    Public Sub Dispose() Implements IDisposable.Dispose
        ' Do not change this code.  Put cleanup code in Dispose(disposing As Boolean) above.
        Dispose(True)
        GC.SuppressFinalize(Me)
    End Sub
#End Region

End Class

Namespace RulesEngine

    Partial Public Class BaseRule
        <DataMember>
        Public Property StatusStr As String
            Get
                Return Me.Status.ToString()
            End Get
            Set(value As String)

            End Set
        End Property

    End Class

End Namespace
