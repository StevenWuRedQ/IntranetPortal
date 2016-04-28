Imports System.Net
Imports System.Web.Http

Namespace Controllers
    Public Class HomeownerController
        Inherits ApiController


        <Route("api/Homeowner/SSN")>
        Public Function GetHomeownerSSN(bble As String, ownerName As String) As IHttpActionResult
            Dim owners = HomeOwner.GetHomeOwenrs(bble)

            If owners.Any(Function(o) o.Name = ownerName) Then
                Dim owner = owners.Where(Function(o) o.Name = ownerName).FirstOrDefault

            End If
        End Function


    End Class
End Namespace