Imports System.Net
Imports System.Web.Http

Namespace Controllers
    Public Class HomeownerController
        Inherits ApiController


        <Route("api/Homeowner/SSN/{bble}")>
        Public Function PostHomeownerSSN(bble As String, <FromBody> ownerName As String) As IHttpActionResult
            Dim owners = HomeOwner.GetHomeOwenrs(bble)

            If owners.Any(Function(o) o.Name = ownerName) Then
                Dim owner = owners.Where(Function(o) o.Name = ownerName).FirstOrDefault
                Return Ok(owner.Last4SSN)
            End If

            Return NotFound()
        End Function

    End Class
End Namespace