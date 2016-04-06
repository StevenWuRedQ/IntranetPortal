Imports System.IO
Imports System.IO.Compression
Imports Newtonsoft.Json.Linq
Imports Novacode
''' <summary>
''' The action realted to PropertyOffer
''' </summary>
Public Class PropertyOfferManage

    ''' <summary>
    ''' Generate Offer Package
    ''' </summary>
    ''' <param name="bble">The property BBLE</param>
    ''' <param name="data">The offer related data</param>
    ''' <param name="offerDocPath">The offer document path</param>
    ''' <param name="destPath">The destination path</param>
    ''' <returns>Return the filename of generated package</returns>
    Public Shared Function GeneratePackage(bble As String, data As JObject, offerDocPath As String, destPath As String) As String

        Dim path = offerDocPath 'HttpContext.Current.Server.MapPath("~/App_Data/OfferDoc")
        Dim targetPath = destPath & bble ' HttpContext.Current.Server.MapPath("~/TempDataFile/OfferDoc/" & bble)
        Dim zipPath = IO.Path.Combine(destPath, bble & ".zip")

        Try
            Dim generator As New DocumentGenerator(data)
            Dim direcotry = New IO.DirectoryInfo(path)

            If Not Directory.Exists(targetPath) Then
                Directory.CreateDirectory(targetPath)
            End If

            Dim files = direcotry.GetFiles()

            Dim deedType = CType(data.SelectToken("DeadType"), JObject)
            For Each doc In deedType.Properties
                If CBool(deedType.GetValue(doc.Name).ToString) Then
                    Dim config = generator.LoadFileConfigration(doc.Name)
                    Dim f = files.Where(Function(a) a.Name = config.FileName).First

                    Dim finalpath = IO.Path.Combine(targetPath, f.Name)

                    Using d = DocX.Load(f.FullName)
                        generator.GenerateDocument(d, f.Name)
                        d.SaveAs(finalpath)
                    End Using

                End If
            Next

            'For Each f In direcotry.GetFiles()
            '    Dim fname = f.Name
            '    Dim finalpath = IO.Path.Combine(targetPath, fname)

            '    Using d = DocX.Load(f.FullName)

            '        d.ReplaceText("[DAY]", DateTime.Today.ToString())
            '        d.SaveAs(finalpath)
            '    End Using
            'Next
            If File.Exists(zipPath) Then
                File.Delete(zipPath)
            End If

            ZipFile.CreateFromDirectory(targetPath, zipPath)
            Return String.Format("{0}.zip", bble)
        Catch ex As Exception
            Throw ex
        End Try
    End Function


End Class

Public Class DocumentGenerator
    Public Property Data As JObject
    Public Property Path As String

    Public Sub New(data As JObject)
        Me.Data = data
    End Sub

    Public Sub GenerateDocument(doc As DocX, fileName As String)
        Dim phs = LoadFileConfigration(fileName)
        Me.Data = Data

        For Each ph In phs.PlaceHolders
            doc.ReplaceText(String.Format("[{0}]", ph.FieldName), GetValue(ph))
        Next
    End Sub

    Public Function LoadFileConfigration(configName As String) As GenerateFileConfig
        Dim contract = New GenerateFileConfig With {.FileName = "MemorandumOfContract.docx", .ConfigKey = "Memo"}

        Dim phs = {
            New DocumentPlaceHolder("DATE"),
            New DocumentPlaceHolder("MONTH"),
            New DocumentPlaceHolder("YEAR"),
            New DocumentPlaceHolder("SELLERNAMES", Function(data As JObject)
                                                       Dim names = data.SelectToken("DealSheet.ContractOrMemo.Sellers[*].Name")
                                                       Return String.Join(",", names)
                                                   End Function),
           New DocumentPlaceHolder("SELLERADDRESS", "DealSheet.ContractOrMemo.Sellers[0].Address"),
           New DocumentPlaceHolder("BUYERNAME", "DealSheet.ContractOrMemo.Buyer.CorpName"),
           New DocumentPlaceHolder("BUYERADDRESS", "DealSheet.ContractOrMemo.Buyer.Address")
        }

        contract.PlaceHolders = phs.ToList
        Return contract
    End Function

    Public Function GetValue(ph As DocumentPlaceHolder) As String
        Select Case ph.Type
            Case DocumentPlaceHolder.ValueType.Predefined
                Return PredefinedValue(ph.FieldName)
            Case DocumentPlaceHolder.ValueType.JSON
                Return Me.Data.SelectToken(ph.ValueField).ToString
            Case DocumentPlaceHolder.ValueType.FixedString
                Return ph.ValueField
            Case DocumentPlaceHolder.ValueType.Custom
                Return ph.CustomFunction.Invoke(Data)
            Case Else
                Return Nothing
        End Select

    End Function

    Private _predefinedValues As Dictionary(Of String, String)

    Private ReadOnly Property PredefinedValue() As Dictionary(Of String, String)
        Get
            If _predefinedValues Is Nothing Then
                _predefinedValues = New Dictionary(Of String, String)
                Dim td = DateTime.Today
                _predefinedValues.Add("DATE", td.Day)
                _predefinedValues.Add("MONTH", MonthName(td.Month))
                _predefinedValues.Add("YEAR", td.Year)
            End If

            Return _predefinedValues
        End Get
    End Property


End Class

Public Class GenerateFileConfig
    Public Property ConfigKey As String
    Public Property FileName As String
    Public Property PlaceHolders As List(Of DocumentPlaceHolder)


End Class

Public Class DocumentPlaceHolder
    Public Sub New(name As String)
        Me.FieldName = name
        Me.Type = ValueType.Predefined
    End Sub

    Public Sub New(name As String, value As String)
        Me.FieldName = name
        Me.ValueField = value
        Me.Type = ValueType.JSON
    End Sub

    Public Sub New(name As String, value As String, type As ValueType)
        Me.FieldName = name
        Me.ValueField = value
        Me.Type = type
    End Sub

    Public Sub New(name As String, customeFun As Func(Of Object, String))
        Me.FieldName = name
        Me.Type = ValueType.Custom
        Me.CustomFunction = customeFun
    End Sub

    Public Property FieldName As String
    Public Property ValueField As String
    Public Property Type As ValueType
    Public Property CustomFunction As Func(Of Object, String)
    Public Enum ValueType
        JSON
        Predefined
        FixedString
        Custom
    End Enum
End Class