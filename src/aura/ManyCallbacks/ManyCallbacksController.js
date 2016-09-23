({ 
    // callback hell
	getAccountOwner1 : function(cmp, event, helper) {
        cmp.find("contactName").set('v.value', '');
        cmp.find("accountName").set('v.value', '');
        cmp.find("ownerName").set('v.value', '');
        // obtain contact
		var getContact = cmp.get("c.getContact");
        getContact.setParams( {"contactId": cmp.get("v.recordId")} );
        getContact.setCallback(this, function(contact) {
        	// obtain account
            contact = contact.getReturnValue();
            cmp.find("contactName").set('v.value', contact.Name);
            var getAccount = cmp.get("c.getAccount"); 
            getAccount.setParams( {"accountId": contact.AccountId} );
            getAccount.setCallback(this, function(account) {
                // obtain user
                account = account.getReturnValue();
            	cmp.find("accountName").set('v.value', account.Name);
            	var getUser = cmp.get("c.getUser");
                getUser.setParams( {"userId": account.OwnerId} );
            	getUser.setCallback(this, function(user) {
                	user = user.getReturnValue();
            		cmp.find("ownerName").set('v.value', user.Name);
        		});
            	$A.enqueueAction(getUser);
            });
            $A.enqueueAction(getAccount);
        }); 
        $A.enqueueAction(getContact);
	},
    // better version - separate callback functions
    getAccountOwner2 : function(cmp, event, helper) {
        // cleanup
        cmp.find("contactName").set('v.value', '');
        cmp.find("accountName").set('v.value', '');
        cmp.find("ownerName").set('v.value', '');
        
        var getContact = cmp.get("c.getContact");
        getContact.setParams( {"contactId": cmp.get("v.recordId")} );
        getContact.setCallback(this, contactCallback);
        $A.enqueueAction(getContact);
        
        function contactCallback(contact) {
            contact = contact.getReturnValue();
            cmp.find("contactName").set('v.value', contact.Name);
            var getAccount = cmp.get("c.getAccount"); 
            getAccount.setParams( {"accountId": contact.AccountId} );
            getAccount.setCallback(this, accountCallback);
            $A.enqueueAction(getAccount);
        }
        function accountCallback(account) {
            account = account.getReturnValue();
            cmp.find("accountName").set('v.value', account.Name);
            var getUser = cmp.get("c.getUser");
            getUser.setParams( {"userId": account.OwnerId} );
            getUser.setCallback(this, userCallback);
            $A.enqueueAction(getUser);
        }
        function userCallback(user) { 
            user = user.getReturnValue();
            cmp.find("ownerName").set('v.value', user.Name);
        }
    },
    // promises
	getAccountOwner3 : function(cmp, event, helper) {
        // cleanup
        cmp.find("contactName").set('v.value', '');
        cmp.find("accountName").set('v.value', '');
        cmp.find("ownerName").set('v.value', '');
                
        var getContact = cmp.get("c.getContact");
        getContact.setParams( {"contactId": cmp.get("v.recordId")} );
        AuraPromise.serverSideCall(getContact, cmp).then(
            function(contact) {
            	cmp.find("contactName").set('v.value', contact.Name);
            	var getAccount = cmp.get("c.getAccount"); 
            	getAccount.setParams( {"accountId": contact.AccountId} );
                return AuraPromise.serverSideCall(getAccount, cmp);
            }
        ).then(
            function(account) { 
            	cmp.find("accountName").set('v.value', account.Name);
            	var getUser = cmp.get("c.getUser");
                getUser.setParams( {"userId": account.OwnerId} );
                return AuraPromise.serverSideCall(getUser, cmp);
            }
        ).then(
            function(user) { 
                cmp.find("ownerName").set('v.value', user.Name);   
                /* this is how to put another remote call */
                var getUser = cmp.get("c.getUser");
                getUser.setParams( {"userId": user.ManagerId} );
                return AuraPromise.serverSideCall(getUser, cmp);
            }
        ).then(
            function(user) {
                alert('Manager: '+user.Name);
            }
        ).catch(
            function(error) {
                alert('Error: '+error);
            }
        );
    }
})