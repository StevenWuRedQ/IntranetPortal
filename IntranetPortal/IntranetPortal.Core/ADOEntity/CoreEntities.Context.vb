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

Partial Public Class CoreEntities
    Inherits DbContext

    Public Sub New()
        MyBase.New("name=CoreEntities")
    End Sub

    Protected Overrides Sub OnModelCreating(modelBuilder As DbModelBuilder)
        Throw New UnintentionalCodeFirstException()
    End Sub

    Public Overridable Property EmailMessages() As DbSet(Of EmailMessage)
    Public Overridable Property SpecialDays() As DbSet(Of SpecialDay)
    Public Overridable Property EmailTemplates() As DbSet(Of EmailTemplate)
    Public Overridable Property DataLoopRules() As DbSet(Of DataLoopRule)
    Public Overridable Property RecycleLeads() As DbSet(Of RecycleLead)
    Public Overridable Property SystemLogs() As DbSet(Of SystemLog)
    Public Overridable Property TLOApiLogs() As DbSet(Of TLOApiLog)
    Public Overridable Property PortalSettings() As DbSet(Of PortalSetting)
    Public Overridable Property CommonDatas() As DbSet(Of CommonData)
    Public Overridable Property Applications() As DbSet(Of Application)

End Class
