# salesforce-exchange-demo

How To configure:

1) Deploy components of the application
2) Go to Setup -> Custom Settings, find 'Fixier Settings' and set 'API Key' field to your key, Base URL to Fixier endpoint.
3) Go to Setup -> Permission Sets and assign 'Fixier Permissions' permission set to your user.
4) Add LWC component 'Exchange Manager' to desired page.

What can be improved:
1) Add error handling (Fixier API can return that we have reached the limit of requests).
2) Additional tests on Fixier errors + error handling.
3) Add caching.
4) [Optional] Switch from Custom Settings to Custom Metadata.