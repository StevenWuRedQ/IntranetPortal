Public Class AngentOverview
    Inherits System.Web.UI.Page
    Public report_data As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        report_data = report_data_f()


    End Sub


    'retrun the report data fields
    Function report_fields() As String
        Dim serializer As New System.Web.Script.Serialization.JavaScriptSerializer()
        Dim D_report_data As New List(Of String)
        'From()
        '    {"property", "date", "call_atpt"
        '        }
        D_report_data.Add("property")
        D_report_data.Add("date")

        D_report_data.Add("call_atpt")

        Return serializer.Serialize(D_report_data)
    End Function
    'retrun the report data
    Function report_data_f() As String
        Dim serializer As New System.Web.Script.Serialization.JavaScriptSerializer()
        Dim D_report_data As New List(Of Dictionary(Of String, String))


        For i As Integer = 1 To 20
            Dim item As New Dictionary(Of String, String) From
            {
                {"property", "123 Main St, Brooklyn, NY 12345"},
                {"date", "4/23/2014"},
                {"call_atpt", "12"},
                {"doorknk_atpt", "3"},
                {"Comment", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras at porta justo, vitae ultrices orci."},
                {"data", "3"}
            }
            If i Mod 2 = 0 Then
                Dim item2 As New Dictionary(Of String, String) From
            {
                {"property", "5732 Jamaica Ave, Jamaica, NY 11456"},
                {"date", "5/17/2014"},
                {"call atpt", "20"},
                {"doorknk_atpt", "9"},
                {"Comment", "Phasellus enim libero, pulvinar sit amet felis at, rutrum rhoncus ante."},
                {"data", " "}
            }
                item = item2
            End If
            D_report_data.Add(item)
        Next
        Return serializer.Serialize(D_report_data)

    End Function
    Public Sub click_report_index(ByVal sender As System.Object)
        Dim index As Integer = sender
        'Request.QueryString("index")
        MsgBox("index =" & index)
    End Sub
End Class