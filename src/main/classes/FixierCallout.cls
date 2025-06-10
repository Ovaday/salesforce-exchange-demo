/**
 * Created by eab on 10.06.2025.
 */

public with sharing class FixierCallout {

    public static Map<String, Map<String, String>> getLatestRates(String baseCurrency, List<String> targetCurrencies) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod(Constants.POST_METHOD);
        request.setHeader(Constants.CONTENT_TYPE_KEY, Constants.CONTENT_TYPE_APPLICATION_JSON);
        request.setEndpoint('callout:Fixier_API_Latest' + prepareLatestRatesRequestString(baseCurrency, targetCurrencies));
        request.setTimeout(Constants.DEFAULT_GET_REQUEST_TIMEOUT);

        HttpResponse response = http.send(request);

        Integer statusCode = response.getStatusCode();

        if (statusCode == 200) {
            String responseBody = response.getBody();
            ResponseDTO responseDTO = (ResponseDTO) JSON.deserialize(responseBody, ResponseDTO.class);
            if (!responseDTO.success) {
                throw new CalloutException('Callout failed, fixier returned failure.');
            }
            Map<String, Map<String, String>> rates = new Map<String, Map<String, String>>();
            rates.put(responseDTO.base, responseDTO.rates);
            return rates;
        } else {
            throw new CalloutException('Callout failed with status code: ' + statusCode);
        }
    }


    /*
    https://data.fixer.io/api/latest
    ? access_key = API_KEY
    & base = USD
    & symbols = GBP,JPY,EUR
     */
    private static String prepareLatestRatesRequestString(String baseCurrency, List<String> targetCurrencies) {
        return '&base=' + baseCurrency + '&symbols=' + String.join(targetCurrencies, ',');
    }

    private class ResponseDTO {
        public Boolean success;
        public Integer timestamp;
        public String base;
        public Map<String, String> rates;
    }

}