Public Class PropertyHelper
    Public Shared Function BuildPropertyAddress(num As String, strname As String, borough As String, neighName As String, zip As String) As String
        If String.IsNullOrEmpty(num) AndAlso String.IsNullOrEmpty(strname) Then
            Return ""
        End If

        Dim result = String.Format("{0} {1},", num, strname)

        If String.IsNullOrEmpty(borough) AndAlso String.IsNullOrEmpty(neighName) Then
            Return result
        End If

        If borough = "4" Then
            result = result & " " & neighName
        Else
            If BoroughNames(borough) IsNot Nothing Then
                result = result & " " & BoroughNames(borough)
            Else
                result = result & " " & neighName
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
End Class
