Imports System.Net
Imports System.Web.Http
Imports System.Web.Http.Description
Imports Newtonsoft.Json.Linq
Imports IntranetPortal.Data

Namespace Controllers
    Public Class BusinessFormController
        Inherits ApiController

        <ResponseType(GetType(FormDataItem))>
        <Route("api/BusinessForm/{formName}/{id}")>
        Function GetBusinessForm(id As Integer, formName As String) As IHttpActionResult
            Dim obj = FormDataItem.Instance(id)
            If obj Is Nothing Then
                obj = New FormDataItem With
                      {.FormName = formName}
            Else
                obj.LogOpen(HttpContext.Current.User.Identity.Name)
            End If

            Return Ok(obj)
        End Function

        <ResponseType(GetType(FormDataItem))>
        <Route("api/BusinessForm/{formName}/Tag/{Tag}")>
        Function GetBusinessFormByTag(tag As String, formName As String) As IHttpActionResult
            Dim obj = FormDataItem.Instance(formName, tag)
            If obj Is Nothing Then
                obj = New FormDataItem With
                      {.FormName = formName,
                      .Tag = tag}
            Else
                obj.LogOpen(HttpContext.Current.User.Identity.Name)
            End If
            Return Ok(obj)
        End Function

        <ResponseType(GetType(FormDataItem))>
        Function PostBusinessForm(formItem As FormDataItem) As IHttpActionResult

            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            Try
                formItem.Save(HttpContext.Current.User.Identity.Name)
                formItem.LogSave(HttpContext.Current.User.Identity.Name)
            Catch ex As Exception
                Throw ex
            End Try

            Return Ok(FormDataItem.Instance(formItem.DataId))
        End Function

    End Class


End Namespace