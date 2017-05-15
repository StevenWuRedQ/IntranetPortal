Imports System.Configuration
Imports Newtonsoft.Json.Linq
Imports RestSharp

Public Class GradingService
    Inherits RedqService
    Private Shared serviceUrl As String = ConfigurationManager.AppSettings("GPAGraderURL")
    Private Shared serviceKey As String = ConfigurationManager.AppSettings("GPAGraderKey")

    Public Sub New()
        Me.New(serviceUrl)
    End Sub

    Public Sub New(url As String)
        MyBase.New(url)
    End Sub


    Public Function GetData(url As String) As JToken
        Dim request As RestRequest = GetRequest(url, Method.[GET])

        Try
            Dim content As String = Execute(request, True)
            If Not String.IsNullOrEmpty(content) Then
                Return JToken.Parse(content)
            End If
            Return Nothing
        Catch ex As Exception
            Return Nothing
        End Try
    End Function

    Public Function PostData(url As String, data As JToken) As String
        Dim request As RestRequest = GetRequest(url, Method.POST)
        request.RequestFormat = DataFormat.Json
        request.AddParameter("application/json", data, ParameterType.RequestBody)

        Try
            Return Execute(request, True)
        Catch ex As Exception
            Throw ex
        End Try
    End Function


End Class
