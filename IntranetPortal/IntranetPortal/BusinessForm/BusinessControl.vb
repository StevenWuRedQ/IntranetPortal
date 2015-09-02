
Public Class BusinessControl

    Public Property Name As String
    Public Property AscxFile As String
    Public Property Visible As Boolean

End Class

Public Class BusinessListControl
    Inherits UserControl

    Public Property AscxFile As String

    Public Overridable Sub BindList()

    End Sub
End Class


