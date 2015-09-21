Imports System.Reflection
Imports System.ComponentModel
Imports System.Net
Imports System.IO
Imports Newtonsoft.Json.Linq
Imports System.Text.RegularExpressions

Public Class Utility
    Public Shared Function SaveChangesObj(oldObj As Object, newObj As Object) As Object
        Dim type = oldObj.GetType()

        For Each prop In type.GetProperties.Where(Function(p) p.CanWrite)
            Dim newValue = prop.GetValue(newObj)
            If newValue IsNot Nothing Then
                Dim oldValue = prop.GetValue(oldObj)
                If Not newValue.Equals(oldValue) Then
                    If prop.CanWrite Then
                        prop.SetValue(oldObj, newValue)
                    End If
                End If
            Else
                Dim oldValue = prop.GetValue(oldObj)
                If oldValue IsNot Nothing Then
                    If prop.PropertyType Is GetType(DateTime?) OrElse prop.PropertyType Is GetType(Boolean?) OrElse prop.PropertyType Is GetType(Integer?) _
                        OrElse prop.PropertyType Is GetType(String) Then
                        If prop.CanWrite Then
                            prop.SetValue(oldObj, newValue)
                        End If
                    End If
                End If
            End If
        Next

        Return oldObj
    End Function

    Public Shared Function CopyTo(fromObj As Object, toObj As Object) As Object
        Dim type = fromObj.GetType()
        Dim toType = toObj.GetType
        Dim toProperties = toType.GetProperties

        For Each prop In type.GetProperties
            Dim toProp = toType.GetProperty(prop.Name)

            If toProp IsNot Nothing AndAlso (toProp.PropertyType.IsPrimitive Or toProp.PropertyType Is GetType(String) Or toProp.PropertyType.IsValueType) Then
                If toProp IsNot Nothing AndAlso toProp.CanWrite Then
                    toProp.SetValue(toObj, prop.GetValue(fromObj))
                End If
            End If
        Next

        Return toObj
    End Function

    Public Shared Function GetEnumDescription(ByVal EnumConstant As [Enum]) As String
        Dim fi As FieldInfo = EnumConstant.GetType().GetField(EnumConstant.ToString())

        If fi Is Nothing Then
            Return ""
        End If

        Dim attr() As DescriptionAttribute = _
                      DirectCast(fi.GetCustomAttributes(GetType(DescriptionAttribute), _
                      False), DescriptionAttribute())

        If attr.Length > 0 Then
            Return attr(0).Description
        Else
            Return EnumConstant.ToString()
        End If
    End Function
    Public Shared Function Address2BBLE(address As String) As String
        Dim baseURL = "https://api.cityofnewyork.us/geoclient/v1/search.json?app_id=be97fb56&app_key=b51823efd58f25775df3b2956a7b2bef"
        baseURL = baseURL & "&input=" & address
        'baseURL = baseURL & "&houseNumber=" & houseNumber
        'baseURL = baseURL & "&street=" & street
        'baseURL = baseURL & "&borough=" & borough
        '"https://api.cityofnewyork.us/geoclient/v1/search.json?app_id=9cd0a15f&app_key=54dc84bcaca9ff4877da771750033275&houseNumber=433&street=EAST%208TH%20STREET&borough=BROOKLYN"
        Dim request As WebRequest = WebRequest.Create(baseURL)
        ' If required by the server, set the credentials.
        request.Credentials = CredentialCache.DefaultCredentials

        Try
            request.GetResponse()
        Catch ex As Exception
            Throw New Exception("Get Error " + address)
        End Try
        ' Get the response. 
        Dim response As HttpWebResponse = CType(request.GetResponse(), HttpWebResponse)
        ' Display the status.
        Console.WriteLine(response.StatusDescription)
        ' Get the stream containing content returned by the server. 
        Dim dataStream As Stream = response.GetResponseStream()
        ' Open the stream using a StreamReader for easy access. 
        Dim reader As New StreamReader(dataStream)
        ' Read the content. 
        Dim reslut As String = reader.ReadToEnd()
        Dim values = JObject.Parse(reslut)
        Dim info = CType(values.Item("results"), JArray)
        Dim Erray = ""
        If (info IsNot Nothing) AndAlso info.Count > 0 Then
            Dim bbl = info(0).Item("response").Item("bbl").ToString
            If (bbl IsNot Nothing) Then
                Return bbl
            Else
                Erray = "Get Error " + If(info.Item("message") IsNot Nothing, info.Item("message").ToString, "")
            End If
        Else
            Erray = "Get Error " + address
        End If
        Throw New Exception(Erray)
    End Function
    'Change address 2 BBLE
    Public Shared Function Address2BBLE(houseNumber As String, street As String, borough As String) As String

        Dim address = String.Format("{0} {1} {2}", houseNumber, street, borough)
        'baseURL = baseURL & "&houseNumber=" & houseNumber
        'baseURL = baseURL & "&street=" & street
        'baseURL = baseURL & "&borough=" & borough
        Try
            Return Address2BBLE(address)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Shared Function RemoveHtmlTags(html As String) As String
        Dim text = Regex.Replace(html, "<[^>]*>", String.Empty)
        Return text
    End Function

    Public Shared Function StripTagsCharArray(source As String) As String
        Dim array As Char() = New Char(source.Length - 1) {}
        Dim arrayIndex As Integer = 0
        Dim inside As Boolean = False

        For i As Integer = 0 To source.Length - 1
            Dim [let] As Char = source(i)
            If [let] = "<"c Then
                inside = True
                Continue For
            End If
            If [let] = ">"c Then
                inside = False
                Continue For
            End If
            If Not inside Then
                array(arrayIndex) = [let]
                arrayIndex += 1
            End If
        Next
        Return New String(array, 0, arrayIndex)
    End Function



End Class
