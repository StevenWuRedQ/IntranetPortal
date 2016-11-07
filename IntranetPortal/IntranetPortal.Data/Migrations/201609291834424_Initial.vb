Imports System
Imports System.Data.Entity.Migrations
Imports Microsoft.VisualBasic

Namespace Migrations
    Public Partial Class Initial
        Inherits DbMigration
    
        Public Overrides Sub Up()
            CreateTable(
                "dbo.UnderwritingPropertyInfoes",
                Function(c) New With
                    {
                        .Id = c.Int(nullable := False, identity := True),
                        .ActualNumOfUnits = c.Int(nullable := False),
                        .BuildingDimension = c.String(maxLength := 50),
                        .LotSize = c.String(maxLength := 50),
                        .NumOfTenants = c.Int(nullable := False),
                        .OccupancyStatus = c.Int(nullable := False),
                        .PropertyAddress = c.String(),
                        .PropertyTaxYear = c.Decimal(nullable := False, precision := 18, scale := 2),
                        .PropertyType = c.Int(nullable := False),
                        .SellerOccupied = c.Boolean(nullable := False),
                        .TaxClass = c.String(maxLength := 50),
                        .Zoning = c.String(maxLength := 50)
                    }) _
                .PrimaryKey(Function(t) t.Id)
            
            CreateTable(
                "dbo.Underwritings",
                Function(c) New With
                    {
                        .Id = c.Int(nullable := False, identity := True),
                        .BBLE = c.String(),
                        .CreateBy = c.String(),
                        .UpdateBy = c.String(),
                        .CreateDate = c.DateTime(nullable := False),
                        .UpdateDate = c.DateTime(nullable := False),
                        .PropertyInfo_Id = c.Int()
                    }) _
                .PrimaryKey(Function(t) t.Id) _
                .ForeignKey("dbo.UnderwritingPropertyInfoes", Function(t) t.PropertyInfo_Id) _
                .Index(Function(t) t.PropertyInfo_Id)
            
        End Sub
        
        Public Overrides Sub Down()
            DropForeignKey("dbo.Underwritings", "PropertyInfo_Id", "dbo.UnderwritingPropertyInfoes")
            DropIndex("dbo.Underwritings", New String() { "PropertyInfo_Id" })
            DropTable("dbo.Underwritings")
            DropTable("dbo.UnderwritingPropertyInfoes")
        End Sub
    End Class
End Namespace
