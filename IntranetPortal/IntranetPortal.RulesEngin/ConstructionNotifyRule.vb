Imports System.Text

Public Class ConstructionNotifyRule
    Inherits BaseRule

    Public Sub NotifyHPDRegExpired()
        Dim violations = Data.ConstructionViolation.GetViolationsWithin30Days()
        If Not violations Is Nothing Then

            For Each v In violations
                Dim bble = v.BBLE
                Dim ccase = Data.ConstructionCase.GetCase(bble)
                Dim Address = ccase.CaseName
                Dim Manager = ccase.Owner
                'Dim emails = Employee.GetInstance(Manager).Email

                Dim maildata As New Dictionary(Of String, String)
                maildata.Add("Address", Address)
                maildata.Add("Manager", Manager)

                Core.EmailService.SendShortSaleMail("stephenz@myidealprop.com", "", "HPDRegExpiredNotify", maildata)


            Next
        End If
    End Sub

    Public Overrides Sub Execute()
        Log("========================Starting Construction Notify Rule============================================")
        Me.NotifyHPDRegExpired()
        Log("========================Construction Notify Rule Completed.==========================================")
    End Sub


End Class
