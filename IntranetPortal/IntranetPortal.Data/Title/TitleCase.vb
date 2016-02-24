﻿Public Class TitleCase
    Inherits BusinessDataBase

    Public Property TitleCategory As String
    Public Property SSCategory As String

    Public ReadOnly Property StatusStr As String
        Get
            If Status.HasValue Then
                Return CType(Status, DataStatus).ToString
            End If

            Return Nothing
        End Get
    End Property

    Public Shared Function GetCase(bble As String) As TitleCase
        Using ctx As New PortalEntities
            Dim tcase = ctx.TitleCases.Find(bble)
            If tcase IsNot Nothing Then
                tcase.InitCategory()
            End If

            Return tcase
        End Using
    End Function

    Public Shared Function GetAllCases(status As DataStatus) As TitleCase()
        Using ctx As New PortalEntities
            Return ctx.TitleCases.Where(Function(c) c.Status = status Or status = DataStatus.All).ToArray
        End Using
    End Function

    Public Shared Function Exists(bble As String) As Boolean
        Using ctx As New PortalEntities
            Return ctx.TitleCases.Any(Function(c) c.BBLE = bble)
        End Using
    End Function

    Public Shared Function GetCaseStatus(bble As String) As TitleCase.DataStatus
        Using ctx As New PortalEntities
            Dim xcase = ctx.TitleCases.Find(bble)
            If xcase IsNot Nothing Then
                Return xcase.Status
            Else
                Return 0
            End If
        End Using
    End Function

    Public Shared Function GetAllCases(userName As String, status As DataStatus) As TitleCase()
        Using ctx As New PortalEntities
            Return ctx.TitleCases.Where(Function(c) c.Owner = userName AndAlso (c.Status = status Or status = DataStatus.All)).ToArray
        End Using
    End Function

    Public Shared Function LoadSSCategories(id As Integer) As MapTitleShortSaleCategory
        If Not MapTitleShortSaleCategory.Any(Function(m) m.Id = id) Then
            Throw New Exception("Unknow category id: " & id)
        End If

        Return MapTitleShortSaleCategory.Where(Function(a) a.Id = id).SingleOrDefault
    End Function

    Public Shared Function GetCasesBySSCategory(userName As String) As TitleCase()

        Using ctx As New PortalEntities
            Dim result = (From tCase In ctx.TitleCases.Where(Function(c) c.Owner = userName Or userName = "All")
                          Join ss In ctx.SSFirstMortgages On tCase.BBLE Equals ss.BBLE
                          Select tCase, ss).ToList.Select(Function(s)
                                                              If s.ss IsNot Nothing Then
                                                                  s.tCase.SSCategory = s.ss.Category
                                                                  Dim cate = GetTitleCategory(s.ss.Category)
                                                                  s.tCase.TitleCategory = If(cate Is Nothing, "External", cate)
                                                              End If

                                                              Return s.tCase
                                                          End Function).Distinct.ToArray

            Return result
        End Using
    End Function

    Public Shared Function GetCasesBySSCategory(userName As String, id As Integer) As TitleCase()
        If id = 0 Then
            Return GetExternalCases(userName)
        End If

        If id = -1 Then
            Return GetCasesBySSCategory(userName)
        End If

        Dim mapItem = LoadSSCategories(id)
        Dim ssCategories = mapItem.ShortSaleCategories
        Dim category = mapItem.Category
        Using ctx As New PortalEntities
            Dim result = (From tCase In ctx.TitleCases.Where(Function(c) c.Owner = userName Or userName = "All")
                          Join ss In ctx.SSFirstMortgages On tCase.BBLE Equals ss.BBLE
                          Where ssCategories.Contains(ss.Category)
                          Select tCase, ss).ToList.Select(Function(s)
                                                              If s.ss IsNot Nothing Then
                                                                  s.tCase.SSCategory = s.ss.Category
                                                                  s.tCase.TitleCategory = mapItem.Category
                                                              End If

                                                              Return s.tCase
                                                          End Function).Distinct.OrderByDescending(Function(s) s.UpdateDate).ToArray

            Return result
        End Using
    End Function

    Public Shared Function GetExternalCases(userName As String) As TitleCase()
        Using ctx As New PortalEntities
            Dim except = ctx.SSFirstMortgages.Where(Function(s) s.Category IsNot Nothing AndAlso s.Category <> "").Select(Function(s) s.BBLE).Distinct
            Dim result = ctx.TitleCases.Where(Function(c) Not except.Contains(c.BBLE) AndAlso (c.Owner = userName Or userName = "All")).ToList.Select(Function(ts)
                                                                                                                                                          ts.TitleCategory = "External"
                                                                                                                                                          Return ts
                                                                                                                                                      End Function).OrderByDescending(Function(s) s.UpdateDate).ToArray
            Return result
        End Using
    End Function

    Public Overrides Function LoadData(formId As Integer) As BusinessDataBase

        Using ctx As New PortalEntities
            Dim tCase = New TitleCase With {.FormItemId = formId}

            If ctx.TitleCases.Any(Function(t) t.FormItemId = formId) Then
                tCase = ctx.TitleCases.Where(Function(t) t.FormItemId = formId).FirstOrDefault

                If tCase IsNot Nothing Then
                    tCase.InitCategory()
                End If
            End If

            Return tCase
        End Using
    End Function

    Private Sub InitCategory()
        Me.SSCategory = ShortSaleCase.GetCaseCategory(BBLE)
        Me.TitleCategory = GetTitleCategory(SSCategory)
    End Sub

    Public Sub SaveData(saveBy As String)
        Using ctx As New PortalEntities
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

        Using ctx As New PortalEntities
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
            Owner = jsonCase.Item("Owner")
            CreateDate = DateTime.Now
            CreateBy = itemData.CreateBy

            Return
        End If

        UpdateBy = itemData.UpdateBy
        UpdateDate = DateTime.Now
    End Sub

    Public Shared Function GetTitleCategory(ssCategory As String) As String
        Return MapTitleShortSaleCategory.Where(Function(m) m.ShortSaleCategories.Contains(ssCategory)).Select(Function(m) m.Category).SingleOrDefault
    End Function

    Public Shared MapTitleShortSaleCategory As New List(Of MapTitleShortSaleCategory) From {
            New Data.MapTitleShortSaleCategory() With {.Id = 1, .Category = "Approved", .ShortSaleCategories = {"Approved"}},
            New MapTitleShortSaleCategory() With {.Id = 2, .Category = "Pending Approval", .ShortSaleCategories = {"Offers Review"}},
            New MapTitleShortSaleCategory() With {.Id = 3, .Category = "In Process", .ShortSaleCategories = {"Assign", "Equator", "Homepath", "Processing", "Valuation", "Value Dispute"}},
            New MapTitleShortSaleCategory() With {.Id = 4, .Category = "Held", .ShortSaleCategories = {"Dead", "Evictions", "Held", "Intake", "Litigation", "Pending"}},
            New MapTitleShortSaleCategory() With {.Id = 5, .Category = "Closed", .ShortSaleCategories = {"Closed"}}
        }

    Public Enum DataStatus
        All = -1
        InitialReview = 0
        PendingClearance = 1
        CTC = 2
        Completed = 3
    End Enum

End Class

Public Class MapTitleShortSaleCategory
    Public Property Id As Integer
    Public Property Category As String
    Public Property ShortSaleCategories As String()
End Class