Imports DevExpress.Web

Public Class CreateNew
    Inherits System.Web.UI.UserControl

    Public Event CaseCreatedEvent As OnCaseCreated
    Public Delegate Sub OnCaseCreated(bble As String)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub lbNewBBLE_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase)
        Dim pageRootControl = Me.pageControlNewLeads
        Dim pageInputData = Me.pageControlInputData
        'Dim borough = TryCast(pageInputData.FindControl("txtStreetBorough"), ASPxTextBox).Text

        Dim lbBBLE = TryCast(sender, ASPxListBox)

        Dim returnData = GetBBLEData()

        If returnData.Rows.Count = 0 Then
            Throw New CallbackException("No data matched, Please check!")
        End If

        lbBBLE.DataSource = returnData.DefaultView
        lbBBLE.DataBind()
    End Sub

    Protected Sub cbStreetlookup_Callback(sender As Object, e As DevExpress.Web.CallbackEventArgsBase)
        If String.IsNullOrEmpty(e.Parameter) Then
            Return
        End If

        Dim cbStreetlookup = TryCast(sender, ASPxComboBox)
        Using Context As New Entities
            cbStreetlookup.DataSource = Context.NYC_St_Names.Where(Function(st) st.BOROUGH = e.Parameter).ToList()
            cbStreetlookup.DataBind()
        End Using
    End Sub


    Function GetBBLEData() As DataTable
        Dim pageRootControl = Me.pageControlNewLeads
        Dim pageInputData = Me.pageControlInputData

        Using client As New Data.DataAPI.WCFMacrosClient
            Dim dt = New DataTable
            dt.Columns.Add("BBLE")
            dt.Columns.Add("LeadsName")

            'Dim wdr = dt.NewRow
            'wdr(0) = "4065270030 "
            'wdr(1) = "25-29 96 ST - Chris"
            'dt.Rows.Add(wdr)

            'Return dt

            'Search by address
            If pageInputData.ActiveTabIndex = 0 Then
                Dim cbStreetlookup = TryCast(pageInputData.FindControl("cbStreetlookup"), ASPxComboBox)
                Dim cbStreetBorough = TryCast(pageInputData.FindControl("cbStreetBorough"), ASPxComboBox)
                Dim txtHouseNum = TryCast(pageInputData.FindControl("txtHouseNum"), ASPxTextBox)

                Dim streenAddress = client.NYC_Address_Search(cbStreetBorough.Value, txtHouseNum.Text, cbStreetlookup.Text)

                For Each item In streenAddress.ToList
                    Dim newdr = dt.NewRow
                    newdr(0) = item.BBLE
                    newdr(1) = String.Format("{0} {1} - {2}", item.NUMBER, item.ST_NAME, item.OWNER_NAME)
                    dt.Rows.Add(newdr)
                Next
            End If

            'Search by legal info
            If pageInputData.ActiveTabIndex = 1 Then
                Dim cblegalBorough = TryCast(pageInputData.FindControl("cblegalBorough"), ASPxComboBox)
                Dim txtlegalBlock = TryCast(pageInputData.FindControl("txtlegalBlock"), ASPxTextBox)
                Dim txtLegalLot = TryCast(pageInputData.FindControl("txtLegalLot"), ASPxTextBox)

                For Each item In client.NYC_Legal_Search(cblegalBorough.Value, txtlegalBlock.Text, txtLegalLot.Text)
                    Dim newdr = dt.NewRow
                    newdr(0) = item.BBLE
                    newdr(1) = String.Format("{0} {1} - {2}", item.NUMBER, item.ST_NAME, item.OWNER_NAME)
                    dt.Rows.Add(newdr)
                Next
            End If

            'Search by Owner
            If pageInputData.ActiveTabIndex = 2 Then
                Dim cbNameBorough = TryCast(pageInputData.FindControl("cbNameBorough"), ASPxComboBox)
                Dim txtNameFirst = TryCast(pageInputData.FindControl("txtNameFirst"), ASPxTextBox)
                Dim txtNameLast = TryCast(pageInputData.FindControl("txtNameLast"), ASPxTextBox)

                For Each item In client.NYC_Owner_Search(cbNameBorough.Value, String.Format("{0} {1}", txtNameFirst.Text, txtNameLast.Text))
                    Dim newdr = dt.NewRow
                    newdr(0) = item.BBLE
                    newdr(1) = String.Format("{0} {1} - {2}", item.NUMBER, item.ST_NAME, item.OWNER_NAME)
                    dt.Rows.Add(newdr)
                Next
            End If

            Return dt
        End Using
    End Function

    Protected Sub popupCreateNew_WindowCallback(source As Object, e As PopupWindowCallbackArgs)

        If e.Parameter.StartsWith("Add") Then

            Dim bble = e.Parameter.Split("|")(1)

            RaiseEvent CaseCreatedEvent(bble)

        End If


    End Sub
End Class