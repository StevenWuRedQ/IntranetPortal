<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="VacantListCtrl.ascx.vb" Inherits="IntranetPortal.VacantListCtrl" %>
<div class="col-md-6" ng-controller="VacantListCtrl">
    <div class="row">
        <div class="col-md-5">
            <%--<div class="row">
                <div class="col-md-6">
                    <h5>{{Filter}}</h5>
                </div>
                <div class="col-md-6">
                    <div class="dropdown">
                        <a class="btn dropdown-toggle" id="filterDropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">Switch filter
                        </a>
                        <ul class="dropdown-menu" aria-labelledby="filterDropdown">
                            <li ng-click="LoadLeads(f.name)" ng-repeat="f in Filters"><a>{{f.name}} </a></li>
                        </ul>
                    </div>
                </div>
            </div>--%>
        </div>
        <div class="col-md-7">
            <div class="input-group" style="padding-top: 3px;">
                <input type="text" class="form-control" ng-model="auctionFilter" placeholder="Search by BBLE,Address,ZipCode ..." aria-describedby="basic-addon2">
                <span class="input-group-addon" id="basic-addon2"><i class="fa fa-search"></i></span>
            </div>
        </div>
    </div>

    <div class="wx_scorll_list" data-bottom="90" style="margin-top: 10px">
        <div class="list-group">
            <a href="#/vacant/{{au.BBLE}}" class="list-group-item" ng-repeat="au in List|filter:auctionFilter as results track by au.BBLE"><%--<span class="badge">{{au.Owner }} </span>--%>
                {{au.PropertyAddress}}
            </a>
            <a class="list-group-item" ng-if="results.length == 0"><strong>No results found...</strong>
            </a>
        </div>
    </div>

</div>
