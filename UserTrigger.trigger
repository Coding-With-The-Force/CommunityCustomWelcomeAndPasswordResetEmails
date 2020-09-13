/**
 * Created by gerry on 9/11/2020.
 */

trigger UserTrigger on User (after insert)
{
    if(Trigger.isAfter && trigger.isInsert)
    {
        CommunityEmailManager.processEmails(trigger.new);
    }
}