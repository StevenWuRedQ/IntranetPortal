Public Class TitleCase
    Inherits BusinessDataBase

    Public Shared Function GetCase(bble As String) As TitleCase
        Using ctx As New ConstructionEntities
            Return ctx.TitleCases.Find(bble)
        End Using
    End Function

    Public Shared Function GetAllCases() As TitleCase()
        Using ctx As New ConstructionEntities
            Return ctx.TitleCases.ToArray
        End Using
    End Function

    Public Shared Function GetAllCases(userName As String) As TitleCase()
        Using ctx As New ConstructionEntities
            Return ctx.TitleCases.Where(Function(c) c.Owner = userName).ToArray
        End Using
    End Function

    Public Overrides Function LoadData(formId As Integer) As BusinessDataBase
        Dim data = MyBase.LoadData(formId)

        Using ctx As New ConstructionEntities
            If ctx.TitleCases.Any(Function(t) t.FormItemId = formId) Then
                data = ctx.TitleCases.Where(Function(t) t.FormItemId = formId).FirstOrDefault
            End If
        End Using

        Return data
    End Function

    Public Sub SaveData(saveBy As String)
        Using ctx As New ConstructionEntities
            If ctx.TitleCases.Any(Function(t) t.BBLE = BBLE) Then
                Me.UpdateDate = DateTime.Now
                Me.UpdateBy = saveBy

                ctx.Entry(Me).State = Entity.EntityState.Modified
            Else
                Me.CreateBy = saveBy
                Me.CreateDate = DateTime.Now

                ctx.TitleCases.Add(Me)
            End If

            ctx.SaveChanges()
        End Using
    End Sub

    Public Overrides Function Save(itemData As FormDataItem) As String
        MyBase.Save(itemData)

        Using ctx As New ConstructionEntities
            If ctx.TitleCases.Any(Function(t) t.FormItemId = itemData.DataId) Then
                UpdateFields(itemData)
                ctx.Entry(Me).State = Entity.EntityState.Modified
            Else
                UpdateFields(itemData, True)
                ctx.TitleCases.Add(Me)
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
            CaseName = jsonCase.Item("CaseName")
            CreateDate = DateTime.Now
            CreateBy = itemData.CreateBy

            Return
        End If

        CaseName = jsonCase.Item("CaseName")
        UpdateBy = itemData.UpdateBy
        UpdateDate = DateTime.Now
    End Sub

End Class
