Imports System.ComponentModel.DataAnnotations

<MetadataType(GetType(LeadInfoDocumentSearchCaseMetaData))>
Public Class LeadInfoDocumentSearch
    Public Property ResutContent As String
    Public Property IsSave As Boolean
    Public Shared Function Exist(bble As String) As Boolean
        Using ctx As New IntranetPortalEntities
            Return ctx.LeadInfoDocumentSearches.Find(bble) IsNot Nothing
        End Using
    End Function

    Public Shared Function GetAllSearches() As List(Of LeadInfoDocumentSearch)
        Using ctx As New IntranetPortalEntities
            Return ctx.LeadInfoDocumentSearches.ToList
        End Using
    End Function


    Public Enum SearchStauts
        NewSearch = 0
        Completed = 1
    End Enum
End Class

Public Class LeadInfoDocumentSearchCaseMetaData
    <Newtonsoft.Json.JsonConverter(GetType(Core.JsObjectToStringConverter))>
    Public Property LeadResearch As String
End Class