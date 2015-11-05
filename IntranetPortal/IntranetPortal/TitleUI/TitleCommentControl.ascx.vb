Public Class TitleCommentControl
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Dim managers = TitleManage.GetManagers
            reviewManagers.DataSource = managers
            reviewManagers.DataBind()
        End If
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

    Public ReadOnly Property ReviewManager As String
        Get
            Return reviewManagers.SelectedValue.ToString
        End Get

    End Property

    Public ReadOnly Property FollowUpDate As DateTime
        Get
            Return dtFollowup.Date
        End Get
    End Property

End Class