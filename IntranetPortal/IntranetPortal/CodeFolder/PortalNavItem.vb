Imports System.Xml.Serialization

Public Class PortalNavItem

    <XmlAttribute()>
    Public Property Name As String
    <XmlAttribute()>
    Public Property Text As String
    <XmlAttribute()>
    Public Property NavigationUrl As String
    Public Property FontClass As String
    <XmlAttribute()>
    Public Property ShowAmount As Boolean
    <XmlAttribute()>
    Public Property Amount As Integer
    Public Property UserRoles As String
    <XmlAttribute()>
    Public Property ItemType As String
    Public Property Items As List(Of PortalNavItem)
    Public Property level As Integer = 1
    Public Property FrontButton As String = ""
    <XmlAttribute()>
    Public Property Expanded As Boolean

    Private rootItemFormat As String = "<li><a href=""{0}"" class=""category {3}"" target=""contentUrlPane"">{1} - {2}</a>"
    Private itemFormat As String = "<li>{3}<a href=""{1}"" target=""contentUrlPane"">{0}{2}</a>"
    Private itemWithChildrenFormat As String = "<li>{4}<a href=""{1}"" class=""{3}"" target=""contentUrlPane""><i class=""fa fa-caret-right""></i>{0}{2}</a>"
    Private itemWithNumFormat As String = "<li>{5}<a href=""{1}"" target=""contentUrlPane"">{0}{2}<span class=""notification"" id=""{3}"">{4}</span></a>"
    Private childrenWrapFormat As String = "<ul class=""nav-level-{0}"">{1}</ul>"
    Private level2WrapFormat As String = " <div class=""nav-level-{0}-container"">{1}</div>"
    Private itemEndFormat As String = "</li>"
    Private ReadOnly AMOUNTSPANID As String = "SpanAmount_"

    <XmlIgnore>
    Public ReadOnly Property LeadsCountSpanId() As String
        Get
            Return AMOUNTSPANID & Name
        End Get
    End Property

    Public Function ToHtml() As String
        If Visible() Then
            Dim htmlNode = ""
            If level = 1 Then
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

                subNode = String.Format(childrenWrapFormat, level + 1, subNode)

                If level = 1 Then
                    subNode = String.Format(level2WrapFormat, level + 1, subNode)
                End If

                htmlNode += subNode
            End If

            htmlNode += itemEndFormat
            Return htmlNode
        End If
        Return ""
    End Function

    Function RenderRootNode() As String
        Return String.Format(rootItemFormat, NavigationUrl, Text, HttpContext.Current.User.Identity.Name, If(Expanded, "current", ""))
    End Function

    Function RenderNode() As String
        If ShowAmount Then
            Return String.Format(itemWithNumFormat, FontClass, NavigationUrl, Text, LeadsCountSpanId, "", FrontButton)
        Else
            If Items.Count > 0 Then
                Return String.Format(itemWithChildrenFormat, FontClass, NavigationUrl, Text, "has-level-" & level + 1 & "-menu", FrontButton)
            End If

            Return String.Format(itemFormat, FontClass, NavigationUrl, Text, FrontButton)
        End If
    End Function

    Function Visible(Optional userContext As HttpContext = Nothing) As Boolean
        If userContext Is Nothing AndAlso HttpContext.Current IsNot Nothing Then
            userContext = HttpContext.Current
        End If
        Dim userName = userContext.User.Identity.Name

        If String.IsNullOrEmpty(ItemType) Then
            Return IsUserRoles(userName)
        End If

        Dim type = [Enum].Parse(GetType(NavItemType), ItemType)

        Select Case type
            Case NavItemType.Agent
                If Not Employee.HasSubordinates(userName) Then
                    Return True
                End If
            Case NavItemType.Manager
                If Employee.HasSubordinates(userName) Then
                    Return True
                End If
            Case NavItemType.Office
                If IsUserRoles(userName) Then
                    Return True
                End If
        End Select

        Return False
    End Function

    Function IsUserRoles(userName As String) As Boolean
        If Not String.IsNullOrEmpty(UserRoles) Then
            For Each rl In UserRoles.Split(",")
                If Roles.IsUserInRole(userName, rl) Then
                    Return True
                End If
            Next
        Else
            Return True
        End If

        Return False
    End Function

    Public Enum NavItemType
        Agent
        Manager
        Office
    End Enum
End Class