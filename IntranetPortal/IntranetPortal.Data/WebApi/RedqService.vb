Imports RestSharp
Imports System.Configuration
Imports System.Runtime.CompilerServices
Imports System.Net

''' <summary>
''' Base service object for Redq web api
''' </summary>
Public Class RedqService
    Private Shared SericeUrl As String = ConfigurationManager.AppSettings("EcourtServiceUrl")
    Private Shared apiKey As String = ConfigurationManager.AppSettings("RedqServiceKey")

    Protected Sub New()
        client = New RestClient(SericeUrl)
        System.Net.WebRequest.DefaultWebProxy = Nothing
        client.Proxy = Nothing
    End Sub

    Protected Sub New(url As String)
        client = New RestClient(url)
        System.Net.WebRequest.DefaultWebProxy = Nothing
        client.Proxy = Nothing
    End Sub


    Protected Function GetRequest(url As String, method As RestSharp.Method) As RestRequest
        Dim request As New RestRequest(url, method)
        request.AddHeader("apiKey", apiKey)
        Return request
    End Function

    Protected Function Execute(request As RestRequest, Optional emptyWhenNotFound As Boolean = False) As String
        Dim result = client.Execute(request)

        If result.IsSuccessful Then
            Return result.Content
        Else
            If result.StatusCode.IsNotFound AndAlso emptyWhenNotFound Then
                Return Nothing
            End If

            Throw New Exception(HandleErrorResponse(request, result))
        End If
    End Function

    Protected Function Execute(Of T As New)(request As RestRequest, Optional emptyWhenNotFound As Boolean = False) As T
        Dim result = client.Execute(Of T)(request)

        If result.IsSuccessful Then
            Return result.Data
        Else
            If result.StatusCode.IsNotFound AndAlso emptyWhenNotFound Then
                Return Nothing
            End If

            Throw New Exception(HandleErrorResponse(request, result))
        End If
    End Function

    Protected Function HandleErrorResponse(request As IRestRequest, response As IRestResponse) As String
        Dim statusString As String = String.Format("{0} {1} - {2}", CInt(response.StatusCode), response.StatusCode, response.StatusDescription)
        Dim errorString As String = Convert.ToString("Response status: ") & statusString

        Dim resultMessage As String = ""
        If Not response.StatusCode.IsSuccessStatusCode() Then
            If String.IsNullOrWhiteSpace(resultMessage) Then
                resultMessage = "An error occurred while processing the request: " + response.StatusDescription
            End If
        End If
            If response.ErrorException IsNot Nothing Then
            If String.IsNullOrWhiteSpace(resultMessage) Then
                resultMessage = "An exception occurred while processing the request: " + response.ErrorException.Message
            End If
            errorString = errorString & ", Exception: " & response.ErrorException.Message
        End If

        Return resultMessage
    End Function

    Private client As RestClient
End Class

Public Module RestSharpExtensionMethods
    <Extension()>
    Public Function IsSuccessful(ByVal response As IRestResponse) As Boolean
        Return response.StatusCode.IsSuccessStatusCode() AndAlso response.ResponseStatus = ResponseStatus.Completed
    End Function

    <Extension()>
    Public Function IsNotFound(ByVal responseCode As HttpStatusCode) As Boolean
        Return responseCode = HttpStatusCode.NotFound
    End Function

    <Extension()>
    Public Function IsSuccessStatusCode(ByVal responseCode As HttpStatusCode) As Boolean
        Return responseCode >= 200 AndAlso responseCode <= 399
    End Function
End Module

Public Class NotFoundException
    Inherits Exception

    Public Sub New(msg As String)
        MyBase.New(msg)
    End Sub

End Class