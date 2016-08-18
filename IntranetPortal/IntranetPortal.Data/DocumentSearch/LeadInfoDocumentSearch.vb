Imports System.ComponentModel.DataAnnotations

<MetadataType(GetType(LeadInfoDocumentSearchCaseMetaData))>
Public Class LeadInfoDocumentSearch
    Public Property ResutContent As String
    Public Property IsSave As Boolean
    Public Property CaseName As String

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
                         Select search, ld.PropertyAddress
            'New With {
            '   .BBLE = search.BBLE,
            '   .CaseName = ld.PropertyAddress,
            '   .ExpectedSigningDate = search.ExpectedSigningDate,
            '   .CompletedBy = search.CompletedBy,
            '   .CompletedOn = search.CompletedOn,
            '   .CreateBy = search.CreateBy,
            '   .CreateDate = search.CreateDate,
            '   .LeadResearch = search.LeadResearch,
            '   .Status = search.Status,
            '   .UpdateBy = search.UpdateBy,
            '   .UpdateDate = search.UpdateDate
            '}

            'Return result.ToList

            Return result.AsEnumerable().Select(Function(data)
                                                    data.search.CaseName = data.PropertyAddress
                                                    Return data.search
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
End Class

Public Class LeadInfoDocumentSearchCaseMetaData
    <Newtonsoft.Json.JsonConverter(GetType(Core.JsObjectToStringConverter))>
    Public Property LeadResearch As String
End Class