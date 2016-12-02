Imports System.Threading.Tasks
Imports System.Web.Http

Namespace Controllers
    Public Class DialerController
        Inherits ApiController


        <Route("api/dialer/CreateContactList/{listname}")>
        Public Async Function PostCreateContactList(listName As String) As Task(Of String)
            Try
                Dim result = Await DialerServiceManage.CreateContactList(listName)
                Return result
            Catch ex As Exception
                Throw ex
            End Try

        End Function

        <Route("api/dialer/SyncNewLeadsFolder/{username}")>
        Public Async Function PostSyncNewLeadsFolder(username As String) As Task(Of Integer)
            Try
                Dim count = Await Task.Run(Function()
                                               Return DialerServiceManage.UploadNewLeadsToContactlist(username)
                                           End Function)
                Return count
            Catch ex As Exception
                Throw ex
            End Try

        End Function


    End Class
End Namespace

