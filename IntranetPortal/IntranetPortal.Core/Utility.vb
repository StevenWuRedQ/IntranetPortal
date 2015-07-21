Imports System.Reflection
Imports System.ComponentModel

Public Class Utility
    Public Shared Function SaveChangesObj(oldObj As Object, newObj As Object) As Object
        Dim type = oldObj.GetType()

        For Each prop In type.GetProperties.Where(Function(p) p.CanWrite)
            Dim newValue = prop.GetValue(newObj)
            If newValue IsNot Nothing Then
                Dim oldValue = prop.GetValue(oldObj)
                If Not newValue.Equals(oldValue) Then
                    If prop.CanWrite Then
                        prop.SetValue(oldObj, newValue)
                    End If
                End If
            Else
                Dim oldValue = prop.GetValue(oldObj)
                If oldValue IsNot Nothing Then
                    If prop.PropertyType Is GetType(DateTime?) OrElse prop.PropertyType Is GetType(Boolean?) OrElse prop.PropertyType Is GetType(Integer?) _
                        OrElse prop.PropertyType Is GetType(String) Then
                        If prop.CanWrite Then
                            prop.SetValue(oldObj, newValue)
                        End If
                    End If
                End If
            End If
        Next

        Return oldObj
    End Function

    Public Shared Function CopyTo(fromObj As Object, toObj As Object) As Object
        Dim type = fromObj.GetType()
        Dim toType = toObj.GetType
        Dim toProperties = toType.GetProperties

        For Each prop In type.GetProperties
            Dim toProp = toType.GetProperty(prop.Name)

            If toProp.PropertyType.IsPrimitive Or toProp.PropertyType Is GetType(String) Or toProp.PropertyType.IsValueType Then
                If toProp IsNot Nothing AndAlso toProp.CanWrite Then
                    toProp.SetValue(toObj, prop.GetValue(fromObj))
                End If
            End If
        Next

        Return toObj
    End Function

    Public Shared Function GetEnumDescription(ByVal EnumConstant As [Enum]) As String
        Dim fi As FieldInfo = EnumConstant.GetType().GetField(EnumConstant.ToString())
        Dim attr() As DescriptionAttribute = _
                      DirectCast(fi.GetCustomAttributes(GetType(DescriptionAttribute), _
                      False), DescriptionAttribute())

        If attr.Length > 0 Then
            Return attr(0).Description
        Else
            Return EnumConstant.ToString()
        End If
    End Function
End Class
