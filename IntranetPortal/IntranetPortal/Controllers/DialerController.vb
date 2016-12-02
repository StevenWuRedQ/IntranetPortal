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
        Public Function PostSyncNewLeadsFolder(username As String) As IHttpActionResult
            Try
                Dim count = DialerServiceManage.UploadNewLeadsToContactlist(username)
                Return Ok(count)
            Catch ex As Exception
                Return StatusCode(System.Net.HttpStatusCode.InternalServerError)
            End Try

        End Function


    End Class
End Namespace

