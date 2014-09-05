Public Class EmployeePerformance
    Public Property Employee As Employee

    Private _empLogs As List(Of LeadsActivityLog)
    Private ReadOnly Property EmpLogs As List(Of LeadsActivityLog)
        Get
            If _empLogs Is Nothing Then
                Using context As New Entities
                    _empLogs = context.LeadsActivityLogs.Where(Function(log) log.EmployeeID = Employee.EmployeeID).ToList
                End Using
            End If

            Return _empLogs
        End Get
    End Property

    Private _leadsList As List(Of Lead)
    Private ReadOnly Property LeadsList As List(Of Lead)
        Get
            If _leadsList Is Nothing Then
                Using context As New Entities
                    _leadsList = context.Leads.Where(Function(ld) ld.EmployeeID = Employee.EmployeeID).ToList
                End Using
            End If

            Return _leadsList
        End Get
    End Property

    Public Sub New(emp As Employee)
        Employee = emp
    End Sub

    Public ReadOnly Property CallAttemps As Integer
        Get
            Return EmpLogs.Where(Function(log) log.ActionType.HasValue AndAlso log.ActionType = 0).Count
        End Get
    End Property

    Public ReadOnly Property Doorknock As Integer
        Get
            Return EmpLogs.Where(Function(log) log.ActionType IsNot Nothing AndAlso log.ActionType = LeadsActivityLog.EnumActionType.DoorKnock).Count
        End Get
    End Property

    Public ReadOnly Property FollowUp As Integer
        Get
            Return EmpLogs.Where(Function(log) log.ActionType IsNot Nothing AndAlso log.ActionType = LeadsActivityLog.EnumActionType.FollowUp).Count
        End Get
    End Property

    Public ReadOnly Property LeadsCount As Integer
        Get
            Return LeadsList.Count
        End Get
    End Property
End Class
