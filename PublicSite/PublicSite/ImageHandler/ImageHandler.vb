Public Class ImageHandler
    Implements IRouteHandler


    Public Function GetHttpHandler(requestContext As RequestContext) As IHttpHandler Implements IRouteHandler.GetHttpHandler

        Dim routeValues = requestContext.RouteData.Values

        If routeValues.ContainsKey("imageId") Then
            Dim imageId = CInt(routeValues("imageId"))
            Dim img = PublicSiteData.PropertyImage.GetImage(imageId)

            If img IsNot Nothing Then
                AddImagetoRequestContext(requestContext, img.ContentType, img.ImageData)
            Else
                requestContext.HttpContext.Response.TransmitFile("~/images/listing-1.jpg")
                requestContext.HttpContext.Response.End()
            End If
        End If

        If routeValues.ContainsKey("agentId") Then
            Dim agent = PublicSiteData.PortalAgent.GetAgent(CInt(routeValues("agentId")))
            If agent.Photo IsNot Nothing Then
                AddImagetoRequestContext(requestContext, "", agent.Photo)
            Else
                requestContext.HttpContext.Response.TransmitFile("~/images/agent-1.jpg")
                requestContext.HttpContext.Response.End()
                'Dim img = System.Drawing.Image.FromStream(New System.IO.FileStream(requestContext.HttpContext.Server.MapPath("~/images/agent-1.jpg"), IO.FileMode.Open))
                'requestContext.HttpContext.Response.Clear()
                'img.Save(requestContext.HttpContext.Response.OutputStream, System.Drawing.Imaging.ImageFormat.Jpeg)
                'requestContext.HttpContext.Response.End()
            End If
        End If

        Return Nothing
    End Function

    Sub AddImagetoRequestContext(requestContext As RequestContext, contextType As String, data As Byte())
        requestContext.HttpContext.Response.Clear()
        requestContext.HttpContext.Response.ContentType = contextType
        requestContext.HttpContext.Response.BufferOutput = True
        requestContext.HttpContext.Response.BinaryWrite(data)
        requestContext.HttpContext.Response.End()
    End Sub
End Class
