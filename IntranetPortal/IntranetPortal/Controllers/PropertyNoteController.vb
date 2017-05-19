Imports System.Net
Imports System.Web.Http
Imports IntranetPortal.Data

Namespace Controllers
    Public Class PropertyNoteController
        Inherits ApiController

        Public Function GetPropertyNotes(bble As String, status As String) As IHttpActionResult
            Dim results = PropertyNote.GetNotes(bble, status)
            Return Ok(results)
        End Function

    End Class
End Namespace