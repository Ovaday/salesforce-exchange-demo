/**
 * Created by eab on 10.06.2025.
 */

public with sharing class FixierCallout {

    public static Map<String, String> getSupportedSymbols() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod(Constants.GET_METHOD);
        request.setHeader(Constants.CONTENT_TYPE_KEY, Constants.CONTENT_TYPE_APPLICATION_JSON);
        request.setEndpoint('callout:Fixier_API_Symbols');
        request.setTimeout(Constants.DEFAULT_GET_REQUEST_TIMEOUT);

        HttpResponse response = http.send(request);

        Integer statusCode = response.getStatusCode();

        if (statusCode == 200) {
            String responseBody = response.getBody();
            Symbols_ResponseDTO responseDTO = (Symbols_ResponseDTO) JSON.deserialize(responseBody, Symbols_ResponseDTO.class);
            if (!responseDTO.success) {
                throw new CalloutException('Callout failed, fixier returned failure.');
            }
            return responseDTO.symbols;
        } else {
            throw new CalloutException('Callout failed with status code: ' + statusCode);
        }
    }

    public static Latest_ResponseDTO getLatestRates(String baseCurrency, List<String> targetCurrencies) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod(Constants.GET_METHOD);
        request.setHeader(Constants.CONTENT_TYPE_KEY, Constants.CONTENT_TYPE_APPLICATION_JSON);
        request.setEndpoint('callout:Fixier_API_Latest' + prepareLatestRatesRequestString(baseCurrency, targetCurrencies));
        request.setTimeout(Constants.DEFAULT_GET_REQUEST_TIMEOUT);

        HttpResponse response = http.send(request);

        Integer statusCode = response.getStatusCode();

        if (statusCode == 200) {
            String responseBody = response.getBody();
            Latest_ResponseDTO responseDTO = (Latest_ResponseDTO) JSON.deserialize(responseBody, Latest_ResponseDTO.class);
            if (!responseDTO.success) {
                throw new CalloutException('Callout failed, fixier returned failure.');
            }
            return responseDTO;
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

    private abstract class Base_ResponseDTO {
        public Boolean success;
    }

    public class Latest_ResponseDTO extends Base_ResponseDTO{
        public Integer timestamp;
        public String base;
        public Map<String, Decimal> rates;

        public Map<String, Map<String, Decimal>> exchangeRates() {
            Map<String, Map<String, Decimal>> exchangeRates = new Map<String, Map<String, Decimal>>();
            exchangeRates.put(base, rates);
            return exchangeRates;
        }
    }

    public class Symbols_ResponseDTO extends Base_ResponseDTO {
        public Map<String, String> symbols;
    }

}