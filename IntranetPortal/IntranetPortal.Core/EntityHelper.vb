Imports System.Data.Entity
Imports System.Data.Entity.Infrastructure

Public Class EntityHelper(Of T As Class)

    Public Shared Function GetNavigationProperties(ctx As IObjectContextAdapter) As List(Of Entity.Core.Metadata.Edm.NavigationProperty)
        Dim properties As List(Of Entity.Core.Metadata.Edm.NavigationProperty)
        Dim entityType = GetType(T)
        Dim entitySetElementType = ctx.ObjectContext.CreateObjectSet(Of T)().EntitySet.ElementType
        properties = entitySetElementType.NavigationProperties.ToList
        Return properties
    End Function

    Public Shared Sub ReferenceUpdate(ctx As DbContext, oldv As T, newv As T)

        For Each np In GetNavigationProperties(ctx)
            Dim refentry = ctx.Entry(oldv).Reference(np.ToString)
            refentry.Load()
            Dim p = GetType(T).GetProperty(np.ToString)
            Dim dp = p.PropertyType
            Dim orgobj = p.GetValue(oldv)
            Dim tarobj = p.GetValue(CType(newv, T))

            For Each dpp In dp.GetProperties
                dp.GetProperty(dpp.Name).SetValue(orgobj, dp.GetProperty(dpp.Name).GetValue(tarobj, Nothing))
            Next
        Next
    End Sub
End Class
