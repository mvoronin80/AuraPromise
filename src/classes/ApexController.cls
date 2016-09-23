public class ApexController {
    
    // methods for many callback demo
    
	@AuraEnabled
    public static Contact getContact(String contactId) {
    	List<Contact> contacts = [SELECT AccountId, Name FROM Contact WHERE Id =: contactId];
        if (contacts.size() == 0)
            return null;
        return contacts[0];
    }
    
    @AuraEnabled
    public static Account getAccount(String accountId) {
        List<Account> accounts = [SELECT Name, ParentId, OwnerId FROM Account WHERE Id =:accountId];
        if (accounts.size() == 0)
            return null;
        return accounts[0];
    }
   
    @AuraEnabled
    public static User getUser(String userId) { 
        List<User> users = [SELECT Name, ManagerId FROM User WHERE Id =:userId];
        if (users.size() == 0)
            return null;
        return users[0];
    }
    
    // methods for background job demo
    
    public class BatchInfo {
        @AuraEnabled
        public Id batchId;
        @AuraEnabled
        public Boolean done;
    }
    
    @AuraEnabled
    public static BatchInfo startProcess(String accountId) {
        LongRunJobBatchable batch = new LongRunJobBatchable(accountId);
        BatchInfo result = new BatchInfo();
        result.batchId = Database.executeBatch(batch);
        result.done = false;
        return result;
    }
    
    @AuraEnabled
    public static BatchInfo isBatchRunning(Id batchId) {
        AsyncApexJob jobStatus = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID =: batchId];
        BatchInfo result = new BatchInfo();
        result.batchId = batchId;
        result.done = (jobStatus.Status == 'Completed');
        return result;
    } 
    
    @AuraEnabled
    public static Decimal getBatchResult(String accountId) {
        return [SELECT TotalAmount__c FROM Account WHERE Id =:accountId].TotalAmount__c;
    }
    
    // parallel execution
    
    @AuraEnabled
    public static String getOpportunityField(Id opportunityId, String fieldName) {
        sObject opportunity = Database.query('SELECT ' + fieldName + ' FROM Opportunity WHERE Id =:opportunityId');
        return (String)opportunity.get(fieldName);
    }
}