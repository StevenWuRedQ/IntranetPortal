﻿Imports System.ComponentModel

Partial Public Class ConstructionSpotCheck
    Private Shared _KeyDescDict As Dictionary(Of String, String) = New Dictionary(Of String, String) From {
    {"date", "Date"},
    {"access", "Access"},
    {"numOfWork", "Number of workers"},
    {"descInterior", "Description of interior work being done"},
    {"descExterior", "Description of exterior work being done"},
    {"descMaterial", "Description of Material on site"},
    {"isPermitOnsite", "Are permits on site"},
    {"permitsAndExpired", "If YES, please confirm which permit(s) and date it expires"},
    {"isPlansOnSite", "Are plans on site"},
    {"nextDayPlan", "Next day planned work/tasks"},
    {"note", "Additional Notes:"}
    }
    Public Shared Function GetSpotChecks() As ConstructionSpotCheck()
        Using ctx = New ConstructionEntities()
            Return ctx.ConstructionSpotCheck.Where(Function(x) x.status = 0).ToArray
        End Using
    End Function

    Public Shared Function GetSpotChecks(userName As String) As ConstructionSpotCheck()
        Using ctx = New ConstructionEntities()
            Dim result = ctx.ConstructionSpotCheck.Where(Function(sc) sc.status = 0 And sc.owner = userName).ToList.Select(
                Function(sc)
                    Return New ConstructionSpotCheck With {.Id = sc.Id, .propertyAddress = sc.propertyAddress}
                End Function)
            Return result.ToArray
        End Using
    End Function

    Public Shared Function GetSpotCheck(id As Integer) As ConstructionSpotCheck
        Using ctx = New ConstructionEntities
            Dim result = ctx.ConstructionSpotCheck.Where(Function(sc) sc.Id = id).FirstOrDefault
            Return result
        End Using
    End Function

    Public Sub StartSpotCheck(BBLE As String, Owner As String)
        Using ctx = New ConstructionEntities()
            Me.BBLE = BBLE
            Me.propertyAddress = ctx.ConstructionCases.Where(Function(c) c.BBLE).FirstOrDefault.CaseName
            Me.owner = Owner
            Me.status = CaseStatus.Created
            ctx.ConstructionSpotCheck.Add(Me)
            ctx.SaveChanges()
        End Using
    End Sub

    Public Shared Sub UpdateSpotCheck(data As ConstructionSpotCheck)
        If Not data.Id = Nothing Then
            Using ctx = New ConstructionEntities
                Dim savedCased = ctx.ConstructionSpotCheck.Where(Function(sc) sc.Id = data.Id).FirstOrDefault
                For Each P In savedCased.GetType.GetProperties
                    If Not P.GetValue(data, Nothing) Is Nothing Then
                        If (P.Name <> "Id") Then
                            P.SetValue(savedCased, P.GetValue(data, Nothing))
                        End If
                    End If
                Next
                If savedCased.date Is Nothing Then
                    savedCased.date = New Date()
                End If
                savedCased.status = CaseStatus.Finished
                ctx.SaveChanges()
            End Using
        End If
    End Sub

    Public Shared Function GetNameDesction(key As String) As String
        Return _KeyDescDict(key)
    End Function
    Public Sub New()

    End Sub

    Public Enum CaseStatus
        <Description("Created")>
        Created = 0
        <Description("Finished")>
        Finished = 1
    End Enum

End Class


