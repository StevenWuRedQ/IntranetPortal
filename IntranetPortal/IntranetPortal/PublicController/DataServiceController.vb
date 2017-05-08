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

        <Route("api/dataservice/gpaoffer")>
        Function PostGpaOffer(data As GPAOffer) As IHttpActionResult
            Try
                If Not ModelState.IsValid Then
                    Return BadRequest(ModelState)
                End If

                Dim li = LeadsInfo.GetInstance(data.BBLE)
                If li Is Nothing Then
                    LeadsInfo.CreateLeadsInfo(data.BBLE, LeadsInfo.LeadsType.StraightSale, data.GenerateBy)
                    DataWCFService.UpdateAssessInfo(data.BBLE)
                End If

                data.Save()

                SystemLog.Log("UpdateGPAOffer", data.ToJsonString, SystemLog.LogCategory.Operation, Nothing, "GPAService")
                Return Ok(GPAOffer.GetOffer(data.BBLE))
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
                    owner.TLOLocateReport.LastUpdate = owner.LastUpdate
                    Return Ok(owner.TLOLocateReport)
                End If

                Return NotFound()
            Catch ex As Exception
                Throw ex
            End Try
        End Function

        <Route("api/dataservice/property/{bble}/tlo/{name}/death")>
        Function GetOwnerDeathIndicator(bble As String, name As String) As IHttpActionResult
            Try
                If Not ModelState.IsValid Then
                    Return BadRequest(ModelState)
                End If

                Dim owner = HomeOwner.GetHomeOwner(bble, name)

                If owner Is Nothing Then
                    Return Ok(DeathStatus.Unknow)
                End If

                If owner.TLOLocateReport.dateOfDeathField IsNot Nothing Then
                    Return Ok(DeathStatus.Death)
                End If

                Return Ok(DeathStatus.Active)
            Catch ex As Exception
                Throw ex
            End Try
        End Function

        <Route("api/dataservice/property/{bble}/tlo/{name}/info")>
        Function GetOwnerInfo(bble As String, name As String) As IHttpActionResult
            Try
                If Not ModelState.IsValid Then
                    Return BadRequest(ModelState)
                End If

                Dim owner = HomeOwner.GetHomeOwner(bble, name)

                If owner Is Nothing Then
                    Return NotFound()
                End If

                Dim result = New With {
                    .bble = bble,
                    .name = owner.Name,
                    .dob = owner.Dob,
                    .age = owner.Age,
                    .death = Not owner.Alive,
                    .ssn = owner.OwnerSSN
                    }

                Return Ok(result)
            Catch ex As Exception
                Throw ex
            End Try
        End Function

        Enum DeathStatus
            Unknow
            Active
            Death
        End Enum

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

