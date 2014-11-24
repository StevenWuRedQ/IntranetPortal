Public Class HolidayService
    Public Shared Function IsHoliday(dt As Date, emp As String) As Boolean
        If IsPublicHoliday(dt) Then
            Return True
        End If

        If IsPersonalOff(dt, emp) Then
            Return True
        End If

        Return False
    End Function

    Public Shared Function IsPublicHoliday(dt As Date) As Boolean
        Using ctx As New CoreEntities
            Return ctx.SpecialDays.Where(Function(sd) sd.Type = SpecialDay.DayType.PublicHoliday And sd.SpecialDate = dt).Count > 0
        End Using

        Return False
    End Function

    Public Shared Function IsPersonalOff(dt As Date, emp As String) As Boolean
        Using ctx As New CoreEntities
            Return ctx.SpecialDays.Where(Function(sd) sd.Type = SpecialDay.DayType.PersonalOff And sd.SpecialDate = dt).Count > 0
        End Using

        Return False
    End Function
End Class

Public Class SpecialDay
    Enum DayType
        PublicHoliday = 0
        PersonalOff = 1
    End Enum

End Class