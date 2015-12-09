Imports System.Reflection

Public Class SearchResluts_View
    Public Shared Function Cast(Of T)(myobj As [Object]) As T
        Dim objectType As Type = myobj.[GetType]()
        Dim target As Type = GetType(T)
        Dim x = Activator.CreateInstance(target, False)
        Dim z = From source In objectType.GetMembers().ToList() Where source.MemberType = MemberTypes.Property Select source
        Dim d = From source In target.GetMembers().ToList() Where source.MemberType = MemberTypes.Property Select source
        Dim members As List(Of MemberInfo) = d.Where(Function(memberInfo) d.[Select](Function(c) c.Name).ToList().Contains(memberInfo.Name)).ToList()
        Dim propertyInfo As PropertyInfo
        Dim value As Object
        For Each memberInfo In members
            propertyInfo = GetType(T).GetProperty(memberInfo.Name)
            value = myobj.[GetType]().GetProperty(memberInfo.Name).GetValue(myobj, Nothing)

            propertyInfo.SetValue(x, value, Nothing)
        Next
        Return DirectCast(x, T)
    End Function
End Class
