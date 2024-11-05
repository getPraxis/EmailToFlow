# Email To Flow

Receive emails to a Salesforce address, and use Flow to define the logic of how to handle the email once it has been received.

## Introduction
Salesforce has the ability to create custom email addresses which allow custom processing once the email has been received.
Think Email-to-Case - but instead, Email-to-Anything.
Normally, to receive emails into Salesforce and create any automation based on the email, Apex code must be created.

The purpoase of this package is to empower Declarative Developers (AKA Flownatics AKA Salesforce Administrators) to create the same capabilities.

## How does it work?
The package includes:
1. Apex Class (EmailToFlow) and Test Class
2. Platform Event called 'Email to Flow Received'
3. Sample Flow you can use as a starting point.

Once an email is received:
1. The Apex Class will handle the receipt of the email:
   - Create ContentVersion record for each attachment included in the email
   - Publish a Platform Event, including all relevant Email Details 
2. Platform-Event Triggered Flow is used to then perform any logic that should occur (create records, send notifications, or whatever else you can dream of)

![Visual Flow of the Email to Flow Process](../Media/media/Email%20to%20Flow%20Process%20Map.png)

## Setup
Any user who should be able to set up processing flows, or which acts as the Context User for the Email Service (see below), must have the 'EmailToFlow User/Admin' Permission Set assigned to them.
This permission set provides Create and Read access to the Platform Event and to the Apex Class.

In order to use this tool, you need to set up an Email Service in Salesforce, and select the EmailToFlow Apex Class:
1. Navigate to Setup > Custom Code > Email Service
2. Click New
3. Give the Service a name
4. Select the EmailToFlow Apex Class
5. Ensure the Active checkbox is checked

![Screenshot of Email Service Setup Screen](../Media/media/EmailServiceSetup.png)

Once the Email Service has been setup, we need to create at least one Service Email Address - that will be the unique (and very long) email address to which emails should be sent or forwarded.
1. Give the address an API name
2. Enter the 'local part' of the email address (i.e. the part before the @ sign)
3. Ensure the Address is Active
4. Select the Context User - that will be the user which the Apex Class will operate as
5. Optional: Set or remove the 'Accept Email From' list. Empty means anyone can send emails to this address, populated means only emails from addresses listed here can be accepted.

![Screenshot of Email Service Address Setup](../Media/media/EmailServiceAddressSetup.png)

Once the Email Service has been setup, when an email is received to the Service Address, the Apex Class will publish a Platform Event, to which a Flow should be Subscribed to (another way to say that the Flow is Platform-Event Triggered off this event type)
The Flow can do whatever you need it to do - so you can start from a brand new flow if you want.
However, the package includes a Sample flow titled  'Email to Flow - Sample Flow for Email Handling'. You can use this flow as a starting point and make changes as you see fit.

![Sample EmailToFlow Flow](../Media/media/EmailToFlow-SampleFlow.png)

The flow is designed to:
1. Accept an Email to a specific Email Service Address
2. Create a Case
3. Create an Email Message and associate it with the case
4. Link any file attachments to the Case
5. Send an Auto-Response email

Worth Noting that the flow uses a non-traditional loop pattern, where instead of using a Loop element, we use a 'Connect to Element' node to extract values from a Comma-separated string, until that string is Empty.
You can use other mechanisms to convert a Comma-separated string to a collection, such as custom Apex Actions, or the [UnOfficial Salesforce](https://unofficialsf.com/)'s [Convert Strings to String Collections, and Vice Versa](https://unofficialsf.com/new-flow-actions-to-convert-csv-strings-to-string-collections-and-vice-versa/) Apex Action.
This will allow you to replace 4 elements with a single Apex Action.

## Installation
To install this component, use one of the following links:
[Sandbox](https://test.salesforce.com/packaging/installPackage.apexp?p0=04tRN000001TQOLYA4) - https://test.salesforce.com/packaging/installPackage.apexp?p0=04tRN000001TQOLYA4
[Production/Dev](https://login.salesforce.com/packaging/installPackage.apexp?p0=04tRN000001TQOLYA4) - https://login.salesforce.com/packaging/installPackage.apexp?p0=04tRN000001TQOLYA4
