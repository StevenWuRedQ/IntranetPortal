Imports System.Configuration
Imports System.IO
Imports System.Net
Imports System.Net.Http
Imports System.Web.Script.Serialization
Imports CsvHelper

Public Class DialerRule
    Inherits BaseRule

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

    Public Async Function GetContactListExport(ListId As String) As Task(Of ContactListExportItem)
        Dim item As ContactListExportItem = Nothing
        Dim path = "/api/v2/outbound/contactlists/{0}/export"
        path = String.Format(path, ListId)
        Dim response = Await APIClient.GetAsync(path)
        Console.WriteLine(response.Headers)
        If (response.IsSuccessStatusCode) Then
            Dim itemstr = Await response.Content.ReadAsStringAsync()
            item = New JavaScriptSerializer().Deserialize(Of ContactListExportItem)(itemstr)
        End If
        Return item
    End Function

    Public Async Function DownloadContactListExportCSV(ListId As String) As Task
        Try
            Dim exportItem As ContactListExportItem = Await GetContactListExport(ListId)
            If exportItem IsNot Nothing Then
                Dim request As HttpWebRequest = WebRequest.Create(exportItem.uri)
                request.AllowAutoRedirect = True
                request.MaximumAutomaticRedirections = 10
                request.Headers.Add("Authorization", "bearer " & Token)
                Dim response = request.GetResponse()
                Dim content = response.GetResponseStream()
                Dim stream = New StreamReader(content, Text.UTF8Encoding.UTF8)
                Dim csv = New CsvReader(stream)
                csv.Configuration.HasHeaderRecord = True
                csv.Configuration.QuoteAllFields = True
                Dim records = csv.GetRecords(Of ExportItemDetails)().ToList()
            End If
        Catch ex As Exception

        End Try
    End Function

End Class

Public Class ContactListExportItem
    Public Property uri As String
    Public Property exportTimestamp As DateTime
End Class

Public Class ExportItemDetails

    Public Property inin_outbound_id As String

    Public Property Leads As String

End Class