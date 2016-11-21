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

            Return Ok("")
        End Function

        <Route("api/Homeowner/{bble}")>
        Public Function GetHomeownerSSN(bble As String) As IHttpActionResult
            Dim owners = HomeOwner.GetHomeOwenrs(bble)
            Dim li = LeadsInfo.GetInstance(bble)

            Dim owner = owners.Where(Function(o) o.Name = li.Owner OrElse o.Name = li.CoOwner).Select(Function(a)
                                                                                                          If a.TLOLocateReport IsNot Nothing AndAlso a.TLOLocateReport.sSNField IsNot Nothing Then
                                                                                                              a.TLOLocateReport.sSNField.sSNField = a.Last4SSN
                                                                                                          End If

                                                                                                          Return New With {a.Name, a.TLOLocateReport}
                                                                                                      End Function)
            Return Ok(owner)
        End Function


    End Class
End Namespace