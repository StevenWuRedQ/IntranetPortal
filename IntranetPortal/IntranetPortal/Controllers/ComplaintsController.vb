Imports System.Net
Imports System.Web.Http
Imports System.Web.Http.Description
Imports Newtonsoft.Json.Linq
Imports IntranetPortal.Data.DataAPI

Namespace Controllers
    Public Class ComplaintsController
        Inherits ApiController

        ' GET: api/ConstructionCases    
        Function GetComplaints() As IQueryable(Of Data.DataAPI.SP_DOB_Complaints_By_BBLE_Result)
            Return Data.CheckingComplain.GetComplainsResult().AsQueryable
        End Function

        <ResponseType(GetType(SP_DOB_Complaints_By_BBLE_Result()))>
        Function GetComplaints(ByVal id As String) As IHttpActionResult

            Return Ok(Data.CheckingComplain.GetComplainsResult(id))

        End Function

        <ResponseType(GetType(JArray))>
      <Route("api/Complaints/Result")>
        Function GetComplaintsResult() As JArray
            Dim result As New JArray
            For Each item In Data.CheckingComplain.GetComplainsResultString()
                For Each child In JArray.Parse(item)
                    result.Add(child)
                Next
            Next

            Return result
        End Function

    End Class
End Namespace