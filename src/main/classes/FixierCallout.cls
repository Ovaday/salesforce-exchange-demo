/**
 * Created by eab on 10.06.2025.
 */

public with sharing class FixierCallout {
    final static FixierSettings__c FIXIER_SETTINGS = FixierSettings__c.getOrgDefaults();

    private abstract class Base_ResponseDTO {
        public Boolean success;
    }

    /*
        Version: 11.06.2025
        Supported Symbols Endpoint
        The Fixer API comes with a constantly updated endpoint returning all available currencies.
        To access this list, make a request to the API's symbols endpoint.
        Endpoint: https://data.fixer.io/api/symbols?access_key=API_KEY
        Response:
        {
          "success": true,
          "symbols": {
            "AED": "United Arab Emirates Dirham",
            "AFN": "Afghan Afghani",
            "ALL": "Albanian Lek",
            "AMD": "Armenian Dram"
            }
        }
     */

    public class Symbols_ResponseDTO extends Base_ResponseDTO {
        public Map<String, String> symbols;
    }

    public static Map<String, String> getSupportedSymbols() {

        String endpoint = FIXIER_SETTINGS.Base_Endpoint__c + 'symbols?access_key=' + FIXIER_SETTINGS.API_Key__c;

        HttpResponse response = RESTUtils.sendRequest(Constants.GET_METHOD, endpoint);
        Integer statusCode = response.getStatusCode();

        if (statusCode == 200) {
            String responseBody = response.getBody();
            Symbols_ResponseDTO responseDTO = (Symbols_ResponseDTO) JSON.deserialize(responseBody, Symbols_ResponseDTO.class);
            return responseDTO.symbols;
        } else {
            throw new CalloutException('Callout failed with status code: ' + statusCode);
        }
    }


    /*
        Version: 11.06.2025
        Latest Rates Endpoint
        Depending on your subscription plan, the API's latest endpoint will return real-time
        exchange rate data updated every 60 minutes, every 10 minutes or every 60 seconds.
        Endpoint: https://data.fixer.io/api/latest?access_key=API_KEY&base=USD&symbols=GBP,JPY,EUR
        Response:
        {
            "success": true,
            "timestamp": 1519296206,
            "base": "USD",
            "date": "2025-06-10",
            "rates": {
                "GBP": 0.72007,
                "JPY": 107.346001,
                "EUR": 0.813399,
            }
        }
     */

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

    public static Latest_ResponseDTO getLatestRates(String baseCurrency, List<String> targetCurrencies) {
        String endpoint = FIXIER_SETTINGS.Base_Endpoint__c + 'latest?access_key=' + FIXIER_SETTINGS.API_Key__c + prepareLatestRatesRequestString(baseCurrency, targetCurrencies);

        HttpResponse response = RESTUtils.sendRequest(Constants.GET_METHOD, endpoint);
        Integer statusCode = response.getStatusCode();

        if (statusCode == 200) {
            String responseBody = response.getBody();
            Latest_ResponseDTO responseDTO = (Latest_ResponseDTO) JSON.deserialize(responseBody, Latest_ResponseDTO.class);
            return responseDTO;
        } else {
            throw new CalloutException('Callout failed with status code: ' + statusCode);
        }
    }
    private static String prepareLatestRatesRequestString(String baseCurrency, List<String> targetCurrencies) {
        return '&base=' + baseCurrency + '&symbols=' + String.join(targetCurrencies, ',');
    }
}