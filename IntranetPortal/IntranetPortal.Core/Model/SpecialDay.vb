
Partial Public Class SpecialDay

    Public Shared Function GetPersonalOffDays()
        Using ctx As New CoreEntities
            Return ctx.SpecialDays.Where(Function(s) s.Type = DayType.PersonalOff).ToList
        End Using
    End Function

    Public Shared Sub AddPersonalOff(name As String, startDate As Date, endDate As Date, reason As String, createby As String)

        Using ctx As New CoreEntities
            While startDate <= endDate
                Dim sp = ctx.SpecialDays.Where(Function(s) s.Employee = name And s.SpecialDate = startDate And s.Type = DayType.PersonalOff).SingleOrDefault
                If sp Is Nothing Then
                    sp = New SpecialDay
                    sp.Employee = name
                    sp.Type = DayType.PersonalOff
                    sp.SpecialDate = startDate
                    sp.Description = reason
                    sp.CreateBy = createby
                    sp.CreateDate = DateTime.Now

                    ctx.SpecialDays.Add(sp)
                End If

                startDate = startDate.AddDays(1)
            End While

            ctx.SaveChanges()
        End Using
    End Sub

    Public Shared Function GetPublicOffDays()
        Using ctx As New CoreEntities
            Return ctx.SpecialDays.Where(Function(s) s.Type = DayType.PublicHoliday).ToList
        End Using
    End Function

    Enum DayType
        PublicHoliday = 0
        PersonalOff = 1
    End Enum

End Class