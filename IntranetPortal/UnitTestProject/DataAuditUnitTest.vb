Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal.Data

<TestClass()> Public Class DataAuditUnitTest

    Dim bble = "2037130013"

    <TestMethod()> Public Sub DataCreated_TheLogWasCreated()

        Using ctx As New PortalEntities
            Dim record = New PreSignRecord
            record.BBLE = bble
            record.ExpectedDate = New Date(2016, 5, 1)
            record.DealAmount = 5000
            record.Title = "Test Data"

            ctx.PreSignRecords.Add(record)
            ctx.SaveChanges("Test")

            Dim logs = ctx.AuditLogs.Where(Function(a) a.TableName = "PreSignRecord" And a.UserName = "Test" And a.RecordId = record.Id AndAlso a.EventType = 0).ToList
            Assert.IsTrue(logs.Count > 0)
            Assert.IsTrue(logs.Any(Function(l) l.ColumnName = "Title" AndAlso l.NewValue = "Test Data"))
            Assert.IsTrue(logs.Any(Function(l) l.ColumnName = "DealAmount" AndAlso l.NewValue = 5000))
            Assert.IsFalse(logs.Any(Function(l) l.NewValue Is Nothing))
            Assert.IsTrue(logs.Any(Function(l) l.ColumnName = "BBLE" AndAlso l.NewValue = bble))
        End Using
    End Sub

    <TestMethod()> Public Sub DataUpdated_TheLogWasCreated()
        Dim recordBak As PreSignRecord
        Using ctx As New PortalEntities
            recordBak = New PreSignRecord
            recordBak.BBLE = bble
            recordBak.ExpectedDate = New Date(2016, 5, 2)
            recordBak.DealAmount = 3000
            recordBak.Title = "Test Data"
            ctx.PreSignRecords.Add(recordBak)
            ctx.SaveChanges()
        End Using

        Using ctx As New PortalEntities
            Dim record = ctx.PreSignRecords.Find(recordBak.Id)
            record.ExpectedDate = New Date(2016, 5, 2)
            record.DealAmount = 3000
            record.Title = "Test Data 2"
            ctx.SaveChanges("Test")

            Dim logs = ctx.AuditLogs.Where(Function(a) a.TableName = "PreSignRecord" And a.UserName = "Test" And a.RecordId = record.Id AndAlso a.EventType = 1).ToList
            Assert.IsTrue(logs.Count > 0)
            Assert.IsTrue(logs.Any(Function(l) l.ColumnName = "Title" AndAlso l.NewValue = record.Title AndAlso l.OriginalValue = recordBak.Title))
            Assert.IsFalse(logs.Any(Function(l) l.NewValue = l.OriginalValue))
            'Assert.IsFalse(logs.Any(Function(l) l.ColumnName = "BBLE" AndAlso l.NewValue = bble))
        End Using
    End Sub

    <TestMethod()> Public Sub DataUpdated2_TheLogWasCreated()
        Dim recordBak As PreSignRecord
        Using ctx As New PortalEntities
            recordBak = New PreSignRecord
            recordBak.BBLE = bble
            recordBak.ExpectedDate = New Date(2016, 5, 2)
            recordBak.DealAmount = 3000
            recordBak.Title = "Test Data"
            ctx.PreSignRecords.Add(recordBak)
            ctx.SaveChanges()
        End Using

        Using ctx As New PortalEntities
            recordBak.DealAmount = 5000
            recordBak.Title = "Test Data 2"
            'Dim record = ctx.PreSignRecords.Find(recordBak.Id)
            'ctx.Entry(record).CurrentValues.SetValues(recordBak)
            ctx.Entry(recordBak).State = Entity.EntityState.Modified
            ctx.Entry(recordBak).OriginalValues.SetValues(ctx.Entry(recordBak).GetDatabaseValues)

            ctx.SaveChanges("Test")

            Dim logs = ctx.AuditLogs.Where(Function(a) a.TableName = "PreSignRecord" And a.UserName = "Test" And a.RecordId = recordBak.Id AndAlso a.EventType = 1).ToList
            Assert.IsTrue(logs.Count > 0)
            Assert.IsFalse(logs.Any(Function(l) l.NewValue = l.OriginalValue))
            'Assert.IsFalse(logs.Any(Function(l) l.ColumnName = "BBLE" AndAlso l.NewValue = bble))
        End Using
    End Sub

    <TestMethod()> Public Sub UpdateFunction_TheLogWasCreated()
        Dim recordBak As PreSignRecord
        Using ctx As New PortalEntities
            recordBak = New PreSignRecord
            recordBak.BBLE = bble
            recordBak.ExpectedDate = New Date(2016, 5, 2)
            recordBak.DealAmount = 3000
            recordBak.Title = "Test Data"
            ctx.PreSignRecords.Add(recordBak)
            ctx.SaveChanges()
        End Using

        recordBak.Title = "Test date 2"
        recordBak.Save("Test")

        Using ctx As New PortalEntities
            Dim logs = ctx.AuditLogs.Where(Function(a) a.TableName = "PreSignRecord" And a.UserName = "Test" And a.RecordId = recordBak.Id AndAlso a.EventType = 1).ToList
            Assert.IsTrue(logs.Count > 0)
            Assert.IsFalse(logs.Any(Function(l) l.NewValue = l.OriginalValue))
            Assert.IsTrue(logs.Any(Function(l) l.ColumnName = "Title" AndAlso l.NewValue = recordBak.Title AndAlso l.OriginalValue = "Test Data"))
        End Using

    End Sub

    <TestMethod()> Public Sub DataDeleted_TheLogWasCreated()
        Using ctx As New PortalEntities
            Dim record = New PreSignRecord
            record.ExpectedDate = New Date(2016, 5, 2)
            record.DealAmount = 3000
            record.Title = "Test Data 2"
            ctx.SaveChanges()

            ctx.PreSignRecords.Add(record)
            ctx.SaveChanges()

            record = ctx.PreSignRecords.Find(record.Id)
            ctx.PreSignRecords.Remove(record)
            ctx.SaveChanges("Test")

            Dim logs = ctx.AuditLogs.Where(Function(a) a.TableName = "PreSignRecord" And a.UserName = "Test" And a.RecordId = record.Id AndAlso a.EventType = 2).ToList
            Assert.IsTrue(logs.Count > 0)
            Assert.IsTrue(logs.Any(Function(l) l.ColumnName = "Title" AndAlso l.NewValue Is Nothing AndAlso l.OriginalValue = record.Title))
            Assert.IsFalse(logs.Any(Function(l) l.NewValue IsNot Nothing))
            Assert.IsFalse(logs.Any(Function(l) l.ColumnName = "BBLE" AndAlso l.OriginalValue = bble))
        End Using

    End Sub


    <TestMethod()> Public Sub FormatDecimalValue_ReturnValueOfFormat()
        Dim log As New AuditLog With {
            .TableName = "PreSignRecord",
            .ColumnName = "DealAmount",
            .OriginalValue = "5021",
            .NewValue = "1204"
            }

        Assert.IsInstanceOfType(log.FormatNewValue, GetType(Decimal))
        Assert.IsInstanceOfType(log.FormatOriginalValue, GetType(Decimal))

    End Sub

    <TestMethod()> Public Sub FormatJarrayValue_ReturnValueOfFormat()
        Dim log As New AuditLog With {
            .TableName = "PreSignRecord",
            .ColumnName = "Parties",
            .OriginalValue = <string>
                                 [
                                      {
                                        "Name": "Williams, Michelle"
                                      }
                                    ]
                             </string>,
            .NewValue = <string>
                                [
                                  {
                                    "Name": "Yoon, Ick Kyung"
                                  }
                                ]
                         </string>
        }

        Assert.AreEqual(log.FormatOriginalValue, "Williams, Michelle")

    End Sub

End Class