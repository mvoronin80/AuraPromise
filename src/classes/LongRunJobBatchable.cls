global class LongRunJobBatchable implements Database.Batchable<sObject>, Database.Stateful
{
    public Decimal total;
    private String accountId;
    public LongRunJobBatchable(String accountId) {
        this.accountId = accountId;
        this.total = 0;
    }
     
    global Database.QueryLocator start(Database.BatchableContext context){
        return Database.getQueryLocator('SELECT Amount FROM Opportunity WHERE AccountId = \'' + accountId + '\'');
    }
    
    global void execute(Database.BatchableContext context, List<sObject> scope){
        for(sObject o : scope) {
            total += (Decimal)o.get('Amount');
        }
    }
    
    global void finish(Database.BatchableContext context){
        Account a = [SELECT TotalAmount__c FROM Account WHERE Id =:accountId];
        a.TotalAmount__c = total;
        update a;
    }
}