Imports System
Imports System.Data.Entity
Imports System.ComponentModel.DataAnnotations.Schema
Imports System.Linq
Imports System.ComponentModel.DataAnnotations

Partial Public Class UnderwriterEntity
    Inherits DbContext

    Public Overridable Property forms As DbSet(Of UnderwriterForm)


    Public Sub New()
        MyBase.New("name=UnderwriterEntity")
    End Sub


    Protected Overrides Sub OnModelCreating(ByVal modelBuilder As DbModelBuilder)
    End Sub
End Class

Public Class UnderwriterForm
    <Key>
    Public Property FormId As Integer

    <MaxLength(30)>
    Public Property Test As String

    Public Property CreateBy As String

    Public Property UpdateBy As String

    Public Property CreateDate As DateTime

    Public Property updateDate As DateTime




End Class