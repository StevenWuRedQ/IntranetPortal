Imports Newtonsoft.Json.Linq

''' <summary>
''' The property offer object
''' </summary>
Partial Public Class PropertyOffer
    Inherits BusinessDataBase

    ''' <summary>
    ''' Return the PropertyOffer Array Owner Nmae
    ''' </summary>
    ''' <param name="name">The Owner Name</param>
    ''' <returns>The PropertyOffer Array</returns>
    Public Shared Function GetOffers(name As String) As PropertyOffer()

        Using ctx As New PortalEntities
            Dim offers = ctx.PropertyOffers.Where(Function(p) p.Owner = name OrElse name = "*").ToArray

            Return offers
        End Using
    End Function

    ''' <summary>
    ''' Load Property offer data
    ''' </summary>
    ''' <param name="bble">The Property BBLE</param>
    ''' <returns>The Property Offer</returns>
    Public Shared Function GetOffer(bble As String) As PropertyOffer
        Using ctx As New PortalEntities
            Dim offer = ctx.PropertyOffers.Where(Function(p) p.BBLE = bble).FirstOrDefault
            Return offer
        End Using
    End Function

    ''' <summary>
    ''' Return the PropertyOffer object by business form id
    ''' </summary>
    ''' <param name="formId">The form Id</param>
    ''' <returns>The PropertyOffer object</returns>
    Public Overrides Function LoadData(formId As Integer) As BusinessDataBase

        Using ctx As New PortalEntities
            Dim tCase = New PropertyOffer With {.FormItemId = formId}

            If ctx.PropertyOffers.Any(Function(t) t.FormItemId = formId) Then
                tCase = ctx.PropertyOffers.Where(Function(t) t.FormItemId = formId).FirstOrDefault
            End If

            Return tCase
        End Using
    End Function

    ''' <summary>
    ''' Save the case data
    ''' </summary>
    ''' <param name="saveBy">The user who save this data</param>
    Public Sub SaveData(saveBy As String)
        Using ctx As New PortalEntities
            If ctx.PropertyOffers.Any(Function(t) t.BBLE = BBLE) Then
                Me.UpdateDate = DateTime.Now
                Me.UpdateBy = saveBy

                ctx.Entry(Me).State = Entity.EntityState.Modified
                ctx.Entry(Me).OriginalValues.SetValues(ctx.Entry(Me).GetDatabaseValues)
            Else
                Me.CreateBy = saveBy
                Me.CreateDate = DateTime.Now
                ctx.PropertyOffers.Add(Me)
            End If

            ctx.SaveChanges(saveBy)
        End Using
    End Sub

    ''' <summary>
    ''' The base override method to save data from FormDataItem
    ''' </summary>
    ''' <param name="itemData">The data in FormDataItem</param>
    ''' <returns>return data tag</returns>
    Public Overrides Function Save(itemData As FormDataItem) As String
        MyBase.Save(itemData)

        If String.IsNullOrEmpty(BBLE) Then
            Throw New Exception("can not find BBLE")
        End If

        Dim updateBy = itemData.UpdateBy
        Using ctx As New PortalEntities
            If ctx.PropertyOffers.Any(Function(t) t.FormItemId = itemData.DataId) Then
                UpdateFields(itemData)
                ctx.Entry(Me).State = Entity.EntityState.Modified
                ctx.Entry(Me).OriginalValues.SetValues(ctx.Entry(Me).GetDatabaseValues)
            Else
                UpdateFields(itemData, True)
                ctx.PropertyOffers.Add(Me)
                updateBy = itemData.CreateBy
            End If

            ctx.SaveChanges(updateBy)
            Return BBLE
        End Using
    End Function

    ''' <summary>
    ''' Update the New Offer report fields
    ''' </summary>
    ''' <param name="itemData">The Business Data Object</param>
    ''' <param name="newCase">indicate if the object is new</param>
    Public Sub UpdateFields(itemData As FormDataItem, Optional newCase As Boolean = False)
        Dim jsonCase = Newtonsoft.Json.Linq.JObject.Parse(itemData.FormData)

        If jsonCase Is Nothing Then
            Return
        End If

        If newCase Then
            FormItemId = itemData.DataId
            BBLE = jsonCase.Item("BBLE")
            Owner = itemData.CreateBy
            Me.OfferType = jsonCase.Item("Type")
            Me.Status = OfferStatus.Initial
            CreateDate = DateTime.Now
            CreateBy = itemData.CreateBy
            Title = jsonCase.Item("PropertyAddress")
            Return
        End If

        Dim jStatus = jsonCase.GetValue("Status")
        If jStatus IsNot Nothing AndAlso Not String.IsNullOrEmpty(jStatus.ToString) Then
            Dim tmpStatus As Integer
            If Int32.TryParse(jStatus.ToString, tmpStatus) Then
                Me.Status = tmpStatus
            End If
        End If

        ContractSeller1 = LoadJsonData(Of String)(jsonCase, "DealSheet.ContractOrMemo.Sellers[0].Name")
        ContractSeller2 = LoadJsonData(Of String)(jsonCase, "DealSheet.ContractOrMemo.Sellers[1].Name")
        ContractSeller3 = LoadJsonData(Of String)(jsonCase, "DealSheet.ContractOrMemo.Sellers[2].Name")
        ContractPrice = LoadJsonData(Of Decimal)(jsonCase, "DealSheet.ContractOrMemo.contractPrice")
        ContractDownPay = LoadJsonData(Of Decimal)(jsonCase, "DealSheet.ContractOrMemo.downPayment")

        UpdateBy = itemData.UpdateBy
        UpdateDate = DateTime.Now
    End Sub

    Public Enum OfferStatus
        Initial = 0
        Assigned = 1
        Completed = 2
    End Enum

    Private Function LoadJsonData(Of T)(jsonCase As JObject, jpath As String) As T

        Try
            Dim field = jsonCase.SelectToken(jpath)

            If field IsNot Nothing Then
                Return CTypeDynamic(Of T)(field)
            End If
        Catch ex As Exception

        End Try

        Return Nothing
    End Function
End Class
