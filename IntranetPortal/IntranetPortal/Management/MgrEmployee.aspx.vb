﻿Imports DevExpress.Web.ASPxEditors
Imports DevExpress.Web.ASPxTreeList
Imports DevExpress.Web.ASPxUploadControl

Public Class MgrEmployee
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        BindTreeList()
    End Sub

    Sub BindTreeList()
        Using Context As New Entities
            treeList.DataSource = Context.Employees.ToList
            treeList.DataBind()
        End Using
    End Sub

    Protected Sub treeList_NodeInserting(sender As Object, e As DevExpress.Web.Data.ASPxDataInsertingEventArgs) Handles treeList.NodeInserting
        Dim emp As New Employee
        emp.Name = e.NewValues("Name")
        emp.Position = e.NewValues("Position")
        emp.Department = e.NewValues("Department")
        emp.Extension = e.NewValues("Extension")
        emp.Email = e.NewValues("Email")
        emp.Cellphone = e.NewValues("Cellphone")
        emp.EmployeeSince = e.NewValues("EmployeeSince")
        emp.Picture = e.NewValues("Picture")
        emp.Password = e.NewValues("Password")
        emp.ReportTo = e.NewValues("ReportTo")
        emp.Description = e.NewValues("Description")
        emp.Active = e.NewValues("Active")
        emp.CreateDate = DateTime.Now
        emp.CreateBy = Page.User.Identity.Name

        Using Context As New Entities
            Context.Employees.Add(emp)
            Try
                Context.SaveChanges()
            Catch ex As Exception
                If Context.GetValidationErrors().Count > 0 Then
                    Throw New Exception(Context.GetValidationErrors().First.ValidationErrors(0).ErrorMessage)
                Else
                    Throw ex
                End If
            End Try

        End Using

        'BindTreeList()

        e.Cancel = True
        treeList.CancelEdit()

        BindTreeList()
    End Sub

    Protected Sub treeList_NodeUpdating(sender As Object, e As DevExpress.Web.Data.ASPxDataUpdatingEventArgs) Handles treeList.NodeUpdating
        Using Context As New Entities
            Dim empID = CInt(e.Keys("EmployeeID"))
            Dim emp = Context.Employees.Where(Function(em) em.EmployeeID = empID).FirstOrDefault

            emp.Name = e.NewValues("Name")
            emp.Position = e.NewValues("Position")
            emp.Department = e.NewValues("Department")
            emp.Extension = e.NewValues("Extension")
            emp.Email = e.NewValues("Email")
            'emp.Password = e.NewValues("Password")

            emp.Cellphone = e.NewValues("Cellphone")
            emp.EmployeeSince = e.NewValues("EmployeeSince")
            emp.Picture = e.NewValues("Picture")

            emp.ReportTo = e.NewValues("ReportTo")
            emp.Description = e.NewValues("Description")
            emp.Active = e.NewValues("Active")

            emp.CreateDate = DateTime.Now
            emp.CreateBy = Page.User.Identity.Name

            Context.SaveChanges()
        End Using

        e.Cancel = True
        treeList.CancelEdit()

        BindTreeList()
    End Sub

    Protected Sub confirmButton_Click(sender As Object, e As EventArgs) Handles confirmButton.Click
        Dim empID = CInt(treeList.EditingNodeKey)

        Using Context As New Entities
            Dim emp = Context.Employees.Where(Function(em) em.EmployeeID = empID).FirstOrDefault

            emp.Password = cnpsw.Text
            Context.SaveChanges()
        End Using

        ASPxPopupControl1.ShowOnPageLoad = False
    End Sub

    'Protected Sub treeList_CellEditorInitialize(sender As Object, e As DevExpress.Web.ASPxTreeList.TreeListColumnEditorEventArgs) Handles treeList.CellEditorInitialize
    '    If e.Column.FieldName = "ReportTo" Then
    '        Dim cbEmp = TryCast(e.Editor, ASPxComboBox)
    '        Using Context As New Entities
    '            cbEmp.DataSource = Context.Employees.OrderBy(Function(em) em.Name).ToList
    '            cbEmp.DataBind()
    '        End Using
    '    End If
    'End Sub

    Protected Sub treeList_Init(sender As Object, e As EventArgs) Handles treeList.Init
        Dim cbEmpColumn = TryCast(treeList.Columns("ReportTo"), TreeListComboBoxColumn)
        Using Context As New Entities
            cbEmpColumn.PropertiesComboBox.DataSource = Context.Employees.OrderBy(Function(em) em.Name).ToList
        End Using
    End Sub

    Protected Sub uplImage_FileUploadComplete(sender As Object, e As DevExpress.Web.ASPxUploadControl.FileUploadCompleteEventArgs)
        e.CallbackData = String.Format("/DownloadFile.aspx?id={0}", SavePostedFile(e.UploadedFile))
    End Sub

   Private Function SavePostedFile(ByVal uploadedFile As UploadedFile) As String
        'Dim bble = Request.QueryString("b").ToString

        If (Not uploadedFile.IsValid) Then
            Return String.Empty
        End If
        Dim fileName As String = uploadedFile.FileName

        Using Context As New Entities
            Dim attach As New FileAttachment
            'attach.BBLE = bble
            attach.Name = uploadedFile.FileName
            attach.ContentType = uploadedFile.ContentType
            attach.Size = uploadedFile.ContentLength
            attach.Data = uploadedFile.FileBytes
            attach.Description = "Employee Photo"
            attach.Createby = Page.User.Identity.Name
            attach.CreateDate = DateTime.Now

            Context.FileAttachments.Add(attach)
            Context.SaveChanges()

            Return attach.FileID
        End Using
    End Function
End Class