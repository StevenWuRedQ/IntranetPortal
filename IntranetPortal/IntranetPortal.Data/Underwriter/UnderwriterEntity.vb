Imports System
Imports System.Data.Entity
Imports System.ComponentModel.DataAnnotations.Schema
Imports System.Linq
Imports System.ComponentModel.DataAnnotations

Partial Public Class UnderwriterEntity
    Inherits DbContext

    Public Overridable Property underwriters As DbSet(Of Underwriter)




    Public Sub New()
        MyBase.New("name=UnderwriterEntity")
    End Sub


    Protected Overrides Sub OnModelCreating(ByVal modelBuilder As DbModelBuilder)
    End Sub
End Class