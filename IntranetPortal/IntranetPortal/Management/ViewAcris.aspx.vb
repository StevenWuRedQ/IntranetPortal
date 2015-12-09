Imports System.Net
Imports Newtonsoft.Json.Linq

Public Class ViewAcris
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim bble = Request.QueryString("bble")
        If (Not String.IsNullOrEmpty(bble)) Then
            Using wc = New WebClient()
                Dim json = wc.DownloadString("https://api.cityofnewyork.us/geoclient/v1/bin.json?app_id=be97fb56&app_key=b51823efd58f25775df3b2956a7b2bef&bin=" & bble)
                If (Not String.IsNullOrEmpty(json)) Then
                    Try
                        Dim lead = JObject.Parse(json)
                        Dim boro = lead.SelectToken("bin.bblBoroughCode")
                        If (boro IsNot Nothing) Then
                            Dim block = lead.SelectToken("bin.bblTaxBlock")
                            Dim lot = lead.SelectToken("bin.bblTaxLot")
                            Dim url = "http://a836-acris.nyc.gov/bblsearch/bblsearch.asp?max_rows=99&borough=" & boro.ToString & "&block=" & CInt(block.ToString) & "&lot=" & CInt(lot.ToString)
                            Response.Redirect(url)
                        End If
                    Catch ex As Exception

                    End Try
                End If
            End Using
        End If
    End Sub

End Class