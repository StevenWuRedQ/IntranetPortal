Imports System.Collections
Imports System.Collections.Generic
Imports System.Web.Script.Serialization
Public Class DateTimeJavaScriptConverter
    Inherits JavaScriptConverter
    Public Overrides Function Deserialize(dictionary As IDictionary(Of String, Object), type As Type, serializer As JavaScriptSerializer) As Object
        Return New JavaScriptSerializer().ConvertToType(dictionary, type)
    End Function

    Public Overrides Function Serialize(obj As Object, serializer As JavaScriptSerializer) As IDictionary(Of String, Object)
        If Not (TypeOf obj Is DateTime) Then
            Return Nothing
        End If
        Return New CustomString(DirectCast(obj, DateTime).ToUniversalTime().ToString("O"))
    End Function

    Public Overrides ReadOnly Property SupportedTypes() As IEnumerable(Of Type)
        Get
            Return {GetType(DateTime)}
        End Get
    End Property

    Private Class CustomString
        Inherits Uri
        Implements IDictionary(Of String, Object)

        Public Sub New(str As String)
            MyBase.New(str, UriKind.Relative)
        End Sub


        Public Sub Add(item As KeyValuePair(Of String, Object)) Implements ICollection(Of KeyValuePair(Of String, Object)).Add
            Throw New NotImplementedException
        End Sub

        Public Sub Clear() Implements ICollection(Of KeyValuePair(Of String, Object)).Clear
            Throw New NotImplementedException
        End Sub

        Public Function Contains(item As KeyValuePair(Of String, Object)) As Boolean Implements ICollection(Of KeyValuePair(Of String, Object)).Contains
            Throw New NotImplementedException
        End Function

        Public Sub CopyTo(array() As KeyValuePair(Of String, Object), arrayIndex As Integer) Implements ICollection(Of KeyValuePair(Of String, Object)).CopyTo
            Throw New NotImplementedException
        End Sub

        Public ReadOnly Property Count As Integer Implements ICollection(Of KeyValuePair(Of String, Object)).Count
            Get

            End Get
        End Property

        Public ReadOnly Property IsReadOnly As Boolean Implements ICollection(Of KeyValuePair(Of String, Object)).IsReadOnly
            Get

            End Get
        End Property

        Public Function Remove(item As KeyValuePair(Of String, Object)) As Boolean Implements ICollection(Of KeyValuePair(Of String, Object)).Remove
            Throw New NotImplementedException
        End Function

        Public Sub Add1(key As String, value As Object) Implements IDictionary(Of String, Object).Add

        End Sub

        Public Function ContainsKey(key As String) As Boolean Implements IDictionary(Of String, Object).ContainsKey
            Throw New NotImplementedException
        End Function

        Default Public Property Item(key As String) As Object Implements IDictionary(Of String, Object).Item
            Get
                Throw New NotImplementedException
            End Get
            Set(value As Object)

            End Set
        End Property

        Public ReadOnly Property Keys As ICollection(Of String) Implements IDictionary(Of String, Object).Keys
            Get
                Throw New NotImplementedException
            End Get
        End Property

        Public Function Remove1(key As String) As Boolean Implements IDictionary(Of String, Object).Remove

        End Function

        Public Function TryGetValue(key As String, ByRef value As Object) As Boolean Implements IDictionary(Of String, Object).TryGetValue

        End Function

        Public ReadOnly Property Values As ICollection(Of Object) Implements IDictionary(Of String, Object).Values
            Get
                Throw New NotImplementedException
            End Get
        End Property

        Public Function GetEnumerator() As IEnumerator(Of KeyValuePair(Of String, Object)) Implements IEnumerable(Of KeyValuePair(Of String, Object)).GetEnumerator

        End Function

        Public Function GetEnumerator1() As IEnumerator Implements IEnumerable.GetEnumerator
            Throw New NotImplementedException
        End Function
    End Class
End Class
