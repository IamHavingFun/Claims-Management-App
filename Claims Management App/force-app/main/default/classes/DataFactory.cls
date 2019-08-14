public class DataFactory {
    /**
     * Creates a number of contacts according to the passed argument, and returns the IDs of the records.
     * @param  intNumberOfContacts Integer
     * @return Returns List<ID> 
     */
    public static List<ID> createContacts(Integer intNumberOfContacts){
        List<Contact> listContacts = new List<Contact>();
        List<ID> listContactIDs = new List<ID>();
        
        for (Integer counter = 0; counter < intNumberOfContacts; counter++) {
            Contact c = new Contact();
            c.FirstName = 'First Name: ' + counter;
            c.LastName = 'Last Name: ' + counter;
            listContacts.add(c);
        }
        
        insert listContacts;
        
        for (Contact con : listContacts) {
            listContactIDs.add(con.Id);
        }
        
        return listContactIDs;
    }
    
    public static List<ID> createPolicies(List<ID> policyHolderIDs, Integer intNumberOfPolicies){
        List<Policy__c> policiesToInsert = new List<Policy__c>();
        Integer polHolderIDCounter = 0;
        List<ID> policyIDs = new List<ID>();
        
        for (Integer counter = 0; counter < intNumberOfPolicies; counter++) {
            if (counter >= policyHolderIDs.size()) {
                polHolderIDCounter = 0;
            }
            
            Policy__c policyToInsert = new Policy__c();
            policyToInsert.Policy_Holder__c = policyHolderIDs.get(polHolderIDCounter);
            policyToInsert.Policy_Type__c = 'Renters';
            policyToInsert.Name = 'Renters Policy TEST: ' + counter;
            policiesToInsert.add(policyToInsert);
            
            polHolderIDCounter++;
        }
        
        insert policiesToInsert;
        
        for (Policy__c newPolicy : policiesToInsert) {
            policyIDs.add(newPolicy.Id);
        }
        
        return policyIDs;
    }
    
    public static List<ID> createPolicyCoverages(List<ID> policyIDs){
        List<Schema.PicklistEntry> currentCoverageTypes = Schema.Policy_Coverage__c.Coverage_Type__c.getDescribe().getPickListValues();
        List<Policy_Coverage__c> policyCoverages = new List<Policy_Coverage__c>();
        Policy_Coverage__c policyCoverage;
        List<ID> policyCoverageIDs = new List<ID>();
        
        for (ID i : policyIDs) {
            for (Schema.PicklistEntry coverageType : currentCoverageTypes) {
                policyCoverage = new Policy_Coverage__c();
                policyCoverage.Name = 'Coverage ' + coverageType.getLabel() + ' for policy ID ' + i;
                policyCoverage.Coverage_Type__c = coverageType.getLabel();
                policyCoverage.Limit__c = Decimal.valueOf(Math.random() * 1000).setScale(2);
                policyCoverage.Policy_Number__c = i;
                policyCoverages.add(policyCoverage);
            }
            
        }
        insert policyCoverages;
        
        for (Policy_Coverage__c pc : policyCoverages) {
            policyCoverageIDs.add(pc.Id);
        }
        
        return policyCoverageIDs;
    }
    
    public static List<ID> createClaims(List<ID> policyIDs){
        List<Policy__c> policies  = [SELECT Id, Policy_Holder__c, (SELECT Id FROM Policy_Coverages__r) FROM Policy__c WHERE Id IN :policyIDs];
        List<Claim__c> claims = new List<Claim__c>();
        List<ID> claimIDs = new List<ID>();
        Claim__c claim;
        for (Policy__c pol : policies) {
            for (Policy_Coverage__c coverage : pol.Policy_Coverages__r) {
                claim = new Claim__c();
                claim.Policy__c = pol.Id;
                claim.Claimant__c = pol.Policy_Holder__c;
                claim.Policy_Coverage__c = coverage.Id;
                claims.add(claim);
            }
        }
        
        insert claims;
        
        for (Claim__c c : claims) {
            claimIDs.add(c.Id);
        }
        
        return claimIDs;
    }
}
