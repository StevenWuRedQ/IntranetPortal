Imports System.Xml.Serialization

Public Class PortalNavItem

    <XmlAttribute()>
    Public Property Name As String
    Public Property Text As String
    Public Property NavigationUrl As String
    Public Property FontClass As String
    Public Property ShowAmount As Boolean
    Public Property Amount As Integer
    Public Property Roles As String
    Public Property Items As List(Of PortalNavItem)
    Public Property level As Integer = 0

    Private rootItemFormat As String = "<li class=""category""><a href=""{0}"">{1}</a>"
    Private itemFormat As String = "<li>{0}<a href=""{1}"">{2}</a>"
    Private childrenWrapFormat As String = "<ul class=""nav-level-{0}"">{1}</ul>"
    Private itemEndFormat As String = "</li>"

    Public Function ToHtml() As String
        Dim htmlNode = ""
        If level = 0 Then
            htmlNode = RenderRootNode()
        Else
            htmlNode = RenderNode()
        End If

        If Items IsNot Nothing AndAlso Items.Count > 0 Then
            Dim subNode = ""

            For Each item In Items
                item.level = level + 1
                subNode += item.ToHtml
            Next

            htmlNode += String.Format(childrenWrapFormat, level + 1, subNode)
        End If

        htmlNode += itemEndFormat
        Return htmlNode
    End Function


    Function RenderRootNode() As String
        Return String.Format(rootItemFormat, NavigationUrl, Text)
    End Function

    Function RenderNode() As String
        Return String.Format(itemFormat, FontClass, NavigationUrl, Text)
    End Function

    Function Visible() As Boolean
        Return True
    End Function
End Class