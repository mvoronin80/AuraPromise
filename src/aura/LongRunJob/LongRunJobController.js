({
	startJob : function(cmp, event, helper) { 
		cmp.find("result").set('v.value', ''); 
        var action = cmp.get("c.startProcess");
        action.setParams({"accountId":cmp.get("v.recordId")});
        AuraPromise.serverSideCall(action, cmp).while( 
                        function(response) {
                            return !response.done;
                        },
            			function(response) {                 		
                            cmp.find("result").set('v.value', 'Pending'); 
                			var action1 = cmp.get("c.isBatchRunning");
                            action1.setParams({"batchId":response.batchId})
                			return AuraPromise.serverSideCall(action1, cmp);
            			}  
        			).then(
        				function(response) {
                    		var action2 = cmp.get("c.getBatchResult");
                            action2.setParams({"accountId":cmp.get("v.recordId")});
                            return AuraPromise.serverSideCall(action2, cmp);
            			}
            		).then(
                        function(response) { 
                            cmp.find("result").set('v.value', response); 
                        }
        			).catch(
            			function(error) {
                            alert('Error: ' + error);
        				}
        			);
	}
})