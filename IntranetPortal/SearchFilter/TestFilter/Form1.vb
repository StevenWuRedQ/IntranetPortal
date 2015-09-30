Imports System.Windows.Forms

Imports System.Threading
Imports SearchFilter
Imports System.Reflection

Public Class Form1
    Inherits Form

    Private Sub New()

        ' This call is required by the designer.
        InitializeComponent()


        'FilterLogic.ClearAfterLps()

        ' Add any initialization after the InitializeComponent() call.

    End Sub
    Sub RunTest()
        ' Dim testBBLE = New String() '{"4016990058", "3016090015", "3015680031"}
        Using ctx As New RonEntities
            'testBBLE.Select(Function(s) New With {.BBLE = s, .IsSoldByLPUser = FilterLogic.LPSoldPortry(s)}).toList()

            Dim testBBLE = FilterLogic.GetTestBBLEs() 'ctx.ALL_NYC_Tax_Liens_CO_Info.Where(Function(l) l.NeedCollection).Select(Function(l) l.BBLE).Distinct().ToArray() 'FilterLogic.GetTestBBLEs() 'ctx.SearchResultMayInfoes.Select(Function(f) f.BBLE).Distinct().ToArray()

            Dim runed = 0
            Dim runedBBLEs = New List(Of String)()
            Dim LpInfoList = New List(Of FilterLogic.LPinfo)()
            Dim action As Action = Function() UpdataUI(testBBLE.Count(), runed, runedBBLEs, Nothing)


            For Each rBBEL In testBBLE
                Dim lpIf = New FilterLogic.LPinfo()
                FilterLogic.LPSoldPortry(rBBEL, lpIf)
                FilterLogic.LpReFiled(rBBEL)
                runedBBLEs.Add(rBBEL)
                LpInfoList.Add(lpIf)

                If runed Mod 100 = 0 Then
                    Me.Invoke(action)
                End If

                runed = runed + 1
                If (runed >= testBBLE.Count - 1) Then
                    If (LpInfoList.Count > 0) Then
                        Me.Invoke(action)

                    End If

                End If
            Next
            'testBBLE.Select(Function(s) New With {.BBLE = s, .IsSoldByLPUser = FilterLogic.LPSoldPortry(s)}).toList()





        End Using
    End Sub

    Function UpdataUI(needRun As Integer, runed As Integer, runedBblEs As List(Of String), lpInfoList As List(Of FilterLogic.LPinfo)) As Boolean
        TextBox1.Text = "" & runed & "/" & needRun
        If (runedBblEs Is Nothing) Then
            DataGridView1.DataSource = If(lpInfoList IsNot Nothing, lpInfoList, FilterLogic.GetTestReslut(Nothing))
        Else

            DataGridView1.DataSource = If(lpInfoList IsNot Nothing, lpInfoList, FilterLogic.GetTestReslut(runedBblEs.ToArray()))
        End If

        runedBblEs.Clear()
        Return True
    End Function
    Public Shared Sub Main()
        Application.Run(New Form1)
    End Sub


    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        If (String.IsNullOrEmpty(SearchName.Text)) Then
            MsgBox("please fill the Search Name")
            Return
        End If
        lbTransferStatus.Text = "Start transfer"
        Dim resluts = New List(Of SearchResult)
        Using cxt As New RonEntities
            Dim search_view = cxt.SearchResluts_View.ToList()

            For Each v In search_view
                Dim s As SearchResult = New SearchResult
                s.LeadsName = v.LeadsName
                s.MotgCombo = v.MotgCombo
                s.Neigh_Name = v.NEIGH_NAME
                s.CLass = v.CLASS
                s.ORIG_SQFT = v.ORIG_SQFT
                s.LOT_DIM = v.LOT_DIM
                s.Servicer = v.Servicer
                s.TaxCombo = v.TaxCombo
                s.Type = v.Type
                s.ImportDate = v.ImportDate
                s.PropertyAddress = v.PropertyAddress
                s.BLOCK = v.BLOCK
                s.LOT = v.LOT
                s.BBLE = v.BBLE
                If (Not String.IsNullOrEmpty(SearchName.Text)) Then
                    s.Type = SearchName.Text
                End If
                resluts.Add(s)
            Next
            FilterLogic.Transfer2SearchReslut(resluts)
        End Using
        lbTransferStatus.Text = "End Transfer " & resluts.Count & " Leads "
    End Sub

    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        Dim t = New Thread(AddressOf Me.RunTest)
        t.Start()
        Me.Text = "Test Filter"
    End Sub

    Private Sub Filiter2_Click(sender As Object, e As EventArgs) Handles Filiter2.Click
        Dim testBBLE = FilterLogic.GetTestBBLEs() 'ctx.ALL_NYC_Tax_Liens_CO_Info.Where(Function(l) l.NeedCollection).Select(Function(l) l.BBLE).Distinct().ToArray() 'FilterLogic.GetTestBBLEs() 'ctx.SearchResultMayInfoes.Select(Function(f) f.BBLE).Distinct().ToArray()

        Dim runed = 0
        Dim runedBBLEs = New List(Of String)
        Dim LpInfoList = New List(Of FilterLogic.LPinfo)
        For Each rBBEL In testBBLE
            Dim lpIf = New FilterLogic.LPinfo()
            FilterLogic.LPSoldPortry(rBBEL, lpIf)
            LpInfoList.Add(lpIf)
        Next
        DataGridView2.DataSource = LpInfoList
    End Sub

    Private Sub DataGridView1_CellContentClick(sender As Object, e As DataGridViewCellEventArgs) Handles DataGridView1.CellContentClick

    End Sub

    Private Sub GridControl1_Click(sender As Object, e As EventArgs)

    End Sub

    Private Sub DataGridView2_CellContentClick(sender As Object, e As DataGridViewCellEventArgs) Handles DataGridView2.CellContentClick

    End Sub
End Class
