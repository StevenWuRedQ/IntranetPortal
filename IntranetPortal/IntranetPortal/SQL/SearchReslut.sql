SELECT        dbo.ALL_NYC_Tax_Liens_CO_Info.BBLE, DataColection.dbo.NYC_Assessment.NUMBER + ' ' + DataColection.dbo.NYC_Assessment.ST_NAME + ' - ' + RTRIM(COALESCE (dbo.ALL_NYC_Tax_Liens_CO_Info.Owner,
                          N'')) + ',' + RTRIM(COALESCE (dbo.ALL_NYC_Tax_Liens_CO_Info.CoOwner, N'')) AS LeadsName, DataColection.dbo.NYC_Assessment.BLOCK, DataColection.dbo.NYC_Assessment.LOT, 
                         DataColection.dbo.NYC_Assessment.ORIG_SQFT, DataColection.dbo.NYC_Assessment.LOT_DIM, DataColection.dbo.NYC_Assessment.CLASS, DataColection.dbo.NYC_Assessment.NEIGH_NAME, 
                         dbo.ALL_NYC_Tax_Liens_CO_Info.PropertyAddress, dbo.ALL_NYC_Tax_Liens_CO_Info.Bill_Line1 AS Servicer, COALESCE (dbo.ALL_NYC_Tax_Liens_CO_Info.C1stMotgrAmt, 0) 
                         + COALESCE (dbo.ALL_NYC_Tax_Liens_CO_Info.C2ndMotgrAmt, 0) + COALESCE (dbo.ALL_NYC_Tax_Liens_CO_Info.C3rdMotgrAmt, 0) AS MotgCombo, dbo.ALL_NYC_Tax_Liens_CO_Info.TaxesAmt AS TaxCombo, 
                         GETDATE() AS ImportDate, 'Jay_9_17' AS Type, dbo.ALL_NYC_Tax_Liens_CO_Info.NeedCollection
FROM            dbo.ALL_NYC_Tax_Liens_CO_Info INNER JOIN
                         DataColection.dbo.NYC_Assessment ON dbo.ALL_NYC_Tax_Liens_CO_Info.BBLE = DataColection.dbo.NYC_Assessment.BBLE
WHERE        (dbo.ALL_NYC_Tax_Liens_CO_Info.NeedCollection = 1)