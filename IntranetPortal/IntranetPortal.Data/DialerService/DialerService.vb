Imports System.Configuration
Imports System.IO
Imports System.Net
Imports System.Net.Http
Imports System.Web.Script.Serialization
Imports CsvHelper
Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq

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

    Public Async Function InitialExport(listid As String) As Task(Of Boolean)
        Dim url = "/api/v2/outbound/contactlists/{0}/export"
        url = String.Format(url, listid)
        Dim content = New StringContent("", Text.Encoding.UTF8, "application/json")
        Dim response = Await APIClient.PostAsync(url, content)
        If response.IsSuccessStatusCode Then
            Return True
        End If
        Return False
    End Function

    Public Async Function GetExportURL(ListId As String) As Task(Of ContactListExportURLItem)
        Dim item As ContactListExportURLItem = Nothing
        Dim path = "/api/v2/outbound/contactlists/{0}/export"
        path = String.Format(path, ListId)
        Dim response = Await APIClient.GetAsync(path)
        If (response.IsSuccessStatusCode) Then
            Dim responsestr = Await response.Content.ReadAsStringAsync()
            item = JsonConvert.DeserializeObject(Of ContactListExportURLItem)(responsestr)
        End If
        Return item
    End Function

    Public Async Function ExportList(ListId As String) As Task(Of List(Of DialerContact))
        Try
            Dim initResult = Await InitialExport(ListId)
            If initResult = False Then
                Return Nothing
            End If

            Dim exportItem As ContactListExportURLItem = Await GetExportURL(ListId)
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
                Return ParseCSV(memory)
            End If
            Return Nothing
        Catch ex As Exception
            Return Nothing
        End Try
    End Function

    Public Async Function ExportList(ListId As String, isDirectDownLoad As Boolean) As Task(Of List(Of DialerContact))
        If isDirectDownLoad <> True Then
            Dim stream = Await ExportList(ListId)
            Return stream
        Else
            Dim initResult = Await InitialExport(ListId)
            If initResult = False Then
                Return Nothing
            End If

            Dim path = "https://api.mypurecloud.com/api/v2/outbound/contactlists/{0}/export?download=true"
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
                Return ParseCSV(memory)
            Catch ex As Exception
                Return Nothing
            End Try
        End If

    End Function

    Public Async Function AddContactList(listName As String) As Task(Of JObject)
        Dim template = <![CDATA[Hello{
            "name": "{0}",
            "version": 1,
            "columnNames": [
                "BBLE",
                "Leads",
                "Address",
                "Comments",
                "Owner",
                "CoOwner",
                "OwnerPhone1",
                "CoOwnerPhone1",
                "OwnerPhone2",
                "CoOwnerPhone2",
                "OwnerPhone3",
                "CoOwnerPhone3",
                "OwnerPhone4",
                "CoOwnerPhone4",
                "OwnerPhone5",
                "CoOwnerPhone5",
                "OwnerPhone6",
                "CoOwnerPhone6",
                "OwnerPhone7",
                "CoOwnerPhone7",
                "OwnerPhone8",
                "CoOwnerPhone8",
                "OwnerPhone9",
                "CoOwnerPhone9",
                "OwnerPhone10",
                "CoOwnerPhone10",
                "OwnerPhone11",
                "CoOwnerPhone11",
                "OwnerPhone12",
                "CoOwnerPhone12",
                "OwnerPhone13",
                "CoOwnerPhone13",
                "OwnerPhone14",
                "CoOwnerPhone14",
                "OwnerPhone15",
                "CoOwnerPhone15",
                "OwnerPhone16",
                "CoOwnerPhone16",
                "OwnerPhone17",
                "CoOwnerPhone17",
                "OwnerPhone18",
                "CoOwnerPhone18",
                "OwnerPhone19",
                "CoOwnerPhone19",
                "OwnerPhone20",
                "CoOwnerPhone20"
              ],
            "phoneColumns": [
                {
                  "columnName": "OwnerPhone1",
                  "type": "Cell"
                },
                {
                  "columnName": "OwnerPhone2",
                  "type": "Cell"
                },
                {
                  "columnName": "OwnerPhone3",
                  "type": "Cell"
                },
                {
                  "columnName": "OwnerPhone4",
                  "type": "Cell"
                },
                {
                  "columnName": "OwnerPhone5",
                  "type": "Cell"
                },
                {
                  "columnName": "OwnerPhone6",
                  "type": "Cell"
                },
                {
                  "columnName": "OwnerPhone7",
                  "type": "Cell"
                },
                {
                  "columnName": "OwnerPhone8",
                  "type": "Cell"
                },
                {
                  "columnName": "OwnerPhone9",
                  "type": "Cell"
                },
                {
                  "columnName": "OwnerPhone10",
                  "type": "Cell"
                },
                {
                  "columnName": "OwnerPhone11",
                  "type": "Cell"
                },
                {
                  "columnName": "OwnerPhone12",
                  "type": "Cell"
                },
                {
                  "columnName": "OwnerPhone13",
                  "type": "Cell"
                },
                {
                  "columnName": "OwnerPhone14",
                  "type": "Cell"
                },
                {
                  "columnName": "OwnerPhone15",
                  "type": "Cell"
                },
                {
                  "columnName": "OwnerPhone16",
                  "type": "Cell"
                },
                {
                  "columnName": "OwnerPhone17",
                  "type": "Cell"
                },
                {
                  "columnName": "OwnerPhone18",
                  "type": "Cell"
                },
                {
                  "columnName": "OwnerPhone19",
                  "type": "Cell"
                },
                {
                  "columnName": "OwnerPhone20",
                  "type": "Cell"
                },
                {
                  "columnName": "CoOwnerPhone1",
                  "type": "Cell"
                },
                {
                  "columnName": "CoOwnerPhone2",
                  "type": "Cell"
                },
                {
                  "columnName": "CoOwnerPhone3",
                  "type": "Cell"
                },
                {
                  "columnName": "CoOwnerPhone4",
                  "type": "Cell"
                },
                {
                  "columnName": "CoOwnerPhone5",
                  "type": "Cell"
                },
                {
                  "columnName": "CoOwnerPhone6",
                  "type": "Cell"
                },
                {
                  "columnName": "CoOwnerPhone7",
                  "type": "Cell"
                },
                {
                  "columnName": "CoOwnerPhone8",
                  "type": "Cell"
                },
                {
                  "columnName": "CoOwnerPhone9",
                  "type": "Cell"
                },
                {
                  "columnName": "CoOwnerPhone10",
                  "type": "Cell"
                },
                {
                  "columnName": "CoOwnerPhone11",
                  "type": "Cell"
                },
                {
                  "columnName": "CoOwnerPhone12",
                  "type": "Cell"
                },
                {
                  "columnName": "CoOwnerPhone13",
                  "type": "Cell"
                },
                {
                  "columnName": "CoOwnerPhone14",
                  "type": "Cell"
                },
                {
                  "columnName": "CoOwnerPhone15",
                  "type": "Cell"
                },
                {
                  "columnName": "CoOwnerPhone16",
                  "type": "Cell"
                },
                {
                  "columnName": "CoOwnerPhone17",
                  "type": "Cell"
                },
                {
                  "columnName": "CoOwnerPhone18",
                  "type": "Cell"
                },
                {
                  "columnName": "CoOwnerPhone19",
                  "type": "Cell"
                },
                {
                  "columnName": "CoOwnerPhone20",
                  "type": "Cell"
                }
              ],
            "previewModeColumnName": "",
            "previewModeAcceptedValues": []
                }]]>.Value
        Dim data = String.Format(template, listName)
        Dim content = New StringContent(data, Text.Encoding.UTF8, "application/json")
        Dim url = "/api/v2/outbound/contactlists"
        Dim response = Await APIClient.PostAsync(url, content)
        If response.IsSuccessStatusCode Then
            Dim responsestr = Await response.Content.ReadAsStringAsync()
            Return JsonConvert.DeserializeObject(responsestr)
        End If
        Return Nothing
    End Function

    Public Async Function DeleteContactList(listid As String) As Task(Of Boolean)
        Dim url = "/api/v2/outbound/contactlists/{0}"
        url = String.Format(url, listid)
        Dim response = Await APIClient.DeleteAsync(url)
        If response.IsSuccessStatusCode Then
            Return True
        End If
        Return False
    End Function

    Public Async Function GetContactFromList(listId As String, contactId As String) As Task(Of JObject)
        Dim url = "/api/v2/outbound/contactlists/{0}/contacts/{1}"
        url = String.Format(url, listId, contactId)
        Dim response = Await APIClient.GetAsync(url)
        If (response.IsSuccessStatusCode) Then
            Dim responsestr = Await response.Content.ReadAsStringAsync()
            Return JsonConvert.DeserializeObject(responsestr)
        End If
        Return Nothing
    End Function

    Public Async Function AddContactsToList(listId As String, contacts As List(Of DialerContact)) As Task(Of List(Of JObject))
        Dim jsonlist = New List(Of JObject)
        For Each contact In contacts
            Dim item = New JObject
            Dim data = ConvertContactToJson(contact)
            item.Add("contactListId", listId)
            item.Add("data", data)
            jsonlist.Add(item)
        Next

        Dim url = "/api/v2/outbound/contactlists/{0}/contacts"
        url = String.Format(url, listId)
        Dim content = New StringContent(JsonConvert.SerializeObject(jsonlist), Text.Encoding.UTF8, "application/json")
        Dim response = Await APIClient.PostAsync(url, content)
        If response.IsSuccessStatusCode Then
            Dim responsestr = Await response.Content.ReadAsStringAsync()
            Return JsonConvert.DeserializeObject(Of List(Of JObject))(responsestr)
        End If
        Return Nothing
    End Function

    Public Async Function RemoveContactFromList(listId As String, contactId As String) As Task(Of Boolean)
        Dim url = "/api/v2/outbound/contactlists/{0}/contacts/{1}"
        url = String.Format(url, listId, contactId)
        Dim response = Await APIClient.DeleteAsync(url)
        If response.IsSuccessStatusCode Then
            Return True
        End If
        Return False
    End Function

    Public Async Function RemoveContactFromList(contact As DialerContact) As Task(Of Boolean)
        Return Await RemoveContactFromList(contact.ContactListId, contact.inin_outbound_id)
    End Function

    Public Async Function UpdateContactInList(contact As DialerContact) As Task(Of JObject)
        Dim json = Await GetContactFromList(contact.ContactListId, contact.inin_outbound_id)
        Dim newdata = ConvertContactToJson(contact)
        json.Property("data").Remove()
        json.Add("data", newdata)

        Dim url = "/api/v2/outbound/contactlists/{0}/contacts/{1}"
        url = String.Format(url, contact.ContactListId, contact.inin_outbound_id)
        Dim content = New StringContent(JsonConvert.SerializeObject(json), Text.Encoding.UTF8, "application/json")
        Dim response = Await APIClient.PutAsync(url, content)
        If response.IsSuccessStatusCode Then
            Dim responsestr = Await response.Content.ReadAsStringAsync()
            Return JsonConvert.DeserializeObject(responsestr)
        End If
        Return Nothing

    End Function

    Public Function ParseCSV(response As Stream) As List(Of DialerContact)
        If response IsNot Nothing Then
            Dim stream = New StreamReader(response, Text.UTF8Encoding.UTF8)
            Dim csv = New CsvReader(stream)
            csv.Configuration.HasHeaderRecord = True
            csv.Configuration.QuoteAllFields = True
            Dim records = csv.GetRecords(Of DialerContact)().ToList()
        End If
    End Function

    Public Function ConvertContactToJson(contact As DialerContact) As JObject
        Dim dataObject = New JObject()
        dataObject.Add("BBLE", contact.BBLE)
        dataObject.Add("Leads", contact.Leads)
        dataObject.Add("Address", contact.Address)
        dataObject.Add("Comments", contact.Comments)
        dataObject.Add("Owner", contact.Owner)
        dataObject.Add("CoOwner", contact.CoOwner)

        dataObject.Add("OwnerPhone1", contact.OwnerPhone1)
        dataObject.Add("CoOwnerPhone1", contact.CoOwnerPhone1)
        dataObject.Add("OwnerPhone2", contact.OwnerPhone2)
        dataObject.Add("CoOwnerPhone2", contact.CoOwnerPhone2)
        dataObject.Add("OwnerPhone3", contact.OwnerPhone3)
        dataObject.Add("CoOwnerPhone3", contact.CoOwnerPhone3)
        dataObject.Add("OwnerPhone4", contact.OwnerPhone4)
        dataObject.Add("CoOwnerPhone4", contact.CoOwnerPhone4)
        dataObject.Add("OwnerPhone5", contact.OwnerPhone5)
        dataObject.Add("CoOwnerPhone5", contact.CoOwnerPhone5)
        dataObject.Add("OwnerPhone6", contact.OwnerPhone6)
        dataObject.Add("CoOwnerPhone6", contact.CoOwnerPhone6)
        dataObject.Add("OwnerPhone7", contact.OwnerPhone7)
        dataObject.Add("CoOwnerPhone7", contact.CoOwnerPhone7)
        dataObject.Add("OwnerPhone8", contact.OwnerPhone8)
        dataObject.Add("CoOwnerPhone8", contact.CoOwnerPhone8)
        dataObject.Add("OwnerPhone9", contact.OwnerPhone9)
        dataObject.Add("CoOwnerPhone9", contact.CoOwnerPhone9)
        dataObject.Add("OwnerPhone10", contact.OwnerPhone10)
        dataObject.Add("CoOwnerPhone10", contact.CoOwnerPhone10)
        dataObject.Add("OwnerPhone11", contact.OwnerPhone11)
        dataObject.Add("CoOwnerPhone11", contact.CoOwnerPhone11)
        dataObject.Add("OwnerPhone12", contact.OwnerPhone12)
        dataObject.Add("CoOwnerPhone12", contact.CoOwnerPhone12)
        dataObject.Add("OwnerPhone13", contact.OwnerPhone13)
        dataObject.Add("CoOwnerPhone13", contact.CoOwnerPhone13)
        dataObject.Add("OwnerPhone14", contact.OwnerPhone14)
        dataObject.Add("CoOwnerPhone14", contact.CoOwnerPhone14)
        dataObject.Add("OwnerPhone15", contact.OwnerPhone15)
        dataObject.Add("CoOwnerPhone15", contact.CoOwnerPhone15)
        dataObject.Add("OwnerPhone16", contact.OwnerPhone16)
        dataObject.Add("CoOwnerPhone16", contact.CoOwnerPhone16)
        dataObject.Add("OwnerPhone17", contact.OwnerPhone17)
        dataObject.Add("CoOwnerPhone17", contact.CoOwnerPhone17)
        dataObject.Add("OwnerPhone18", contact.OwnerPhone18)
        dataObject.Add("CoOwnerPhone18", contact.CoOwnerPhone18)
        dataObject.Add("OwnerPhone19", contact.OwnerPhone19)
        dataObject.Add("CoOwnerPhone19", contact.CoOwnerPhone19)
        dataObject.Add("OwnerPhone20", contact.OwnerPhone20)
        dataObject.Add("CoOwnerPhone20", contact.CoOwnerPhone20)

        Return dataObject
    End Function

End Class

Public Class ContactListExportURLItem
    Public Property uri As String
    Public Property exportTimestamp As DateTime
End Class