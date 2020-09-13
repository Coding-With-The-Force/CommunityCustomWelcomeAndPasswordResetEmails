/**
 * Created by gerry on 9/12/2020.
 */

public with sharing class CommunityEmailManager
{
	private static final String PROFILE_NAME = 'Customer Community Plus Login User';

	public static void processEmails(List<User> userList)
	{
		Set<Id> profIds = new Set<Id>();

		for(User usr: userList)
		{
			profIds.add(usr.ProfileId);
		}

		Map<Id, Profile> profilesFoundMap = new Map<Id, Profile>([SELECT Name FROM Profile WHERE Id IN: profIds]);
		List<Messaging.SingleEmailMessage> welcomeEmails = new List<Messaging.SingleEmailMessage>();
		List<EmailTemplate> welcomeEmailTemplates = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Taco_Bueno' LIMIT 1];

		for(User usr: userList)
		{
			if(profilesFoundMap.get(usr.ProfileId).Name == PROFILE_NAME)
			{
				System.resetPassword(usr.Id, true);
			}

			Messaging.SingleEmailMessage welcomeEmailMessage = Messaging.renderStoredEmailTemplate(welcomeEmailTemplates[0].Id, usr.ContactId, null);
			String [] toAddresses = new String[]{usr.Email};
			welcomeEmailMessage.setToAddresses(toAddresses);
			welcomeEmails.add(welcomeEmailMessage);
		}

		if(!welcomeEmails.isEmpty())
		{
			Messaging.sendEmail(welcomeEmails);
		}
	}
}