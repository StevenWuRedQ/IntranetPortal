Imports DevExpress.Web

Public Class FollowUpItem
    Inherits SummaryItemBase

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            gridFollowUp.GroupBy(gridFollowUp.Columns("FollowUpDate"))
        End If
    End Sub

    Public Function GetCaseName(bble As String, type As Integer) As String
        Select Case type
            Case LeadsActivityLog.LogCategory.Title
                Return TitleManage.GetTitleCaseName(bble)
            Case LeadsActivityLog.LogCategory.Construction
                Return ConstructionManage.GetCaseName(bble)
            Case Else
                Return LeadsInfo.GetInstance(bble).LeadsName
        End Select
    End Function

    Public Overrides Sub BindData()
        MyBase.BindData()
        gridFollowUp.DataBind()
    End Sub

    Protected Sub gridTask_DataBinding(sender As Object, e As EventArgs) Handles gridFollowUp.DataBinding
        If gridFollowUp.DataSource Is Nothing Then
            gridFollowUp.DataSource = Data.UserFollowUp.GetMyFollowUps(Page.User.Identity.Name)
        End If
    End Sub

    Public Function GroupText(groupDateText As String) As String
        Dim today = DateTime.Now.Date

        If String.IsNullOrEmpty(groupDateText) Then
            Return "Today"
        End If

        Dim groupDate = Date.Parse(groupDateText).Date
        If today >= groupDate Then
            Return "Today"
        Else
            If today.AddDays(1).Equals(groupDate) Then
                Return "Tomorrow"
            Else
                Return "Future"
            End If
        End If
    End Function

    Protected Sub gridAppointment_CustomColumnGroup(sender As Object, e As CustomColumnSortEventArgs) Handles gridFollowUp.CustomColumnGroup
        If e.Column.FieldName = "FollowUpDate" Then
            Dim today = DateTime.Now.Date
            Dim day1 = CDate(e.Value1).Date
            Dim day2 = CDate(e.Value2).Date

            If day1 <= today Then
                day1 = today
            Else
                If day1 >= today.AddDays(2) Then
                    day1 = today.AddDays(2)
                End If
            End If

            If day2 <= today Then
                day2 = today
            Else
                If day2 >= today.AddDays(2) Then
                    day2 = today.AddDays(2)
                End If
            End If

            Dim res As Integer
            If day1 = day2 Then
                res = 0
            End If

            If day1 < day2 Then
                res = 1
            End If

            If day1 > day2 Then
                res = -1
            End If

            e.Result = res
            e.Handled = True

        End If
    End Sub

End Class