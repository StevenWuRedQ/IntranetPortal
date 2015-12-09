Imports SearchFilter
Imports System.Reflection

Public Class ALL_NYC_Tax_Liens_CO_Info
    Public ReadOnly Property LpUserSold As Boolean
        Get
            Return FilterLogic.LPSoldPortry(BBLE)
        End Get
    End Property


   
End Class
