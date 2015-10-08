Imports System.Text

Public Class ConstructionNotifyRule
    Inherits BaseRule

    Public Sub NotifyHPDRegExpired()
        Dim violations = Data.ConstructionViolation.GetViolationsWithin30Days()
        If Not violations Is Nothing Then
            Dim dict = New Dictionary(Of String, List(Of String))
            For Each v In violations
                Dim bble = v.BBLE
                Dim ccase = Data.ConstructionCase.GetCase(bble)
                If Not ccase Is Nothing Then
                    Dim Address = ccase.CaseName
                    Dim Manager = ccase.Owner

                    If dict.ContainsKey(Manager) Then
                        dict(Manager).Add(Address)
                    Else
                        dict(Manager) = New List(Of String)
                        dict(Manager).Add(Address)
                    End If
                End If

            Next

            For Each kvp In dict
                Dim manager = kvp.Key
                Dim builder = New StringBuilder
                builder.Append("<table>")
                For Each address In kvp.Value
                    builder.Append("<tr>")
                    builder.Append("<td>" & address & "</td>")
                    builder.Append("</tr>")
                Next
                builder.Append("</table>")
                Dim body = builder.ToString
                ' Dim toAddr = Employee.GetInstance(manager).Email
                Dim toAddr = "stephenz@myidealprop.com"

                Dim maildata As New Dictionary(Of String, String)

                maildata.Add("Manager", manager)
                maildata.Add("Body", body)
                Core.EmailService.SendShortSaleMail(toAddr, "", "HPDRegExpiredNotify", maildata)
            Next
        End If
    End Sub

    Public Overrides Sub Execute()
        Log("========================Starting Construction Notify Rule============================================")
        Me.NotifyHPDRegExpired()
        Log("========================Construction Notify Rule Completed.==========================================")
    End Sub


End Class
