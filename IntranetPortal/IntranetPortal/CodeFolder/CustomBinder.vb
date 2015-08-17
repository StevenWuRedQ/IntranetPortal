Imports System.Runtime.Serialization

Public Class CustomBinder
    Inherits SerializationBinder

    Public Overrides Function BindToType(assemblyName As String, typeName As String) As Type

        Dim newType = typeName.Replace("IntranetPortal.DataAPI", "IntranetPortal.Data.DataAPI")
        Return Type.GetType(String.Format("{0},{1}", newType, "IntranetPortal.Data"))
    End Function

End Class
