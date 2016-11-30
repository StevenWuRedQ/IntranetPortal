Public Class Class1
    Public Sub test()
        Dim server = New ININ.PureCloudApi.Api.OutboundApi
        Dim contact = server.GetContactlistsContactlistIdContactsContactId("1", "1")
        contact.Callable = True
    End Sub
End Class
