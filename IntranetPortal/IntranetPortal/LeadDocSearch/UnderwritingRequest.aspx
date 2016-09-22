<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="UnderwritingRequest.aspx.vb" Inherits="IntranetPortal.UnderwritingRequest" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">

    <div id="" class="container" style="width: 80%; border: 1px dashed #f3f3f3" ng-controller="UnderwritingRequestController" >
        <div class="row" >
            <div class="col-md-12">
                <h4>Underwriting Questionnaire</h4>

                <div class="form">
                    <h5  >Brief Description</h5>
                    <textarea class="form-control" ng-model="data.BriefDescription"></textarea>
                </div>
                <div class="form">
                    <h5  >Occupancy</h5>
                    <select class="form-control" ng-model="data.Occupancy">
                        <option>Not Sure</option>
                        <option>Vacant</option>
                        <option>Tenants</option>
                        <option>Seller</option>
                        <option>Seller + Tenants</option>
                        <option>Family Member(s)</option>
                    </select>
                </div>
                <div class="form">
                    <h5  >Occupancy Description </h5>
                    <textarea class="form-control" ng-model="data.OccupancyDescription"></textarea>
                </div>
                <div class="form">
                    <h5  >Already working on SS?</h5>
                    <select ng-model="data.isWorkingOnSS">
                        <option>Not Sure</option>
                        <option>Yes</option>
                        <option>No</option>
                    </select>
                </div>
                <div class="form">
                    <h5  >If so, what is the name of the company they are working with?</h5>
                    <input type="text" class="form-control" ng-model="data.WorkingCompany" />
                </div>


                <div class="form">
                    <h5  >Was an HOI requested from the HO</h5>
                    <select ng-model="data.Occupancy" ng-model="data.WasHOIFromHO">
                        <option>Yes</option>
                        <option>No</option>
                    </select>
                </div>
                <div class="form">
                    <h5  >If so, how much was requested? </h5>
                    <input type="text" class="form-control" ng-model="data.TotalRequest" />
                </div>
                <div class="form">
                    <h5  >How much requested upfront?</h5>
                    <input type="text" class="form-control" ng-model="data.UpfrontRequested" />
                </div>


                <div class="form">
                    <h5  >Was an HOI offered</h5>
                    <select ng-model="data.Occupancy" ng-model="data.WasHOIOffered">
                        <option>Yes</option>
                        <option>No</option>
                    </select>
                </div>

                <div class="form">
                    <h5  >If so, how much was offered?  </h5>
                    <input type="text" class="form-control" ng-model="data.TotalOffered" />
                </div>
                <div class="form">
                    <h5  >How much was offered upfront?</h5>
                    <input type="text" class="form-control" ng-model="data.UpfrontOffered" />
                </div>
            </div>
            <hr />
            <div class='pull-right'>


                <button type="button" class="btn btn-primary">Save</button>
                <button type="button" class="btn btn-warning">Request Underwriting</button>
            </div>
        </div>
    </div>
</asp:Content>
