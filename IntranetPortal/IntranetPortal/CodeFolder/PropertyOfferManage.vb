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
            Return String.Format("{0}.zip", bble)
        Catch ex As Exception
            Throw ex
        End Try
    End Function

End Class
