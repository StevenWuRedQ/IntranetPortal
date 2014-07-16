Partial Public Class APIOrder
    Public Enum ItemStatus
        NonCall = 0
        Calling = 1
        Complete = 2
    End Enum

    Public Enum OrderStatus
        Active = 0
        PartialComplete = 1
        Complete = 2
        [Error] = 3
    End Enum

    Public ReadOnly Property IsComplete As Boolean
        Get
            Return True
        End Get
    End Property

End Class
