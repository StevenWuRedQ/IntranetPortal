<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="DialerManagement.aspx.vb" Inherits="IntranetPortal.DialerManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">

    <div class="container-fluid" ng-controller="DialerManagementController">
        <div class="row">
            <div class="col-md-4">
                <div class="dx-fieldset">
                    <div class="dx-fieldset-header">Pure Cloud Contact List</div>
                    <div class="dx-field">
                        <h4>Employee List</h4>
                        <div id="lookup"></div>
                    </div>
                    <br />
                    <div class="dx-fieldset-footer">
                        <button type="button" class="btn btn-default" data-ng-click="CreateContactList()">CreateContactList</button>
                        <br />
                        <br />
                        <button type="button" class="btn btn-default" data-ng-click="SyncNewLeadsFolder()">SyncNewLeadsFolder</button>
                    </div>
                </div>
            </div>
            <hr />

        </div>
    </div>
</asp:Content>
