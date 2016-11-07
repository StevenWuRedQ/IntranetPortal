Imports DevExpress.Web

Public Class MySummary
    Inherits System.Web.UI.UserControl

    Private SummaryItems As New List(Of SummaryItemBase)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            spanWorklistCount.InnerHtml = IntranetPortal.WorkflowService.GetMyWorklist().Count
            spanAppointmentCount.InnerHtml = IntranetPortal.UserAppointment.GetMyTodayAppointments(Page.User.Identity.Name).Count

            For Each ctr In SummaryItems
                ctr.BindData()
            Next
        End If
    End Sub

    Protected Sub rptModules_ItemDataBound(sender As Object, e As RepeaterItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim ascx = CType(e.Item.DataItem, SummaryItemBase)
            Dim myControl = CType(ascx.LoadControl("~/UserControl/SummaryItem/" & ascx.ControlFileName), SummaryItemBase)
            'Dim myControl = CType(Page.LoadControl(), SummaryItemBase)
            myControl.ID = "Control" & e.Item.ItemIndex
            myControl.Parameters = ascx.Parameters
            SummaryItems.Add(myControl)
            'myControl.BindData()

            Dim lt = CType(e.Item.FindControl("ltContainer"), HtmlControl)
            lt.Controls.Add(myControl)
        End If
    End Sub

    Private Sub MySummary_Init(sender As Object, e As EventArgs) Handles Me.Init
        Dim name = "Default"

        If Not String.IsNullOrEmpty(Request.QueryString("Name")) Then
            name = Request.QueryString("Name").ToString
        End If

        Dim models = SummaryControlSetting.LoadSettings(name)
        rptModules.DataSource = models
        rptModules.DataBind()
    End Sub

    Public Class SummaryControlSetting

        Public Property Name As String
        Public Property ControlSettings As List(Of SummaryItemBase)

        Private Shared Settings As List(Of SummaryControlSetting)

        Public Shared Function LoadSettings(name As String) As List(Of SummaryItemBase)
            If Settings Is Nothing Then
                Settings = New List(Of SummaryControlSetting) From {
                    New SummaryControlSetting() With {
                        .Name = "Default",
                        .ControlSettings = New List(Of SummaryItemBase) From {
                             New SummaryItemBase() With {.ControlFileName = "TaskItem.ascx"},
                             New SummaryItemBase() With {.ControlFileName = "AppointmentItem.ascx"},
                             New SummaryItemBase() With {.ControlFileName = "FollowUpItem.ascx"},
                             New SummaryItemBase() With {.ControlFileName = "CalendarItem.ascx"}}
                    },
                    New SummaryControlSetting() With {
                        .Name = "NewOffer",
                        .ControlSettings = New List(Of SummaryItemBase) From {
                             New SummaryItemBase() With {.ControlFileName = "NewOfferItem.ascx",
                                                         .Parameters = New Dictionary(Of String, Object) From {
                                                                               {"mgrView", PropertyOfferManage.ManagerView.Completed}
                                                                           }
                                                        },
                             New SummaryItemBase() With {.ControlFileName = "NewOfferItem.ascx",
                                                         .Parameters = New Dictionary(Of String, Object) From {
                                                                               {"mgrView", PropertyOfferManage.ManagerView.InProcess}
                                                                          }},
                             New SummaryItemBase() With {.ControlFileName = "NewOfferItem.ascx",
                                                         .Parameters = New Dictionary(Of String, Object) From {
                                                                               {"mgrView", PropertyOfferManage.ManagerView.SSAccepted}
                                                                          }}
                    }},
                     New SummaryControlSetting() With {
                        .Name = "UnderWriter",
                        .ControlSettings = New List(Of SummaryItemBase) From {
                             New SummaryItemBase() With {.ControlFileName = "UnderWriterItem.ascx",
                                                         .Parameters = New Dictionary(Of String, Object) From {
                                                                               {"caseStatus", 0}
                                                                           }
                                                        },
                             New SummaryItemBase() With {.ControlFileName = "UnderWriterItem.ascx",
                                                         .Parameters = New Dictionary(Of String, Object) From {
                                                                               {"caseStatus", 2}
                                                                          }},
                            New SummaryItemBase() With {.ControlFileName = "UnderWriterItem.ascx",
                                                         .Parameters = New Dictionary(Of String, Object) From {
                                                                               {"caseStatus", 3}
                                                                          }},
                            New SummaryItemBase() With {.ControlFileName = "UnderWriterItem.ascx",
                                                .Parameters = New Dictionary(Of String, Object) From {
                                                {"caseStatus", 4}
                                        }}
                    }},
                    New SummaryControlSetting() With {
                        .Name = "Title",
                        .ControlSettings = New List(Of SummaryItemBase) From {
                            New SummaryItemBase() With {.ControlFileName = "FollowUpItem2.ascx"
                                                      },
                             New SummaryItemBase() With {.ControlFileName = "TitlesByCategoryItem.ascx",
                                                         .Parameters = New Dictionary(Of String, Object) From {
                                                            {"CategoryId", 1}
                                                         }},
                             New SummaryItemBase() With {.ControlFileName = "TitlesByCategoryItem.ascx",
                                                         .Parameters = New Dictionary(Of String, Object) From {
                                                            {"CategoryId", 2}
                                                         }},
                                                          New SummaryItemBase() With {.ControlFileName = "TitlesByCategoryItem.ascx",
                                                         .Parameters = New Dictionary(Of String, Object) From {
                                                            {"CategoryId", 3}
                                                         }},
                                                          New SummaryItemBase() With {.ControlFileName = "TitlesByCategoryItem.ascx",
                                                         .Parameters = New Dictionary(Of String, Object) From {
                                                            {"CategoryId", 4}
                                                         }},
                                                          New SummaryItemBase() With {.ControlFileName = "TitlesByCategoryItem.ascx",
                                                         .Parameters = New Dictionary(Of String, Object) From {
                                                            {"CategoryId", 5}
                                                         }}
                                                      }
                    }}

                'New SummaryItemBase() With {.ControlFileName = "TitlesByCategoryItem.ascx",
                '                                .Parameters = New Dictionary(Of String, Object) From {
                '                                   {"CategoryId", 0}, {"IsTitleStatus", True}
                '                                }},
                '                                   New SummaryItemBase() With {.ControlFileName = "TitlesByCategoryItem.ascx",
                '                                .Parameters = New Dictionary(Of String, Object) From {
                '                                   {"CategoryId", 1}, {"IsTitleStatus", True}
                '                                }},
                '                                   New SummaryItemBase() With {.ControlFileName = "TitlesByCategoryItem.ascx",
                '                                .Parameters = New Dictionary(Of String, Object) From {
                '                                   {"CategoryId", 2}, {"IsTitleStatus", True}
                '                                }}
            End If

            If Settings.Any(Function(s) s.Name = name) Then
                Return Settings.Where(Function(s) s.Name = name).SingleOrDefault.ControlSettings
            Else
                Return Nothing
            End If
        End Function


    End Class

End Class