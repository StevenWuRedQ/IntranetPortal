Imports System.Text
Imports Microsoft.VisualStudio.TestTools.UnitTesting
Imports IntranetPortal

<TestClass()> Public Class UserTaskTest
    Dim employee = "Chris Yan"
    Dim priority = "Normal"
    Dim taskAction = "User Task Test"
    Dim taskDescription = "User Task Test Description"
    Dim bble = "1018070044"
    Dim createUser = "Chris Yan"
    Dim logCategory As LeadsActivityLog.LogCategory = LeadsActivityLog.LogCategory.SalesAgent

    <TestMethod()> Public Sub ExpiredAgentTaskTest()
        Dim task = Lead.CreateTask("Chris Yan", priority, taskAction, taskDescription, bble, createUser, logCategory)
        Dim taskId = task.TaskID
        Assert.IsTrue(taskId > 0)
        Assert.IsTrue(task.LogID > 0)
        task = UserTask.GetTaskByLogID(task.LogID)
        Assert.AreEqual(CType(task.Status, UserTask.TaskStatus), UserTask.TaskStatus.Active)
        UserTask.ExpiredAgentTasks(bble)
        task = UserTask.GetTaskById(taskId)
        Assert.AreEqual(CType(task.Status, UserTask.TaskStatus), UserTask.TaskStatus.Complete)
    End Sub

End Class