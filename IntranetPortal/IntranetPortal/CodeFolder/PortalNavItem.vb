Imports System.Xml.Serialization

Public Class PortalNavItem

    <XmlAttribute()>
    Public Property Name As String
    <XmlAttribute()>
    Public Property Text As String
    <XmlAttribute()>
    Public Property Visible As Boolean = True
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
    Public Property Office As String = ""

    <XmlAttribute()>
    Public Property Expanded As Boolean

    <XmlAttribute()>
    Public Property AmountManageClass As String

    Public Property Applications As String

    Private rootItemFormat As String = "<li><a href=""{0}"" class=""category {2}"" target=""contentUrlPane"">{1}</a>"
    Private rootOfficeItemFormat As String = "<li><a href=""{0}"" class=""category {2}"" target=""contentUrlPane"">{1}</a>"
    Private itemFormat As String = "<li class=""{4}"">{3}<a href=""{1}"" target=""contentUrlPane"">{0}{2}</a>"
    Private itemWithChildrenFormat As String = "<li class=""{5}"">{4}<a href=""{1}"" class=""{3}"" target=""contentUrlPane""><i class=""fa fa-caret-right""></i>{0}{2}</a>"
    Private itemWithNumFormat As String = "<li class=""{7}"">{5}<a href=""{1}"" target=""contentUrlPane"" class=""{6}"">{0}{2}<span class=""notification"" id=""{3}"">{4}</span></a>"
    Private itemWithNumChildrenFormat = "<li class=""{7}"">{5}<a href=""{1}"" class=""{6}"" target=""contentUrlPane""><i class=""fa fa-caret-right""></i>{0}{2}<span class=""notification"" id=""{3}"">{4}</span></a>"
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

    <XmlIgnore>
    Public Property Parent As PortalNavItem

    Public Function ToHtml() As String
        If IsVisible() Then
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
        If ItemType = "Office" Then
            Return String.Format(rootOfficeItemFormat, NavigationUrl, Text, If(Expanded, "current", ""))
        End If
        Return String.Format(rootItemFormat, NavigationUrl, Text, If(Expanded, "current", ""))
    End Function

    Function RenderNode() As String
        If ShowAmount Then
            If Items IsNot Nothing AndAlso Items.Count > 0 Then
                Return String.Format(itemWithNumChildrenFormat, FontClass, NavigationUrl, Text, LeadsCountSpanId, "", FrontButton, "has-level-" & level + 1 & "-menu", If(String.IsNullOrEmpty(FrontButton), "", "has-add-button"))
            End If
            Return String.Format(itemWithNumFormat, FontClass, NavigationUrl, Text, LeadsCountSpanId, "", FrontButton, If(Items IsNot Nothing AndAlso Items.Count > 0, "has-level-" & level + 1 & "-menu", ""), If(String.IsNullOrEmpty(FrontButton), "", "has-add-button"))
        Else
            If Items IsNot Nothing AndAlso Items.Count > 0 Then
                Return String.Format(itemWithChildrenFormat, FontClass, NavigationUrl, Text, "has-level-" & level + 1 & "-menu", FrontButton, If(String.IsNullOrEmpty(FrontButton), "", "has-add-button"))
            End If

            Return String.Format(itemFormat, FontClass, NavigationUrl, Text, FrontButton, If(String.IsNullOrEmpty(FrontButton), "", "has-add-button"))
        End If
    End Function

    Function IsVisible(Optional userContext As HttpContext = Nothing) As Boolean
        If Not Visible Then
            Return False
        End If

        If userContext Is Nothing AndAlso HttpContext.Current IsNot Nothing Then
            userContext = HttpContext.Current
        Else
            HttpContext.Current = userContext
        End If

        Dim userName = userContext.User.Identity.Name

        If Not String.IsNullOrEmpty(Applications) Then
            If Not Applications.Contains(Employee.GetInstance(userName).AppId) Then
                Return False
            End If
        End If

        If String.IsNullOrEmpty(ItemType) Then
            Return IsUserRoles(userName)
        End If

        Dim type = [Enum].Parse(GetType(NavItemType), ItemType)

        Select Case type
            Case NavItemType.Agent
                If IsUserRoles(userName) Then
                    If Roles.IsUserInRole(userName, "Admin") Then
                        Return False
                    End If

                    If Not UserInTeam.IsUserInTeam(userName) Then
                        Return False
                    End If

                    If Not Employee.HasSubordinates(userName) Then
                        Return True
                    End If
                End If
            Case NavItemType.Manager
                If Roles.IsUserInRole(userName, "Admin") Then
                    Return True
                End If

                If Not UserInTeam.IsUserInTeam(userName) Then
                    Return False
                End If

                If IsUserRoles(userName) Then
                    If Employee.HasSubordinates(userName) Then
                        Return True
                    End If
                End If
            Case NavItemType.Office
                If IsUserRoles(userName) Then
                    Return True
                End If
            Case NavItemType.ShortSale
                If IsUserRoles(userName) Then
                    Return True
                End If
        End Select

        Return False
    End Function

    Function IsUserRoles(userName As String) As Boolean
        If Roles.IsUserInRole(userName, "Admin") Then
            Return True
        End If

        If Not String.IsNullOrEmpty(UserRoles) Then
            For Each rl In UserRoles.Split(",")
                If rl = "OfficeManager-*" Then
                    If Roles.GetRolesForUser(userName).Where(Function(a) a.StartsWith("OfficeManager-")).Count > 0 Then
                        Return True
                    End If
                End If

                If rl.Contains("*") Then
                    If Roles.GetRolesForUser(userName).Where(Function(a) a.StartsWith(rl.Replace("*", ""))).Count > 0 Then
                        Return True
                    End If
                End If

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
        ShortSale
    End Enum
End Class