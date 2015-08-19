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

    'Private _saleDate As DateTime
    'Public ReadOnly Property SaleDate As Date
    '    Get
    '        If (_saleDate Is Nothing) Then

    '        End If
    '        Return _saleDate
    '    End Get
    'End Property
    Public ReadOnly Property LegalStatusString As String
        Get
            If LegalStatus.HasValue Then
                Dim ls As DataStatus = LegalStatus
                Return Core.Utility.GetEnumDescription(ls)
            End If

            Return Nothing
        End Get
    End Property

    Public Sub SaveData(saveBy As String)
        'Refresh data report fields
        RefreshReportFields()

        Using ctx As New LegalModelContainer
            Dim lc = ctx.LegalCases.Find(BBLE)

            If lc Is Nothing Then
                Me.CreateDate = DateTime.Now
                Me.CreateBy = saveBy
                ctx.LegalCases.Add(Me)
            Else
                lc = Core.Utility.SaveChangesObj(lc, Me)
                lc.UpdateBy = saveBy
                lc.UpdateDate = DateTime.Now
            End If

            ctx.SaveChanges()
        End Using

        Core.SystemLog.Log("LegalSave", Newtonsoft.Json.JsonConvert.SerializeObject(Me), Core.SystemLog.LogCategory.SaveData, Me.BBLE, saveBy)
    End Sub

    Private Sub RefreshReportFields()
        Dim jsonCase = Newtonsoft.Json.Linq.JObject.Parse(CaseData)

        If jsonCase IsNot Nothing Then
            Dim caseStatus = jsonCase.Item("CaseStauts")
            Dim result As Integer
            If Integer.TryParse(caseStatus, result) Then
                If result > 0 Then
                    Me.LegalStatus = result
                End If
            End If

            Dim data = jsonCase.Item("SaleDate")
            Dim saleData As DateTime?
            If data IsNot Nothing AndAlso DateTime.TryParse(data.ToString, saleData) Then
                If saleData.HasValue Then
                    Me.SaleDate = saleData
                Else
                    Me.SaleDate = Nothing
                End If
            End If
        End If
    End Sub

    Public Shared Function GetCase(bble As String) As LegalCase
        Using ctx As New LegalModelContainer
            Return ctx.LegalCases.Find(bble)
        End Using
    End Function

    Public Shared Sub UpdateStatus(bble As String, status As LegalCaseStatus, updateBy As String)
        'update legal case status
        Dim lc = GetCase(bble)
        lc.Status = status
        lc.SaveData(updateBy)
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

    Public Shared Function GetFollowUpCases() As List(Of LegalCase)
        Using ctx As New LegalModelContainer
            Return ctx.LegalCases.Where(Function(lc) lc.FollowUp.HasValue).OrderByDescending(Function(lc) lc.FollowUp).ToList
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
    NoAction = 1
    <Description("S&C/LP")>
    SCLP = 2
    <Description("RJI")>
    RJI = 3
    <Description("Settlement Conf")>
    SettlementConf = 4
    <Description("O/REF")>
    OREF = 5
    <Description("Judgment Submitted")>
    JudgmentSubmitted = 10
    <Description("Judgment Granted")>
    JudgmentGranted = 11
    <Description("Judgment Entered")>
    JudgmentEntered = 12
    <Description("Sale Date")>
    SaleDate = 7
    <Description("Dismissed w/ Prejudice")>
    DismissedWithPrejudice = 8
    <Description("Dismissed w/o Prejudice")>
    DismissedWithoutPrejudice = 9
End Enum
