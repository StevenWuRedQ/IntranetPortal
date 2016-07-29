<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="AuditLogs.ascx.vb" Inherits="IntranetPortal.AuditLogs" %>

<script>
    var auditLog = {
        objectName: "PreSignRecord",
        recordId: 78,
        angularApp: null,
        http: null,
        scope: null,
        init: function () {
            me = this;
            me.angularApp = window.angular;
            me.angularApp.module('PortalApp')
                     .controller('AuditLogController', ['$scope', '$http', function ($scope, $http) {
                         me.http = $http;
                         me.scope = $scope;                       
                         //me.http.get('/api/auditlog/' + me.objectName + "/" + me.recordId).success(function (data) {
                         //    var result = _.groupBy(data, function (item) {
                         //        return item.EventDate;
                         //    });                           
                         //    me.scope.AuditLogs = result;
                         //});
                     }]);          
        },
        show: function (objName, recordId) {
            me = this;
            if (objName)
                me.objectName = objName;

            if (recordId)
                me.recordId = recordId;

            me.http.get('/api/auditlog/' + me.objectName + "/" + me.recordId).success(function (data) {
                var result = _.groupBy(data, function (item) {
                    return item.EventDate;
                });
                console.log(result);
                me.scope.AuditLogs = result;
            });
        }
    };

    auditLog.init();
</script>

<style type="text/css">

    .audit_log_block {
        padding: 10px;
        border-bottom: 1px solid #ccc;
    }

    .audit_log_block:hover {
        background-color: #f5f5f5;
        border-left: 5px solid #3572b0;
        padding-left: 5px;
    }

    .frist-line-log{
        background:blue;
    }

</style>

<div ng-controller="AuditLogController" >
    <div ng-repeat="(key, prop) in AuditLogs" class="audit_log_block">
        <h5 ng-class="{alert-success:$index==0}"><strong> {{prop[0].UserName}}</strong> <span style="color:blue;">{{prop[0].EventType==0?'first created this form':'made changes'}} on {{key | date:"MM/dd/yyyy HH:mm"}}</span>  </h5>        
        <table class="" style="width: 100%; font-size:14px" ng-show="prop[0].EventType!=0">
             <tr>
                <th style="width: 20%">Field</th>
                <th style="width: 40%">Previous Value</th>
                <th style="width: 40%">New Value</th>
            </tr>
            <tr ng-repeat="log in prop" style="border: none">
                <td style="width: 20%">{{log.ColumnName}}</td>
                <td style="width: 40%">{{log.FormatOriginalValue}}</td>
                <td style="width: 40%">{{log.FormatNewValue}}</td>
            </tr>
        </table>
    </div>
</div>
