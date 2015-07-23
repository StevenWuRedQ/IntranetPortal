Imports Newtonsoft.Json.Linq

Public Class JsArrayToStringConverter
    Inherits Newtonsoft.Json.JsonConverter

    Public Overrides Function CanConvert(objectType As Type) As Boolean
        Return True
    End Function

    Public Overrides Function ReadJson(reader As Newtonsoft.Json.JsonReader, objectType As Type, existingValue As Object, serializer As Newtonsoft.Json.JsonSerializer) As Object
        Dim jtoken = serializer.Deserialize(Of JToken)(reader)
        Return jtoken.ToString
    End Function

    Public Overrides Sub WriteJson(writer As Newtonsoft.Json.JsonWriter, value As Object, serializer As Newtonsoft.Json.JsonSerializer)
        Dim jData As New JArray
        If Not String.IsNullOrEmpty(value) Then
            Try
                jData = JArray.Parse(value)
            Catch ex As Exception

            End Try
        End If

        jData.WriteTo(writer)
    End Sub
End Class
