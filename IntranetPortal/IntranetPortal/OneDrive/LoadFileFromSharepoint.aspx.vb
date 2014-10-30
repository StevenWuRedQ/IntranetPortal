Imports Microsoft.SharePoint.Client
Imports Microsoft.SharePoint.Client.Sharing
Imports System.Security
Imports System.IO
Imports IntranetPortal.Core

Public Class LoadFileFromSharepoint
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            GetServerClient()
        End If
    End Sub

    Public Sub PreviewContent(fileName As String)
        Using ClientContext = GetClientContext()
            Dim fileUrl = "/Shared Documents/" & fileName

            Dim fileItem = ClientContext.Web.GetFileByServerRelativeUrl(fileUrl)

            Dim objInfo = ObjectSharingInformation.GetObjectSharingInformation(ClientContext, fileItem.ListItemAllFields, True, True, True, True, True, True, True)
            ClientContext.Load(objInfo, Function(a As ObjectSharingInformation) a.AnonymousViewLink)
            ClientContext.ExecuteQuery()

            Response.Redirect(objInfo.AnonymousViewLink)
        End Using
    End Sub

    Public Sub PreviewContentByUniqueId(uniqueId As String)
        Using ClientContext = GetClientContext()
            Dim list = ClientContext.Web.Lists.GetByTitle("Documents")
            Dim camlQuery As New CamlQuery
            camlQuery.ViewXml = String.Format("<View><Query><Where><Eq><FieldRef Name='UniqueId'/><Value Type='Guid'>{0}</Value></Contains></Where></Query></View>", uniqueId)
            Dim items = list.GetItems(camlQuery)
            ClientContext.Load(items)
            ClientContext.ExecuteQuery()

            If items.Count = 1 Then
                Dim objInfo = ObjectSharingInformation.GetObjectSharingInformation(ClientContext, items(0), True, True, True, True, True, True, True)
                ClientContext.Load(objInfo, Function(a As ObjectSharingInformation) a.AnonymousViewLink)
                ClientContext.ExecuteQuery()

                Response.Redirect(objInfo.AnonymousViewLink)
            End If
            
        End Using
    End Sub

    Public Function GetClientContext() As ClientContext
        Dim userName = "georgev@gvs4u.org"
        Dim passwordstr = "Pupamutata1234$"
        Dim serverUrl = "https://gvs4uinc.sharepoint.com"
        Dim password As New SecureString
        Dim clientContext As New ClientContext(serverUrl)
        Array.ForEach(passwordstr.ToCharArray, Sub(c)
                                                   password.AppendChar(c)
                                               End Sub)

        Dim credentials As New SharePointOnlineCredentials(userName, password)
        clientContext.Credentials = credentials

        Return clientContext
    End Function

    Sub GetServerClient()
        Dim userName = "ron@MyIdealPropertyInc.onmicrosoft.com"
        Dim passwordstr = "Unlock12"
        Dim serverUrl = "https://myidealpropertyinc.sharepoint.com"

        Using ClientContext As New ClientContext(serverUrl)
            Dim password As New SecureString
            Array.ForEach(passwordstr.ToCharArray, Sub(c)
                                                       password.AppendChar(c)
                                                   End Sub)

            Dim credentials As New SharePointOnlineCredentials(userName, password)
            ClientContext.Credentials = credentials

            Dim docs = ClientContext.Web.Lists
            ClientContext.Load(docs)
            ClientContext.ExecuteQuery()

            For Each File In docs
                ClientContext.Load(File)
                ClientContext.ExecuteQuery()

                Response.Write(File.Title + "<br />")
            Next

            Return

            Dim lists = ClientContext.Web.Lists.GetByTitle("Documents")
            ClientContext.Load(lists)
            Dim camlQuery As New CamlQuery
            camlQuery.ViewXml = "<View Scope='RecursiveAll'></View>"
            Dim items = lists.GetItems(camlQuery)
            ClientContext.Load(items)
            ClientContext.ExecuteQuery()

            For Each item As ListItem In items
                If item.FileSystemObjectType = FileSystemObjectType.File Then
                    Dim File = item.File
                    ClientContext.Load(item.File)
                    ClientContext.ExecuteQuery()

                    If item.File IsNot Nothing Then
                        Dim objInfo = ObjectSharingInformation.GetObjectSharingInformation(ClientContext, item, True, True, True, True, True, True, True)
                        ClientContext.Load(objInfo, Function(a As ObjectSharingInformation) a.AnonymousViewLink)
                        ClientContext.ExecuteQuery()

                        Response.Write(objInfo.AnonymousViewLink + " <br />")
                        Response.Write(String.Format("Id: {0}. Name: {1}. Link: {2} <br />", item.Id, item.File.Name, item.File.ServerRelativeUrl))
                    End If
                End If
            Next
        End Using
    End Sub

    Protected Sub btnUpload_Click(sender As Object, e As EventArgs)
        Dim cate = "7945614444/Sales"
        DocumentService.UploadFile(cate, fileUpload.FileBytes, fileUpload.FileName)
        Return

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
            ClientContext.ExecuteQuery()

            Dim fileUrl = "/Shared Documents/" & fileUpload.FileName

            Using fs As New MemoryStream(fileUpload.FileBytes)
                Microsoft.SharePoint.Client.File.SaveBinaryDirect(ClientContext, fileUrl, fs, True)
            End Using

            Dim userRoleAssignments As New List(Of UserRoleAssignment)
            userRoleAssignments.Add(New UserRoleAssignment With
                                    {.UserId = "Everyone",
                                        .Role = Sharing.Role.View
                                        })
            Dim returnValue = DocumentSharingManager.UpdateDocumentSharingInfo(ClientContext, serverUrl & fileUrl, userRoleAssignments, False, True, True, "", True)
            ClientContext.ExecuteQuery()

            GetServerClient()
            Return
        End Using
        '    ClientContext.Load(lists)
        '    Dim camlQuery As New CamlQuery
        '    camlQuery.ViewXml = "<View Scope='RecursiveAll'></View>"
        '    Dim items = lists.GetItems(camlQuery)
        '    ClientContext.Load(items)
        '    ClientContext.ExecuteQuery()

        '    For Each item As ListItem In items

        '        Dim File = item.File
        '        ClientContext.Load(item.File)
        '        ClientContext.ExecuteQuery()

        '        'Dim userRoleAssignments As New List(Of UserRoleAssignment)
        '        'userRoleAssignments.Add(New UserRoleAssignment With
        '        '                        {.UserId = "EveryOne",
        '        '                            .Role = Sharing.Role.View
        '        '                            })

        '        Dim objInfo = ObjectSharingInformation.GetObjectSharingInformation(ClientContext, item, True, True, True, True, True, True, True)
        '        ClientContext.Load(objInfo, Function(a As ObjectSharingInformation) a.AnonymousViewLink)
        '        ClientContext.ExecuteQuery()
        '        Response.Write(objInfo.AnonymousViewLink + " <br />")

        '        'Dim returnValue = DocumentSharingManager.UpdateDocumentSharingInfo(ClientContext, File.ServerRelativeUrl, userRoleAssignments, False, False, _
        '        '    False, "", False)

        '        'Response.Write(returnValue)

        '        Response.Write(String.Format("Id: {0}. Name: {1}. Link: {2} <br />", item.Id, item.File.Name, item.File.ServerRelativeUrl))
        '    Next
        'End Using
    End Sub


    Protected Sub btnShare_Click(sender As Object, e As EventArgs)
        Dim userName = "georgev@gvs4u.org"
        Dim passwordstr = "Pupamutata1234$"
        Dim serverUrl = "https://gvs4uinc.sharepoint.com"
        Dim fileUrl = "https://gvs4uinc.sharepoint.com/Shared%20Documents/page2.jpg"

        Using ClientContext As New ClientContext(serverUrl)
            Dim password As New SecureString
            Array.ForEach(passwordstr.ToCharArray, Sub(c)
                                                       password.AppendChar(c)
                                                   End Sub)

            Dim credentials As New SharePointOnlineCredentials(userName, password)
            ClientContext.Credentials = credentials
            Dim lists = ClientContext.Web.Lists.GetByTitle("Documents")
            'ClientContext.ExecuteQuery()

            Dim userRoleAssignments As New List(Of UserRoleAssignment)
            userRoleAssignments.Add(New UserRoleAssignment() With
                                    {
                                        .UserId = "Everyone",
                                        .Role = Sharing.Role.View
                                        }
                                    )

            Dim returnValue = DocumentSharingManager.UpdateDocumentSharingInfo(ClientContext, fileUrl, userRoleAssignments, False, True, True, "", True)
            ClientContext.ExecuteQuery()
        End Using

    End Sub

    Protected Sub Button1_Click(sender As Object, e As EventArgs)
        CreateSharigLink(txtFileName.Text)
        PreviewContent(txtFileName.Text)
    End Sub

    Public Sub CreateSharigLink(fileName As String)
        Dim fileUrl = "/Shared Documents/" & fileName
        Dim serverUrl = "https://gvs4uinc.sharepoint.com"

        Using ClientContext = GetClientContext()
            Dim userRoleAssignments As New List(Of UserRoleAssignment)
            userRoleAssignments.Add(New UserRoleAssignment With
                                    {.UserId = "Everyone",
                                        .Role = Sharing.Role.View
                                        })
            Dim returnValue = DocumentSharingManager.UpdateDocumentSharingInfo(ClientContext, serverUrl & fileUrl, userRoleAssignments, False, True, True, "", True)
            ClientContext.ExecuteQuery()
        End Using
    End Sub
End Class