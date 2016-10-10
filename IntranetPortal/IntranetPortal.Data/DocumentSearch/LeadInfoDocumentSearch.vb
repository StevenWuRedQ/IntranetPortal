Imports System.ComponentModel
Imports Humanizer

' <MetadataType(GetType(LeadInfoDocumentSearchCaseMetaData))>

Public Class LeadInfoDocumentSearch
    Public Property ResutContent As String
    Public Property IsSave As Boolean
    Public Property CaseName As String

    ''' <summary>
    ''' Notify roles when updating or completing
    ''' </summary>
    Public Shared ReadOnly NOTIFY_ROLE_WHEN_UPDATING As String = "DocSearch-Updating"
    Public Shared ReadOnly NOTIFY_ROLE_WHEN_COMPLETING As String = "DocSearch-Completing"

    Public Shared ReadOnly EMAIL_TEMPLATE_UPADATING As String = "DocSearchUpdating"
    Public Shared ReadOnly EMAIL_TEMPLATE_COMPLETED As String = "DocSearchCompleted"

    Public Shared Function Exist(bble As String) As Boolean
        Using ctx As New PortalEntities
            Return ctx.LeadInfoDocumentSearches.Find(bble) IsNot Nothing
        End Using
    End Function

    Public Shared Function GetInstance(bble As String) As LeadInfoDocumentSearch
        Using ctx As New PortalEntities
            Return ctx.LeadInfoDocumentSearches.Find(bble)
        End Using
    End Function

    Public Shared Function GetDocumentSearchs() As List(Of LeadInfoDocumentSearch)
        Using ctx As New PortalEntities
            Dim result = From search In ctx.LeadInfoDocumentSearches
                         Join ld In ctx.ShortSaleLeadsInfoes On search.BBLE Equals ld.BBLE
                         Select New With {
               .BBLE = search.BBLE,
               .CaseName = ld.PropertyAddress,
               .ExpectedSigningDate = search.ExpectedSigningDate,
               .CompletedBy = search.CompletedBy,
               .CompletedOn = search.CompletedOn,
               .CreateBy = search.CreateBy,
               .CreateDate = search.CreateDate,
               .Status = search.Status,
               .UpdateBy = search.UpdateBy,
               .UpdateDate = search.UpdateDate,
               .UnderwriteStatus = search.UnderwriteStatus,
                     .UnderwriteCompletedOn = search.UnderwriteCompletedOn
            }

            'Return result.ToList

            Return result.AsEnumerable().Select(Function(search)
                                                    Return New LeadInfoDocumentSearch With {
                                                                   .BBLE = search.BBLE,
                                                                   .CaseName = search.CaseName,
                                                                   .ExpectedSigningDate = search.ExpectedSigningDate,
                                                                   .CompletedBy = search.CompletedBy,
                                                                   .CompletedOn = search.CompletedOn,
                                                                   .CreateBy = search.CreateBy,
                                                                   .CreateDate = search.CreateDate,
                                                                   .Status = search.Status,
                                                                   .UpdateBy = search.UpdateBy,
                                                                   .UpdateDate = search.UpdateDate,
                                                                   .UnderwriteStatus = search.UnderwriteStatus,
                                                                   .UnderwriteCompletedOn = search.UnderwriteCompletedOn
                                                        }
                                                End Function).ToList
        End Using
    End Function

    Public Shared Function GetAllSearches() As List(Of LeadInfoDocumentSearch)
        Using ctx As New PortalEntities
            Return ctx.LeadInfoDocumentSearches.ToList
        End Using
    End Function

    Public Function LoadJudgesearchDoc() As Object
        Dim json = Newtonsoft.Json.Linq.JObject.Parse(LeadResearch)
        Dim judgementDoc = json("judgementSearchDoc")

        If judgementDoc IsNot Nothing Then
            Dim path = judgementDoc("path")
            Dim name = judgementDoc("name")
            If path IsNot Nothing AndAlso Not String.IsNullOrEmpty(path) Then
                Dim file = IntranetPortal.Core.DocumentService.GetPDFContent(path)

                If file IsNot Nothing AndAlso name IsNot Nothing Then
                    Return New With {.Data = file, .Name = name.ToString}
                End If
            End If
        End If

        Return Nothing
    End Function

    ''' <summary>
    ''' Updating doc search
    ''' </summary>
    Public Sub Update(updateBy As String)
        If (String.IsNullOrEmpty(updateBy)) Then
            Throw New Exception("Can not update file with nobody! ")
        End If
        UpdateDate = Date.Now
        Me.UpdateBy = updateBy

    End Sub


    ''' <summary>
    ''' Build email message
    ''' </summary>
    ''' <returns> 
    ''' email data Dictionary of message to use it in Email service send email.
    ''' </returns>
    Public Function buildEmailMessge() As Dictionary(Of String, String)
        If (ResutContent Is Nothing) Then
            Throw New Exception("Can not build email message with out result content")
        End If

        If (String.IsNullOrEmpty(CreateBy)) Then
            Throw New Exception("Can not build mail message when Create By is null")
        End If

        Dim mailData = New Dictionary(Of String, String)

        'mailData.Add("UserName", CreateBy)
        mailData.Add("ResutContent", ResutContent)

        Return mailData
    End Function
    ''' <summary>
    ''' combine status and under write status to one filed
    ''' </summary>
    ''' <returns></returns>
    Public Function GetUnderWritingStatus() As Integer
        Dim reslut = 0
        ' last 8 bit is search status
        ' last 9-16 bit is under writing status
        reslut = Status << 8 Or UnderwriteStatus

        Return Status
    End Function

    ''' <summary>
    ''' check combined under writing status
    ''' </summary>
    ''' <param name="m_status">under write status</param>
    ''' <returns></returns>
    Public Function isUnderWritingStatus(m_status As UnderWriterStatus) As Boolean
        Dim s = CType(m_status, Integer)

        If (s >= 2) Then
            If (UnderwriteStatus IsNot Nothing) Then
                Return UnderwriteStatus = s - 2
            Else
                Return False
            End If
        End If
        Return s = Me.Status
    End Function

    ''' <summary>
    ''' Submit new search
    ''' </summary>
    ''' <param name="submitBy"></param>
    Public Sub SubmitSearch(submitBy As String)
        Status = SearchStatus.NewSearch
        CreateDate = Date.Now
        CreateBy = submitBy
        ' As deploy 8/18/2016 open new version switch
        Version = 1
    End Sub

    ''' <summary>
    ''' Check if need notify user when need search
    ''' 1. Before completed no need send notify
    ''' 2. after completed when saving send notify to 
    ''' user in rule
    ''' <todo>
    ''' this function should be private or p not for unit test 
    ''' I doing it for public.
    ''' </todo>
    ''' </summary>
    ''' <returns>
    ''' ture if this case need to
    ''' </returns>
    Public Function isNeedNotifyWhenSaving() As Boolean
        Return Status = SearchStatus.Completed
    End Function
    Public Sub Save()
        Using ctx As New PortalEntities
            If ctx.LeadInfoDocumentSearches.Find(BBLE) IsNot Nothing Then
                ctx.Entry(Me).State = Entity.EntityState.Modified
            Else
                ctx.LeadInfoDocumentSearches.Add(Me)
            End If
            ctx.SaveChanges()
        End Using
    End Sub

    Public Enum SearchStatus
        NewSearch = 0
        Completed = 1
    End Enum


    ' should move this to UnderWriter class
    Public Enum UnderWriterStatus
        <Description("New Search")>
        PendingSearch = 0
        <Description("Completed Search")>
        CompletedSearch = 1
        <Description("Pending Underwriting")>
        PendingUnderwriting = 2
        <Description("Completed Underwriting")>
        CompletedUnderwriting = 3
        <Description("Rejected Underwriting")>
        RejectUnderwriting = 4
    End Enum

    ' duck type type converting to underwriter type
    Public Shared Function CUnderWriterStatus(Of InputT)(obj As InputT, lambda As Func(Of InputT, UnderWriterStatus)) As UnderWriterStatus
        If obj Is Nothing Then
            Throw New Exception("can not covert to underwriter status with empty object")
        End If
        Return lambda(obj)
    End Function

    Public ReadOnly Property MUnderWritingStatus() As UnderWriterStatus
        Get
            Return CUnderWriterStatus(Me, Function(x)

                                              If (x.UnderwriteStatus = 0) Then
                                                  Return UnderWriterStatus.PendingUnderwriting
                                              End If
                                              If (x.UnderwriteStatus = 1) Then
                                                  Return UnderWriterStatus.CompletedUnderwriting
                                              End If
                                              If (x.UnderwriteStatus = 2) Then
                                                  Return UnderWriterStatus.RejectUnderwriting
                                              End If

                                              If x.Status = SearchStatus.NewSearch Then
                                                  Return UnderWriterStatus.PendingSearch
                                              End If

                                              If (x.Status = SearchStatus.Completed) Then
                                                  Return UnderWriterStatus.CompletedSearch
                                              End If


                                              Return UnderWriterStatus.PendingSearch

                                          End Function)
        End Get
    End Property


    ''' <summary>
    ''' get under writing status
    ''' </summary>
    ''' <param name="status">under writing status</param>
    ''' <returns> list of doc search</returns>
    Public Shared Function GetByUnerWritingStatus(status As UnderWriterStatus) As List(Of LeadInfoDocumentSearch)
        ' Query need  optimization if search is big table

        Dim searches = GetDocumentSearchs()
        If (searches IsNot Nothing) Then
            Return searches.ToList().Where(Function(s) s.isUnderWritingStatus(status)).ToList
        End If
        Return Nothing
    End Function
    Public Shared Function MarkCompletedUnderwriting(BBLE As String, User As String, Status As Integer) As LeadInfoDocumentSearch
        Using ctx As New PortalEntities
            Dim search = ctx.LeadInfoDocumentSearches.Find(BBLE)
            If Nothing IsNot search Then
                search.UnderwriteCompletedBy = User
                search.UnderwriteCompletedOn = Date.Now
                search.UnderwriteStatus = CInt(Status)
                ctx.SaveChanges()
                Return search
            Else
                Return Nothing
            End If
        End Using
    End Function

End Class

Public Class LeadInfoDocumentSearchCaseMetaData
    <Newtonsoft.Json.JsonConverter(GetType(Core.JsObjectToStringConverter))>
    Public Property LeadResearch As String
End Class