Imports System.Web.Http

Namespace Controllers
    Public Class WorkListController
        Inherits ApiController

        <Route("api/worklist/{username}")>
        Public Function GetWorkListByUserName(username As String) As IHttpActionResult
            Dim list = WorkflowService.GetUserWorklist(username)
            Return Ok(list)
        End Function
    End Class
End Namespace
