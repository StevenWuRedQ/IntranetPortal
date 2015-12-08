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
    <TestMethod()> _
    Public Sub PoolA1Testing()
        Dim testActions As SqlDatabaseTestActions = Me.PoolA1TestingData
        'Execute the pre-test script
        '
        System.Diagnostics.Trace.WriteLineIf((Not (testActions.PretestAction) Is Nothing), "Executing pre-test script...")
        Dim pretestResults() As SqlExecutionResult = TestService.Execute(Me.PrivilegedContext, Me.PrivilegedContext, testActions.PretestAction)
        Try
            'Execute the test script
            '
            System.Diagnostics.Trace.WriteLineIf((Not (testActions.TestAction) Is Nothing), "Executing test script...")
            Dim testResults() As SqlExecutionResult = TestService.Execute(Me.ExecutionContext, Me.PrivilegedContext, testActions.TestAction)
        Finally
            'Execute the post-test script
            '
            System.Diagnostics.Trace.WriteLineIf((Not (testActions.PosttestAction) Is Nothing), "Executing post-test script...")
            Dim posttestResults() As SqlExecutionResult = TestService.Execute(Me.PrivilegedContext, Me.PrivilegedContext, testActions.PosttestAction)
        End Try
    End Sub


#Region "Designer support code"

    'NOTE: The following procedure is required by the Designer
    'It can be modified using the Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Dim CleaningDataTest_TestAction As Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(PortalDBUnitTest))
        Dim ScalarValueCondition1 As Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.ScalarValueCondition
        Dim PoolA1Testing_TestAction As Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction
        Dim ScalarValueCondition2 As Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.ScalarValueCondition
        Me.CleaningDataTestData = New Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions()
        Me.PoolA1TestingData = New Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions()
        CleaningDataTest_TestAction = New Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction()
        ScalarValueCondition1 = New Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.ScalarValueCondition()
        PoolA1Testing_TestAction = New Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction()
        ScalarValueCondition2 = New Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.ScalarValueCondition()
        '
        'CleaningDataTest_TestAction
        '
        CleaningDataTest_TestAction.Conditions.Add(ScalarValueCondition1)
        resources.ApplyResources(CleaningDataTest_TestAction, "CleaningDataTest_TestAction")
        '
        'ScalarValueCondition1
        '
        ScalarValueCondition1.ColumnNumber = 1
        ScalarValueCondition1.Enabled = true
        ScalarValueCondition1.ExpectedValue = "0"
        ScalarValueCondition1.Name = "ScalarValueCondition1"
        ScalarValueCondition1.NullExpected = false
        ScalarValueCondition1.ResultSet = 1
        ScalarValueCondition1.RowNumber = 1
        '
        'CleaningDataTestData
        '
        Me.CleaningDataTestData.PosttestAction = Nothing
        Me.CleaningDataTestData.PretestAction = Nothing
        Me.CleaningDataTestData.TestAction = CleaningDataTest_TestAction
        '
        'PoolA1TestingData
        '
        Me.PoolA1TestingData.PosttestAction = Nothing
        Me.PoolA1TestingData.PretestAction = Nothing
        Me.PoolA1TestingData.TestAction = PoolA1Testing_TestAction
        '
        'PoolA1Testing_TestAction
        '
        PoolA1Testing_TestAction.Conditions.Add(ScalarValueCondition2)
        resources.ApplyResources(PoolA1Testing_TestAction, "PoolA1Testing_TestAction")
        '
        'ScalarValueCondition2
        '
        ScalarValueCondition2.ColumnNumber = 1
        ScalarValueCondition2.Enabled = true
        ScalarValueCondition2.ExpectedValue = "0"
        ScalarValueCondition2.Name = "ScalarValueCondition2"
        ScalarValueCondition2.NullExpected = false
        ScalarValueCondition2.ResultSet = 1
        ScalarValueCondition2.RowNumber = 1
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
    Private PoolA1TestingData As SqlDatabaseTestActions
End Class

