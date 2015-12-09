Imports System.IO
Imports System.Drawing
Imports System.Drawing.Drawing2D

Partial Public Class Thumbnail
    Public Shared Function IsImageFile(FileName As String) As Boolean

        Dim extList = {".jpg", ".jpeg", ".png", ".bmp", ".gif"}
        Dim ext = Path.GetExtension(FileName).ToLower
        If extList.Contains(ext) Then
            Return True
        Else
            Return False
        End If

    End Function


    Public Shared Function SaveThumb(fileType As String, binary As Byte()) As String
        Using ctx As New CoreEntities
            Dim thumb = New Core.Thumbnail
            Select Case fileType
                Case ".jpg"
                    thumb.mime_type = "image/jpeg"
                Case ".jpeg"
                    thumb.mime_type = "image/jpeg"
                Case ".png"
                    thumb.mime_type = "image/png"
                Case ".bmp"
                    thumb.mime_type = "image/bmp"
                Case ".gif"
                    thumb.mime_type = "image/gif"
                Case Else
                    thumb.mime_type = ""
            End Select
            thumb.content = binary
            ctx.Thumbnails.Add(thumb)
            ctx.SaveChanges()
            Return thumb.id
        End Using
    End Function

    Public Shared Function GetThumb(Id As Integer) As Byte()
        Using ctx As New CoreEntities
            Dim thumb = ctx.Thumbnails.Where(Function(t) t.id = Id).FirstOrDefault
            Return thumb.content
        End Using
    End Function

    Public Shared Function FixedSize(imgPhoto As Image, width As Integer, height As Integer) As Image

        Dim sourceWidth = imgPhoto.Width
        Dim sourceHeight = imgPhoto.Height
        Dim sourceX = 0
        Dim sourceY = 0
        Dim destX = 0
        Dim destY = 0

        Dim nPercent = 0.0
        Dim nPercentW = (CDbl(width) / CDbl(sourceWidth))
        Dim nPercentH = (CDbl(height) / CDbl(sourceHeight))

        If (nPercentH < nPercentW) Then
            nPercent = nPercentH
            destX = System.Convert.ToInt16((width - (sourceWidth * nPercent)) / 2)

        Else
            nPercent = nPercentW
            destY = System.Convert.ToInt16((height - (sourceHeight * nPercent)) / 2)
        End If


        Dim destWidth = CInt(sourceWidth * nPercent)
        Dim destHeight = CInt(sourceHeight * nPercent)

        Dim bmPhoto = New Bitmap(width, height)
        bmPhoto.SetResolution(imgPhoto.HorizontalResolution, imgPhoto.VerticalResolution)
        Dim grPhoto = Graphics.FromImage(bmPhoto)
        grPhoto.Clear(Color.Black)
        grPhoto.InterpolationMode = InterpolationMode.Low

        grPhoto.DrawImage(imgPhoto, New Rectangle(destX, destY, destWidth, destHeight), New Rectangle(sourceX, sourceY, sourceWidth, sourceHeight), GraphicsUnit.Pixel)

        grPhoto.Dispose()
        Return bmPhoto
    End Function
End Class
