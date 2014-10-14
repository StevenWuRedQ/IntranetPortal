Imports Microsoft.SharePoint.Client
Imports Microsoft.SharePoint.Client.Sharing
Imports System.Security

Public Class LoadFileFromSharepoint
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        GetServerClient()
    End Sub

    Sub GetServerClient()
        Dim userName = "georgev@gvs4u.org"
        Dim passwordstr = "Pupamutata1234$"
        Dim serverUrl = "https://gvs4uinc.sharepoint.com"

        Using ClientContext As New ClientContext(serverUrl)
            Dim password As New SecureString
            Array.ForEach(passwordstr.ToCharArray, Sub(c)
                                                       password.AppendChar(c)
                                                   End Sub)

            Dim credentials As New SharePointOnlineCredentials(userName, password)
            ClientContext.Credentials = credentials

            Dim lists = ClientContext.Web.Lists.GetByTitle("Documents")
            ClientContext.Load(lists)
            Dim camlQuery As New CamlQuery
            camlQuery.ViewXml = "<View Scope='RecursiveAll'></View>"
            Dim items = lists.GetItems(camlQuery)
            ClientContext.Load(items)
            ClientContext.ExecuteQuery()

            For Each item As ListItem In items

                Dim File = item.File
                ClientContext.Load(item.File)
                ClientContext.ExecuteQuery()

                'Dim userRoleAssignments As New List(Of UserRoleAssignment)
                'userRoleAssignments.Add(New UserRoleAssignment With
                '                        {.UserId = "EveryOne",
                '                            .Role = Sharing.Role.View
                '                            })

                Dim objInfo = ObjectSharingInformation.GetObjectSharingInformation(ClientContext, item, True, True, True, True, True, True, True)
                ClientContext.Load(objInfo, Function(a As ObjectSharingInformation) a.AnonymousViewLink)
                ClientContext.ExecuteQuery()
                Response.Write(objInfo.AnonymousViewLink + " <br />")

                'Dim returnValue = DocumentSharingManager.UpdateDocumentSharingInfo(ClientContext, File.ServerRelativeUrl, userRoleAssignments, False, False, _
                '    False, "", False)

                'Response.Write(returnValue)

                Response.Write(String.Format("Id: {0}. Name: {1}. Link: {2} <br />", item.Id, item.File.Name, item.File.ServerRelativeUrl))
            Next
        End Using
    End Sub
End Class