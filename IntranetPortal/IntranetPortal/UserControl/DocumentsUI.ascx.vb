﻿Imports Microsoft.SharePoint.Client
Imports System.Security
Imports System.Web.Services

Public Class DocumentsUI
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'If Not String.IsNullOrEmpty(Request.QueryString("bble")) Then

        '    Dim bble = Request.QueryString("bble").ToString
        '    BindFileList(bble)
        'End If
    End Sub

    Public Property LeadsName As String

    Sub BindFileList(bble As String)
        BindFilesFromSharepoint(bble)
        Return

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
        End If
    End Sub

    Public Sub BindFilesFromSharepoint(bble As String)
        datalistCategory.DataSource = DocumentService.GetFilesByBBLE(bble)
        datalistCategory.DataBind()
    End Sub
End Class