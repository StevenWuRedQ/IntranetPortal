﻿Public Class LegalTab
    Inherits System.Web.UI.UserControl
    Public SecondaryAction As Boolean = False
    Public Agent As Boolean = False
    Sub Page_init(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Init
        SecondaryAction = Request.QueryString("Attorney") IsNot Nothing
        Agent = Request.QueryString("Agent") IsNot Nothing
        If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then


            Dim wli = WorkflowService.LoadTaskProcess(Request.QueryString("sn"))
            Select Case wli.ActivityName
                Case "LegalResearch"
                    btnCompleteResearch.Visible = True
                Case "ManagerAssign"
                    lbEmployee.Visible = True
                    btnAssign.Visible = True
            End Select
        End If
    End Sub
   
    Protected Sub btnCompleteResearch_ServerClick(sender As Object, e As EventArgs)
        If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
            Dim sn = Request.QueryString("sn").ToString

            Dim wli = WorkflowService.LoadTaskProcess(sn)
            wli.Finish()

            Response.Clear()
            Response.Write("The case is move back to manager.")
            Response.End()
        End If
    End Sub

    Protected Sub btnAssign_ServerClick(sender As Object, e As EventArgs)
        If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
            Dim sn = Request.QueryString("sn").ToString

            Dim wli = WorkflowService.LoadTaskProcess(sn)
            wli.ProcessInstance.DataFields("Attorney") = lbEmployee.Value
            wli.Finish()

            Response.Clear()
            Response.Write("The case is move to " & lbEmployee.Value)
            Response.End()
        End If
    End Sub

    Protected Sub btnComplete_ServerClick(sender As Object, e As EventArgs)
        If Not String.IsNullOrEmpty(Request.QueryString("sn")) Then
            Dim sn = Request.QueryString("sn").ToString

            Dim wli = WorkflowService.LoadTaskProcess(sn)
            wli.Finish()

            Response.Clear()
            Response.Write("The case is finished.")
            Response.End()
        End If
    End Sub

End Class