Imports System.Data
Imports System.Data.Entity
Imports System.Data.Entity.Infrastructure
Imports System.IO
Imports System.Linq
Imports System.Net
Imports System.Net.Http
Imports System.Web.Http
Imports System.Web.Http.Description
Imports IntranetPortal.Data
Imports IntranetPortal.Core

Namespace PublicController

    ''' <summary>
    '''     Data service controller to provide the callback for external service
    ''' </summary>
    Public Class DataServiceController
        Inherits System.Web.Http.ApiController

        <Route("api/dataservice/completed")>
        Function PostData(data As ExternalData) As IHttpActionResult
            Try
                If Not ModelState.IsValid Then
                    Return BadRequest(ModelState)
                End If

                DataWCFService.UpdateExternalData(data)
                SystemLog.Log("Completed DataService", data.ToJsonString, SystemLog.LogCategory.Operation, Nothing, "ExternalService")
                Return Ok()
            Catch ex As Exception
                Throw ex
            End Try
        End Function

    End Class

End Namespace

