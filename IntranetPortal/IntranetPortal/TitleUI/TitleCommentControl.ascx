<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitleCommentControl.ascx.vb" Inherits="IntranetPortal.TitleCommentControl" %>
<div>
    <div style="float: right">
        <div class="color_gray upcase_text">Category</div>
        <select class="select_bootstrap select_margin" id="selCategory" data-required="true" onchange="TitleCommentControl.onItemChanged(this)" runat="server">
            <option value=""></option>
            <option value="0">Initial Review</option>
            <option value="1">Clearance Follow Up</option>
            <option value="2">CTC</option>
        </select>
    </div>

    <div style="float: right">
        <div id="review_manager_div" hidden>
            <div class="color_gray upcase_text">Review Manager</div>
            <asp:DropDownList class="select_bootstrap select_margin" ID="reviewManagers" data-required="true" runat="server"></asp:DropDownList>
        </div>
    </div>
    <div style="float: right">
        <div class="color_gray upcase_text">Follow Up date</div>
        <dx:ASPxDateEdit ID="dtFollowup" Border-BorderStyle="None" CssClass="select_bootstrap" ClientInstanceName="dtClientFollowup" Width="130px" DisplayFormatString="d" runat="server">
        </dx:ASPxDateEdit>
    </div>
</div>


<script>
    TitleCommentControl = function () {

        return {
            onItemChanged: function (el) {
                var review_manager_div = $("#review_manager_div")
                if (el.value == "2") {
                    review_manager_div.show()
                } else {
                    review_manager_div.hide()
                }
            }
        }
    }();
</script>
