Imports DevExpress.Web

Public Class CompanyTree
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Using Context As New Entities
                Dim nodeCompany = TreeViewEmp.RootNode.Nodes(0)
                Dim employeeList As New List(Of Employee)

                For Each position In Context.Employees.GroupBy(Function(emp) emp.Position).OrderBy(Function(emp) emp.Key)
                    Dim groupNode = New TreeViewNode()
                    'groupNode.Name = position.Key
                    groupNode.Name = position.Key
                    groupNode.Text = position.Key

                    For Each emp In position
                        Dim empNode As TreeViewNode = New TreeViewNode()
                        empNode.Text = emp.Name
                        'empNode.Name = String.Format(empNodeNameFormat, emp.EmployeeID)
                        'empNode.Value = emp
                        'empNode.ContextMenuStrip = contextMenuEmployee
                        groupNode.Nodes.Add(empNode)

                        employeeList.Add(emp)
                    Next

                    nodeCompany.Nodes.Add(groupNode)
                Next
            End Using
        End If
    End Sub

End Class