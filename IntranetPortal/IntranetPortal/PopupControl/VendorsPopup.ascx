<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="VendorsPopup.ascx.vb" Inherits="IntranetPortal.VendorsPopup" %>

<dx:ASPxPopupControl ID="VendorsPopup" runat="server"
    ClientInstanceName="VendorsPopupClient"
    Width="1000" Height="730px" CloseAction="CloseButton"
    MaxWidth="1300" MinWidth="500"
    HeaderText="Email" Modal="true" AllowResize="true"
    EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
    <HeaderTemplate>
        <div class="clearfix">
            <div class="pop_up_header_margin">
                <i class="fa fa-users with_circle pop_up_header_icon"></i>
                <span class="pop_up_header_text">Vendors</span>
            </div>
            <div class="pop_up_buttons_div">
                <i class="fa fa-times icon_btn" onclick="VendorsPopupClient.Hide()"></i>
            </div>
        </div>
    </HeaderTemplate>
    <ContentCollection>
        <dx:PopupControlContentControl runat="server" ID="VendorsPopupContent">
            <div style="color:#b1b2b7" class="clearfix">
                <div class="row">
                    <div class="col-md-3">
                        <div style="font-size: 16px; color: #3993c1; font-weight: 700">
                            <ul class="list-group" style="box-shadow: none">

                                <li class="list-group-item popup_menu_list_item">All Vendors</li>
                                <li class="list-group-item popup_menu_list_item">Employees</li>
                                <li class="list-group-item popup_menu_list_item">Title Companies</li>
                                <li class="list-group-item popup_menu_list_item">Attorneys</li>
                                <li class="list-group-item popup_menu_list_item">Sellers</li>
                                <li class="list-group-item popup_menu_list_item">{{ hello}}</li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-md-4" style="border-left: 1px solid #eee; border-right: 1px solid #eee">
                        <div style="padding: 0 10px">
                            <div>

                                <div class="clearfix" style="color: #234b60; font-size: 20px">
                                    Employees
                                           <div style="float: right">
                                               <i class="fa fa-sort-amount-desc" style="color: #999ca1"></i>
                                           </div>
                                </div>
                                <input style="margin-top: 20px;" type="text" class="form-control" placeholder="Type employee's name">

                                <div style="margin-top: 10px; height: 350px; overflow: auto" id="employee_list">
                                    <div>
                                        <ul class="list-group" style="box-shadow: none">
                                            <li class="list-group-item popup_menu_list_item" style="font-size: 18px; width: 80px; cursor: default; font-weight: 900">A
                                                <span class="badge" style="font-size: 18px; border-radius: 18px;">2</span>

                                            </li>

                                            <li class="list-group-item popup_menu_list_item popup_employee_list_item">
                                                <div>
                                                    <div style="font-weight: 900; font-size: 16px">
                                                        Alko Kone  
                                                        <i class="fa fa-list-alt icon_btn" style="float: right; margin-right: 20px; margin-top: 10px; font-size: 18px;"></i>

                                                    </div>
                                                    <div style="font-size: 14px">Eviction</div>

                                                </div>

                                            </li>

                                        </ul>
                                    </div>
                                </div>
                                <div style="margin-top:20px">
                                    <%--Press ‘Ctrl’ or ‘Command’ for multiple selections.--%>
                                    Check to muliple selections.
                                </div>
                                <div  style="margin-top:20px">
                                    <i class="fa fa-plus-circle tooltip-examples icon_btn" title="Add" style="color: #3993c1;font-size:24px" onclick=""></i>
                                </div>
                            </div>

                        </div>
                    </div>
                    <div class="col-md-5">
                        <div style="padding: 10px; border-bottom: 1px solid #eee">
                            <div style="padding-bottom: 20px;">
                                <table>
                                    <tr>
                                        <td>
                                            <img src="/images/agent_pic_defined.png" class="img-circle" style="width: 100px; height: 100px" />
                                        </td>
                                        <td>
                                            <div class="detail_right">
                                                <div style="font-size: 30px; color: #234b60">{{currentContact.Name}}</div>
                                                <div style="font-size: 16px; color: #234b60; font-weight: 900">Sales Agent</div>
                                            </div>
                                        </td>
                                        <td valign="top">
                                            <input style="margin-left:40px;" type="button" class="rand-button short_sale_edit" value="Edit" onclick="">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div style="height: 45px">
                                                &nbsp;
                                            </div>
                                        </td>
                                    </tr>
                                    <tr class="vendor_info">
                                        <td class="vendor_info_left">Manager
                                         </td>
                                        <td>
                                            <div class="detail_right">Ron Borovinsky</div>
                                        </td>
                                    </tr>
                                     <tr class="vendor_info">
                                        <td class="vendor_info_left">Office
                                         </td>
                                        <td>
                                            <div class="detail_right">Sales (Brooklyn)</div>
                                        </td>
                                    </tr>
                                     <tr class="vendor_info">
                                        <td class="vendor_info_left">Employee Since
                                         </td>
                                        <td>
                                            <div class="detail_right">Jan 7,2014</div>
                                        </td>
                                    </tr>
                                     <tr class="vendor_info">
                                        <td class="vendor_info_left">Cell
                                         </td>
                                        <td>
                                            <div class="detail_right">718 123-456</div>
                                        </td>
                                    </tr>
                                     <tr class="vendor_info">
                                        <td class="vendor_info_left">Email
                                         </td>
                                        <td>
                                            <div class="detail_right"><span style="color:#3993c1">email@exmaple.com</span></div>
                                        </td>
                                    </tr>
                                     <tr class="vendor_info">
                                        <td class="vendor_info_left">Closed deals
                                         </td>
                                        <td>
                                            <div class="detail_right">21</div>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <div>
                                <div style="margin-top:20px;margin-left:5px">
                                    Notes 
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div style="float:right;margin-right:20px;margin-top: 40px;">
                     <input style="margin-left:20px;" type="button" class="rand-button short_sale_edit bg_color_blue" value="Ok" onclick="">
                     <input  type="button" class="rand-button short_sale_edit bg_color_gray" value="Cancel" onclick="">
                </div>
            </div>



        </dx:PopupControlContentControl>
    </ContentCollection>
</dx:ASPxPopupControl>
