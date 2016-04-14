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
            Else
                Me.CreateBy = saveBy
                Me.CreateDate = DateTime.Now

                ctx.PropertyOffers.Add(Me)
            End If

            ctx.SaveChanges()
        End Using
    End Sub

    ''' <summary>
    ''' The base override method to save data from FormDataItem
    ''' </summary>
    ''' <param name="itemData">The data in FormDataItem</param>
    ''' <returns>return data tag</returns>
    Public Overrides Function Save(itemData As FormDataItem) As String
        MyBase.Save(itemData)

        Using ctx As New PortalEntities
            If ctx.PropertyOffers.Any(Function(t) t.FormItemId = itemData.DataId) Then
                UpdateFields(itemData)
                ctx.Entry(Me).State = Entity.EntityState.Modified
            Else
                UpdateFields(itemData, True)
                ctx.PropertyOffers.Add(Me)
            End If

            ctx.SaveChanges()
            Return BBLE
        End Using
    End Function

    Private Sub UpdateFields(itemData As FormDataItem, Optional newCase As Boolean = False)
        Dim jsonCase = Newtonsoft.Json.Linq.JObject.Parse(itemData.FormData)

        If newCase Then
            FormItemId = itemData.DataId
            BBLE = jsonCase.Item("BBLE")
            Owner = itemData.CreateBy
            Me.OfferType = jsonCase.Item("Type")
            CreateDate = DateTime.Now
            CreateBy = itemData.CreateBy
            Return
        End If

        Title = jsonCase.Item("PropertyAddress")

        UpdateBy = itemData.UpdateBy
        UpdateDate = DateTime.Now
    End Sub

    Public Enum OfferStatus
        Initial = 0
        Assigned = 1
        Complete = 2
    End Enum

End Class
