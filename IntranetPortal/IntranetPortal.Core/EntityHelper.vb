Imports System.Data.Entity
Imports System.Data.Entity.Infrastructure

Public Class EntityHelper(Of T As Class)

    'Get navigationproperties Of Type T
    Public Shared Function GetNavigationProperties(ctx As IObjectContextAdapter) As List(Of Entity.Core.Metadata.Edm.NavigationProperty)
        Dim properties As List(Of Entity.Core.Metadata.Edm.NavigationProperty)
        Dim entityType = GetType(T)
        Dim entitySetElementType = ctx.ObjectContext.CreateObjectSet(Of T)().EntitySet.ElementType
        properties = entitySetElementType.NavigationProperties.ToList
        Return properties
    End Function

    public Shared Sub TryLoad(ctx As DbContext, t As T)
        If t IsNot Nothing
            for each navigationProperties in GetNavigationProperties(ctx)
                ctx.Entry(t).Reference(navigationProperties.ToString()).Load()
            Next 
        End If
    End Sub

    ' Update Reference Type in DBEntry Recursively
    Public Shared Sub ReferenceUpdate(ctx As DbContext, oldv As T, newv As T)
        For Each np In GetNavigationProperties(ctx)
            Dim refentry = ctx.Entry(oldv).Reference(np.ToString)
            refentry.Load()
            Dim p = GetType(T).GetProperty(np.ToString)
            Dim dp = p.PropertyType
            Dim orgobj = p.GetValue(oldv)
            Dim tarobj = p.GetValue(newv)

            For Each dpp In dp.GetProperties
                dp.GetProperty(dpp.Name).SetValue(orgobj, dp.GetProperty(dpp.Name).GetValue(tarobj, Nothing))
            Next
        Next
    End Sub

End Class
