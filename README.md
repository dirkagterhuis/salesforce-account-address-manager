# Salesforce Account Address Manager
This repository holds a solution for the following user story, used to manage company addresses in a Salesforce Lightning Web Component.

## User Story
As a user I want to be more in control of companies that do not have address. I want to easily access them, update and have an overview over which of them have and which don’t have addresses.

I want to be able to have an overview of 2 things:
1. Last 10 created companies without an address
2. Last 30 modified companies which do have an address.

Information which I want to see is on each record is:
1. Company name
2. Company phone number
3. Company address.

For each company from the list that does not have an address, I want to be able to easily retrieve an address. When retrieving an address, I expect 2 things can happen:
1. Record is updated with an address and it disappears from the list of companies without an address and appears in the list of the last modified companies who have an address
2. If there is no address to retrieve, I want to be notified there is no available address and company should disappear from the list of companies without an address.

## How does it work?
- Currently, it has been built to work in Dutch address locale, retrieved by the Google Places API place search. This means that the Street, Postal Code, City and Country will be retrieved when a Dutch address format is retrieved. To try out correct use, try a company with a Dutch name.

![Screenshot](./images/Screenshot.jpg)

## Technical implementation:
- As technology, I used Lightning Web Components for displaying a page with 2 Account lists.
- To retrieve an address based on the Account name. I used the [Google Places API](https://developers.google.com/places/web-service/search), which callout is put on the button next to each record in the list.
- Used Apex Enterprise Patterns as Apex code framework.

## Considerations

## Potential improvements

## Prerequisites for using this implementation
- [FFLib ApexMocks](https://github.com/apex-enterprise-patterns/fflib-apex-mocks) and [FFLib Apex Common](https://github.com/apex-enterprise-patterns/fflib-apex-common) (these are not included in respository).
- Set up the use of the [Google Places API](https://developers.google.com/places/web-service/search):
  - Add `maps.googleapis.com` to the Remote Site Settings
  - Configure the API key in the (hierarchiy) custom settings `GooglePlacesAPI__c` in a field called `Key__c` as org defaults.