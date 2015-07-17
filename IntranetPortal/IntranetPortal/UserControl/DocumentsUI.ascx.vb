Imports System.Security
Imports System.Web.Services
Imports IntranetPortal.Core
Imports Newtonsoft.Json
Imports System.Web.Script.Services

Public Class DocumentsUI
    Inherits System.Web.UI.UserControl

    Public Property ViewMode As Boolean = False
    Public Property LeadsName As String
    Public Property LeadsBBLE As String
    Public Property CurrentFolderUrl As String = ""
    Public Property CurrentFolder As Object

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
    End Sub



    Sub BindFileList(bble As String)
        'BindFilesFromSharepoint(bble)
        Using Context As New Entities
            Dim groups = (From file In Context.FileAttachments
                          Where file.BBLE = bble
                         Select file.Category, file.Name, file.CreateDate, file.FileID, file.ContentType).GroupBy(Function(file) file.Category).ToList()
        End Using
    End Sub

    'Protected Sub datalistCategory_ItemDataBound(sender As Object, e As DataListItemEventArgs) Handles datalistCategory.ItemDataBound
    '    If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then

    '        Dim rptFiles = TryCast(e.Item.FindControl("rptFiles"), Repeater)
    '        rptFiles.DataSource = DataBinder.Eval(e.Item.DataItem, "Group")
    '        rptFiles.DataBind()

    '        Dim rptFolders = TryCast(e.Item.FindControl("rptFolders"), Repeater)
    '        rptFolders.DataSource = DataBinder.Eval(e.Item.DataItem, "SubCategory")
    '        rptFolders.DataBind()
    '    End If
    'End Sub

    Public Sub BindFilesFromSharepoint(bble As String)
        ' datalistCategory.DataSource = DocumentService.GetFilesByBBLE(bble)
        ' datalistCategory.DataBind()
        CurrentFolder = DocumentService.GetCateByBBLEAndFolder(bble, CurrentFolderUrl)
    End Sub

    Protected Sub cbpDocumentUI_Callback(sender As Object, e As DevExpress.Web.ASPxClasses.CallbackEventArgsBase)
        BindFilesFromSharepoint(e.Parameter)
    End Sub

    Protected Sub rptFiles_ItemDataBound(sender As Object, e As RepeaterItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim rptFiles = TryCast(e.Item.FindControl("rptFiles"), Repeater)
            rptFiles.DataSource = DataBinder.Eval(e.Item.DataItem, "Group")
            rptFiles.DataBind()
        End If
    End Sub

End Class