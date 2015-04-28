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
        Dim number As String = ""

        ' get the phone number from the page request parameters, if given
        If Request("PhoneNumber") IsNot Nothing Then
            number = Request("PhoneNumber")
        End If
        Dim ConfrenceName = Request("ConfrenceName")
        ' wrap the phone number or client name in the appropriate TwiML verb
        ' by checking if the number given has only digits and format symbols
        Dim muted = Request("muted")
        Dim isOut = Request("isout")

        ' All user is not muted need end conferce on exit
        If (String.IsNullOrEmpty(muted)) Then
            isOut = "1"
        End If
        'Dim m = Regex.Match(number, "^[\d\+\-\(\) ]+$")


        'If m.Success Then

        '    numberOrClient = String.Format("<Number>{0}</Number>", number) ')
        'Else
        '    numberOrClient = ""


        'numberOrClient = numberOrClient & String.Format("<Client>{0}</Client>", number)
        If (Not String.IsNullOrEmpty(number)) Then

            numberOrClient = String.Format("<Number>{0}</Number>", number)
        Else
            Dim mutedStr = If(muted IsNot Nothing, "muted=""true""  beep=""false""", "")
            Dim toString = If(isOut IsNot Nothing, "endConferenceOnExit=""true""", "")
            numberOrClient = String.Format("<Conference {0} {1}>{2}</Conference>", mutedStr, toString, If(ConfrenceName IsNot Nothing, ConfrenceName, "Conference"))
        End If
        
        'End If



        Response.Write(BiuldXml(callerId, numberOrClient))
    End Sub

    Function BiuldXml(callerId As String, number As String) As String
        Return "<Response>" &
                "<Dial callerId=""" & callerId & """>" & number &
                "</Dial>" &
                "</Response>"


    End Function
End Class
