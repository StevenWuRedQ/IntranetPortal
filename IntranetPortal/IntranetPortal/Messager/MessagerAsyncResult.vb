Namespace Messager
    Public Class MessagerAsyncResult
        Implements IAsyncResult

        Public Property context As HttpContext
        Public Property Message As UserMessage

        Public Sub New(contxt As HttpContext, msg As UserMessage)
            context = contxt
            Message = msg
        End Sub

        Public ReadOnly Property AsyncState As Object Implements IAsyncResult.AsyncState
            Get
                Return Nothing
            End Get
        End Property

        Public ReadOnly Property AsyncWaitHandle As Threading.WaitHandle Implements IAsyncResult.AsyncWaitHandle
            Get
                Return Nothing
            End Get
        End Property

        Public ReadOnly Property CompletedSynchronously As Boolean Implements IAsyncResult.CompletedSynchronously
            Get
                Return True
            End Get
        End Property

        Public ReadOnly Property IsCompleted As Boolean Implements IAsyncResult.IsCompleted
            Get
                Return True
            End Get
        End Property
    End Class
End Namespace
