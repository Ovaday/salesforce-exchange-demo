public with sharing class ExchangeRateController {
    @AuraEnabled(Cacheable=true)
    public static Map<String, String> getSupportedCurrencies() {
        FixierCallout.Symbols_ResponseDTO responseDTO = FixierCallout.getSupportedSymbols();
        responseDTO.validate();

        return responseDTO.symbols;
    }


    @AuraEnabled(Cacheable=true)
    public static Map<String, Decimal> getExchangeRates(String fromCurrency, List<String> targetCurrencies) {
        FixierCallout.Latest_ResponseDTO responseDTO = FixierCallout.getLatestRates(fromCurrency, targetCurrencies);
        responseDTO.validate();

        Map<String, Map<String, Decimal>> exchangeRates = responseDTO.exchangeRates();

        if (exchangeRates.containsKey(fromCurrency)) {
            return exchangeRates.get(fromCurrency);
        }
        
        throw new AuraHandledException('Exchange rate not available for selected currencies.');
    }

}
