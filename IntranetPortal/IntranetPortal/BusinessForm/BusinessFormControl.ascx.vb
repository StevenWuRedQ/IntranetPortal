Public Class BusinessFormControl
    Inherits System.Web.UI.UserControl

    Public Property ControlName As String
    Public Property CurrentControl As BusinessControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then

            Dim FormData = BusinessForm.Instance(ControlName)
            CurrentControl = FormData.DefaultControl
            Dim dataControl = CType(Page.LoadControl(CurrentControl.AscxFile), TitleTab)
            dataControl.ID = "Control_" & ControlName
            dataControl.ControlReadonly = "true"
            dataControl.DataBind()

            pnMain.Controls.Add(dataControl)
        End If
    End Sub

End Class