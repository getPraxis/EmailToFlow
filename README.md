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

![Visual Flow of the Email to Flow Process](..Media/media/Email%20to%20Flow%20Process%20Map.png)
