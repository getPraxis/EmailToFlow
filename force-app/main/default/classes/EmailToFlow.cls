/* @author:         Praxis Solutions, LLC
 * @authorEmail:    support@getpraxis.com
 * @Description:    Email Service Publishes Platform Event that can be subscribed to by Flows or Apex.
 */

global class EmailToFlow implements Messaging.inboundEmailHandler{
 
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope env) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        
        Email_to_Flow_Received__e emailPE = new Email_to_Flow_Received__e (
            Email_From_Address__c           = email.FromAddress,
            Email_From_Name__c              = email.FromName,
            Email_Subject__c                = email.Subject,
            Email_HTML_Body__c              = email.HTMLBody,
            Email_Text_Body__c              = email.PlainTextBody,
            Email_Message_Id__c             = email.MessageId,
            Email_In_ReplyTo__c             = email.InReplyTo,
            Email_Is_HTML_Truncated__c      = email.HTMLBodyIsTruncated,
            Email_Is_Text_Body_Truncated__c = email.PlainTextBodyIsTruncated,
            Email_Reply_To__c               = email.ReplyTo,
            Envelope_From_Address__c        = env.FromAddress,
            Envelope_To_Address__c          = env.ToAddress,
            Email_To_Addresses__c           = email.ccAddresses != null ? String.join(email.toAddresses, ',') : null,
            Email_CC_Addresses__c           = email.ccAddresses != null ? String.join(email.ccAddresses, ','): null,
            Email_References__c             = email.References  != null ? String.join(email.References, ',') : null,
            Content_Version_Ids__c          = ConvertAttachmentsToCV(email)
        );
       
        //Publish Platform Event
        EventBus.publish(emailPE);
        return result;
    }
    
    //Convert All Attachments to List of ContentVersion
    private static String ConvertAttachmentsToCV(Messaging.InboundEmail email){
        List<ContentVersion>CVRecords = new List<ContentVersion>();
        //Convert binary attachments to ContentVersion
        if (email.BinaryAttachments != null && !email.BinaryAttachments.isEmpty()){
            for (Messaging.InboundEmail.BinaryAttachment BinAttach : email.BinaryAttachments){
                ContentVersion CVRecord = new ContentVersion();
                CVRecord.Title = BinAttach.FileName;
                CVRecord.VersionData = BinAttach.Body;
                CVRecord.PathOnClient = '/' + BinAttach.FileName ;
                CVRecords.add(CVRecord);
            }
        }
        //Convert text attachments to PDF ContentVersion
        if (email.TextAttachments != null && !email.TextAttachments.isEmpty()){
            for (Messaging.InboundEmail.TextAttachment TextAttach : email.TextAttachments){
                ContentVersion CVRecord = new ContentVersion();
                CVRecord.Title = TextAttach.FileName;
                CVRecord.VersionData = Blob.ToPDF(TextAttach.Body);
                CVRecord.PathOnClient = '/' + TextAttach.FileName.Replace('.','') + '.pdf' ;
                CVRecords.add(CVRecord);
            }
        }

        String cvRecordIDs = '';
        //return only if Attachments exist
        if(CVRecords != null && !CVRecords.isEmpty()){
            insert CVRecords;
            List<String> Ids = new List<String>();
            for(ContentVersion CV : CVRecords){
                Ids.add(CV.Id);
            }
            cvRecordIDs = string.join(Ids,',');
        }

        return cvRecordIDs;
    }
}