﻿Imports System.ServiceModel
Imports System.ServiceModel.Activation
Imports System.ServiceModel.Web
Imports Newtonsoft.Json

<ServiceContract(Namespace:="")>
<AspNetCompatibilityRequirements(RequirementsMode:=AspNetCompatibilityRequirementsMode.Allowed)>
Public Class LegalServices

    ' To use HTTP GET, add <WebGet()> attribute. (Default ResponseFormat is WebMessageFormat.Json)
    ' To create an operation that returns XML,
    '     add <WebGet(ResponseFormat:=WebMessageFormat.Xml)>,
    '     and include the following line in the operation body:
    '         WebOperationContext.Current.OutgoingResponse.ContentType = "text/xml" 

#Region "Law References"

    <OperationContract()>
    <WebGet(ResponseFormat:=WebMessageFormat.Json)>
    Public Function GetLawReference(refId As Integer) As Channels.Message
        Return Legal.LawReference.GetReference(refId).ToJson
    End Function

    <OperationContract()>
    <WebGet(ResponseFormat:=WebMessageFormat.Json)>
    Public Function DeleteLawReference(refId As Integer) As Boolean
        Try
            Legal.LawReference.GetReference(refId).Delete()
            Return True
        Catch ex As Exception
            Throw ex
        End Try

        Return False
    End Function


    <OperationContract()>
    <WebGet(ResponseFormat:=WebMessageFormat.Json)>
    Public Function GetAllReference() As Channels.Message
        Return Legal.LawReference.GetAllReference().ToJson
    End Function

    <OperationContract()>
    <WebInvoke(RequestFormat:=WebMessageFormat.Json, ResponseFormat:=WebMessageFormat.Json, BodyStyle:=WebMessageBodyStyle.WrappedRequest)>
    Public Function SaveLaeReference(lawRef As String) As String
        Dim res = JsonConvert.DeserializeObject(Of Legal.LawReference)(lawRef)
        Try
            res.Save()
        Catch ex As Exception
            Throw ex
        End Try

        Return res.RefId
    End Function

#End Region

#Region "Legal Case"
    <OperationContract()>
    <WebInvoke(RequestFormat:=WebMessageFormat.Json, ResponseFormat:=WebMessageFormat.Json, BodyStyle:=WebMessageBodyStyle.WrappedRequest)>
    Public Function SetLegalFollowUp(bble As String, type As String, dtSelected As String) As Boolean
        Dim dateSelected = DateTime.Now

        Select Case type
            Case "Tomorrow"
                dateSelected = DateTime.Now.AddDays(1)
            Case "nextWeek"
                dateSelected = DateTime.Now.AddDays(7)
            Case "thirtyDays"
                dateSelected = DateTime.Now.AddDays(30)
            Case "sixtyDays"
                dateSelected = DateTime.Now.AddDays(60)
            Case "customDays"
                If DateTime.TryParse(dtSelected, dateSelected) Then

                Else

                End If
        End Select

        Try
            Dim lCase = Legal.LegalCase.GetCase(bble)
            lCase.FollowUp = dateSelected
            lCase.UpdateDate = DateTime.Now
            lCase.UpdateBy = HttpContext.Current.User.Identity.Name
            lCase.SaveData()

            LeadsActivityLog.AddActivityLog(DateTime.Now, "New Legal follow up date: " & dateSelected.ToString("d"), bble, LeadsActivityLog.LogCategory.Legal.ToString, LeadsActivityLog.EnumActionType.FollowUp)
            Return True
        Catch ex As Exception
            Throw ex
        End Try

        Return False
    End Function

#End Region




End Class