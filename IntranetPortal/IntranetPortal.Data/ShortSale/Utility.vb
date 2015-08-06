Public Class ShortSaleUtility
    Public Shared Function SaveChangesObj(oldObj As Object, newObj As Object) As Object

        Return Core.Utility.SaveChangesObj(oldObj, newObj)

    End Function

    Public Shared Function BuildPropertyAddress2(num As String, strName As String, city As String, state As String, zip As String) As String
        If String.IsNullOrEmpty(num) AndAlso String.IsNullOrEmpty(strName) Then
            Return ""
        End If

        Dim result = String.Format("{0} {1}, ", num, strName)

        If Not String.IsNullOrEmpty(city) Then
            result += city & ", "
        End If

        result = result & state & " " & zip

        Return result.TrimStart.TrimEnd

    End Function

    Public Shared Function BuildPropertyAddress(num As String, strname As String, borough As String, neighName As String, zip As String) As String
        If String.IsNullOrEmpty(num) AndAlso String.IsNullOrEmpty(strname) Then
            Return ""
        End If

        Dim result = String.Format("{0} {1},", num, strname)

        If String.IsNullOrEmpty(borough) Then
            Return result
        End If

        If borough = "4" Then
            result = result & " " & neighName
        Else
            If BoroughNames(borough) IsNot Nothing Then
                result = result & " " & BoroughNames(borough)
            End If
        End If

        result = result & ",NY " & zip

        Return result.TrimStart.TrimEnd
    End Function

    Private Shared _boroughNames As Hashtable
    Private Shared ReadOnly Property BoroughNames As Hashtable
        Get
            If _boroughNames Is Nothing Then
                Dim ht As New Hashtable
                ht.Add("1", "Manhattan")
                ht.Add("2", "Bronx")
                ht.Add("3", "Brooklyn")
                ht.Add("5", "Staten Island")

                _boroughNames = ht
            End If

            Return _boroughNames
        End Get
    End Property

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
