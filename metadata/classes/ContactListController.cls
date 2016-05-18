public class ContactListController {
	@AuraEnabled 
    public List<Contact> getContacts() {
        return [SELECT Id, Name, Email, Title, Phone, Profile_Image__c FROM Contact
                ];        
    }

    public void test() {
    	for (integer x=0;x<3000;x++) {
    		sytem.debug('out');
    	}
    }
}