﻿Partial Public Class PropertyMortgage

    Private _shortSaleDeptContact As PartyContact
    Public Property ShortSaleDeptContact As PartyContact
        Get
            If ShortSaleDept.HasValue Then
                _shortSaleDeptContact = PartyContact.GetContact(ShortSaleDept)
            End If

            Return _shortSaleDeptContact
        End Get
        Set(value As PartyContact)
            _shortSaleDeptContact = value
        End Set
    End Property

    Private _processorContact As PartyContact
    Public Property ProcessorContact As PartyContact
        Get
            If Processor.HasValue Then
                _processorContact = PartyContact.GetContact(Processor)
            End If

            Return _processorContact
        End Get
        Set(value As PartyContact)
            _processorContact = value
        End Set
    End Property

    Private _negotiatorContact As PartyContact
    Public Property NegotiatorContact As PartyContact
        Get
            If Negotiator.HasValue Then
                _negotiatorContact = PartyContact.GetContact(Negotiator)
            End If

            Return _negotiatorContact
        End Get
        Set(value As PartyContact)
            _negotiatorContact = value
        End Set
    End Property

    Private _supervisorContact As PartyContact
    Public Property SupervisorContact As PartyContact
        Get
            If Supervisor.HasValue Then
                _supervisorContact = PartyContact.GetContact(Supervisor)
            End If

            Return _supervisorContact
        End Get
        Set(value As PartyContact)
            _supervisorContact = value
        End Set
    End Property

    Private _closerContact As PartyContact
    Public Property CloserContact As PartyContact
        Get
            If Closer.HasValue Then
                _closerContact = PartyContact.GetContact(Closer)
            End If

            Return _closerContact
        End Get
        Set(value As PartyContact)
            _closerContact = value
        End Set
    End Property

    Public Property DataStatus As ModelStatus

    Public Sub Save()
        Using context As New ShortSaleEntities
            Dim pbi = context.PropertyMortgages.Find(MortgageId)

            If pbi Is Nothing Then
                CreateDate = DateTime.Now
                context.Entry(Me).State = Entity.EntityState.Added
            Else
                pbi = ShortSaleUtility.SaveChangesObj(pbi, Me)
            End If

            context.SaveChanges()
        End Using
    End Sub
End Class
