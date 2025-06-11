/**
 * Created by eab on 10.06.2025.
 */

public class RESTUtils {
    public static StaticResourceCalloutMock prepareMockCallout(String staticResourceName, Integer statusCode) {
        StaticResourceCalloutMock calloutMock = new StaticResourceCalloutMock();
        calloutMock.setStaticResource(staticResourceName);
        calloutMock.setStatusCode(statusCode);
        calloutMock.setHeader(Constants.CONTENT_TYPE_KEY, Constants.CONTENT_TYPE_APPLICATION_JSON);

        return calloutMock;
    }

    public static HttpResponse sendRequest(String requestMethod, String Endpoint) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod(requestMethod);
        request.setHeader(Constants.CONTENT_TYPE_KEY, Constants.CONTENT_TYPE_APPLICATION_JSON);
        request.setEndpoint(Endpoint);
        request.setTimeout(Constants.DEFAULT_GET_REQUEST_TIMEOUT);

        HttpResponse response = http.send(request);
        return response;
    }

}