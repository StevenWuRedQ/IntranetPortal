<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitleCommentControl.ascx.vb" Inherits="IntranetPortal.TitleCommentControl" %>
<div>    
    <div class="color_gray upcase_text">Category</div>    
    <select class="select_bootstrap select_margin" id="selCategory" data-required="true" runat="server">
        <option value=""></option>
        <option value="1">Clearance Follow Up</option>
        <option value="2">CTC</option>
    </select>
    <%--<div class="color_gray upcase_text">Status Update</div>
    <select class="select_bootstrap select_margin selStatusUpdate" id="selStatusUpdate" data-required="true" onchange="ShortSale.StatusUpdateChange(this)">
        <option value=""></option>        
    </select>--%>
    <div class="color_gray upcase_text">Follow Up date</div>
    <dx:ASPxDateEdit ID="dtFollowup" Border-BorderStyle="None" CssClass="select_bootstrap" ClientInstanceName="dtClientFollowup" Width="130px" runat="server" DisplayFormatString="d"></dx:ASPxDateEdit>
</div>
