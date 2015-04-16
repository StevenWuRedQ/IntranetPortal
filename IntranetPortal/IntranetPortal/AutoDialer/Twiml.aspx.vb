Imports System.Xml.Serialization

Public Class Twiml
    Inherits System.Web.UI.Page
    Public Property callerId As String
    Public Property numberOrClient As String
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Response.ContentType = "text/xml"

        ' put a phone number you've verified with Twilio to use as a caller ID number
        callerId = "+19179633481"

        ' put your default Twilio Client name here, for when a phone number isn't given
        Dim number As String = "jenny"

        ' get the phone number from the page request parameters, if given
        If Request("PhoneNumber") IsNot Nothing Then
            number = Request("PhoneNumber")
        End If
        Dim ConfrenceName = Request("ConfrenceName")
        ' wrap the phone number or client name in the appropriate TwiML verb
        ' by checking if the number given has only digits and format symbols

        Dim m = Regex.Match(number, "^[\d\+\-\(\) ]+$")
      
       
        If m.Success Then
            'numberOrClient = String.Format("<Conference>{0}</Conference>", "Conference" & number)
            numberOrClient = String.Format("<Conference>{0}</Conference>", "Conference")
            numberOrClient = String.Format("<Number>{0}</Number>", number) ')
        Else
            numberOrClient = ""


            'numberOrClient = numberOrClient & String.Format("<Client>{0}</Client>", number)
            numberOrClient = numberOrClient & String.Format("<Conference>{0}</Conference>", ConfrenceName)
        End If



        Response.Write(BiuldXml(callerId, numberOrClient))
    End Sub
    Function BiuldXml(callerId As String, number As String) As String
        Return "<Response>" &
                "<Dial callerId=""" & callerId & """>" & number &
                "</Dial>" &
                "</Response>"


    End Function
End Class
