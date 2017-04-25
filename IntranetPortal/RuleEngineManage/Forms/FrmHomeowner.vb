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
                                                                initData(id)
                                                            End Sub)
        Next
    End Sub

    Public Sub initData(id As Integer)
        If stopTag Then
            Return
        End If

        If chkSSN.Checked Then
            HomeOwner.InitOwnerSSN(id)
        End If

        If chkPhone.Checked Then
            HomeOwner.InitPhoneNums(id)
        End If

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

    Private Sub btnLoadPhone_Click(sender As Object, e As EventArgs) Handles btnLoadPhone.Click
        Dim ids = HomeOwner.LoadOwnersNoPhone()
        txtTotal.Text = ids.Count
    End Sub

    Private Sub btnSavePhone_Click(sender As Object, e As EventArgs) Handles btnSavePhone.Click
        Dim ids() As Integer
        If chkBBLes.Checked Then
            ids = txtBBLEs.Lines.Select(Function(s) CInt(s)).ToArray
        Else
            ids = HomeOwner.LoadOwnersNoPhone()
        End If

        txtTotal.Text = ids.Count

        If chkUseThreads.Checked Then
            Threading.ThreadPool.SetMaxThreads(3, 3)
            For Each id In ids
                If stopTag Then
                    Return
                End If

                Dim tp = Threading.ThreadPool.QueueUserWorkItem(Sub()
                                                                    initData(id)
                                                                End Sub)
            Next
        Else
            Dim ts As New Thread(Sub()
                                     For Each id In ids
                                         If stopTag Then
                                             Return
                                         End If

                                         initData(id)
                                     Next
                                 End Sub)
            ts.Start()
        End If
    End Sub

    Private Sub chkBBLes_CheckedChanged(sender As Object, e As EventArgs) Handles chkBBLes.CheckedChanged
        If chkBBLes.Checked Then
            txtBBLEs.Visible = True
        Else
            txtBBLEs.Visible = False
        End If
    End Sub

    Private Sub BtnUpdateTLO_Click(sender As Object, e As EventArgs) Handles BtnUpdateTLO.Click
        If (String.IsNullOrEmpty(ThreadCount.Text)) Then
            MsgBox("Please input update type such as mortgage Owner!")
            Return
        End If

        Dim ids = txtBBLEs.Lines()

        Parallel.ForEach(ids,
                         New ParallelOptions With {.MaxDegreeOfParallelism = CInt(ThreadCount.Text)},
                         Sub(id)
                             Try
                                 Dim result = HomeOwner.UpdateLocatedRepot(id)
                                 Logger.Log.Info("succeed owner id: " + id)
                                 If (result = 1) Then
                                     Logger.Log.Info("missing location report owner id: " + id)
                                 End If
                             Catch ex As Exception
                                 Logger.Log.Error("failed owner id: " + id, ex)
                             End Try
                         End Sub)

    End Sub

    Private Sub RichTextBox1_TextChanged(sender As Object, e As EventArgs)

    End Sub
End Class