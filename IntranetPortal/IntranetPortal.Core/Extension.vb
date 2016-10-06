Imports System.Runtime.CompilerServices
Imports System.IO
Imports System.Text
Imports System.Reflection
Imports System.ComponentModel

Public Module JsonExtension

    <Extension()>
    Public Function ToJsonString(ByVal obj As Object) As String
        Dim json = Newtonsoft.Json.JsonConvert.SerializeObject(obj)
        Return json
    End Function
End Module

Public Module EnumExtension
    <Extension()>
    Public Function GetDescription(Of T As Structure)(enumerationValue As [Enum]) As String
        Dim type As Type = enumerationValue.[GetType]()
        If Not type.IsEnum Then
            Throw New ArgumentException("EnumerationValue must be of Enum type", "enumerationValue")
        End If

        'Tries to find a DescriptionAttribute for a potential friendly name
        'for the enum
        Dim memberInfo As MemberInfo() = type.GetMember(enumerationValue.ToString())
        If memberInfo IsNot Nothing AndAlso memberInfo.Length > 0 Then
            Dim attrs As Object() = memberInfo(0).GetCustomAttributes(GetType(DescriptionAttribute), False)

            If attrs IsNot Nothing AndAlso attrs.Length > 0 Then
                'Pull out the description value
                Return DirectCast(attrs(0), DescriptionAttribute).Description
            End If
        End If
        'If we have no description attribute, just return the ToString of the enum
        Return enumerationValue.ToString()
    End Function
End Module