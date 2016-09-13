Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal
Imports ClosedXML.Excel
Imports Newtonsoft.Json.Linq
Imports IntranetPortal.Data

<TestClass()> Public Class DocumentGeneratorTest
    Dim jstr = <![CDATA[
        {
  "ownerSSN": null,
  "propertyTaxes": 918.76,
  "waterCharges": 15966.47,
  "ecbViolation": "123",
  "dobWebsites": "123",
  "judgementSearchDoc": {
    "path": "/Shared%20Documents/4123420113/Construction/AuctionsPropList_4-04-2016.xls",
    "name": "AuctionsPropList_4-04-2016.xls",
    "uploadTime": "2016-05-18T15:16:59.234Z"
  },
  "DocumentsReceivedOn": "05/25/2016",
  "Ownership_Mortgage_Info": false,
  "Purchase_Deed_Ownership_Mortgage_Info": false,
  "c_1st_Mortgage_Ownership_Mortgage_Info": false,
  "c_2nd_Mortgage_Ownership_Mortgage_Info": false,
  "OtherMortgageDiv": false,
  "OtherMortgage": [
    {
      "Amount": "Test"
    },
    {
      "Amount": "Test2"
    }
  ],
  "OtherLiensDiv": false,
  "OtherLiens": [
    {
      "Lien": "Lien1 ",
      "Amount": "5000",
      "Date": "2016/12/11"
    },
    {
      "Lien": "Lien2",
      "Amount": "5001",
      "Date": "2016/1/1"
    }
  ],
  "TaxLienCertificateDiv": false,
  "TaxLienCertificate": [
    {
      "Year": "2015",
      "Amount": "4000"
    }
  ],
  "COSRecordedDiv": false,
  "COSRecorded": [
    {
      "Date": "2014/12/01",
      "Buyer": "Chris"
    }
  ],
  "DeedRecordedDiv": false,
  "DeedRecorded": [
    {
      "Date": "2014/12/01",
      "Buyer": "Christ 1"
    },
    {
      "Date": "2015/1/1",
      "Buyer": "Chris2"
    }
  ],
  "Last_Assignment_Ownership_Mortgage_Info": false,
  "LP_Index___Num_Ownership_Mortgage_Info": false,
  "Property_Dues_Violations": false,
  "Property_Taxes_Due_Property_Dues_Violations": false,
  "Water_Charges_Due_Property_Dues_Violations": false,
  "ECB_Violoations_Property_Dues_Violations": false,
  "DOB_Violoations_Property_Dues_Violations": false,
  "C_O_Property_Dues_Violations": false,
  "HPD_Violations_Property_Dues_Violations": false,
  "HPD_Charges_Not_Paid_Transferred_Property_Dues_Violations": false,
  "Judgements_Liens": false,
  "Personal_Judgments_Judgements_Liens": false,
  "HPD_Judgments_Judgements_Liens": false,
  "IRS_Tax_Lien_Judgements_Liens": false,
  "NYS_Tax_Lien_Judgements_Liens": false,
  "Sidewalk_Liens_Judgements_Liens": false,
  "Vacate_Order_Judgements_Liens": false,
  "ECB_Tickets_Judgements_Liens": false,
  "ECB_on_Name_other_known_address_Judgements_Liens": false,
  "ownerName": "MCCAIN, DONALD",
  "mortgageAmount": 417000,
  "secondMortgageAmount": "22222",
  "Has_Deed_Purchase_Deed": true,
  "Has_c_1st_Mortgage_c_1st_Mortgage": true,
  "Has_c_2nd_Mortgage_c_2nd_Mortgage": true,
  "has_Last_Assignment_Last_Assignment": true,
  "fannie": true,
  "Freddie_Mac_": false,
  "fha": false,
  "Has_Due_Property_Taxes_Due": true,
  "Has_Due_Water_Charges_Due": true,
  "Has_Open_ECB_Violoations": true,
  "Has_Open_DOB_Violoations": true,
  "hasCO": true,
  "Has_Violations_HPD_Violations": true,
  "Is_Open_HPD_Charges_Not_Paid_Transferred": true,
  "has_Judgments_Personal_Judgments": true,
  "has_Judgments_HPD_Judgments": true,
  "has_IRS_Tax_Lien_IRS_Tax_Lien": true,
  "hasNysTaxLien": true,
  "has_Sidewalk_Liens_Sidewalk_Liens": true,
  "has_Vacate_Order_Vacate_Order": true,
  "has_ECB_Tickets_ECB_Tickets": true,
  "has_ECB_on_Name_ECB_on_Name_other_known_address": true,
  "Date_of_Deed_Purchase_Deed": "08/11/2016",
  "Party_1_Purchase_Deed": "apple1",
  "Party_2_Purchase_Deed": "organge",
  "Has_Other_Mortgage": true,
  "Has_Other_Liens": true,
  "Has_TaxLiensCertifcate": true,
  "Has_COS_Recorded": true,
  "Has_Deed_Recorded": true,
  "Assignment_date_Last_Assignment": "08/23/2016",
  "Assigned_To_Last_Assignment": "Steven",
  "LP_Index___Num_LP_Index___Num": "12452112",
  "servicer": "xx",
  "Property_Taxes_per_YR_Property_Taxes_Due": "5000.00",
  "Count_ECB_Violoations": "422",
  "Count_DOB_Violoations": "2422",
  "___Num_of_Units_C_O": "gg",
  "A_Class_HPD_Violations": "a class",
  "B_Class_HPD_Violations": "b class",
  "C_Class_HPD_Violations": "c class",
  "I_Class_HPD_Violations": "d calss",
  "Open_Amount_HPD_Charges_Not_Paid_Transferred": "52525",
  "HPD_Number_of_Units": "4",
  "Tax_Classification": "4",
  "Count_Personal_Judgments": "5",
  "Amount_Personal_Judgments": "5000",
  "Count_HPD_Judgments": "4",
  "HPDjudgementAmount": "4000",
  "Count_IRS_Tax_Lien": "5",
  "irsTaxLien": "4000",
  "Count_NYS_Tax_Lien": "4",
  "Amount_NYS_Tax_Lien": "5222",
  "Count_Sidewalk_Liens": "3",
  "Amount_Sidewalk_Liens": "4255",
  "Count_Vacate_Order": "2",
  "Amount_Vacate_Order": "5222",
  "Count_ECB_Tickets": "2",
  "Amount_ECB_Tickets": "52223",
  "Count_ECB_on_Name_other_known_address": "1",
  "Amount_ECB_on_Name_other_known_address": "52252",
  "notes_LP_Index___Num": "test",
  "Servicer_notes": "xeghse"
}
    ]]>.Value()
    Dim jobj = Newtonsoft.Json.Linq.JObject.Parse(jstr)


    <TestMethod>
    Public Sub testaddIRSNYS()
        Dim val2 = ExcelBuilder.addIRSNYS()(jobj)
        Assert.IsFalse(val2 = "100")
        Assert.IsTrue(val2 = "9222")
    End Sub

    <TestMethod>
    Public Sub testdecideBBaseOnA()
        Dim jstr = <![CDATA[
            {

            "A": "A",
            "B": "B"
            
           }
        ]]>.Value
        Dim jobj = JObject.Parse(jstr)
        Dim val1 = ExcelBuilder.decideBBaseOnA("A", "B")(jobj)
        Assert.IsTrue(val1 = "B")

        jstr = <![CDATA[
            {

            "A": "false",
            "B": "B"
            
           }
        ]]>.Value
        jobj = JObject.Parse(jstr)
        val1 = ExcelBuilder.decideBBaseOnA("A", "B")(jobj)
        Assert.IsFalse(val1 = "")

    End Sub


    <TestMethod>
    Public Sub testbooleanToYN()
        Dim jstr = <![CDATA[
            {

            "A": "A",
            "B": "B"
            
           }
        ]]>.Value
        Dim jobj = JObject.Parse(jstr)
        Dim val1 = ExcelBuilder.booleanToYN("A")(jobj)
        Dim val2 = ExcelBuilder.booleanToYN("C")(jobj)
        Assert.IsTrue(val1 = "No")
        Assert.IsTrue(val2 = "")
    End Sub


End Class