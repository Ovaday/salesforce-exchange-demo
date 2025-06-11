public with sharing class ExchangeRateController {
    @AuraEnabled(Cacheable=true)
    public static Map<String, String> getSupportedCurrencies() {
        return FixierCallout.getSupportedSymbols();
    }


    @AuraEnabled(Cacheable=true)
    public static Map<String, Decimal> getExchangeRates(String fromCurrency, List<String> targetCurrencies) {
        FixierCallout.Latest_ResponseDTO responseDTO = FixierCallout.getLatestRates(fromCurrency, targetCurrencies);

        if (!responseDTO.success && responseDTO.error != null) {
            throw new AuraHandledException('Fixier:' + responseDTO.error.type + ': ' + responseDTO.error.info);
        }

        if (!responseDTO.success) {
            throw new AuraHandledException('Failed to get exchange rates.');
        }

        Map<String, Map<String, Decimal>> exchangeRates = responseDTO.exchangeRates();

        if (exchangeRates.containsKey(fromCurrency)) {
            return exchangeRates.get(fromCurrency);
        }
        
        throw new AuraHandledException('Exchange rate not available for selected currencies.');
    }
}
