﻿'------------------------------------------------------------------------------
' <auto-generated>
'     This code was generated from a template.
'
'     Manual changes to this file may cause unexpected behavior in your application.
'     Manual changes to this file will be overwritten if the code is regenerated.
' </auto-generated>
'------------------------------------------------------------------------------

Imports System
Imports System.Data.Entity
Imports System.Data.Entity.Infrastructure

Partial Public Class ShortSaleEntities
    Inherits DbContext

    Public Sub New()
        MyBase.New("name=ShortSaleEntities")
    End Sub

    Protected Overrides Sub OnModelCreating(modelBuilder As DbModelBuilder)
        Throw New UnintentionalCodeFirstException()
    End Sub

    Public Overridable Property CleareneceNotes() As DbSet(Of CleareneceNote)
    Public Overridable Property PartyContacts() As DbSet(Of PartyContact)
    Public Overridable Property PropertyFloors() As DbSet(Of PropertyFloor)
    Public Overridable Property PropertyTitles() As DbSet(Of PropertyTitle)
    Public Overridable Property ShortSaleCases() As DbSet(Of ShortSaleCase)
    Public Overridable Property TitleClearences() As DbSet(Of TitleClearence)
    Public Overridable Property PropertyBaseInfoes() As DbSet(Of PropertyBaseInfo)
    Public Overridable Property ShortSaleCaseComments() As DbSet(Of ShortSaleCaseComment)
    Public Overridable Property PropertyOccupants() As DbSet(Of PropertyOccupant)
    Public Overridable Property TitleJudgementSearches() As DbSet(Of TitleJudgementSearch)
    Public Overridable Property EvictionCases() As DbSet(Of EvictionCas)
    Public Overridable Property Employees() As DbSet(Of Employee)
    Public Overridable Property ShortSaleActivityLogs() As DbSet(Of ShortSaleActivityLog)
    Public Overridable Property MortgageStatusDatas() As DbSet(Of MortgageStatusData)
    Public Overridable Property GroupTypes() As DbSet(Of GroupType)
    Public Overridable Property PropertyValueInfoes() As DbSet(Of PropertyValueInfo)
    Public Overridable Property PropertyMortgages() As DbSet(Of PropertyMortgage)
    Public Overridable Property PropertyOwners() As DbSet(Of PropertyOwner)
    Public Overridable Property ShortSaleOverviews() As DbSet(Of ShortSaleOverview)
    Public Overridable Property ShortSaleBuyers() As DbSet(Of ShortSaleBuyer)
    Public Overridable Property ShortSaleOffers() As DbSet(Of ShortSaleOffer)
    Public Overridable Property CorporationEntities() As DbSet(Of CorporationEntity)

End Class