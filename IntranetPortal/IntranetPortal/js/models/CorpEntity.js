angular.module('PortalApp').factory('CorpEntity', function (ptBaseResource, LeadsInfo) {

    var corpEntity = ptBaseResource('CorporationEntities', 'EntityId',null,
    { assign: { url: '/api/CorporationEntities/:EntityId/BBLE', method: 'Post' } });

    //corpEntity.prototype.assignCorp = function () {
        
        
    //    this
    //        self = corpEntity.assign(self.EntityId, JSON.stringify(leadInfo.BBLE));
    //        //return self.$assign(JSON.stringify(leadInfo.BBLE));
    //    });
    //}
    corpEntity.prototype.assignDateNow = function()
    {
        if(this.AssignOn)
        {
            var now = Date.now();
            var assignOn = Date.parse(this.AssignOn);
            var times = now - assignOn;
            return times
        }

    }
    
    return corpEntity;
});