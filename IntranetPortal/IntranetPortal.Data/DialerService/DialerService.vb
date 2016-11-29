Imports System.Configuration
Imports System.IO
Imports System.Net
Imports System.Net.Http
Imports System.Web.Script.Serialization
Imports CsvHelper

Public Class DialerService
    Shared APIClient As HttpClient
    Shared Token As String

    Sub New()
        APIClient = New HttpClient()
        'System.Net.ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12 Or SecurityProtocolType.Tls11 Or SecurityProtocolType.Tls
        APIClient.BaseAddress = New Uri("https://api.mypurecloud.com")
        Token = ConfigurationManager.AppSettings("pure_cloud_token")
        If Not String.IsNullOrEmpty(Token) Then
            Dim BearerToken = "bearer " & Token
            APIClient.DefaultRequestHeaders.Add("Authorization", BearerToken)
        End If
    End Sub

    Public Async Function GetContactListExportURL(ListId As String) As Task(Of ContactListExportURLItem)
        Dim item As ContactListExportURLItem = Nothing
        Dim path = "/api/v2/outbound/contactlists/{0}/export"
        path = String.Format(path, ListId)
        Dim response = Await APIClient.GetAsync(path)
        If (response.IsSuccessStatusCode) Then
            Dim itemstr = Await response.Content.ReadAsStringAsync()
            item = New JavaScriptSerializer().Deserialize(Of ContactListExportURLItem)(itemstr)
        End If
        Return item
    End Function

    Public Async Function ExportListDetail(ListId As String) As Task(Of Stream)
        Try
            Dim exportItem As ContactListExportURLItem = Await GetContactListExportURL(ListId)
            If exportItem IsNot Nothing Then
                Dim request As HttpWebRequest = WebRequest.Create(exportItem.uri)
                request.AllowAutoRedirect = True
                request.MaximumAutomaticRedirections = 10
                request.Headers.Add("Authorization", "bearer " & Token)
                Dim response = request.GetResponse()
                Dim content = response.GetResponseStream()
                Dim memory = New MemoryStream
                content.CopyTo(memory)
                response.Close()
                Return memory
            End If
            Return Nothing
        Catch ex As Exception
            Return Nothing
        End Try
    End Function

    Public Async Function ExportListDetail(ListId As String, isDirectDownLoad As Boolean) As Task(Of Stream)
        If isDirectDownLoad <> True Then
            Dim stream = Await ExportListDetail(ListId)
            Return stream
        Else
            Dim path = "https://api.mypurecloud.com//api/v2/outbound/{0}/export?download=true"
            path = String.Format(path, ListId)
            Try
                Dim request As HttpWebRequest = WebRequest.Create(path)
                request.AllowAutoRedirect = True
                request.MaximumAutomaticRedirections = 10
                request.Headers.Add("Authorization", "bearer " & Token)
                Dim response = request.GetResponse()
                Dim content = response.GetResponseStream()
                Dim memory = New MemoryStream
                content.CopyTo(memory)
                response.Close()
                Return memory
            Catch ex As Exception
                Return Nothing
            End Try
        End If

    End Function


    Public Sub Parse(response As Stream)
        If response IsNot Nothing Then
            Dim stream = New StreamReader(response, Text.UTF8Encoding.UTF8)
            Dim csv = New CsvReader(stream)
            csv.Configuration.HasHeaderRecord = True
            csv.Configuration.QuoteAllFields = True
            Dim records = csv.GetRecords(Of DialerContact)().ToList()
        End If
    End Sub


End Class

Public Class ContactListExportURLItem
    Public Property uri As String
    Public Property exportTimestamp As DateTime
End Class