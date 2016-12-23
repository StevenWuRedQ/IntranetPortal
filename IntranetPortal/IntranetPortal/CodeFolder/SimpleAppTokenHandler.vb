Imports System.Net.Http
Imports System.Net
Imports System.Threading
Imports System.Threading.Tasks
Imports IntranetPortal.Data

''' <summary>
''' Simple application token handler authorization
''' </summary>
Public Class SimpleAppTokenHandler
    Inherits DelegatingHandler

    Private apiKey As String = ConfigurationManager.AppSettings("PublicApiKey")
    Private apiKeyName As String = "apiKey"

    ''' <summary>
    ''' Override api request support both in header and parameters token
    ''' </summary>
    ''' <param name="request"></param>
    ''' <param name="cancellationToken"></param>
    ''' <returns></returns>
    Protected Overrides Function SendAsync(request As HttpRequestMessage, cancellationToken As CancellationToken) As Task(Of HttpResponseMessage)
        ' Only authored web api
        If request.RequestUri.AbsolutePath.ToLower.Contains("api/dataservice") Then
            Dim requestToken = GetApiToken(request)
            If Not String.IsNullOrEmpty(requestToken) Then

                Dim serverToken = apiKey

                If requestToken = serverToken Then
                    ' match token succeed
                    Dim response = MyBase.SendAsync(request, cancellationToken)
                    Return response
                End If
            End If

            Return UnauthoredRequest(request).Task
        End If

        Return MyBase.SendAsync(request, cancellationToken)
    End Function

    ''' <summary>
    ''' Get Api token from request header and parameter
    ''' </summary>
    ''' <param name="request">http request</param>
    ''' <returns></returns>
    Public Function GetApiToken(request As HttpRequestMessage) As String
        ' Support both in heder and parameters token
        Dim queryToken = request.GetQueryNameValuePairs().Where(Function(kv) kv.Key = apiKeyName).[Select](Function(kv) kv.Value).FirstOrDefault()
        Dim headerToken As String = Nothing
        If request.Headers.Contains(apiKeyName) Then
            headerToken = request.Headers.GetValues(apiKeyName).FirstOrDefault()
        End If

        Return If(queryToken, headerToken)
    End Function

    ''' <summary>
    ''' Build unauthored request
    ''' </summary>
    ''' <returns></returns>
    Public Function UnauthoredRequest(request As HttpRequestMessage) As TaskCompletionSource(Of HttpResponseMessage)
        Dim response = request.CreateResponse(HttpStatusCode.Unauthorized)
        response.Headers.Add("HASERROR", "TRUE")
        Dim tsc = New TaskCompletionSource(Of HttpResponseMessage)()
        tsc.SetResult(response)
        Return tsc
    End Function

End Class
