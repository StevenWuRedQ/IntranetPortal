Imports IntranetPortal
Imports System.Threading

Public Class FrmHomeowner
    Private stopTag As Boolean

    Private Sub btnLoadOwner_Click(sender As Object, e As EventArgs) Handles btnLoadOwner.Click
        Dim ids = HomeOwner.LoadOwnerIds()
        txtTotal.Text = ids.Count

        For Each id In ids
            If stopTag Then
                Return
            End If

            Dim tp = Threading.ThreadPool.QueueUserWorkItem(Sub()
                                                                initSSN(id)
                                                            End Sub)
        Next
    End Sub

    Public Sub initSSN(id As Integer)
        HomeOwner.InitOwnerSSN(id)
        UpdateCount()
    End Sub

    Delegate Sub UpdateCountCallback()

    Private Sub UpdateCount()
        If txtRunning.InvokeRequired Then
            Dim d As New UpdateCountCallback(AddressOf Me.UpdateCount)
            Me.Invoke(d)
        Else
            Dim count = CInt(txtRunning.Text)
            count += 1
            txtRunning.Text = count
        End If
    End Sub

    Private Sub btnStop_Click(sender As Object, e As EventArgs) Handles btnStop.Click
        stopTag = True
    End Sub

End Class