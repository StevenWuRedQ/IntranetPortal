Imports Newtonsoft.Json
Imports IntranetPortal.ShortSale
Imports DevExpress.Web.ASPxGridView

Public Class ShortSalePropertyTab
    Inherits System.Web.UI.UserControl
    Public Property propertyInfo As New PropertyBaseInfo
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load



    End Sub
    Sub initPropertyInfo()
        Using Context As New Entities
            'propertyInfo = Internal.sh .Where(Function(pi) pi.BBLE = "123").FirstOrDefault()
        End Using
    End Sub

    Sub BindData()

        home_breakdown_gridview.DataSource = propertyInfo.PropFloors
        hfBble.Value = propertyInfo.BBLE
        home_breakdown_gridview.DataBind()
        home_breakdown_gridview.SettingsEditing.BatchEditSettings.EditMode = GridViewBatchEditMode.Cell
        home_breakdown_gridview.SettingsEditing.BatchEditSettings.StartEditAction = GridViewBatchStartEditAction.Click

    End Sub

    Protected Sub save_floors_Callback(source As Object, e As DevExpress.Web.ASPxCallback.CallbackEventArgs)
        Dim floors As List(Of PropertyFloor) = CType(home_breakdown_gridview.DataSource, List(Of PropertyFloor))
        propertyInfo.PropFloors.Clear()
        For Each floor As PropertyFloor In floors
            propertyInfo.PropFloors.Add(floor)
        Next
        propertyInfo.Save()
    End Sub

    Protected Sub home_breakdown_gridview_RowInserting(sender As Object, e As DevExpress.Web.Data.ASPxDataInsertingEventArgs)
        Dim values = e.NewValues
        save_floor(values, True)

        e.Cancel = True

    End Sub
    Sub save_floor(ByVal values As OrderedDictionary, ByVal is_insert As Boolean)
        Dim add_floor As PropertyFloor = New PropertyFloor()
        add_floor.BBLE = hfBble.Value
        If (is_insert) Then
            Dim floors As List(Of PropertyFloor) = CType(home_breakdown_gridview.DataSource, List(Of PropertyFloor))
            add_floor.FloorId = floors.Count + 1
        End If
        add_floor.FloorId = values.Item("FloorId")
        add_floor.Bedroom = values.Item("Bedroom")
        add_floor.BoilerRoom = values.Item("BoilerRoom")
        add_floor.Bathroom = values.Item("Bathroom")
        add_floor.Diningroom = values.Item("Diningroom")

        add_floor.Livingroom = values.Item("Livingroom")
        add_floor.Lease = values.Item("Lease")
        add_floor.Kitchen = values.Item("Kitchen")
        add_floor.Occupied = values.Item("Occupied")
        add_floor.Type = values.Item("Type")
        add_floor.Save()
    End Sub

    Protected Sub home_breakdown_gridview_RowDeleting(sender As Object, e As DevExpress.Web.Data.ASPxDataDeletingEventArgs)
        Dim values = e.Values
        PropertyFloor.Delete(hfBble.Value, values.Item("FloorId"))
        e.Cancel = True
    End Sub

    Protected Sub home_breakdown_gridview_RowUpdating(sender As Object, e As DevExpress.Web.Data.ASPxDataUpdatingEventArgs)
        save_floor(e.NewValues, False)
        e.Cancel = True
    End Sub
End Class