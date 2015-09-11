Imports System.Drawing
Imports ImageMagick
Imports System.IO
Imports Tesseract

Public Class OCR

    ' Convert any picture format to bitmap with be used by Tesseract
    Public Function ConvertPNGToBMPBytes(PNGPath As String) As Byte()

        ' Read image from file
        Using image As New MagickImage(PNGPath)
            ' Sets the output format to jpeg
            image.Format = MagickFormat.Bmp
            image.Resize(image.Width * 3, image.Height * 3)
            ' Create byte array that contains a jpeg file
            Dim data As Byte() = image.ToByteArray
            Return data
        End Using


    End Function

    ' OCR Convert A picture from path, return a result text
    Public Function Convert(PNGPath As String) As String
        Dim stream = ConvertPNGToBMPBytes(PNGPath)
        Dim ms = New MemoryStream(stream)

        Using engine As New TesseractEngine("D:\tessdata", "eng", EngineMode.Default)
            Using image As New System.Drawing.Bitmap(ms)
                Dim pix = PixConverter.ToPix(image)
                Dim page = engine.Process(pix)
                Return page.GetText()
            End Using
        End Using

    End Function
End Class
