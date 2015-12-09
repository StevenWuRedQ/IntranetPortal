Imports DevExpress.Web
Imports IntranetPortal.Data

Public Class ShortSaleInLeadsView
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Public Property propertyInfo As New PropertyBaseInfo

    Sub BindData(bble As String)
        Dim ss = ShortSaleCase.GetCaseByBBLE(bble)
        propertyInfo = ss.PropertyInfo

        hfBble.Value = propertyInfo.BBLE
        hfCaseId.Value = ss.CaseId

        home_breakdown_gridview.DataSource = propertyInfo.PropFloors
        home_breakdown_gridview.DataBind()
        home_breakdown_gridview.SettingsEditing.BatchEditSettings.EditMode = GridViewBatchEditMode.Cell
        home_breakdown_gridview.SettingsEditing.BatchEditSettings.StartEditAction = GridViewBatchStartEditAction.Click
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

            add_floor.FloorId = get_floor_id()
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


    Public Function get_floor_id() As Integer
        Dim ss_case As ShortSaleCase = ShortSaleCase.GetCase(hfCaseId.Value)

        If (ss_case Is Nothing) Then
            Return 1
        End If
        Dim floors = ss_case.PropertyInfo.PropFloors
        If (floors Is Nothing) Then
            Return 1
        Else
            Return floors.Count + 1
        End If

    End Function


    Function GetFloorId(floorId) As Integer
        If floorId = 0 Then
            Return get_floor_id()
        Else
            Return floorId
        End If
    End Function

    Protected Sub ASPxPopupControl2_OnWindowCallback(ByVal source As Object, ByVal e As PopupWindowCallbackArgs)

        Dim bble = e.Parameter.Split("|")(0)
        Dim floorId = e.Parameter.Split("|")(1)

        Dim floorData = PropertyFloor.Instance(bble, floorId)
        txtDescription.Value = floorData.Description

        'ASPxPopupControl2.DataSource = floorData
        'ASPxPopupControl2.DataBind()
    End Sub

    Protected Sub gridOccupants_RowInserting(sender As Object, e As DevExpress.Web.Data.ASPxDataInsertingEventArgs) Handles gridOccupants.RowInserting
        Dim info As New PropertyOccupant
        info.BBLE = hfFloorBBLE.Value
        info.FloorId = hfFloorId.Value
        info.Name = e.NewValues("Name")
        info.Phone = e.NewValues("Phone")
        info.Save()

        e.Cancel = True
        gridOccupants.CancelEdit()

        gridOccupants.DataBind()
    End Sub

    Protected Sub gridOccupants_RowUpdating(sender As Object, e As DevExpress.Web.Data.ASPxDataUpdatingEventArgs) Handles gridOccupants.RowUpdating
        Dim info = PropertyOccupant.Instance(e.Keys(0))
        info.Name = e.NewValues("Name")
        info.Phone = e.NewValues("Phone")
 
        info.Save()

        e.Cancel = True
        gridOccupants.CancelEdit()

        gridOccupants.DataBind()
    End Sub

    Protected Sub gridOccupants_RowDeleting(sender As Object, e As DevExpress.Web.Data.ASPxDataDeletingEventArgs) Handles gridOccupants.RowDeleting
        Dim info = PropertyOccupant.Instance(e.Keys(0))
        info.DataStatus = ModelStatus.Deleted
        info.Save()

        e.Cancel = True
        gridOccupants.DataBind()
    End Sub

    Protected Sub gridOccupants_DataBinding(sender As Object, e As EventArgs) Handles gridOccupants.DataBinding
        If gridOccupants.DataSource Is Nothing Then
            gridOccupants.DataSource = PropertyOccupant.GetOccupantByBBLE(hfFloorBBLE.Value, hfFloorId.Value)
        End If
    End Sub
End Class