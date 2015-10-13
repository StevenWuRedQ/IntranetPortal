Imports System.Data.Entity.Infrastructure
Imports System.Net
Imports System.Web.Http
Imports System.Web.Http.Description
Imports IntranetPortal.Data
Imports System.IO
Imports System.Drawing
Imports System.Net.Http
Imports System.Net.Http.Headers
Imports Newtonsoft.Json.Linq
Imports Newtonsoft.Json
Imports IntranetPortal.Core.ExcelBuilder

Namespace Controllers
    Public Class ConstructionCasesController
        Inherits System.Web.Http.ApiController

        ' GET: api/ConstructionCases
        Function GetConstructionCases() As IQueryable(Of ConstructionCase)
            Return ConstructionManage.GetMyLightCases(User.Identity.Name).AsQueryable
        End Function

        ' GET: api/ConstructionCases/5
        <ResponseType(GetType(ConstructionCase))>
        Function GetConstructionCase(ByVal id As String) As IHttpActionResult
            Dim constructionCase As ConstructionCase = ConstructionManage.GetCase(id, CurrentUser)

            If IsNothing(constructionCase) Then
                Return NotFound()
            End If

            Return Ok(constructionCase)
        End Function

        ' PUT: api/ConstructionCases/5
        <ResponseType(GetType(Void))>
        Function PutConstructionCase(ByVal id As String, ByVal constructionCase As ConstructionCase) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            If Not id = constructionCase.BBLE.Trim Then
                Return BadRequest()
            End If

            Try
                constructionCase.Save(CurrentUser)
            Catch ex As DbUpdateConcurrencyException
                If Not (ConstructionCaseExists(id)) Then
                    Return NotFound()
                Else
                    Throw
                End If
            End Try

            Return StatusCode(HttpStatusCode.NoContent)
        End Function

        ' POST: api/ConstructionCases
        <ResponseType(GetType(ConstructionCase))>
        Function PostConstructionCase(ByVal constructionCase As ConstructionCase) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            Try
                constructionCase.Save(CurrentUser)
            Catch ex As DbUpdateException
                If (ConstructionCaseExists(constructionCase.BBLE)) Then
                    Return Conflict()
                Else
                    Throw
                End If
            End Try

            Return CreatedAtRoute("DefaultApi", New With {.id = constructionCase.BBLE}, constructionCase)
        End Function

        <ResponseType(GetType(Void))>
        <Route("api/ConstructionCases/ChangeStatus/{bble}")>
        Function PostChangeStatus(bble As String, <FromBody> status As ConstructionCase.CaseStatus) As IHttpActionResult
            ConstructionManage.ChnageStatus(bble, status, HttpContext.Current.User.Identity.Name)
            Return StatusCode(HttpStatusCode.NoContent)
        End Function

        ' POST: api/ConstructionCases
        <ResponseType(GetType(String()))>
        <Route("api/ConstructionCases/UploadFiles")>
        Function PostConstructionFiles() As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            Dim results = New List(Of String)
            Dim bble = HttpContext.Current.Request.QueryString("bble")
            Dim fileName = HttpContext.Current.Request.QueryString("fileName")
            Dim fileFoler = HttpContext.Current.Request.QueryString("folder")

            If HttpContext.Current.Request.Files.Count > 0 Then
                For i = 0 To HttpContext.Current.Request.Files.Count - 1
                    Dim file As HttpPostedFile = HttpContext.Current.Request.Files(i)
                    Using ms = New MemoryStream()
                        file.InputStream.CopyTo(ms)

                        Dim folderPath = String.Format("{0}/{1}", bble, "Construction")
                        If Not String.IsNullOrEmpty(fileFoler) Then
                            fileFoler = IIf(fileFoler.Last() = "/", fileFoler.Substring(0, fileFoler.Length - 1), fileFoler)
                            folderPath = folderPath & "/" & fileFoler
                        End If

                        If String.IsNullOrEmpty(fileName) Then
                            Dim fileNameParts = file.FileName.Split("\")
                            fileName = HttpUtility.UrlEncode(fileNameParts(fileNameParts.Length - 1))
                        End If

                        results.Add(Core.DocumentService.UploadFile(folderPath, ms.ToArray, fileName, User.Identity.Name))

                        If (Core.Thumbnail.IsImageFile(file.FileName)) Then
                            Dim image = System.Drawing.Image.FromStream(ms)
                            Dim thumbImg = Core.Thumbnail.FixedSize(image, 50, 50)
                            Using thumbms = New MemoryStream
                                thumbImg.Save(thumbms, image.RawFormat)
                                Dim thumbId = Core.Thumbnail.SaveThumb(Path.GetExtension(file.FileName).ToLower, thumbms.ToArray)
                                results.Add(thumbId)
                            End Using
                        End If
                    End Using

                Next
                Return Ok(results.ToArray)
            End If

            Return BadRequest("Can't find File")
        End Function

        ' DELETE: api/ConstructionCases/5
        <ResponseType(GetType(ConstructionCase))>
        Function DeleteConstructionCase(ByVal id As String) As IHttpActionResult
            Dim constructionCase As ConstructionCase = ConstructionCase.GetCase(id)
            If IsNothing(constructionCase) Then
                Return NotFound()
            End If

            constructionCase.Delete()

            Return Ok(constructionCase)
        End Function

        Private Function ConstructionCaseExists(ByVal id As String) As Boolean
            Return ConstructionCase.Exists(id)
        End Function

        Private Function CurrentUser() As String
            Return RequestContext.Principal.Identity.Name
        End Function

        <Route("api/ConstructionCases/LastLastUpdate/{bble}")>
        <ResponseType(GetType(Void))>
        Function GetLastLastUpdate(bble As String) As IHttpActionResult
            Dim constructionCase As ConstructionCase = ConstructionCase.GetCase(bble)

            If IsNothing(constructionCase) Then
                Return NotFound()
            End If
            Return Ok(constructionCase.LastUpdate)
        End Function

        <Route("api/ConstructionCases/LastModifyUser/{bble}")>
        <ResponseType(GetType(Void))>
        Function GetLastModifyUser(bble As String) As IHttpActionResult
            Dim constructionCase As ConstructionCase = ConstructionCase.GetCase(bble)

            If IsNothing(constructionCase) Then
                Return NotFound()
            End If
            If (constructionCase.UpdateBy = HttpContext.Current.User.Identity.Name) Then
                Return Ok("")
            End If
            Return Ok(constructionCase.UpdateBy)
        End Function

        <Route("api/ConstructionCases/GenerateExcel")>
        Function GenerateExcel(<FromBody> queryString As JToken) As IHttpActionResult

            Dim BBLEToken = queryString.SelectToken("bble")
            Dim DataToken = queryString.SelectToken("updata")
            If Not BBLEToken Is Nothing AndAlso Not DataToken Is Nothing Then
                Dim BBLE = BBLEToken.ToString.Trim
                Dim JData = JsonConvert.DeserializeObject(Of BudgetRow())(DataToken.ToJsonString)
                If Not JData Is Nothing AndAlso Not BBLE Is Nothing Then
                    Dim ccase = Data.ConstructionCase.GetCase(BBLE)
                    If Not ccase Is Nothing Then
                        Dim address = ccase.CaseName
                        Dim owner = User.Identity.Name
                        Dim ms = New MemoryStream
                        Using fs = File.Open(HttpContext.Current.Server.MapPath("~/App_Data/checkrequest.xlsx"), FileMode.OpenOrCreate, FileAccess.ReadWrite)
                            fs.CopyTo(ms)
                        End Using
                        Dim excelbytes = Core.ExcelBuilder.BuildBudgetReport(address, owner, JData, ms)
                        ms.Close()
                        Using tempFile = New FileStream(HttpContext.Current.Server.MapPath("~/TempDataFile/budget.xlsx"), FileMode.OpenOrCreate, FileAccess.ReadWrite)
                            tempFile.Write(excelbytes, 0, excelbytes.Length)
                            Return Ok()
                        End Using
                    End If
                End If
            End If

        End Function

        <Route("api/ConstructionCases/GetGenerateExcel")>
        Function GetGenerateExcel(<FromBody> queryString As JToken) As HttpResponseMessage
            Dim response = New HttpResponseMessage(HttpStatusCode.OK)
            Dim fs = New FileStream(HttpContext.Current.Server.MapPath("~/TempDataFile/budget.xlsx"), FileMode.Open)
            Dim bfs = New BinaryReader(fs).ReadBytes(fs.Length)
            response.Content = New ByteArrayContent(bfs)
            response.Content.Headers.Add("Content-Disposition", "inline; filename=budget.xlsx")
            response.Content.Headers.ContentType = New MediaTypeHeaderValue("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
            response.Content.Headers.ContentLength = bfs.Length
            Return response
        End Function

        <Route("api/ConstructionCases/GetSpotCheckList")>
        Function GetSpotCheckList() As IHttpActionResult
            Dim username = HttpContext.Current.User.Identity.Name.ToString
            Dim list = ConstructionSpotCheck.GetSpotChecks(username)
            Dim result = From x In list
                         Select x.Id, x.propertyAddress
            Return Ok(result.ToArray)
        End Function

        <Route("api/ConstructionCases/GetSpotCheck/{id}")>
        Function GetSpotCheck(ByVal id As Integer) As IHttpActionResult
            Dim result = ConstructionSpotCheck.GetSpotCheck(id)
            Return Ok(result)
        End Function

        <Route("api/ConstructionCases/SaveSpotList")>
        Function SaveSpotList(form As Data.ConstructionSpotCheck) As IHttpActionResult
            ConstructionSpotCheck.UpdateSpotCheck(form)
            Return Ok()
        End Function

        <Route("api/ConstructionCases/FinishSpotList")>
        Function FinishSpotList(form As Data.ConstructionSpotCheck) As IHttpActionResult
            ConstructionSpotCheck.FinishSpotCheck(form)
            ConstructionManage.NotifyWhenSpotCheck(form)
            Return Ok()
        End Function

        <Route("api/ConstructionCases/GetDOBViolations")>
        Function GetDOBViolations(bble As String) As IHttpActionResult
            Dim ld = LeadsInfo.GetInstance(bble)
            Dim violations = Core.WebGrabber.GetDOBViolations(ld.Borough, ld.Block, ld.Lot)
            Return Ok(violations)
        End Function

        <Route("api/ConstructionCases/GetECBViolations")>
        Function GetECBViolations(bble As String) As IHttpActionResult
            Dim ld = LeadsInfo.GetInstance(bble)
            Dim violations = Core.WebGrabber.GetECBViolations(ld.Borough, ld.Block, ld.Lot)
            Return Ok(violations)
        End Function
    End Class
End Namespace
