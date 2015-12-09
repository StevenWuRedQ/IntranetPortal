Imports System.Web
Imports System.Web.Script.Serialization
Imports IntranetPortal.Data

Namespace Messager

    Public Class MessagerAsyncHandler
        Implements IHttpAsyncHandler
        Public Shared LegalFollowCheckTime As DateTime?
        Public Function BeginProcessRequest(context As HttpContext, cb As AsyncCallback, extraData As Object) As IAsyncResult Implements IHttpAsyncHandler.BeginProcessRequest
            'Refresh online user list
            'move refresh action to Global.asax Application_AuthicatedRequest
            'OnlineUser.Refresh(HttpContext.Current)

            'diable task popup notify
            'UserTask.UpdateNotify()
            InitLegalFollowUp()
            Dim msg = UserMessage.GetNewMessage(context.User.Identity.Name)
            Dim result = New MessagerAsyncResult(context, msg)

            Return result
        End Function
        Sub InitLegalFollowUp()

            If (LegalFollowCheckTime Is Nothing) Then
                LegalFollowCheckTime = Date.Now
            End If

            Dim passTime As TimeSpan = (Date.Now - LegalFollowCheckTime)
            Dim needCheck = passTime.Minutes >= CInt(Core.PortalSettings.GetValue("LegalFollowUpTime"))

            If (Not needCheck) Then
                Return
            End If

            LegalFollowCheckTime = Date.Now
            Dim user = HttpContext.Current.User

            If (user.IsInRole("Legal-Attorney") Or user.IsInRole("Legal-Research") Or user.IsInRole("Legal-Manager")) Then
                Dim emp = Employee.GetInstance(user.Identity.Name)
                Dim followUpCaseToday = LegalCase.GetFollowUpCaseByUser(emp.Name).Where(Function(o) o.FollowUp = Date.Now.Date).ToList
                If (followUpCaseToday.Count > 0) Then
                    For Each c In followUpCaseToday
                        UserMessage.AddNewMessage(emp.Name, "Legal Case Follow Up", "You have follow up case today ! " & c.CaseName & ", please check !", c.BBLE, "/LegalUI/LegalUI.aspx?bble=" & c.BBLE)
                    Next

                End If
            End If
        End Sub
        Public Sub EndProcessRequest(result As IAsyncResult) Implements IHttpAsyncHandler.EndProcessRequest
            Dim rslt = CType(result, MessagerAsyncResult)
            Dim user = rslt.context.User.Identity.Name

            Dim json As New JavaScriptSerializer
            Dim jsonString = json.Serialize(rslt.Message)

            If rslt.Message IsNot Nothing Then
                rslt.context.Response.Clear()
                rslt.context.Response.ContentType = "text/html"
                rslt.context.Response.Write(jsonString)
            End If
        End Sub

        Public ReadOnly Property IsReusable As Boolean Implements IHttpHandler.IsReusable
            Get
                Return True
            End Get
        End Property

        Public Sub ProcessRequest(context As HttpContext) Implements IHttpHandler.ProcessRequest
            Throw New NotImplementedException()
        End Sub

    End Class
End Namespace

