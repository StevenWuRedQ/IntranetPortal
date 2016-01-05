Imports System.Net
Imports System.Web.Http
Imports System.Web.Http.Description
Imports IntranetPortal.Data

Namespace Controllers
    Public Class DataStatusController
        Inherits ApiController

        <ResponseType(GetType(String()))>
        <Route("api/DataStatus/Categories")>
        Function GetDataCategories() As IHttpActionResult
            Dim status = Data.DataStatu.LoadCategories()
            Return Ok(status)
        End Function

        <ResponseType(GetType(Data.DataStatu()))>
        <Route("api/DataStatus/{category}")>
        Function GetDataStatus(category As String) As IHttpActionResult
            Dim status = Data.DataStatu.LoadAllDataStatus(category)
            Return Ok(status.ToArray)
        End Function

        <ResponseType(GetType(Data.DataStatu()))>
        <Route("api/DataStatus/Save")>
        Function PostDataStatus(status As DataStatu()) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            Dim i = 1
            For Each item In status.OrderBy(Function(s) s.DisplayOrder).ToList
                If item.Active Then
                    item.DisplayOrder = i
                    i = i + 1

                    'If String.IsNullOrEmpty(item.Category) Then
                    '    item.Category = category
                    'End If
                Else
                    item.DisplayOrder = Nothing
                End If

                item.Save()
            Next

            Return Ok(status)
        End Function


    End Class
End Namespace