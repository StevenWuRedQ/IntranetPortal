Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal.Data

<TestClass()> Public Class PreSignUnitTest

    Dim bble = "2037130013"

    <TestMethod()> Public Sub Create_returnRecordId()

        Dim record = New PreSignRecord
        record.BBLE = bble
        record.NeedCheck = True
        Dim cr As New CheckRequest
        cr.BBLE = bble
        cr.Type = "ShortSale"
        cr.Checks = New List(Of BusinessCheck)
        cr.Checks.Add(New BusinessCheck() With {
                           .Amount = 1000,
                           .PaybleTo = "Test",
                           .Date = DateTime.Today,
                           .CheckFor = "UnitTest"
                      })

        record.CheckRequestData = cr

        record.Create("Test")

        Assert.IsTrue(record.Id > 0)

        record = PreSignRecord.GetInstance(record.Id)
        Assert.IsNotNull(record.CheckRequestData)
        Assert.AreEqual(1, record.CheckRequestData.Checks.Count)
        Assert.AreEqual(cr.Type, record.CheckRequestData.Type)

        record.Description = "Test"
        record.Save("Test")

        Assert.AreEqual("Test", record.Description)

        'record.Delete()

    End Sub

    <TestMethod()> Public Sub CreateCheck_returnCheckId()


    End Sub

End Class