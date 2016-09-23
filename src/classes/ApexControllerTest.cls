@isTest
public class ApexControllerTest {
	static testmethod void getContactSuccess() {
		Account a = new Account(Name = 'Test Account');
		insert a;
		
		Contact c = new Contact();
		c.LastName = 'Test Contact';
		c.AccountId = a.Id;
		insert c;
		
		c = ApexController.getContact(c.Id);
		
		System.assert(c.AccountId == a.Id);
	}
	
	static testmethod void getAccountSuccess() {
		Account a = new Account(Name = 'Test Account');
		insert a;
		
		ApexController.getAccount(a.Id);
		
		System.assert(a.Name == 'Test Account');
	}
	
	static testmethod void getUserSuccess() {
		User u = ApexController.getUser(UserInfo.getUserId());
		
		System.assert(u.Id == UserInfo.getUserId());
	}
    
    static testmethod void testBatchJob() {
        Account a = new Account(Name = 'Test Account');
        insert a;
        Opportunity o1 = new Opportunity(
            Name = 'Test Opportunity', 
            CloseDate = Date.today(), 
            StageName = 'Closed (Won)',
            AccountId = a.Id,
            Amount = 100
        );
        Opportunity o2 = new Opportunity(
            Name = 'Test Opportunity',
            CloseDate = Date.today(),
            StageName = 'Closed (Won)',
            AccountId = a.Id,
            Amount = 200
        );
        insert o1;
        insert o2;
        
        Test.startTest();
        ApexController.BatchInfo b1 = ApexController.startProcess(a.Id);
        ApexController.isBatchRunning(b1.batchId);
        Test.stopTest();
        
        Decimal total = ApexController.getBatchResult(a.Id);
        System.assert(total == 300);
    }
	
	static testmethod void getOpportunityField() {
		Opportunity o = new Opportunity(Name = 'Test Opportunity', CloseDate = Date.today(), StageName = 'Closed (Won)');
		insert o;
		
		String name = ApexController.getOpportunityField(o.Id, 'Name');
		
		System.assert(name == 'Test Opportunity');
	}
}