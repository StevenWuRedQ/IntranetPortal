Public Class BusinessFormDefault
    Inherits System.Web.UI.Page

    Public Property FormData As BusinessForm
    Public Property BusinessList As BusinessListControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            If Not String.IsNullOrEmpty(Request.QueryString("tag")) Then
                Dim tag = Request.QueryString("tag").ToString
                BindData(tag)
            Else
                BusinessList.BindList()
            End If

            rptTopmenu.DataSource = FormData.Controls
            rptTopmenu.DataBind()

            rptBusinessControl.DataSource = FormData.Controls
            rptBusinessControl.DataBind()
        End If
    End Sub

    Private Sub BindData(tag As String)
        contentSplitter.Panes("listPanel").Visible = False

        Dim form = Data.FormDataItem.Instance(FormData.DefaultControl.BusinessData, tag)

        If FormData.ShowActivityLog Then
            If Not Page.ClientScript.IsStartupScriptRegistered("SetleadBBLE") Then
                Dim cstext1 As String = "<script type=""text/javascript"">" &
                                String.Format("var leadsInfoBBLE = ""{0}"";", form.Tag) & "</script>"
                Page.ClientScript.RegisterStartupScript(Me.GetType, "SetleadBBLE", cstext1)
            End If
        End If

        If Not Page.ClientScript.IsStartupScriptRegistered("InitData") Then
            Dim cstext1 = "<script type=""text/javascript"">" &
                                String.Format("$(function(){{ FormControl.LoadData(""{0}""); }});", form.DataId) & "</script>"
            Page.ClientScript.RegisterStartupScript(Me.GetType, "InitData", cstext1)
        End If
    End Sub

    Private Sub Page_Init(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Init
        BindControl()
    End Sub

    Protected Overrides Sub OnInit(e As EventArgs)

        MyBase.OnInit(e)

    End Sub

    Private Sub BindControl()
        FormData = BusinessForm.Instance("title")
        BusinessList = Page.LoadControl(FormData.ListControl)
        BusinessList.ID = "titleList"
        contentSplitter.GetPaneByName("listPanel").Controls.Add(BusinessList)

        If FormData.ShowActivityLog Then
            contentSplitter.GetPaneByName("LogPanel").Visible = True
            ActivityLogs.DisplayMode = FormData.DefaultControl.ActivityLogMode
        End If

    End Sub

    Protected Sub rptBusinessControl_ItemDataBound(sender As Object, e As RepeaterItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim ascx As BusinessControl = e.Item.DataItem

            Dim myControl = CType(Page.LoadControl(ascx.AscxFile), UserControl)
            myControl.DataBind()

            Dim lt = CType(e.Item.FindControl("pnlHolder"), Panel)
            lt.Controls.Add(myControl)
        End If
    End Sub

    Public Function ActivieTab(index As Integer)
        If index = 0 Then
            Return "active"
        End If

        Return ""
    End Function

    Protected Sub cbpLogs_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase)
        ActivityLogs.BindData(e.Parameter)
    End Sub

    Protected Sub ASPxPopupControl3_WindowCallback(source As Object, e As DevExpress.Web.PopupWindowCallbackArgs)
        PopupContentReAssign.Visible = True

        If e.Parameter.StartsWith("type") Then
            Dim type = e.Parameter.Split("|")(1)
            hfUserType.Value = type
            listboxEmployee.DataSource = Roles.GetUsersInRole("Title-" & type)
            listboxEmployee.DataBind()
        End If

        If Not String.IsNullOrEmpty(e.Parameter) AndAlso e.Parameter.StartsWith("Save") Then
            Dim bble = e.Parameter.Split("|")(1)
            Dim user = e.Parameter.Split("|")(2)
            Dim selectType = hfUserType.Value

            TitleManage.AssignTo(bble, user, Page.User.Identity.Name)
        End If
    End Sub

    Public Enum FormMode
        Popup
        InPortal
    End Enum
End Class