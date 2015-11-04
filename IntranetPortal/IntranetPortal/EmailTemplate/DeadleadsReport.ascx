<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="DeadleadsReport.ascx.vb" Inherits="IntranetPortal.DeadleadsReport" %>
<style type="text/css">
    table {
        border-collapse: collapse;
    }

    table, th, td {
        border: 1px solid black;
    }

    thead {
        font-weight: bold;
        background-color: #efefef;
    }

    td {
        padding: 5px 10px;
    }
</style>

Dear Manager,
<br />
<br />
Below is report of Deadleads today (<%= DateTime.Today.ToShortDateString() %>). Please review.
<br />
<br />
<table style="margin-left: 15px; border: 1px solid black">
    <thead>
        <tr>
            <td>Team</td>
            <td style="width:80px">Deed Recorded with Other Party</td>
            <td style="width:80px">Loan MOD</td>
            <td style="width:80px">ShortSale with another company</td>
            <td style="width:80px">MOD Completed</td>
            <td style="width:80px">Not Interested</td>
            <td style="width:80px">Unable to contact</td>
            <td style="width:80px">Manager disapproved</td>
            <td>Others</td>
            <td>Total</td>
        </tr>
    </thead>
    <tbody>
        <%
            Dim items = ActivityData.GroupBy(Function(ad) ad.TeamName).Select(Function(ag) New With {.Key = ag.Key, .Amount = ag.Sum(Function(l) l.DeadLeadsAmount), .Data = ag.ToList}).ToList
        %>

        <% For Each groupData In items %>
        <% Dim lds = New List(Of IntranetPortal.Lead)
            groupData.Data.Select(Function(d)
                                      lds.AddRange(d.DeadLeads)
                                      Return d.DeadLeads
                                  End Function).ToList
        %>
        <tr>
            <td><a href="#<%=groupData.Key%>"><%= groupData.Key %></a></td>
            <td><%= lds.Where(Function(l) l.DeadReason = IntranetPortal.Lead.DeadReasonEnum.DeadRecord).Count  %></td>
            <td><%= lds.Where(Function(l) l.DeadReason = IntranetPortal.Lead.DeadReasonEnum.LoanMod).Count  %></td>
            <td><%= lds.Where(Function(l) l.DeadReason = IntranetPortal.Lead.DeadReasonEnum.ShortSaleWithOther).Count  %></td>
            <td><%= lds.Where(Function(l) l.DeadReason = IntranetPortal.Lead.DeadReasonEnum.ModCompleted).Count  %></td>
            <td><%= lds.Where(Function(l) l.DeadReason = IntranetPortal.Lead.DeadReasonEnum.NotInterested).Count  %></td>
            <td><%= lds.Where(Function(l) l.DeadReason = IntranetPortal.Lead.DeadReasonEnum.UnableToContact).Count  %></td>
            <td><%= lds.Where(Function(l) l.DeadReason = IntranetPortal.Lead.DeadReasonEnum.MgrDisapproved).Count  %></td>
            <td><%= lds.Where(Function(l) (Not l.DeadReason.HasValue) OrElse l.DeadReason < 1).Count %></td>
            <td><a href="#<%=groupData.Key%>"><%= groupData.Amount %></a></td>
        </tr>

        <% Next%>
    </tbody>
</table>
<br />
<h3>Team Breakdown:</h3>
<% For Each item In items%>
<table id="<%=item.Key %>" style="margin-left: 15px; border: 1px solid black; border-collapse: collapse; border-spacing: 0px; width: 700px" border="1" cellspacing="0">
    <thead>
        <tr>
            <td>Team: <%=item.Key%> (<%= item.Amount %>)</td>
        </tr>
    </thead>
    <tr>
        <td>
            <% If item.Amount > 0 Then%>
            <% For Each act In item.Data%>
            <% If act.DeadLeadsAmount > 0 %>
            <strong>Agent: <%= act.Name %> (<%= act.DeadLeadsAmount %>)</strong>
            <ul>
                <% For each ld In act.DeadLeads %>
                <li>
                    <a href="http://portal.myidealprop.com/viewleadsinfo.aspx?id=<%=ld.BBLE%>" target="_blank">
                        <%= ld.LeadsName %> 
                    </a>&nbsp;
                    <br />
                    <% If ld.DeadReason.HasValue Then %>
                    (<%= IntranetPortal.Core.Utility.GetEnumDescription(CType(ld.DeadReason, IntranetPortal.Lead.DeadReasonEnum)) & " - " & ld.Description %>)
                    <% End If %>
                </li>
                <% Next %>
            </ul>
            <% End If %>
            <% Next%>
            <% End If%>
        </td>
    </tr>
</table>
<br />
<% Next %>
<br />
More info, please <a href="http://portal.myidealprop.com/">click here</a>.
<br />
<br />
<br />
Regards,<br />
The Portal Team<br />
<small>(This is an automatic email. Please do not reply.)</small><br />
