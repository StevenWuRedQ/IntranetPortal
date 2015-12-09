Module Module1

    Sub Main()

        Dim ocr1 = New OCR.OCR
        Dim result = ocr1.Convert("D://1.png")
        Console.Write(result)
        Console.ReadKey()
    End Sub

End Module
