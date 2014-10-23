Class EmployeeItemComparer
    Implements IEqualityComparer(Of Employee)

    Public Function Equals1(x As Employee, y As Employee) As Boolean Implements IEqualityComparer(Of Employee).Equals
        Return x.EmployeeID = y.EmployeeID
    End Function

    Public Function GetHashCode1(obj As Employee) As Integer Implements IEqualityComparer(Of Employee).GetHashCode
        Return obj.EmployeeID.GetHashCode
    End Function
End Class
