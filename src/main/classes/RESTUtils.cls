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

}