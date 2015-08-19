Partial Public Class CheckingComplain

    Public Shared Function GetAllComplains() As List(Of CheckingComplain)

        Using ctx As New ConstructionEntities
            Return ctx.CheckingComplains.ToList
        End Using
    End Function

    Public Shared Function Instance(bble As String) As CheckingComplain
        Using ctx As New ConstructionEntities
            Return ctx.CheckingComplains.Find(bble)
        End Using
    End Function

    Public Shared Function GetComplainsResult() As DataAPI.SP_DOB_Complaints_By_BBLE_Result()
        Using client As New DataAPI.WCFMacrosClient
            Try
                Return client.Get_DBO_Complaints_List("", True)
            Catch ex As Exception
                Return {}
            End Try
        End Using
    End Function

    Public Shared Function GetComplaintsHistory(bble As String) As DataAPI.SP_DOB_Complaints_History_By_BBLE_Result()
        Using client As New DataAPI.WCFMacrosClient
            Return client.Get_DBO_Complaints_History_List(bble)
        End Using
    End Function

    Public Shared Function Remove(bble As String) As CheckingComplain
        Try
            Using client As New DataAPI.WCFMacrosClient

                If client.DOB_Complaints_Delete(bble) Then
                    Using ctx As New ConstructionEntities
                        Dim item = ctx.CheckingComplains.Find(bble)
                        ctx.CheckingComplains.Remove(item)
                        ctx.SaveChanges()

                        Return item
                    End Using
                Else
                    Throw New Exception("Failed to remove from data service")
                End If
            End Using
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Public Sub Save(saveBy As String)
        Using ctx As New ConstructionEntities

            Dim cc = ctx.CheckingComplains.Find(BBLE)

            If cc Is Nothing Then
                Me.CreateBy = saveBy
                Me.CreateTime = DateTime.Now
                ctx.CheckingComplains.Add(Me)
            Else
                ctx.Entry(Me).State = Entity.EntityState.Modified
            End If

            ctx.SaveChanges()
        End Using
    End Sub

    Public Sub RefreshComplains(refreshBy As String)

        Me.LastExecute = DateTime.Now

        Try
            Using client As New DataAPI.WCFMacrosClient
                Dim data As New DataAPI.DOB_Complaints_In
                data.BBLE = BBLE
                data.DOB_PenOnly = True
                data.APIorderNum = (New Random()).Next(1000)
                data.SecurityCode = "DS543&8"
                client.DOB_Complaints_Get(data)
            End Using
            Me.Save(refreshBy)
        Catch ex As Exception

        End Try
        
    End Sub
End Class
