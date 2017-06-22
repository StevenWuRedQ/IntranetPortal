Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal.Data

<TestClass()> Public Class TloServiceTest

    <TestMethod()>
    Public Sub GetLocateReport_LocateReport()

        Dim PersonName As String, PersonAddress1 As String, PersonAddress2 As String, PersonCity As String, PersonState As String, PersonZip As String, PersonCountry As String
        PersonName = "Li Peng"
        PersonAddress1 = "8072 87th Rd"
        PersonAddress2 = ""
        PersonCity = "Woodhaven"
        PersonState = "NY"
        PersonZip = "11421"
        PersonCountry = "USA"
        Dim result = TLOService.GetLocateReport(PersonName, PersonAddress1, PersonAddress2, PersonCity, PersonState, PersonZip, PersonCountry, "", "")
        Assert.IsNotNull(result)
    End Sub

    <TestMethod()>
    Public Sub GetTLOPerson_HomeOwner()
        Dim tloId = "075468976"
        Dim result = TLOService.GetTLOPerson(Nothing, Nothing, Nothing, False, False, Nothing, tloId, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing)
        Assert.IsNotNull(result)
    End Sub

End Class