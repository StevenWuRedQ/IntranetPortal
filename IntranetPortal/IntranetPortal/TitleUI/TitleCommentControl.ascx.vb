Public Class TitleCommentControl
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'If Not Page.IsPostBack Then
        '    Dim data = Utility.Enum2Dictinary(GetType(IntranetPortal.Data.TitleCase.DataStatus))
        '    selCategory.Items.Clear()
        '    selCategory.Items.Add("")
        '    For Each item In data
        '        selCategory.Items.Add(New ListItem(item.Key, item.Value))
        '    Next
        'End If
    End Sub

    Public ReadOnly Property Status As Data.TitleCase.DataStatus?
        Get
            If Not String.IsNullOrEmpty(selCategory.Value) Then
                Return CInt(selCategory.Value)
            End If

            Return Nothing
        End Get
    End Property

    Public ReadOnly Property Category As String
        Get
            Return selCategory.Items(selCategory.SelectedIndex).Text
        End Get
    End Property

    Public ReadOnly Property FollowUpDate As DateTime
        Get
            Return dtFollowup.Date
        End Get
    End Property

End Class