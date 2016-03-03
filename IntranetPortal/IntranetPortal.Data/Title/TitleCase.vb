''' <summary>
''' The Title Case Object
''' </summary>
Public Class TitleCase
    Inherits BusinessDataBase

    ''' <summary>
    ''' The title category
    ''' </summary>
    ''' <returns></returns>
    Public Property TitleCategory As String

    ''' <summary>
    ''' The shortsale Category
    ''' </summary>
    ''' <returns></returns>
    Public Property SSCategory As String

    ''' <summary>
    ''' The title status name
    ''' </summary>
    ''' <returns></returns>
    Public ReadOnly Property StatusStr As String
        Get
            If Status.HasValue Then
                Return CType(Status, DataStatus).ToString
            End If

            Return Nothing
        End Get
    End Property

    ''' <summary>
    ''' Return title cases object of given BBLE
    ''' </summary>
    ''' <param name="bble"></param>
    ''' <returns></returns>
    Public Shared Function GetCase(bble As String) As TitleCase
        Using ctx As New PortalEntities
            Dim tcase = ctx.TitleCases.Find(bble)
            If tcase IsNot Nothing Then
                tcase.InitCategory()
            End If

            Return tcase
        End Using
    End Function

    ''' <summary>
    ''' Return all the title cases under given status
    ''' </summary>
    ''' <param name="status">The title status</param>
    ''' <returns>The list of Title Cases</returns>
    Public Shared Function GetAllCases(status As DataStatus) As TitleCase()
        Using ctx As New PortalEntities
            Return ctx.TitleCases.Where(Function(c) c.Status = status Or status = DataStatus.All).ToArray
        End Using
    End Function

    ''' <summary>
    ''' Check if the cases was existed in title
    ''' </summary>
    ''' <param name="bble">The Property BBLE</param>
    ''' <returns></returns>
    Public Shared Function Exists(bble As String) As Boolean
        Using ctx As New PortalEntities
            Return ctx.TitleCases.Any(Function(c) c.BBLE = bble)
        End Using
    End Function

    ''' <summary>
    ''' Return the status of Title
    ''' </summary>
    ''' <param name="bble">The Title Case BBLE</param>
    ''' <returns></returns>
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

    ''' <summary>
    ''' Return the list of title cases under given user and given status
    ''' </summary>
    ''' <param name="userName">The User Name</param>
    ''' <param name="status">The Title Status</param>
    ''' <returns>The List of Title Cases</returns>
    Public Shared Function GetAllCases(userName As String, status As DataStatus) As TitleCase()
        Using ctx As New PortalEntities
            Return ctx.TitleCases.Where(Function(c) c.Owner = userName AndAlso (c.Status = status Or status = DataStatus.All)).ToArray
        End Using
    End Function

    ''' <summary>
    ''' Return the mapping relation between the title category and shortsale category
    ''' </summary>
    ''' <param name="id">The title category id</param>
    ''' <returns>The relation mapping object</returns>
    Public Shared Function LoadSSCategories(id As Integer) As MapTitleShortSaleCategory
        If Not MapTitleShortSaleCategory.Any(Function(m) m.Id = id) Then
            Throw New Exception("Unknow category id: " & id)
        End If

        Return MapTitleShortSaleCategory.Where(Function(a) a.Id = id).SingleOrDefault
    End Function

    ''' <summary>
    ''' Return given user's the list of Title Cases with Title Category and SS Category data 
    ''' </summary>
    ''' <param name="userName">The user name</param>
    ''' <returns></returns>
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

    ''' <summary>
    ''' Return given user's the list of Title Cases with Title Category and SS Category data under given category
    ''' </summary>
    ''' <param name="userName">The user name</param>
    ''' <param name="id">Title Category Id</param>
    ''' <returns></returns>
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

    ''' <summary>
    ''' Return given user's the external cases, which are not in ShortSale
    ''' </summary>
    ''' <param name="userName">The User Name</param>
    ''' <returns>The list of Title Cases</returns>
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

    ''' <summary>
    ''' Return the Titlecase object by business form id
    ''' </summary>
    ''' <param name="formId">The form Id</param>
    ''' <returns>The title case object</returns>
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

    ''' <summary>
    ''' Load the title category and shortsale category data
    ''' </summary>
    Private Sub InitCategory()
        Me.SSCategory = ShortSaleCase.GetCaseCategory(BBLE)
        Me.TitleCategory = GetTitleCategory(SSCategory)
    End Sub

    ''' <summary>
    ''' Save the case data
    ''' </summary>
    ''' <param name="saveBy">The user who save this data</param>
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

    ''' <summary>
    ''' The base override method to save data from FormDataItem
    ''' </summary>
    ''' <param name="itemData">The data in FormDataItem</param>
    ''' <returns>return data tag</returns>
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

    ''' <summary>
    ''' Return title Category by ShortSale Category
    ''' </summary>
    ''' <param name="ssCategory">The ShortSale Category</param>
    ''' <returns>return title category</returns>
    Public Shared Function GetTitleCategory(ssCategory As String) As String
        Return MapTitleShortSaleCategory.Where(Function(m) m.ShortSaleCategories.Contains(ssCategory)).Select(Function(m) m.Category).SingleOrDefault
    End Function

    ''' <summary>
    ''' The list of mapping relation between Title Category and ShortSale Category
    ''' </summary>
    Public Shared MapTitleShortSaleCategory As New List(Of MapTitleShortSaleCategory) From {
            New Data.MapTitleShortSaleCategory() With {.Id = 1, .Category = "Approved", .ShortSaleCategories = {"Approved"}},
            New MapTitleShortSaleCategory() With {.Id = 2, .Category = "Pending Approval", .ShortSaleCategories = {"Offers Review"}},
            New MapTitleShortSaleCategory() With {.Id = 3, .Category = "In Process", .ShortSaleCategories = {"Assign", "Equator", "Homepath", "Processing", "Valuation", "Value Dispute"}},
            New MapTitleShortSaleCategory() With {.Id = 4, .Category = "Held", .ShortSaleCategories = {"Dead", "Evictions", "Held", "Intake", "Litigation", "Pending"}},
            New MapTitleShortSaleCategory() With {.Id = 5, .Category = "Closed", .ShortSaleCategories = {"Closed"}}
        }

    ''' <summary>
    ''' The title data status
    ''' </summary>
    Public Enum DataStatus
        All = -1
        InitialReview = 0
        PendingClearance = 1
        CTC = 2
        Completed = 3
    End Enum

End Class

''' <summary>
''' The map object for relation between Title Category and ShortSale category
''' </summary>
Public Class MapTitleShortSaleCategory
    Public Property Id As Integer
    Public Property Category As String
    Public Property ShortSaleCategories As String()
End Class