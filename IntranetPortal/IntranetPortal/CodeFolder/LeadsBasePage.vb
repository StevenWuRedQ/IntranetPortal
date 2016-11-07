''' <summary>
''' The base class for leads related page
''' The base will handle leads permission, geting BBLE etc.
''' </summary>
Public Class LeadsBasePage
    Inherits PortalPage

    ''' <summary>
    ''' The Property BBLE
    ''' </summary>
    ''' <returns></returns>
    Public Property BBLE As String

    Protected Sub BasePage_load() Handles Me.Load
        If Not Page.IsPostBack Then
            If Request.QueryString("bble") IsNot Nothing Then
                BBLE = Request.QueryString("bble").ToString

                If Not Employee.HasControlLeads(UserName, BBLE) Then
                    Server.Transfer("/PortalError.aspx?code=1001")
                End If

                LoadLeadsData(BBLE)
            Else
                LoadWithoutLeadsData()
            End If
        End If
    End Sub

    Protected Overrides Sub NotAllowdAccess()

    End Sub

    ''' <summary>
    ''' Base method to Load Leads related data
    ''' </summary>
    ''' <param name="bble">The property bble </param>
    Protected Overridable Sub LoadLeadsData(bble As String)

    End Sub

    ''' <summary>
    ''' Base method that call when property address is not specified
    ''' </summary>
    Protected Overridable Sub LoadWithoutLeadsData()
        If Not PageAuthorization Then
            Server.Transfer("/PortalError.aspx?code=1001")
        End If

        Response.Write("No property data is provided. Please check.")
        Response.End()
    End Sub
End Class
