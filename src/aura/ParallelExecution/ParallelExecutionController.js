({
	getFields : function(cmp, event, helper) {
        // clean up input
        cmp.find("result").set('v.value', ''); 
        
        // create actions
        var getName = cmp.get("c.getOpportunityField");
        getName.setParams({"opportunityId":cmp.get("v.recordId"),"fieldName":"Name"});
        var getStage = cmp.get("c.getOpportunityField");
        getStage.setParams({"opportunityId":cmp.get("v.recordId"),"fieldName":"StageName"});
        var getDescription = cmp.get("c.getOpportunityField");
        getDescription.setParams({"opportunityId":cmp.get("v.recordId"),"fieldName":"Description"});
        
        // start parallel execution
		Promise.all([
        	AuraPromise.serverSideCall(getName, cmp),
            AuraPromise.serverSideCall(getStage, cmp),
            AuraPromise.serverSideCall(getDescription, cmp)
            
        ]).then(
            // handle the response when all actions are done
            function(response) {
                cmp.find("result").set('v.value', response.join(','));
            }
        )
	}
})