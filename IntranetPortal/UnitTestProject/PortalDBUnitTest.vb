Imports System
Imports System.Collections.Generic
Imports System.Text
Imports Microsoft.Data.Tools.Schema.Sql.UnitTesting
Imports Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions
Imports Microsoft.VisualStudio.TestTools.UnitTesting

<TestClass()>
Public Class PortalDBUnitTest
    Inherits SqlDatabaseTestClass

    Sub New()
        InitializeComponent()
    End Sub

    <TestInitialize()>
    Public Sub TestInitialize()
        InitializeTest()
    End Sub

    <TestCleanup()>
    Public Sub TestCleanup()
        CleanupTest()
    End Sub

    <TestMethod()>
    Public Sub CleaningDataTest()
        Dim testActions As SqlDatabaseTestActions = Me.CleaningDataTestData
        'Execute the pre-test script
        '
        System.Diagnostics.Trace.WriteLineIf(testActions.PretestAction IsNot Nothing, "Executing pre-test script...")
        Dim pretestResults() As SqlExecutionResult = TestService.Execute(Me.PrivilegedContext, Me.PrivilegedContext, testActions.PretestAction)
        'Execute the test script
        '
        System.Diagnostics.Trace.WriteLineIf(testActions.TestAction IsNot Nothing, "Executing test script...")
        Dim testResults() As SqlExecutionResult = TestService.Execute(Me.ExecutionContext, Me.PrivilegedContext, testActions.TestAction)
        'Execute the post-test script
        '
        System.Diagnostics.Trace.WriteLineIf(testActions.PosttestAction IsNot Nothing, "Executing post-test script...")
        Dim posttestResults() As SqlExecutionResult = TestService.Execute(Me.PrivilegedContext, Me.PrivilegedContext, testActions.PosttestAction)
    End Sub

#Region "Designer support code"

    'NOTE: The following procedure is required by the Designer
    'It can be modified using the Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Dim CleaningDataTest_TestAction As Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(PortalDBUnitTest))
        Dim RowCountCondition1 As Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.RowCountCondition
        Me.CleaningDataTestData = New Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions()
        CleaningDataTest_TestAction = New Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction()
        RowCountCondition1 = New Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.RowCountCondition()
        '
        'CleaningDataTest_TestAction
        '
        CleaningDataTest_TestAction.Conditions.Add(RowCountCondition1)
        resources.ApplyResources(CleaningDataTest_TestAction, "CleaningDataTest_TestAction")
        '
        'CleaningDataTestData
        '
        Me.CleaningDataTestData.PosttestAction = Nothing
        Me.CleaningDataTestData.PretestAction = Nothing
        Me.CleaningDataTestData.TestAction = CleaningDataTest_TestAction
        '
        'RowCountCondition1
        '
        RowCountCondition1.Enabled = true
        RowCountCondition1.Name = "RowCountCondition1"
        RowCountCondition1.ResultSet = 1
        RowCountCondition1.RowCount = 0
    End Sub

#End Region

#Region "Additional test attributes"
    '
    ' You can use the following additional attributes as you write your tests:
    '
    ' Use ClassInitialize to run code before running the first test in the class
    ' <ClassInitialize()> Public Shared Sub MyClassInitialize(ByVal testContext As TestContext)
    ' End Sub
    '
    ' Use ClassCleanup to run code after all tests in a class have run
    ' <ClassCleanup()> Public Shared Sub MyClassCleanup()
    ' End Sub
    '
#End Region

    Private CleaningDataTestData As SqlDatabaseTestActions
End Class

