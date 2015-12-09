
Public Class BusinessDataBase

    Public Property Name As String

    Public Overridable Sub LogSave(saveBy As String)

    End Sub

    Public Overridable Sub LogOpen(openBy As String)

    End Sub

    Public Overridable Function LoadData(formId As Integer) As BusinessDataBase
        Return New BusinessDataBase
    End Function

    Public Overridable Function Save(itemData As FormDataItem) As String
        Return Nothing
    End Function

    'Public Shared Function Create(name As String) As BusinessDataBase
    '    Dim myobj = New BusinessDataBase

    '    If Not String.IsNullOrEmpty(name) Then
    '        Dim t = Type.GetType("IntranetPortal.Data." & name)
    '        If t IsNot Nothing Then
    '            Dim obj = Activator.CreateInstance(t)
    '            If obj IsNot Nothing Then
    '                myobj = obj
    '            End If
    '        End If
    '    End If

    '    Return myobj
    'End Function
End Class


