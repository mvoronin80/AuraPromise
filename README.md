# AuraPromise
This is a simple implementation of Promises support for Aura framework

The unmanaged package with all the source code is available here https://login.salesforce.com/packaging/installPackage.apexp?p0=04t500000003ofu

<a href="https://githubsfdeploy.herokuapp.com?owner=financialforcedev&repo=apex-mdapi">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>

The package contains 3 components.

1. ManyCallbacks - Should be put to Contact page. This component shown Contact, Account, Account Owner and Account Owner's manager info. Contact must have Account, the Account must have Owner, Owner must have a manager.
2. LongRunJob - Should be put to Account page. This component shows total amount of all the opportunities related to the Account.
3. Parallel Execution - Should be put to Opportunity object. This component shows fields from Opportunity (obtained in parallel manner).
