Imports System.Data.Entity
Imports IntranetPortal
Imports Newtonsoft.Json

Public Class MockDB

    ' if our code have data proivder layer or we have mock database
    ' we don't need this
    ' mock test leads will delete it automatically
    ' Func(Of Void, Void) not working now will do research later
    Public Shared Sub MockLeads(mockCtx As Entities, mLead As Lead, mCount As Integer, testFunc As Func(Of Integer))
        Dim ls = New Lead(mCount) {}
        Dim jlead = mLead.ToJsonString()
        Dim i = 0
        For Each lt In ls
            ls(i) = JsonConvert.DeserializeObject(Of Lead)(jlead)
            Dim ld = ls(i)

            ' BBLE start at 8 may never used BBLE 
            ' If there Then is any error ask Chris when changed 
            ' BBLE after this
            ld.BBLE = CStr(8000151131 + i)
            ' for safety
            ld.AssignDate = DateTime.Now()
            i = i + 1
            ' Return ld
        Next

        'Using mockCtx As New Entities
        mockCtx.Leads.AddRange(ls)
        mockCtx.Leads.Count()
        mockCtx.SaveChanges()
        ' use try catch to clear database anyway
        ' can change to goto
        Try
            testFunc()
        Catch ex As Exception
            ' need clear test database any way
            mockCtx.Leads.RemoveRange(ls)
            mockCtx.SaveChanges()
            Throw ex
        End Try
        mockCtx.Leads.RemoveRange(ls)
        mockCtx.SaveChanges()

        'End Using
    End Sub

    Public Shared Sub MockLead(mockEntity As Entities, mLead As Lead, testFunc As Func(Of Integer))

        mockEntity.Leads.Add(mLead)

        mLead.AssignBy = "Testing" ' for save
        mockEntity.SaveChanges()
        Try
            testFunc()
        Catch ex As Exception
            mockEntity.Leads.Remove(mLead)
            mockEntity.SaveChanges()
            Console.WriteLine(ex.ToString())
            'Assert.Fail(
            ' String.Format("Unexpected exception of type {0} caught: {1}",
            '                ex.GetType(), ex.Message))
            ' stack trace

            Throw ex
        End Try
        mockEntity.Leads.Remove(mLead)
        mockEntity.SaveChanges()
    End Sub

    Public Shared Function GetLeadsCountByStatusHelper(ctx As Entities, testEmloyee As String, status As LeadStatus) As Integer
        Return ctx.Leads.Where(Function(l) l.Status = status AndAlso l.EmployeeName = testEmloyee).Count
    End Function

    Public Shared Sub Mock(Of MockT As Class)(ctx As DbContext,
                                              data As MockT,
                                              testFunc As Func(Of Integer),
                                              Optional findMock As Expressions.Expression(Of Func(Of MockT, Boolean)) = Nothing)

        ' if need clear database mockdate give find mock function
        If (findMock IsNot Nothing) Then
            Dim mockData = ctx.Set(Of MockT)().Where(findMock).ToArray()

            If mockData.Any() Then
                ctx.Set(Of MockT)().RemoveRange(mockData)
                ctx.SaveChanges()
            End If
        End If

        ctx.Set(Of MockT)().Add(data)
        ctx.SaveChanges()

        Try
            testFunc()
        Catch ex As Exception

            ctx.Set(Of MockT)().Remove(data)
            ctx.SaveChanges()
            Console.WriteLine(ex.ToString())
            'Assert.Fail(
            ' String.Format("Unexpected exception of type {0} caught: {1}",
            '                ex.GetType(), ex.Message))
            ' stack trace

            Throw ex
        End Try
        ctx.Set(Of MockT)().Remove(data)
        ctx.SaveChanges()
    End Sub
End Class
