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
        Map<String, Map<String, String>> rates = FixierCallout.getLatestRates('EUR', new List<String>{'USD', 'GBP'});
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
}