Imports IntranetPortal.RulesEngine

Public Class TestBusinessRules
    Implements IntranetPortal.RulesEngine.IRulesProvider

    Public Function GetRules() As List(Of BaseRule) Implements IRulesProvider.GetRules
        Throw New NotImplementedException()
    End Function
End Class
