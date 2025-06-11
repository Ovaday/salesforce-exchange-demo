# Salesforce LWC Currency Exchange Demo
![UI Screenshot.png](UI%20Screenshot.png)

## How To configure:
1) Deploy components of the application
2) Go to Setup -> Custom Settings, find 'Fixier Settings' and set 'API Key' field to your key, Base URL to Fixier endpoint.
3) Go to Setup -> Permission Sets and assign 'Fixier Permissions' permission set to your user.
4) Add LWC component 'Exchange Manager' to desired page.

## How to use:
1) Open page, select Base currency and Target currency.
2) Click "Get Exchange Rate"

## What can be improved:
1) Additional error handling (Fixier API can return that we have reached the limit of requests and this can be shown to the user).
2) Additional tests on Fixier errors + error handling.
3) Caching.
4) UI alignment can be improved - 'From Currency' does not align perfectly with 'To Currency'. (Different Lightning Components)
5) [Optional] Switch from Custom Settings to Custom Metadata.
6) [Optional] Increase test coverage from ~92% to 100%.
7) [Optional] Pack source code into unmanaged package.
8) [Optional] Fixier DTO in a separate class.

## Self-critics:
1) Current approach without caching creates a security breach in a way that the API Usage can be flooded with
requests with a simple (D)DOS attack.
2) UI can be nicer, table rows with currencies can be coloured with each line having different color (gray+white).
3) For the provided method of API Key passing (in URL) Salesforce does not have correct way to secure the provided key.
It can be saved as a Named Credential, however, it still will be shown in logs + salesforce cannot identify endpoint
correctly if the query appended starts with '&'. Alternative way to Custom Settings would be to store it in Custom
Metadata, however, still not secure.

### Author:

Evgenii Abdrazakov

11.06.2025