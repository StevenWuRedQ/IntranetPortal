﻿Imports System.Data
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

        <Route("api/dataservice/property/{bble}/tlo/{name}")>
        Function GetTLOData(bble As String, name As String) As IHttpActionResult
            Try
                If Not ModelState.IsValid Then
                    Return BadRequest(ModelState)
                End If

                Dim owner = HomeOwner.GetHomeOwner(bble, name)

                If owner IsNot Nothing Then
                    Return Ok(owner.TLOLocateReport)
                End If

                Return NotFound()
            Catch ex As Exception
                Throw ex
            End Try
        End Function

        <Route("api/dataservice/property/{bble}")>
        Function GetLeadsInfo(bble As String) As IHttpActionResult
            Try
                Dim ld = LeadsInfo.GetInstance(bble)

                If ld IsNot Nothing Then
                    ld.Lead = Lead.GetInstance(bble)
                    Dim result = New With {
                            .leadsInfo = ld,
                            .lead = Lead.GetInstance(bble)
                        }

                    Return Ok(result)
                End If

                Return Ok()
            Catch ex As Exception
                Throw ex
            End Try
        End Function

        <Route("api/dataservice/property/{bble}/leadstatus")>
        Function GetLeadsStatus(bble As String) As IHttpActionResult
            Try
                Dim ld = Lead.GetInstance(bble)

                If ld IsNot Nothing Then
                    Dim status = New With {
                                        .status = ld.StatusStr,
                                        .subStatus = ld.SubStatusStr
                                   }
                    Return Ok(status)
                End If

                Return Ok()
            Catch ex As Exception
                Throw ex
            End Try
        End Function
    End Class

End Namespace

