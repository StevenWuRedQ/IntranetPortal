<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="default.aspx.vb" Inherits="IntranetPortal.SpotCheck" MasterPageFile="~/Mobile.Master" %>


<asp:Content runat="server" ContentPlaceHolderID="content">
    <div ng-controller="SpotCheckCtrl">
        <div class="section">
            <div class="form-group">
                <label>Date</label>
                <input class="form-control" type="text" placeholder="00/00/0000">
            </div>
            <div class="form-group">
                <label>Property Address</label>
                <input class="form-control" type="text" placeholder="123 5th Ave, New York, NY">
            </div>
            <div class="form-group">
                <label>Access</label>
                <input class="form-control" type="text" placeholder="">
            </div>
            <div class="form-group">
                <label>Number of workers</label>
                <input class="form-control" type="text" placeholder="">
            </div>
        </div>
        <hr />
        <div class="section">
            <div class="form-group">
                <label>Description of interior work being done </label>
                <textarea class="form-control" rows="5"></textarea>
            </div>

            <div class="form-group">
                <label>Description of exterior work being done </label>
                <textarea class="form-control" rows="5"></textarea>
            </div>

            <div class="form-group">
                <label>Description of Material on site</label>
                <textarea class="form-control" rows="5"></textarea>
            </div>

            <div class="form-group">
                <label>Description of Material on site</label>
                <textarea class="form-control" rows="5"></textarea>
            </div>

            <div class="form-group">
                <label>Are permits on site</label>
                <ui-switch ng-model="paid"></ui-switch>
                <label>if YES please confirm which permit(s) and date it expires</label>
                <textarea class="form-control" rows="5"></textarea>
            </div>

            <div class="form-group">
                <label>Are plans on site</label>
                <ui-switch ng-model="paidx"></ui-switch>
            </div>

            <div class="form-group">
                <label>Next day planned work/tasks</label>
                <textarea class="form-control" rows="5"></textarea>
            </div>
            <div class="form-group">
                <label>Additional Notes:</label>
                <textarea class="form-control" rows="5"></textarea>
            </div>

            <button type="button" class="btn btn-success pull-right">Submit</button>
        </div>
    </div>
    <script>
        angular.module("PortalMapp")
            .controller("SpotCheckCtrl", function () {
                
            })
    </script>
</asp:Content>
