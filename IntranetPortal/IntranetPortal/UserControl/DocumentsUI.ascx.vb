Imports System.Security
Imports System.Web.Services
Imports IntranetPortal.Core

Public Class DocumentsUI
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'If Not String.IsNullOrEmpty(Request.QueryString("bble")) Then

        '    Dim bble = Request.QueryString("bble").ToString
        '    BindFileList(bble)
        'End If
    End Sub

    Public Property ViewMode As Boolean = False
    Public Property LeadsName As String
    Public Property LeadsBBLE As String

    Sub BindFileList(bble As String)
        'BindFilesFromSharepoint(bble)
        'Return 

        Using Context As New Entities
            Dim groups = (From file In Context.FileAttachments
                          Where file.BBLE = bble
                         Select file.Category, file.Name, file.CreateDate, file.FileID, file.ContentType).GroupBy(Function(file) file.Category).ToList()

            datalistCategory.DataSource = groups
            datalistCategory.DataBind()
        End Using
    End Sub

    Protected Sub datalistCategory_ItemDataBound(sender As Object, e As DataListItemEventArgs) Handles datalistCategory.ItemDataBound
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then

            Dim rptFiles = TryCast(e.Item.FindControl("rptFiles"), Repeater)
            rptFiles.DataSource = DataBinder.Eval(e.Item.DataItem, "Group")
            rptFiles.DataBind()

            Dim rptFolders = TryCast(e.Item.FindControl("rptFolders"), Repeater)
            rptFolders.DataSource = DataBinder.Eval(e.Item.DataItem, "SubCategory")
            rptFolders.DataBind()
        End If
    End Sub

    Public Sub BindFilesFromSharepoint(bble As String)
        datalistCategory.DataSource = DocumentService.GetFilesByBBLE(bble)
        datalistCategory.DataBind()
    End Sub

    Protected Sub cbpDocumentUI_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase)
        ' disable agent file upload options
        ' BindFilesFromSharepoint(e.Parameter)
    End Sub

    Protected Sub rptFiles_ItemDataBound(sender As Object, e As RepeaterItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim rptFiles = TryCast(e.Item.FindControl("rptFiles"), Repeater)
            rptFiles.DataSource = DataBinder.Eval(e.Item.DataItem, "Group")
            rptFiles.DataBind()
        End If
    End Sub
End Class