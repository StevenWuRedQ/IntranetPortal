Imports System.IO
Imports System.IO.Compression
Imports Newtonsoft.Json.Linq
Imports Novacode
''' <summary>
''' The action realted to PropertyOffer
''' </summary>
Public Class PropertyOfferManage

    Public Shared Function GeneratePackage(bble As String, data As JObject) As String

        Dim path = HttpContext.Current.Server.MapPath("~/App_Data/OfferDoc")
        Dim targetpath = HttpContext.Current.Server.MapPath("~/TempDataFile/OfferDoc/" & bble)
        Dim zipPath = IO.Path.Combine(HttpContext.Current.Server.MapPath("~/TempDataFile/OfferDoc"), bble & ".zip")

        Try
            Dim direcotry = New IO.DirectoryInfo(path)

            If Not Directory.Exists(targetpath) Then
                Directory.CreateDirectory(targetpath)
            End If

            For Each f In direcotry.GetFiles()
                Dim fname = f.Name
                Dim finalpath = IO.Path.Combine(targetpath, fname)

                Using d = DocX.Load(f.FullName)

                    d.ReplaceText("[DAY]", DateTime.Today.ToString())


                    d.SaveAs(finalpath)
                End Using
            Next
            If File.Exists(zipPath) Then
                File.Delete(zipPath)
            End If

            ZipFile.CreateFromDirectory(targetpath, zipPath)
            Return String.Format("/TempDataFile/OfferDoc/{0}.zip", bble)
        Catch ex As Exception
            Return ""
        End Try

    End Function

End Class
