/**
 * Created by eab on 10.06.2025.
 */

@IsTest
private class ExchangeRateControllerTEST {
    @IsTest
    static void testGetSupportedCurrencies() {
        Test.setMock(HttpCalloutMock.class, RESTUtils.prepareMockCallout('Fixier_SymbolsMockResponse', 200));

        Test.startTest();
        Map<String, String> supportedCurrencies = ExchangeRateController.getSupportedCurrencies();
        Test.stopTest();

        Assert.isNotNull(supportedCurrencies);
        Assert.isTrue(supportedCurrencies.size() > 0);
    }

    @IsTest
    static void testGetExchangeRate() {
        Test.setMock(HttpCalloutMock.class, RESTUtils.prepareMockCallout('Fixier_LatestMockResponse', 200));

        Test.startTest();
        Map<String, Decimal> exchangeRates = ExchangeRateController.getExchangeRates('EUR', new List<String>{'GBP', 'USD'});
        Test.stopTest();

        Assert.isNotNull(exchangeRates);
        Assert.isTrue(exchangeRates.size() > 0);
    }
}