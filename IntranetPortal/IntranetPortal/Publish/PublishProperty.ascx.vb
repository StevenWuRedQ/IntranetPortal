Imports PublicSiteData
Imports DevExpress.Web.ASPxEditors

Public Class PublishProperty
    Inherits System.Web.UI.UserControl

    Public Property ListPropertyData As PublicSiteData.ListProperty

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            If Not String.IsNullOrEmpty(Request.QueryString("bble")) Then
                Dim bble = Request.QueryString("bble").ToString
                hfBBLE.Value = bble
                BindFeatureList()
                BindData(bble)
                BindImages(bble)
            End If
        End If
    End Sub

    Private Sub BindFeatureList()
        cblFeatures.DataSource = FeatureData.GetList
        cblFeatures.DataBind()
    End Sub

    Private Sub BindImages(bble As String)
        Dim imgs = PropertyImage.GetPropertyImages(bble)
        imageSlider.DataSource = imgs
        imageSlider.DataBind()

        gridImages.DataSource = imgs
        gridImages.DataBind()
    End Sub

    Private Sub BindData(bble As String)
        ListPropertyData = ListProperty.GetProperty(bble)

        If ListPropertyData Is Nothing Then
            ListPropertyData = Lead.InitPublicData(bble)
        End If

        'Bind Sales data
        cbNumOfBath.Text = If(ListPropertyData.BathRoomNum.HasValue, ListPropertyData.BathRoomNum, "")
        cbNumOfBed.Text = If(ListPropertyData.BedRoomNum.HasValue, ListPropertyData.BedRoomNum, "")
        txtSalePrice.Text = If(ListPropertyData.SalePrice.HasValue, ListPropertyData.SalePrice, "")
        txtAnnualTax.Text = If(ListPropertyData.AnnualTax.HasValue, ListPropertyData.AnnualTax, "")
        txtAvaiableDate.Value = If(ListPropertyData.AvaiableDate.HasValue, ListPropertyData.AvaiableDate.Value.ToShortDateString(), "")
        txtTransitLines.Text = ListPropertyData.TransitLines
        txtDescription.Value = ListPropertyData.Description

        'Bind Detail data
        txtCommonCharges.Text = If(ListPropertyData.CommonCharges.HasValue, ListPropertyData.CommonCharges, "")
        txtTaxes.Text = If(ListPropertyData.Taxes.HasValue, ListPropertyData.Taxes, "")
        txtPriceSqft.Text = If(ListPropertyData.PriceSqft.HasValue, ListPropertyData.PriceSqft, "")
        txtDownPayment.Text = If(ListPropertyData.MinDownPay.HasValue, ListPropertyData.MinDownPay, "")
        If ListPropertyData.AllowDog.HasValue Then
            rblDog.Value = If(ListPropertyData.AllowDog, "Yes", "No")
        End If

        If ListPropertyData.AllowCat.HasValue Then
            rblCat.Value = If(ListPropertyData.AllowCat, "Yes", "No")
        End If

        txtSqft.Text = If(ListPropertyData.TotalSqft.HasValue, ListPropertyData.TotalSqft, "")
        txtNumOfUnit.Text = If(ListPropertyData.UnitsInBuilding.HasValue, ListPropertyData.UnitsInBuilding, "")
        txtNumOfFloor.Text = If(ListPropertyData.BuildingFloors.HasValue, ListPropertyData.BuildingFloors, "")
        txtSchoolDistrict.Text = ListPropertyData.SchoolDistrict

        BindFeatures()
    End Sub

    Sub BindFeatures()
        For Each item In ListPropertyData.Features
            Dim ft = cblFeatures.Items.FindByValue(item.FeatureId.ToString)
            If ft IsNot Nothing Then
                ft.Selected = True
            End If
        Next
    End Sub

    Function GetFeatures(bble As String) As List(Of PropertyFeature)
        Dim features As New List(Of PropertyFeature)
        For Each item As ListEditItem In cblFeatures.SelectedItems
            Dim ft As New PropertyFeature
            ft.BBLE = bble
            ft.FeatureId = item.Value

            features.Add(ft)
        Next

        Return features
    End Function

    Function SaveListPropertyData() As ListProperty
        Dim bble = hfBBLE.Value
        ListPropertyData = ListProperty.GetProperty(bble)

        'Bind Sales Data
        ListPropertyData.BathRoomNum = If(String.IsNullOrEmpty(cbNumOfBath.Text), Nothing, CInt(cbNumOfBath.Text))
        ListPropertyData.BedRoomNum = If(String.IsNullOrEmpty(cbNumOfBed.Text), Nothing, CInt(cbNumOfBed.Text))
        ListPropertyData.SalePrice = CDec(txtSalePrice.Value)
        ListPropertyData.AnnualTax = CDec(txtAnnualTax.Value)
        If Not String.IsNullOrEmpty(txtAvaiableDate.Value) Then
            ListPropertyData.AvaiableDate = CDate(txtAvaiableDate.Value)
        End If
        ListPropertyData.TransitLines = txtTransitLines.Text
        ListPropertyData.Description = txtDescription.Value

        'Bind Key Details
        ListPropertyData.CommonCharges = If(String.IsNullOrEmpty(txtCommonCharges.Text), Nothing, CDec(txtCommonCharges.Text))
        ListPropertyData.Taxes = If(String.IsNullOrEmpty(txtTaxes.Text), Nothing, CDec(txtTaxes.Text))
        ListPropertyData.PriceSqft = If(String.IsNullOrEmpty(txtPriceSqft.Text), Nothing, CDec(txtPriceSqft.Text))
        ListPropertyData.MinDownPay = If(String.IsNullOrEmpty(txtDownPayment.Text), Nothing, CDec(txtDownPayment.Text))
        ListPropertyData.AllowDog = If(String.IsNullOrEmpty(rblDog.Value), Nothing, rblDog.Value = "Yes")
        ListPropertyData.AllowCat = If(String.IsNullOrEmpty(rblCat.Value), Nothing, rblCat.Value = "Yes")
        ListPropertyData.TotalSqft = If(String.IsNullOrEmpty(txtSqft.Text), Nothing, CDec(txtSqft.Text))
        ListPropertyData.UnitsInBuilding = If(String.IsNullOrEmpty(txtNumOfUnit.Text), Nothing, CInt(txtNumOfUnit.Text))
        ListPropertyData.BuildingFloors = If(String.IsNullOrEmpty(txtNumOfFloor.Text), Nothing, CInt(txtNumOfFloor.Text))
        ListPropertyData.SchoolDistrict = txtSchoolDistrict.Text

        ListPropertyData.Save()

        'Save Feature
        ListPropertyData.SaveFeatures(GetFeatures(bble))

        Return ListPropertyData
    End Function

    Protected Sub cpPropertyContent_Callback(sender As Object, e As DevExpress.Web.ASPxClasses.CallbackEventArgsBase)
        If e.Parameter = "Save" Then
            SaveListPropertyData()
        End If
    End Sub

    Protected Sub UploadControl_FileUploadComplete(sender As Object, e As DevExpress.Web.ASPxUploadControl.FileUploadCompleteEventArgs)
        Dim img As New PropertyImage
        img.FileName = e.UploadedFile.FileName
        img.ImageData = e.UploadedFile.FileBytes
        img.ContentType = e.UploadedFile.ContentType
        img.ImageSize = e.UploadedFile.ContentLength
        img.BBLE = hfBBLE.Value
        img.CreateBy = Page.User.Identity.Name
        img.Create()

        e.CallbackData = img.ImageId
    End Sub

    Protected Sub gridImages_CustomCallback(sender As Object, e As DevExpress.Web.ASPxGridView.ASPxGridViewCustomCallbackEventArgs)
        If e.Parameters.StartsWith("Upload") Then
            Dim fileId = CInt(e.Parameters.Split("|")(1))
            Dim bble = hfBBLE.Value
            PropertyImage.UpdateBBLE(fileId, bble, Nothing)
        End If
    End Sub

    Protected Sub gridImages_RowDeleting(sender As Object, e As DevExpress.Web.Data.ASPxDataDeletingEventArgs)
        PropertyImage.Delete(CInt(e.Keys(0)))
        e.Cancel = True

        BindImages(hfBBLE.Value)
    End Sub
End Class