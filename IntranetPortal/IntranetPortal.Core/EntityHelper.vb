Imports System.Data.Entity
Imports System.Data.Entity.Infrastructure
Imports System.Web.UI.WebControls.Expressions

Public Class EntityHelper(Of T As Class)

    'Get navigationproperties Of Type T
    Public Shared Function GetNavigationProperties(ctx As IObjectContextAdapter) As List(Of Entity.Core.Metadata.Edm.NavigationProperty)
        Dim properties As List(Of Entity.Core.Metadata.Edm.NavigationProperty)
        Dim entityType = GetType(T)
        Dim entitySetElementType = ctx.ObjectContext.CreateObjectSet(Of T)().EntitySet.ElementType
        properties = entitySetElementType.NavigationProperties.ToList
        Return properties
    End Function

    Public Shared Sub TryLoad(ctx As DbContext, t As T)
        If t IsNot Nothing Then

            For Each navigationProperties In GetNavigationProperties(ctx)
                ctx.Entry(t).Reference(navigationProperties.ToString()).Load()
            Next
        End If
    End Sub

    ' Update Reference Type in DBEntry Recursively
    Public Shared Sub ReferenceUpdate(ctx As DbContext, oldv As T, newv As T)
        For Each np In GetNavigationProperties(ctx)
            Dim refentry = ctx.Entry(oldv).Reference(np.ToString)
            refentry.Load()
            Dim nPropInfo = GetType(T).GetProperty(np.ToString)
            Dim typeInfo = nPropInfo.PropertyType
            Dim orgobj = nPropInfo.GetValue(oldv)
            If orgobj Is Nothing Then
                orgobj = Activator.CreateInstance(typeInfo)
                nPropInfo.SetValue(oldv, orgobj)
                ctx.Entry(orgobj).State = EntityState.Added
            End If
            Dim tarobj = nPropInfo.GetValue(newv)
            If tarobj Is Nothing Then
                tarobj = Activator.CreateInstance(typeInfo)
            End If

            For Each propInfo In typeInfo.GetProperties
                If propInfo.Name.ToUpper() <> "ID" Then
                    Dim prop = typeInfo.GetProperty(propInfo.Name)
                    prop.SetValue(orgobj, prop.GetValue(tarobj, Nothing))
                End If
            Next
        Next
    End Sub

End Class
