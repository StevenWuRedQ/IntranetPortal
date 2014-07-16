Partial Public Class Agent_Properties
    Public ReadOnly Property HouseNum As String
        Get
            Dim houseNo = Property_Address.Split(" ")(0)
            Return houseNo
        End Get
    End Property

    Public ReadOnly Property StreetName As String
        Get
            If Out_Address.Contains(HouseNum) Or Out_Address.Contains(HouseNum.Replace("-", "")) Then
                Dim tmpStr = Out_Address.Replace(HouseNum, "")
                tmpStr = tmpStr.Replace(HouseNum.Replace("-", ""), "")
                Return tmpStr
            End If
            Return Out_Address
        End Get
    End Property

End Class
