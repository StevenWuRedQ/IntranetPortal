/**
 * rewite audit log in model view
 */
/**
 * @return {[class]}                 AuditLog class
 */
angular.module('PortalApp').factory('AuditLog', function (ptBaseResource) {
    var auditLog = ptBaseResource('AuditLog', 'AuditId', null, {
        load: {
            method: "GET",
            url: '/api/auditlog/:TableName/:RecordId'
           , params: {
               RecordId: '@RecordId',
               TableName: '@TableName'

           },
            isArray: true,
            options: { noError: true }
        },
    });

    return auditLog;

});