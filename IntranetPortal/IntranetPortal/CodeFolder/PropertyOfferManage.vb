Imports System.IO
Imports System.IO.Compression
Imports Newtonsoft.Json.Linq
Imports Novacode
Imports IntranetPortal.Data
Imports iTextSharp.text.pdf

''' <summary>
''' The action realted to PropertyOffer
''' </summary>
Public Class PropertyOfferManage

    ''' <summary>
    ''' Check the pre conditions for new offer
    ''' </summary>
    ''' <param name="bble">The property BBLE</param>
    ''' <returns></returns>
    Public Shared Function CheckPreConditions(bble As String) As Boolean
        Dim record = PreSignRecord.GetInstanceByBBLE(bble)
        If record Is Nothing Then
            Return False
        End If

        If record.NeedSearch Then
            Dim search = LeadInfoDocumentSearch.GetInstance(bble)
            If search Is Nothing Then
                Return False
            End If

            If search.Status <> LeadInfoDocumentSearch.SearchStauts.Completed Then
                Return False
            End If
        End If

        Return True
    End Function

    ''' <summary>
    ''' Check the pre conditions for new offer
    ''' </summary>
    ''' <param name="bble">The property BBLE</param>
    ''' <returns></returns>
    Public Shared Function CheckOfferIsReady(bble As String) As Boolean
        Dim record = PreSignRecord.GetInstanceByBBLE(bble)
        If record Is Nothing Then
            Return False
        End If

        If record.NeedSearch Then
            Dim search = LeadInfoDocumentSearch.GetInstance(bble)
            If search Is Nothing Then
                Return False
            End If

            If search.Status <> LeadInfoDocumentSearch.SearchStauts.Completed Then
                Return False
            End If
        End If

        Return True
    End Function

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
            Dim generator As New DocumentGenerator(data, bble)
            Dim direcotry = New IO.DirectoryInfo(path)

            If Not Directory.Exists(targetPath) Then
                Directory.CreateDirectory(targetPath)
            End If

            Dim files = direcotry.GetFiles()

            Dim deedType = CType(data.SelectToken("DeadType"), JObject)
            For Each doc In deedType.Properties
                If CBool(deedType.GetValue(doc.Name).ToString) Then
                    Dim config = generator.LoadFileConfigration(doc.Name)
                    If config IsNot Nothing Then
                        Dim f = files.Where(Function(a) a.Name = config.FileName).First

                        Dim finalpath = IO.Path.Combine(targetPath, f.Name)

                        Select Case config.Type
                            Case GenerateFileConfig.FileType.Word
                                Using d = DocX.Load(f.FullName)
                                    generator.GenerateDocument(d, config)
                                    d.SaveAs(finalpath)
                                End Using
                            Case GenerateFileConfig.FileType.Pdf
                                Dim pdfReader As New PdfReader(f.FullName)
                                Dim pdfNewFile = New PdfStamper(pdfReader, New FileStream(finalpath, FileMode.Create))

                                Dim pdfFormFields = pdfNewFile.AcroFields
                                generator.GeneratePdf(pdfFormFields, config)
                                pdfNewFile.FormFlattening = False
                                pdfNewFile.Close()
                        End Select
                    End If
                End If
            Next

            If File.Exists(zipPath) Then
                File.Delete(zipPath)
            End If

            ZipFile.CreateFromDirectory(targetPath, zipPath)

            If Directory.Exists(targetPath) Then
                For Each file In Directory.GetFiles(targetPath)
                    System.IO.File.SetAttributes(file, FileAttributes.Normal)
                    System.IO.File.Delete(file)
                Next
                Directory.Delete(targetPath, True)
            End If

            Return String.Format("{0}.zip", bble)
        Catch ex As Exception
            Throw ex
        End Try
    End Function
End Class

Public Class DocumentGenerator
    Public Property Data As JObject
    Public Property Path As String
    Public Property BBLE As String

    Public Sub New(data As JObject, bble As String)
        Me.Data = data
        Me.BBLE = bble
    End Sub

    Public Sub GeneratePdf(pdfFormFields As AcroFields, config As GenerateFileConfig)
        For Each ph In config.PlaceHolders
            pdfFormFields.SetField(ph.FieldName, GetValue(ph))
        Next
    End Sub

    Public Sub GenerateDocument(doc As DocX, config As GenerateFileConfig)
        Me.Data = Data

        For Each ph In config.PlaceHolders
            doc.ReplaceText(String.Format("[{0}]", ph.FieldName), GetValue(ph))
        Next
    End Sub

    Public Function LoadFileConfigration(configName As String) As GenerateFileConfig
        If _fileConfigures Is Nothing Then
            InitConfigures()
        End If

        Dim config = _fileConfigures.Where(Function(fc) fc.ConfigKey = configName).SingleOrDefault

        Return config
    End Function

    Private Shared _fileConfigures As List(Of GenerateFileConfig)

    Private Sub InitConfigures()
        If _fileConfigures IsNot Nothing Then
            Return
        End If

        _fileConfigures = New List(Of GenerateFileConfig)

        'Memo
        Dim file = New GenerateFileConfig With {.FileName = "MemorandumOfContract.docx", .ConfigKey = "Memo"}
        Dim phs = {
            New DocumentPlaceHolder("DAY"),
            New DocumentPlaceHolder("MONTH"),
            New DocumentPlaceHolder("YEAR"),
            New DocumentPlaceHolder("DATE"),
            New DocumentPlaceHolder("PROPERTYADDRESS", "PropertyAddress"),
            New DocumentPlaceHolder("BLOCK"),
            New DocumentPlaceHolder("LOT"),
            New DocumentPlaceHolder("SELLERNAMES", Function(data As JObject)
                                                       Dim names = data.SelectToken("DealSheet.ContractOrMemo.Sellers").Select(Function(s) s.SelectToken("Name").ToString).Where(Function(s) Not String.IsNullOrEmpty(s)).ToArray
                                                       Return String.Join(" & ", names)
                                                   End Function),
           New DocumentPlaceHolder("SELLER1NAME", "DealSheet.ContractOrMemo.Sellers[0].Name"),
           New DocumentPlaceHolder("SELLERADDRESS", "DealSheet.ContractOrMemo.Sellers[0].Address"),
           New DocumentPlaceHolder("BUYERNAME", "DealSheet.ContractOrMemo.Buyer.CorpName"),
           New DocumentPlaceHolder("BUYERNAMESIGNER", Function(data As JObject)
                                                          Dim result = data.SelectToken("DealSheet.ContractOrMemo.Buyer.CorpName")

                                                          If result IsNot Nothing Then

                                                              Dim signer = data.SelectToken("DealSheet.ContractOrMemo.Buyer.Signer")
                                                              If signer IsNot Nothing Then
                                                                  Return String.Format("{0} by {1}", result.ToString, signer.ToString)
                                                              End If

                                                              Return result.ToString
                                                          End If

                                                          Return ""
                                                      End Function),
           New DocumentPlaceHolder("BUYERADDRESS", "DealSheet.ContractOrMemo.Buyer.Address")
        }
        file.PlaceHolders = phs.ToList
        _fileConfigures.Add(file)

        ' Sales Contract
        file = New GenerateFileConfig With {.FileName = "SalesContract.docx", .ConfigKey = "Contract"}
        file.PlaceHolders = phs.ToList
        file.PlaceHolders.Add(New DocumentPlaceHolder("CONTRACTPRICE", Function(data As JObject)
                                                                           Dim contractPrice = data.SelectToken("DealSheet.ContractOrMemo.contractPrice")
                                                                           If contractPrice IsNot Nothing Then
                                                                               Dim price = 0
                                                                               If Decimal.TryParse(contractPrice, price) Then
                                                                                   Return String.Format("{0:N2}", price)
                                                                               End If
                                                                           End If
                                                                           Return ""
                                                                       End Function))
        file.PlaceHolders.Add(New DocumentPlaceHolder("DOWNPAYMENT", Function(data As JObject)
                                                                         Dim downPayment = data.SelectToken("DealSheet.ContractOrMemo.downPayment")
                                                                         If downPayment IsNot Nothing Then
                                                                             Dim price = 0
                                                                             If Decimal.TryParse(downPayment, price) Then
                                                                                 Return String.Format("{0:N2}", price)
                                                                             End If
                                                                         End If
                                                                         Return ""
                                                                     End Function))
        file.PlaceHolders.Add(New DocumentPlaceHolder("BALANCE", Function(data As JObject)
                                                                     Dim contractPrice = data.SelectToken("DealSheet.ContractOrMemo.contractPrice")
                                                                     Dim downPayment = data.SelectToken("DealSheet.ContractOrMemo.downPayment")
                                                                     If contractPrice IsNot Nothing AndAlso downPayment IsNot Nothing Then
                                                                         Dim balance = CDec(contractPrice) - CDec(downPayment)
                                                                         Return String.Format("{0:N2}", balance)
                                                                     End If

                                                                     Return ""
                                                                 End Function))
        file.PlaceHolders.Add(New DocumentPlaceHolder("SELLER2NAME", "DealSheet.ContractOrMemo.Sellers[1].Name"))
        file.PlaceHolders.Add(New DocumentPlaceHolder("SELLER3NAME", "DealSheet.ContractOrMemo.Sellers[2].Name"))
        file.PlaceHolders.Add(New DocumentPlaceHolder("SELLERATTORNEY", "DealSheet.ContractOrMemo.Sellers[0].sellerAttorneyObj.Name"))
        file.PlaceHolders.Add(New DocumentPlaceHolder("SELLERATTORNEYADDRESS", "DealSheet.ContractOrMemo.Sellers[0].sellerAttorneyObj.Office"))
        file.PlaceHolders.Add(New DocumentPlaceHolder("SELLERATTORNEYTEL", "DealSheet.ContractOrMemo.Sellers[0].sellerAttorneyObj.OfficeNO"))
        file.PlaceHolders.Add(New DocumentPlaceHolder("SELLERATTORNEYFAX", "DealSheet.ContractOrMemo.Sellers[0].sellerAttorneyObj.Fax"))

        file.PlaceHolders.Add(New DocumentPlaceHolder("BUYERATTORNEY", "DealSheet.ContractOrMemo.Buyer.buyerAttorneyObj.Name"))
        file.PlaceHolders.Add(New DocumentPlaceHolder("BUYERATTORNEYADDRESS", "DealSheet.ContractOrMemo.Buyer.buyerAttorneyObj.Office"))
        file.PlaceHolders.Add(New DocumentPlaceHolder("BUYERATTORNEYTEL", "DealSheet.ContractOrMemo.Buyer.buyerAttorneyObj.OfficeNO"))
        file.PlaceHolders.Add(New DocumentPlaceHolder("BUYERATTORNEYFAX", "DealSheet.ContractOrMemo.Buyer.buyerAttorneyObj.Fax"))
        _fileConfigures.Add(file)

        'Deed 
        file = New GenerateFileConfig With {.FileName = "BargainandSaleDeedwithCovenants.docx", .ConfigKey = "Deed"}
        phs = {
            New DocumentPlaceHolder("DAY"),
            New DocumentPlaceHolder("MONTH"),
            New DocumentPlaceHolder("YEAR"),
            New DocumentPlaceHolder("BLOCK"),
            New DocumentPlaceHolder("LOT"),
            New DocumentPlaceHolder("SELLERNAMES", Function(data As JObject)
                                                       Dim names = data.SelectToken("DealSheet.Deed.Sellers").Select(Function(s) s.SelectToken("Name").ToString).Where(Function(s) Not String.IsNullOrEmpty(s)).ToArray
                                                       Return String.Join(" & ", names)
                                                   End Function),
            New DocumentPlaceHolder("SELLERADDRESS", "DealSheet.Deed.Sellers[0].Address"),
            New DocumentPlaceHolder("BUYERNAME", "DealSheet.Deed.Buyer.CorpName"),
            New DocumentPlaceHolder("BUYERADDRESS", "DealSheet.Deed.Buyer.Address"),
            New DocumentPlaceHolder("PROPERTYADDRESS", "DealSheet.Deed.PropertyAddress"),
            New DocumentPlaceHolder("SELLER1NAME", "DealSheet.Deed.Sellers[0].Name"),
            New DocumentPlaceHolder("SELLER2NAME", "DealSheet.Deed.Sellers[1].Name")
            }
        file.PlaceHolders = phs.ToList
        _fileConfigures.Add(file)

        'Correction deed
        file = New GenerateFileConfig With {.FileName = "SaleDeedwithCovenantsCorrection.docx", .ConfigKey = "CorrectionDeed"}
        phs = {
            New DocumentPlaceHolder("DAY"),
            New DocumentPlaceHolder("MONTH"),
            New DocumentPlaceHolder("YEAR"),
            New DocumentPlaceHolder("BLOCK"),
            New DocumentPlaceHolder("LOT"),
            New DocumentPlaceHolder("SELLERNAMES", Function(data As JObject)
                                                       Dim names = data.SelectToken("DealSheet.CorrectionDeed.Sellers").Select(Function(s) s.SelectToken("Name").ToString).Where(Function(s) Not String.IsNullOrEmpty(s)).ToArray
                                                       Return String.Join(" & ", names)
                                                   End Function),
            New DocumentPlaceHolder("SELLERADDRESS", "DealSheet.CorrectionDeed.Sellers[0].Address"),
            New DocumentPlaceHolder("BUYERNAME", "DealSheet.CorrectionDeed.Buyers[0].Name"),
            New DocumentPlaceHolder("BUYERADDRESS", "DealSheet.CorrectionDeed.Buyers[0].Address"),
            New DocumentPlaceHolder("PROPERTYADDRESS", "DealSheet.CorrectionDeed.PropertyAddress"),
            New DocumentPlaceHolder("SELLER1NAME", "DealSheet.CorrectionDeed.Sellers[0].Name"),
            New DocumentPlaceHolder("SELLER2NAME", "DealSheet.CorrectionDeed.Sellers[1].Name")
            }
        file.PlaceHolders = phs.ToList
        _fileConfigures.Add(file)

        ' POA File
        file = New GenerateFileConfig With {.FileName = "PowerofAttorney.docx", .ConfigKey = "POA"}
        phs = {
                New DocumentPlaceHolder("DAY"),
                New DocumentPlaceHolder("MONTH"),
                New DocumentPlaceHolder("GIVINGPOANAME", "DealSheet.GivingPOA.Name"),
                New DocumentPlaceHolder("GIVINGPOAADDRESS", "DealSheet.GivingPOA.Address"),
                New DocumentPlaceHolder("RECEIVINGPOANAME", "DealSheet.ReceivingPOA.name"),
                New DocumentPlaceHolder("RECEIVINGPOAADDRESS", "DealSheet.ReceivingPOA.address")
            }
        file.PlaceHolders = phs.ToList
        _fileConfigures.Add(file)

        ' ShortSale Package
        'file = New GenerateFileConfig With {.FileName = "ShortSalePackage.pdf", .ConfigKey = "ShortSalePackage", .Type = GenerateFileConfig.FileType.Pdf}
        'phs = {
        '       New DocumentPlaceHolder("Property Address", "PropertyAddress")
        '    }
        'file.PlaceHolders = phs.ToList

        '_fileConfigures.Add(file)

        ' Client info
        file = New GenerateFileConfig With {.FileName = "ClientInfo.docx", .ConfigKey = "ClientInfo"}
        phs = {
                New DocumentPlaceHolder("PROPERTYADDRESS", "PropertyAddress"),
                New DocumentPlaceHolder("SELLER1NAME", "DealSheet.ContractOrMemo.Sellers[0].Name"),
                New DocumentPlaceHolder("SELLERADDRESS", "DealSheet.ContractOrMemo.Sellers[0].Address"),
                New DocumentPlaceHolder("OWNEREMAIL", "DealSheet.ContractOrMemo.Sellers[0].Email")
            }
        file.PlaceHolders = phs.ToList
        _fileConfigures.Add(file)

    End Sub

    Public Function GetValue(ph As DocumentPlaceHolder) As String
        Select Case ph.Type
            Case DocumentPlaceHolder.ValueType.Predefined
                Return PredefinedValue(ph.FieldName)
            Case DocumentPlaceHolder.ValueType.JSON
                Dim field = Me.Data.SelectToken(ph.ValueField)
                If field IsNot Nothing Then
                    Return field.ToString
                End If

                Return ""
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
                _predefinedValues.Add("DAY", td.Day)
                _predefinedValues.Add("MONTH", MonthName(td.Month))
                _predefinedValues.Add("YEAR", td.Year)
                _predefinedValues.Add("DATE", String.Format("{0:M}", td))
                _predefinedValues.Add("TODAY", String.Format("{0:d}", td))

                If Not String.IsNullOrEmpty(BBLE) Then

                    Dim li = LeadsInfo.GetInstance(BBLE)
                    If li IsNot Nothing Then
                        _predefinedValues.Add("BLOCK", li.Block)
                        _predefinedValues.Add("LOT", li.Lot)
                    End If
                End If
            End If

            Return _predefinedValues
        End Get
    End Property

End Class

Public Class GenerateFileConfig
    Public Property ConfigKey As String
    Public Property FileName As String
    Public Property PlaceHolders As List(Of DocumentPlaceHolder)
    Public Property TagData As String
    Public Property Type As FileType

    Public Enum FileType
        Word
        Pdf
    End Enum
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
    Public Property ValueFormat As String

    Public Property Type As ValueType
    Public Property CustomFunction As Func(Of Object, String)
    Public Enum ValueType
        JSON
        Predefined
        FixedString
        Custom
    End Enum
End Class