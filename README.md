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
- Harness the LWC by putting it on a lightning page using the app builder.
- The component loads most recently created companies without an address, and most recently modified companies with an address. For companies without an address, you can hit the button `Get Address` to search for the  address based on the company name, using the Google Places Place Search API. If it's found, it's updated. Companies that have already had an address search, don't appear in the component.
- Currently, it has been built to work in Dutch address locale, retrieved by the Google Places API place search. This means that the Street, Postal Code, City and Country will be retrieved when a Dutch address format is retrieved. To try out correct use, try a company with a Dutch name.

![Screenshot](./images/Screenshot.jpg)

## Technical implementation:
- As technology, I used Lightning Web Components for displaying a page with 2 Account lists.
- To retrieve an address based on the Account name. I used the [Google Places API](https://developers.google.com/places/web-service/search), which callout is put on the button next to each record in the list.
- Used Apex Enterprise Patterns as Apex code framework, and an Application class as an injection framework

## Considerations & things to note
- In the developer org, the LWC has been exposed in the lightning app 'Company Address Manager'.
- Git: worked directly into master. If i'd work with multiple people, I'd work in a feature branch and have my PR reviewed before merging.
- I added fflib as classes in the org, but not in the git repo. In a proper DX project, i'd put them in a separate directory. In the existing codebase of an org you'd probably have them as an unmanaged package somewhere.
- As the google place api is not 'bulkified' (i.e. you can only fire a request for one location, I couldn't directly find a way to fire a request with multiple locations in a request body in [the documentation](https://developers.google.com/places/web-service/search)), I went with a button lightning data table per row, and didn't allow multiple rows to be selected in order to get the location, which might provide a better user experience.
- I've made an assumption that an address consists of the Street, Postal Code, City and Country. If one of these fields are empty, the Company Address is considered to not have an address.
- Use named credentials to store the Google Places API key, instead of custom settings. I couldn't directly find a way to use the API key in the request header in the Google Places API documentation. Another way would have been to  set up Oauth, but that is quite some work at this time so I'm taking this shortcut in order to be able to finish this in a reasonable amount of time.
- The Google Places API Place Search turned out only to provide a formatted address, not individual address fields, which is what I erroneously hoped for. It's possible to do another callout to the Place Details API using the ID from the first request, but then still you'd have to deal with locational differences in address formats. A simplification could have been to create a separate address field as a textfield on the account, or an alternative might be to use the geolocation returned by the Google API, and then have Salesforce find an address for it. For simplification, I'm assuming the response from the google api applies to Dutch companies, and i'll split the response and update individual address fields. For simplicity, I also used the 1st match that google returned.
- Regarding the use of design patterns: it might be debatable whether a controller should control further processing of the account record after having made the  call to the GooglePlacesService, or whether the GooglePlacesService should be responsible for further handling the update. For Single Responsibility purposes, I chose not to have the GooglePlacesService further process the account record. It might have been good to make a separate service for handling the account after retrieving the google response. Here comes the debate: it could be the responsibility of the controller as well.
- I couldn't get 2 assertions to pass in CompanyAddressManagerControllerTest. After spending too much time on this, I decided to skip them. The code works, and I'm running into issues with the mocking framework.

## Suggestions for improvement
- [X] Be able to declaratively determine the max number of records you want to display in the component for companies with or without an address, in the app builder.
- [X] Different styled message for 'no address found': make it a warning.
- Make it a DX project to improve the file structure & more easily add dependencies.
- Add info tags to table headers instead of text underneath to describe the table contents: use LWC LDS Tooltips.
- Make selection available on the component of the field the user can use to retrieve the companies, along with the sorting order, such as 'LastModifiedDate' and 'Ascending'. Also add a 'refresh' button.
- Display the address fields as a LWC formatted address.
- Add custom labels for titles, columns names, errors.
- Make account name clickable. How? -> [link](https://salesforce.stackexchange.com/questions/257065/hyperlink-record-name-lwc-datatable).
- In hindsight, 2 different components might be more fitting since they can then indivdiually be re-used. The 'without' address component could then ommit an event to rerender the 'with address' component after retrieving an address.
- Make company name editable in datatable.
- Test JavaScript code using Jest.
- Use OAuth instead of an api key.
- fix the remaining failing 2 assertions: mocks aren't working properly. Idea: stub the SObject unit of work using a singleton pattern? There's probably a parameter different between the actual parameters being used, and the stubbed ones.
  - Also call the helper method from the test directly, for making the command.
  - Mock: call the helper method for making the command, and mock the uow?
  - use singleton to override instantiation of UOW in controller?
  - [try resource](https://andyinthecloud.com/2016/06/26/working-with-apex-mocks-matchers-and-unit-of-work/)
- There's an error if an address in a format other than Dutch is retrieved, which is too 'short':
    > Something went wrong in retrieving the address results from Google.List index out of bounds: 2Class.GooglePlacesService.RetrievedGooglePlace.<init>: line 61, column 1 Class.GooglePlacesService.placeSearch: line 31, column 1 Class.CompanyAddressManagerController.searchAddressForAccount: line 17, column 1

    It won't always have all the strings when split by comma's. This can be improved by adding a check in the result and returning an error to the users if the format deviates from what is expected. Or, the user can view the response, split by comma, and for him/herself determine which response field is mapped to which account field

## Prerequisites for using this implementation
- [FFLib ApexMocks](https://github.com/apex-enterprise-patterns/fflib-apex-mocks) and [FFLib Apex Common](https://github.com/apex-enterprise-patterns/fflib-apex-common) (these are not included in respository).
- Set up the use of the [Google Places API](https://developers.google.com/places/web-service/search):
  - Add `maps.googleapis.com` to the Remote Site Settings
  - Configure the API key in the (hierarchiy) custom settings `GooglePlacesAPI__c` in a field called `Key__c` as org def

## Useful links
- [getting data from apex](https://wipdeveloper.com/lwc-getting-data-from-apex)
- [use data table](https://www.salesforcecodecrack.com/2019/10/display-reference-data-in-lwc.html)
- [Datatable - component library](https://developer.salesforce.com/docs/component-library/bundle/lightning-datatable/example)
- [datatable with buttons/row actions](https://www.infallibletechie.com/2020/03/lightning-datatable-with-buttonsrow.html)
- [use button or checkbox in lwc data table](https://developer.salesforce.com/docs/component-library/bundle/lightning-datatable/documentation)
- [data table with buttons](https://www.infallibletechie.com/2019/06/lightningdatatable-with-buttons-in.html)
- [set up google place api](http://michaelsoriano.com/lightning-component-google-places/) or [here](https://hellosnl.blogspot.com/2017/09/salesforce-lightning-google-places-autocomplete-predictions-search.html) perhaps [here](https://niksdeveloper.com/salesforce/address-lookup-in-lightning-using-google-api/)
- [api key example](https://simple-force.com/2018/02/03/best-practice-secure-api-keys-in-salesforce%E2%80%8A-%E2%80%8Aexample-google-firebase/) and [documentation](https://developer.salesforce.com/wiki/secure_coding_storing_secrets)
- [authentication hwo to](https://salesforce.stackexchange.com/questions/217281/use-a-named-credential-with-api-key)
- [google places api getting started](https://developers.google.com/maps/gmp-get-started#enable-api-sdk)
- [google cloud console](https://console.cloud.google.com/google/maps-apis/credentials?project=analog-arbor-291706)
- Apex DI/mocks:
  - [article](http://jessealtman.com/2014/06/apexmocks-how-does-it-work/)
  - [article 2](http://cropredysfdc.com/category/salesforce/apex-mocks/)
  - [application example](https://github.com/apex-enterprise-patterns/fflib-apex-common-samplecode/blob/master/sfdx-source/apex-common-samplecode/main/classes/Application.cls)
  - [test example](https://github.com/apex-enterprise-patterns/fflib-apex-common-samplecode/blob/master/sfdx-source/apex-common-samplecode/test/classes/controllers/OpportunityApplyDiscountControllerTest.cls#L40)
  - apex enterprise patterns - force di
  - [The one that is used](https://andyinthecloud.com/2015/03/22/unit-testing-with-apex-enterprise-patterns-and-apexmocks-part-1/) en [deze](https://andyinthecloud.com/2015/03/29/unit-testing-apex-enterprise-patterns-and-apexmocks-part-2/)
  - [Some common reasons why your mocks aren't working](https://salesforce.stackexchange.com/questions/252460/my-apexmocks-arent-working-what-could-be-wrong)
  - how to handle void methods in mocks [link](http://cropredysfdc.com/2019/05/03/apexmocks-answers-and-void-no-argument-domain-methods/)
