Public Class WorkingHours
    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="startDate"></param>
    ''' <param name="endDate"></param>
    ''' <returns>
    ''' for day:   5.00.00.00
    ''' for hours: 2:00:00
    ''' </returns>
    ''' <remarks></remarks>
    Public Shared Function GetWorkingDays(startDate As DateTime, endDate As DateTime) As TimeSpan
        Dim dayCount = 0

        If startDate.Date = endDate.Date Then
            Return endDate - startDate
        End If

        While startDate.Date < endDate.Date
            If startDate.DayOfWeek <> DayOfWeek.Sunday AndAlso startDate.DayOfWeek <> DayOfWeek.Saturday AndAlso Not IsHoliday(startDate) Then
                dayCount += 1
            End If

            startDate = startDate.AddDays(1)
        End While

        Return (endDate - startDate).Add(TimeSpan.Parse(dayCount & ".00:00:00"))
    End Function

    Private Shared Function IsHoliday(startDate As DateTime) As Boolean
        Return False
    End Function

    Public Shared Function IsWorkingHour(dt As DateTime) As Boolean
        If dt.DayOfWeek = DayOfWeek.Sunday Or dt.DayOfWeek = DayOfWeek.Saturday Then
            Return False
        End If

        If IsHoliday(dt) Then
            Return False
        End If

        If dt.Hour > 18 Or dt.Hour < 9 Then
            Return False
        End If

        Return True
    End Function
End Class