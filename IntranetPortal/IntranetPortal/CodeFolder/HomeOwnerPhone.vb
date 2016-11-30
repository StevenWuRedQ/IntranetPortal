Partial Public Class HomeOwnerPhone
    Public Sub CallPhone()
        Me.LastCalledDate = Date.Now()
        If (CallCount Is Nothing) Then
            CallCount = 0
        End If
        CallCount = CallCount + 1
    End Sub

    Public Function HasLastCalled() As Boolean
        Return LastCalledDate IsNot Nothing AndAlso LastCalledDate > Date.MinValue
    End Function

    Public Function HasCallCount() As Boolean
        Return CallCount IsNot Nothing AndAlso CallCount > 0
    End Function

    Public Shared Function GetPhoneNums(bble As String, ownerName As String) As String()
        Using ctx As New Entities
            Return ctx.HomeOwnerPhones.Where(Function(p) p.BBLE = bble AndAlso p.OwnerName = ownerName).Select(Function(p) p.Phone).Distinct.ToArray
        End Using
    End Function

    Public Shared Function GetHomeOwnerPhones(BBLE As String, phoneNumber As String) As HomeOwnerPhone
        Using ctx As New Entities
            Return ctx.HomeOwnerPhones.Where(Function(p) p.BBLE = BBLE AndAlso p.Phone = phoneNumber).FirstOrDefault
        End Using
    End Function
    ''' <summary>
    ''' @todo
    ''' some of phones save in owner contact 
    ''' so that it may not working for sort and count.
    ''' </summary>
    ''' <param name="BBLE"></param>
    ''' <param name="phoneNumber"></param>
    ''' <returns></returns>
    Public Shared Function GetAllPhones(BBLE As String, phoneNumber As String) As List(Of HomeOwnerPhone)
        Using ctx As New Entities
            Return ctx.HomeOwnerPhones.Where(Function(p) p.BBLE = BBLE AndAlso p.Phone = phoneNumber).ToList()
        End Using
    End Function

    Public Shared Function GetAllPhoneLastCall(BBLE As String, phoneNumber As String) As String
        Dim phoneStr = GetPhoneStr(phoneNumber)
        Dim lastCall = ""
        Dim phoneList = GetAllPhones(BBLE, phoneStr)
        If Utility.IsAny(phoneList) Then
            Dim lastCallDateNullable = phoneList.Where(Function(p) p.HasLastCalled()).
                Select(Function(e) e.LastCalledDate).FirstOrDefault()

            If (lastCallDateNullable IsNot Nothing) Then
                Dim lastCallDate = CType(lastCallDateNullable, Date)
                If (lastCallDate > Date.MinValue) Then
                    lastCall = lastCallDate.ToString("MM/dd/yyyy HH:mm")
                End If
            End If
        End If

        Return lastCall
    End Function
    Public Shared Function GetAllPhoneCount(BBLE As String, phoneNumber As String) As String
        Dim phoneStr = GetPhoneStr(phoneNumber)
        Dim lastCall = ""
        Dim phoneList = GetAllPhones(BBLE, phoneStr)
        If Utility.IsAny(phoneList) Then
            Dim lastCallCountNullable = phoneList.Where(Function(p) p.HasCallCount()).
                Select(Function(e) e.CallCount).FirstOrDefault()

            If (lastCallCountNullable IsNot Nothing AndAlso lastCallCountNullable > 0) Then
                lastCall = lastCallCountNullable.ToString()
            End If
        End If
        Return lastCall
    End Function
    Public Shared Function GetPhoneStr(phoneNumber)
        Return Regex.Replace(phoneNumber, "[^\d]+", "")
    End Function
    ''' <summary>
    ''' Get owner phone list by bble
    ''' </summary>
    ''' <param name="BBLE">BBLE</param>
    ''' <returns>list of owner phones</returns>
    Public Shared Function GetPhonesByBBLE(BBLE As String) As List(Of HomeOwnerPhone)
        Using ctx As New Entities
            Return ctx.HomeOwnerPhones.Where(Function(p) p.BBLE = BBLE).ToList()
        End Using
    End Function
    ''' <summary>
    ''' After Call all phone by BBLE and phone number mark all phone number LastCalledDate 
    ''' </summary>
    ''' todo
    ''' 
    ''' <param name="BBLE"></param>
    ''' <param name="phoneNumber"></param>
    Public Shared Sub CallAllPhones(BBLE As String, phoneNumber As String)
        Dim phoneStr = GetPhoneStr(phoneNumber)
        Dim pList = GetAllPhones(BBLE, phoneStr)
        If (Utility.IsAny(pList)) Then
            pList.ForEach(Sub(p) p.CallPhone())
            Using ctx As New Entities
                pList.ForEach(Sub(p) ctx.Entry(p).State = Entity.EntityState.Modified)
                ctx.SaveChanges()
            End Using
        End If


    End Sub

End Class
