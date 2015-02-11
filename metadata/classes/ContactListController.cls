public class ContactListController {
	@AuraEnabled 
    public List<Contact> getContacts() {
        return [SELECT Id, Name, Email, Title, Phone, Profile_Image__c FROM Contact
                ];        
    }
}