/**
 * Created by eab on 10.06.2025.
 */

@IsTest
private class FixierCalloutTEST {
    @IsTest
    static void testGetLatestRates_Success() {
        Integer amountOfRates = 7;
        String baseCurrency = 'EUR';
        Test.setMock(HttpCalloutMock.class, RESTUtils.prepareMockCallout('Fixier_LatestMockResponse', 200));

        Test.startTest();
        FixierCallout.Latest_ResponseDTO responseDTO = FixierCallout.getLatestRates('EUR', new List<String>{'USD', 'GBP'});
        Map<String, Map<String, Decimal>> rates = responseDTO.exchangeRates();
        Test.stopTest();

        Assert.isNotNull(rates, 'Rates should not be null.');
        Assert.isTrue(rates.size() > 0, 'Rates should not be empty.');
        Assert.areEqual(rates.get(baseCurrency).size(), amountOfRates, 'Rates should contain ' + amountOfRates + ' currencies.');

        for (String currencyValue : rates.keySet()) {
            Assert.isNotNull(rates.get(currencyValue), 'Rates for ' + currencyValue + ' should not be null.');
            Assert.isTrue(rates.get(currencyValue).size() > 0, 'Rates for ' + currencyValue + ' should not be empty.');
        }
    }

    @IsTest
    static void testGetLatestRates_Failure() {
        Test.setMock(HttpCalloutMock.class, RESTUtils.prepareMockCallout('Fixier_LatestMockResponse', 500));

        Test.startTest();
        Boolean isExceptionThrown = true;
        try {
            FixierCallout.getLatestRates('EUR', new List<String>{'USD', 'GBP'});
            isExceptionThrown = false;
        } catch (CalloutException e) {
            Assert.isTrue(e.getMessage().contains('Callout failed with status code: 500'), 'Callout failed with status code: 500');
        }
        Test.stopTest();

        Assert.isTrue(isExceptionThrown, 'Exception should be thrown.');
    }

    @IsTest
    static void testGetSupportedSymbols_Success() {
        Integer amountOfCurrencies = 4;
        Test.setMock(HttpCalloutMock.class, RESTUtils.prepareMockCallout('Fixier_SymbolsMockResponse', 200));

        Test.startTest();
        Map<String, String> symbols = FixierCallout.getSupportedSymbols();
        Test.stopTest();

        Assert.isNotNull(symbols, 'Symbols should not be null.');
        Assert.isTrue(symbols.size() > 0, 'Symbols should not be empty.');
        Assert.areEqual(symbols.size(), amountOfCurrencies, 'Symbols should contain ' + amountOfCurrencies + ' currencies.');
    }

    @IsTest
    static void testGetSupportedSymbols_Failure() {
        Test.setMock(HttpCalloutMock.class, RESTUtils.prepareMockCallout('Fixier_SymbolsMockResponse', 500));

        Test.startTest();
        Boolean isExceptionThrown = true;
        try {
            FixierCallout.getSupportedSymbols();
            isExceptionThrown = false;
        } catch (CalloutException e) {
            Assert.isTrue(e.getMessage().contains('Callout failed with status code: 500'), 'Callout failed with status code: 500');
        }
        Test.stopTest();

        Assert.isTrue(isExceptionThrown, 'Exception should be thrown.');
    }
}