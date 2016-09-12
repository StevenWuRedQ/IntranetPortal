Partial Public Class HomeOwnerPhone
    Public Sub CallPhone()
        Me.LastCalledDate = Date.Now()
    End Sub

    Public Shared Function GetHomeOwnerPhones(BBLE As String, phoneNumber As String) As HomeOwnerPhone
        Using ctx As New Entities
            Return ctx.HomeOwnerPhones.Where(Function(p) p.BBLE = BBLE AndAlso p.Phone = phoneNumber).FirstOrDefault
        End Using
    End Function

    Public Shared Function GetAllPhones(BBLE As String, phoneNumber As String) As List(Of HomeOwnerPhone)
        Using ctx As New Entities
            Return ctx.HomeOwnerPhones.Where(Function(p) p.BBLE = BBLE AndAlso p.Phone = phoneNumber).ToList()
        End Using
    End Function

    ''' <summary>
    ''' After Call all phone by BBLE and phone number mark all phone number LastCalledDate 
    ''' </summary>
    ''' <param name="BBLE"></param>
    ''' <param name="phoneNumber"></param>
    Public Shared Sub CallAllPhones(BBLE As String, phoneNumber As String)
        Dim pList = GetAllPhones(BBLE, phoneNumber)
        If (pList IsNot Nothing AndAlso pList.Any()) Then
            pList.ForEach(Sub(p) p.CallPhone())
            Using ctx As New Entities
                ctx.SaveChanges()
            End Using
        End If


    End Sub

End Class
