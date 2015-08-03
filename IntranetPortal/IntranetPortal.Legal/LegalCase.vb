Imports System.ComponentModel


Partial Public Class LegalCase
    Private _stuatsStr As String
    Public ReadOnly Property StuatsStr As String
        Get
            If _stuatsStr Is Nothing Then

                _stuatsStr = CType(Status, LegalCaseStatus).ToString
            End If
            Return _stuatsStr
        End Get
    End Property

    Private _caseStatus As String
    Public ReadOnly Property CaseStatus As String
        Get
            If _caseStatus Is Nothing Then
                Dim mCaseDate = Newtonsoft.Json.Linq.JObject.Parse(CaseData)
                _caseStatus = mCaseDate.Item("CaseStauts")
            End If
            Return _caseStatus
        End Get
    End Property

    Public ReadOnly Property LegalStatusString As String
        Get
            If LegalStatus.HasValue Then
                Dim ls As DataStatus = LegalStatus
                Return Core.Utility.GetEnumDescription(ls)
            End If

            Return Nothing
        End Get
    End Property

    Public Sub SaveData()
        'Refresh data report fields
        RefreshReportFields()

        Using ctx As New LegalModelContainer
            Dim lc = ctx.LegalCases.Find(BBLE)

            If lc Is Nothing Then
                Me.CreateDate = DateTime.Now
                ctx.LegalCases.Add(Me)
            Else
                lc = Core.Utility.SaveChangesObj(lc, Me)
            End If

            ctx.SaveChanges()
        End Using
    End Sub

    Private Sub RefreshReportFields()
        Dim jsonCase = Newtonsoft.Json.Linq.JObject.Parse(CaseData)

        If jsonCase IsNot Nothing Then
            Me.LegalStatus = jsonCase.Item("CaseStauts")
        End If
    End Sub


    Public Shared Function GetCase(bble As String) As LegalCase
        Using ctx As New LegalModelContainer
            Return ctx.LegalCases.Find(bble)
        End Using
    End Function

    Public Shared Sub UpdateStatus(bble As String, status As LegalCaseStatus)
        'update legal case status
        Dim lc = Legal.LegalCase.GetCase(bble)
        lc.Status = status
        lc.SaveData()
    End Sub

    Public Shared Function InLegal(bble As String) As Boolean
        Return LegalCase.GetCase(bble) IsNot Nothing
    End Function

    Public Shared Function GetCaseList(status As LegalCaseStatus) As List(Of LegalCase)
        Using ctx As New LegalModelContainer
            Return ctx.LegalCases.Where(Function(lc) lc.Status = status).ToList
        End Using
    End Function

    Public Shared Function GetAllCases() As List(Of LegalCase)
        Using ctx As New LegalModelContainer
            Return ctx.LegalCases.ToList
        End Using
    End Function

    Public Shared Function GetCaseList(status As LegalCaseStatus, userName As String) As List(Of LegalCase)
        Using ctx As New LegalModelContainer
            Return ctx.LegalCases.Where(Function(lc) lc.Status = status AndAlso (lc.ResearchBy = userName Or lc.Attorney = userName)).ToList
        End Using
    End Function
End Class

Public Enum LegalCaseStatus
    <Description("New Cases")>
    ManagerPreview = 0
    <Description("Research")>
    LegalResearch = 1
    <Description("Review")>
    ManagerAssign = 2
    <Description("In Court")>
    AttorneyHandle = 3
    <Description("Closed")>
    Closed = 4
End Enum

Public Enum DataStatus
    <Description("No current action")>
    NoAction = 0
    <Description("S&C/LP")>
    SCLP = 1
    <Description("RJI")>
    RJI = 2
    <Description("O/REF")>
    OREF = 3
    <Description("Judgement")>
    Judgement = 4
    <Description("Sale Date")>
    SaleDate = 5
    <Description("Dismissed w/ Prejudice")>
    DismissedWithPrejudice = 6
    <Description("Dismissed w/o Prejudice")>
    DismissedWithoutPrejudice = 7
End Enum
