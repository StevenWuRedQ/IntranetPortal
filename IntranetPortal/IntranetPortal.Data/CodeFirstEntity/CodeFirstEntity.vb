Imports System
Imports System.Data.Entity
Imports System.ComponentModel.DataAnnotations.Schema
Imports System.Linq
Imports System.ComponentModel.DataAnnotations

Partial Public Class CodeFirstEntity
    Inherits DbContext

    Public Property Underwritings As DbSet(Of Underwriting)
    Public Property UnderwritingPropertyInfos As DbSet(Of UnderwritingPropertyInfo)


    Public Sub New()
        MyBase.New("name=CodeFirstEntity")
    End Sub


    Protected Overrides Sub OnModelCreating(ByVal modelBuilder As DbModelBuilder)
    End Sub
End Class