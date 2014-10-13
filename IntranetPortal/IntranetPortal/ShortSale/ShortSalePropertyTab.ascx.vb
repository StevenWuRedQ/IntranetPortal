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

    Sub BindData(caseID As Integer)

        home_breakdown_gridview.DataSource = propertyInfo.PropFloors
        hfBble.Value = propertyInfo.BBLE
        hfCaseId.Value = caseID
        home_breakdown_gridview.DataBind()
        home_breakdown_gridview.SettingsEditing.BatchEditSettings.EditMode = GridViewBatchEditMode.Cell
        home_breakdown_gridview.SettingsEditing.BatchEditSettings.StartEditAction = GridViewBatchStartEditAction.Click

    End Sub

   

    Protected Sub home_breakdown_gridview_RowInserting(sender As Object, e As DevExpress.Web.Data.ASPxDataInsertingEventArgs)
        Dim values = e.NewValues
        save_floor(values, True)

        finishEdit(sender, e)


    End Sub
    Sub finishEdit(ByRef sender As Object, e As System.ComponentModel.CancelEventArgs)
        Dim grid = CType(sender, ASPxGridView)
        e.Cancel = True

        grid.CancelEdit()
        If (grid.DataSource Is Nothing) Then

            Dim newData = ShortSaleCase.GetCase(hfCaseId.Value)
            grid.DataSource = newData.PropertyInfo.PropFloors
        End If
        
        grid.DataBind()
    End Sub
    Sub save_floor(ByVal values As OrderedDictionary, ByVal is_insert As Boolean)
        Dim add_floor As PropertyFloor = New PropertyFloor()
        add_floor.BBLE = hfBble.Value
        If (is_insert) Then
            Dim floors = ShortSaleCase.GetCase(hfCaseId.Value).PropertyInfo.PropFloors
            If (floors Is Nothing) Then
                add_floor.FloorId = 1
            Else
                add_floor.FloorId = floors.Count + 1
            End If
        Else
            add_floor.FloorId = values.Item("FloorId")
        End If

        add_floor.Bedroom = values.Item("Bedroom")
        add_floor.BoilerRoom = values.Item("BoilerRoom")
        add_floor.Bathroom = values.Item("Bathroom")
        add_floor.Diningroom = values.Item("Diningroom")
        add_floor.Rent = values.Item("Rent")
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
        finishEdit(sender, e)
    End Sub

    Protected Sub home_breakdown_gridview_RowUpdating(sender As Object, e As DevExpress.Web.Data.ASPxDataUpdatingEventArgs)
        save_floor(e.NewValues, False)
        finishEdit(sender, e)
    End Sub
End Class