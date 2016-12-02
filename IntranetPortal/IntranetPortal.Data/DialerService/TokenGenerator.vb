Imports System.Configuration
Imports System.Net.Http
Imports Newtonsoft.Json

Public Class TokenGenerator


    Public Shared Function getPureCloudeToken() As String
        Try
            Using client As New HttpClient
                client.BaseAddress = New Uri("https://login.mypurecloud.com")
                Dim username = ConfigurationManager.AppSettings("pure_cloud_username")
                Dim passwd = ConfigurationManager.AppSettings("pure_cloud_password")
                Dim base64str = System.Convert.ToBase64String(Text.Encoding.UTF8.GetBytes(username & ":" & passwd))
                client.DefaultRequestHeaders.Add("Authorization", "Basic " & base64str)
                Dim content = New StringContent("grant_type=client_credentials", Text.Encoding.UTF8, "application/x-www-form-urlencoded")
                Dim responsetask = client.PostAsync("/oauth/token", content)
                responsetask.Wait()
                Dim response = responsetask.Result
                If response.IsSuccessStatusCode Then
                    Dim responsestrtask = response.Content.ReadAsStringAsync
                    responsestrtask.Wait()
                    Dim jobj = Linq.JObject.Parse(responsestrtask.Result)
                    Return jobj("access_token").ToString
                End If
                Return Nothing
            End Using
        Catch ex As Exception
            Return Nothing
        End Try
    End Function
End Class
