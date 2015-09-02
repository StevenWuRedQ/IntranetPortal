Public Class BusinessForm

    Public Property Name As String
    Public Property Controls As List(Of BusinessControl)
    Public Property ListControl As String

    Private Shared _instance As BusinessForm

    Public Shared Function Instance(name As String)
        If _instance Is Nothing Then
            _instance = New BusinessForm
            _instance.Name = name
        End If

        Return _instance
    End Function

    Public Sub New()
        Me.Controls = New List(Of BusinessControl)
        Me.Controls.Add(New BusinessControl() With {
                        .Name = "Title",
                        .AscxFile = "~/TitleUI/TitleTab.ascx"
                    })
        Me.ListControl = "~/TitleUI/TitleCaseList.ascx"
    End Sub

End Class
