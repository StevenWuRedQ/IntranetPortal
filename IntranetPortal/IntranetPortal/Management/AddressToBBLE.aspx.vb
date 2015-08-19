Imports System.IO
Imports System.Net

Imports Newtonsoft.Json.Linq

Public Class AddressToBBLE
    Inherits System.Web.UI.Page
    Public reslut As String
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        

        ' Me.Response.Write(reslut.ToString())


    End Sub
    Function street2BBLE(houseNumber As String, street As String, borough As String) As String
        Dim baseURL = "https://api.cityofnewyork.us/geoclient/v1/address.json?app_id=be97fb56&app_key=b51823efd58f25775df3b2956a7b2bef"
        baseURL = baseURL & "&houseNumber=" & houseNumber
        baseURL = baseURL & "&street=" & street
        baseURL = baseURL & "&borough=" & borough
        '"https://api.cityofnewyork.us/geoclient/v1/address.json?app_id=9cd0a15f&app_key=54dc84bcaca9ff4877da771750033275&houseNumber=433&street=EAST%208TH%20STREET&borough=BROOKLYN"
        Dim request As WebRequest = WebRequest.Create(baseURL)
        ' If required by the server, set the credentials.
        request.Credentials = CredentialCache.DefaultCredentials

        Try
            request.GetResponse()
        Catch ex As Exception
            Return "Get Error " + houseNumber + "," + street + "," + borough
        End Try
        ' Get the response. 
        Dim response As HttpWebResponse = CType(request.GetResponse(), HttpWebResponse)
        ' Display the status.
        Console.WriteLine(response.StatusDescription)
        ' Get the stream containing content returned by the server. 
        Dim dataStream As Stream = response.GetResponseStream()
        ' Open the stream using a StreamReader for easy access. 
        Dim reader As New StreamReader(dataStream)
        ' Read the content. 
        Dim reslut As String = reader.ReadToEnd()
        Dim values = JObject.Parse(reslut)
        Dim info = values.Item("address")
        Dim Erray = ""
        If (info IsNot Nothing) Then
            Dim bbl = info.Item("bbl")
            If (bbl IsNot Nothing) Then
                Return bbl
            Else
                Erray = "Get Error " + If(info.Item("message") IsNot Nothing, info.Item("message").ToString, "")
            End If
        Else
            Erray = "Get Error " + houseNumber + "," + street + "," + borough
        End If
        Return Erray
    End Function

    Protected Sub Button1_OnClick(sender As Object, e As EventArgs)
        Dim needToRun = JasonImportText.Text ' "[{""houseNumber"":""433"",""street"":"" EAST 8TH STREET"",""borough"":""BROOKLYN""},{""houseNumber"":""269"",""street"":"" KOSCIUSKO ST"",""borough"":""BROOKLYN""},{""houseNumber"":""581"",""street"":"" CROWN STREET"",""borough"":""BROOKLYN""},{""houseNumber"":""138"",""street"":"" ROSS STREET"",""borough"":""BROOKLYN""},{""houseNumber"":""1272"",""street"":"" BLAKE AVENUE"",""borough"":""BROOKLYN""},{""houseNumber"":""109-02"",""street"":"" 86TH STREET"",""borough"":""Queens""},{""houseNumber"":""187-07"",""street"":"" RIDGEDALE ST"",""borough"":""Queens""},{""houseNumber"":""291"",""street"":"" MACDOUGAL STREET"",""borough"":""BROOKLYN""},{""houseNumber"":""347"",""street"":"" WEST 57TH STREET"",""borough"":""Manhattan""},{""houseNumber"":""169"",""street"":"" CAMDEN AVENUE"",""borough"":""STATEN ISLAND""},{""houseNumber"":""150"",""street"":"" W 51ST STREET 16-31"",""borough"":""Manhattan""},{""houseNumber"":""11"",""street"":"" KANE PLACE"",""borough"":""BROOKLYN""},{""houseNumber"":""29-43"",""street"":"" 143RD STREET"",""borough"":""Queens""},{""houseNumber"":""656"",""street"":"" EAST 231ST STREET"",""borough"":""BRONX""},{""houseNumber"":""63-88"",""street"":"" FITCHETT ST"",""borough"":""Queens""},{""houseNumber"":""1391"",""street"":"" E 98TH STREET"",""borough"":""BROOKLYN""},{""houseNumber"":""142-14"",""street"":"" 250TH ST"",""borough"":""Queens""},{""houseNumber"":""300"",""street"":"" WEST 135TH STREET 2T"",""borough"":""Manhattan""},{""houseNumber"":""54"",""street"":"" -10 111TH ST"",""borough"":""Queens""},{""houseNumber"":""15572"",""street"":"" 115TH ROAD"",""borough"":""Queens""},{""houseNumber"":""589"",""street"":"" LENOX RD NUMBER 2"",""borough"":""BROOKLYN""},{""houseNumber"":""535"",""street"":"" 94TH ST"",""borough"":""BROOKLYN""},{""houseNumber"":""719"",""street"":"" E 84TH ST"",""borough"":""BROOKLYN""},{""houseNumber"":""331"",""street"":"" SOUTH 5TH STREET"",""borough"":""BROOKLYN""},{""houseNumber"":""253"",""street"":"" VERNON AVE"",""borough"":""BROOKLYN""},{""houseNumber"":""4815"",""street"":"" AVENUE K"",""borough"":""BROOKLYN""},{""houseNumber"":""896"",""street"":"" Manhattan"",""borough"":""BROOKLYN""},{""houseNumber"":""1349"",""street"":"" BROOKLYN AVE 1"",""borough"":""BROOKLYN""},{""houseNumber"":""343"",""street"":"" EAST 55TH STREET"",""borough"":""BROOKLYN""},{""houseNumber"":""1626"",""street"":"" CORNELIA ST"",""borough"":""Queens""},{""houseNumber"":""531"",""street"":"" ALABAMA AVE"",""borough"":""BROOKLYN""},{""houseNumber"":""206"",""street"":"" LEFFERTS PLACE"",""borough"":""BROOKLYN""},{""houseNumber"":""143"",""street"":"" MONROE STREET"",""borough"":""BROOKLYN""},{""houseNumber"":""856"",""street"":"" PROSPECT PL"",""borough"":""BROOKLYN""},{""houseNumber"":""779"",""street"":"" PUTNAM AVENUE"",""borough"":""BROOKLYN""},{""houseNumber"":""18"",""street"":"" BULWER PL"",""borough"":""BROOKLYN""},{""houseNumber"":""21215"",""street"":"" 35TH AVE"",""borough"":""Queens""},{""houseNumber"":""137-76"",""street"":"" 75 ROAD"",""borough"":""Queens""},{""houseNumber"":""1225"",""street"":"" E 86TH STEET"",""borough"":""Brooklyn""},{""houseNumber"":""348"",""street"":"" QUINCY ST"",""borough"":""BROOKLYN""},{""houseNumber"":""455"",""street"":"" WILLOUGHBY AVE"",""borough"":""BROOKLYN""},{""houseNumber"":""71"",""street"":"" SHERMAN ST"",""borough"":""BROOKLYN""},{""houseNumber"":""293"",""street"":"" WYONA STREET"",""borough"":""BROOKLYN""},{""houseNumber"":""1389"",""street"":"" SHORE PARKWAY"",""borough"":""BROOKLYN""},{""houseNumber"":""358"",""street"":"" QUINCY STREET"",""borough"":""BROOKLYN""},{""houseNumber"":""13"",""street"":"" SCHENCK AVE"",""borough"":""BROOKLYN""},{""houseNumber"":""747"",""street"":"" E 102ND ST"",""borough"":""BROOKLYN""},{""houseNumber"":""1555"",""street"":"" EAST 34TH STREET"",""borough"":""BROOKLYN""}]"
        Dim listReslut = New List(Of String)

        Dim needRunAddress = JArray.Parse(needToRun)
        For Each a In needRunAddress
            Dim getBBl = ""
            If (a.ToString IsNot Nothing) Then
                Dim address = a.ToString
               
                Try
                    getBBl = Core.Utility.Address2BBLE(address)
                Catch ex As Exception
                    getBBl = "Get " + ex.ToString
                End Try
            End If

            If (Not getBBl.StartsWith("Get") Or aspShowError.Checked Or String.IsNullOrEmpty(getBBl)) Then
                listReslut.Add(getBBl)
            End If

        Next
        reslut = listReslut.ToJsonString()
    End Sub

    Function FormatAddress(address As String) As JObject
        Dim houseNumberRegex = Regex.Match(address, "(^\d*-*\d+|^\d+)")
        If (houseNumberRegex.Success) Then
            Dim j As New JObject

            Dim houseNumber = houseNumberRegex.Value
            Dim street = address.Substring(houseNumberRegex.Value.Length + 1)
            Dim aptRegex = Regex.Match(street, "([Aa][Pp][Tt]|#|[Ss][Tt][Ee]) (\w+)$")

            If (aptRegex.Success) Then
                Dim apt = aptRegex.Value
                aptRegex = Regex.Match(apt, "(\w+)$")
                street = street.Substring(0, street.Length - apt.Length)

                j.Item("apt") = aptRegex.Value

            End If
            j.Item("houseNumber") = houseNumber
            j.Item("street") = street
            Return j
        End If
        Return Nothing
    End Function

    Protected Sub FormatAddressBtn_Click(sender As Object, e As EventArgs)
        Dim needToRun = JasonImportText.Text ' "[{""houseNumber"":""433"",""street"":"" EAST 8TH STREET"",""borough"":""BROOKLYN""},{""houseNumber"":""269"",""street"":"" KOSCIUSKO ST"",""borough"":""BROOKLYN""},{""houseNumber"":""581"",""street"":"" CROWN STREET"",""borough"":""BROOKLYN""},{""houseNumber"":""138"",""street"":"" ROSS STREET"",""borough"":""BROOKLYN""},{""houseNumber"":""1272"",""street"":"" BLAKE AVENUE"",""borough"":""BROOKLYN""},{""houseNumber"":""109-02"",""street"":"" 86TH STREET"",""borough"":""Queens""},{""houseNumber"":""187-07"",""street"":"" RIDGEDALE ST"",""borough"":""Queens""},{""houseNumber"":""291"",""street"":"" MACDOUGAL STREET"",""borough"":""BROOKLYN""},{""houseNumber"":""347"",""street"":"" WEST 57TH STREET"",""borough"":""Manhattan""},{""houseNumber"":""169"",""street"":"" CAMDEN AVENUE"",""borough"":""STATEN ISLAND""},{""houseNumber"":""150"",""street"":"" W 51ST STREET 16-31"",""borough"":""Manhattan""},{""houseNumber"":""11"",""street"":"" KANE PLACE"",""borough"":""BROOKLYN""},{""houseNumber"":""29-43"",""street"":"" 143RD STREET"",""borough"":""Queens""},{""houseNumber"":""656"",""street"":"" EAST 231ST STREET"",""borough"":""BRONX""},{""houseNumber"":""63-88"",""street"":"" FITCHETT ST"",""borough"":""Queens""},{""houseNumber"":""1391"",""street"":"" E 98TH STREET"",""borough"":""BROOKLYN""},{""houseNumber"":""142-14"",""street"":"" 250TH ST"",""borough"":""Queens""},{""houseNumber"":""300"",""street"":"" WEST 135TH STREET 2T"",""borough"":""Manhattan""},{""houseNumber"":""54"",""street"":"" -10 111TH ST"",""borough"":""Queens""},{""houseNumber"":""15572"",""street"":"" 115TH ROAD"",""borough"":""Queens""},{""houseNumber"":""589"",""street"":"" LENOX RD NUMBER 2"",""borough"":""BROOKLYN""},{""houseNumber"":""535"",""street"":"" 94TH ST"",""borough"":""BROOKLYN""},{""houseNumber"":""719"",""street"":"" E 84TH ST"",""borough"":""BROOKLYN""},{""houseNumber"":""331"",""street"":"" SOUTH 5TH STREET"",""borough"":""BROOKLYN""},{""houseNumber"":""253"",""street"":"" VERNON AVE"",""borough"":""BROOKLYN""},{""houseNumber"":""4815"",""street"":"" AVENUE K"",""borough"":""BROOKLYN""},{""houseNumber"":""896"",""street"":"" Manhattan"",""borough"":""BROOKLYN""},{""houseNumber"":""1349"",""street"":"" BROOKLYN AVE 1"",""borough"":""BROOKLYN""},{""houseNumber"":""343"",""street"":"" EAST 55TH STREET"",""borough"":""BROOKLYN""},{""houseNumber"":""1626"",""street"":"" CORNELIA ST"",""borough"":""Queens""},{""houseNumber"":""531"",""street"":"" ALABAMA AVE"",""borough"":""BROOKLYN""},{""houseNumber"":""206"",""street"":"" LEFFERTS PLACE"",""borough"":""BROOKLYN""},{""houseNumber"":""143"",""street"":"" MONROE STREET"",""borough"":""BROOKLYN""},{""houseNumber"":""856"",""street"":"" PROSPECT PL"",""borough"":""BROOKLYN""},{""houseNumber"":""779"",""street"":"" PUTNAM AVENUE"",""borough"":""BROOKLYN""},{""houseNumber"":""18"",""street"":"" BULWER PL"",""borough"":""BROOKLYN""},{""houseNumber"":""21215"",""street"":"" 35TH AVE"",""borough"":""Queens""},{""houseNumber"":""137-76"",""street"":"" 75 ROAD"",""borough"":""Queens""},{""houseNumber"":""1225"",""street"":"" E 86TH STEET"",""borough"":""Brooklyn""},{""houseNumber"":""348"",""street"":"" QUINCY ST"",""borough"":""BROOKLYN""},{""houseNumber"":""455"",""street"":"" WILLOUGHBY AVE"",""borough"":""BROOKLYN""},{""houseNumber"":""71"",""street"":"" SHERMAN ST"",""borough"":""BROOKLYN""},{""houseNumber"":""293"",""street"":"" WYONA STREET"",""borough"":""BROOKLYN""},{""houseNumber"":""1389"",""street"":"" SHORE PARKWAY"",""borough"":""BROOKLYN""},{""houseNumber"":""358"",""street"":"" QUINCY STREET"",""borough"":""BROOKLYN""},{""houseNumber"":""13"",""street"":"" SCHENCK AVE"",""borough"":""BROOKLYN""},{""houseNumber"":""747"",""street"":"" E 102ND ST"",""borough"":""BROOKLYN""},{""houseNumber"":""1555"",""street"":"" EAST 34TH STREET"",""borough"":""BROOKLYN""}]"
        Dim listReslut = New List(Of String)
        Dim ja As New JArray
        Dim needRunAddress = JArray.Parse(needToRun)
        For Each a In needRunAddress
            Dim address = a.Item("PropertyAddress").ToString
            Dim fAddress = FormatAddress(address)
            ja.Add(fAddress)
        Next
        reslut = ja.ToJsonString
    End Sub
End Class