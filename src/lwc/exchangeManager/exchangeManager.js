/**
 * Created by eab on 04.06.2025.
 */

import { LightningElement, wire } from 'lwc';
import getSupportedCurrencies from '@salesforce/apex/ExchangeRateController.getSupportedCurrencies';
import getExchangeRates from '@salesforce/apex/ExchangeRateController.getExchangeRates';

export default class ExchangeManager extends LightningElement {
    fromCurrency = '';
    selectedCurrencies = [];
    exchangeRates = {};
    error = null;
    currencyOptions = [];
    isLoaded = false;

    get exchangeRateEntries() {
        return Object.entries(this.exchangeRates).map(([code, rate]) => ({
            currencyCode: code,
            rate: rate
        }));
    }

    @wire(getSupportedCurrencies)
    wiredSupportedCurrencies({ error, data }) {
        if (data) {
            // Convert the currency map to an array of options
            this.currencyOptions = Object.entries(data).map(([code, name]) => ({
                label: `${code} (${name})`,
                value: code
            }));
        } else if (error) {
            console.error('Error loading currencies:', error);
            this.error = 'Error loading currency options. Please try again later or contact System Administrator.';
            // Fallback to default currency
            this.currencyOptions = [
                { label: 'EUR (Euro)', value: 'EUR' }
            ];
        }
    }

    handleFromCurrencyChange(event) {
        this.fromCurrency = event.detail.value;
    }

    handleCurrenciesChange(event) {
        this.selectedCurrencies = event.detail.value;
    }

    fetchExchangeRate() {
        if (!this.fromCurrency || this.selectedCurrencies.length === 0) {
            this.exchangeRates = {};
            this.error = 'Please select both currencies.';
            return;
        }

        getExchangeRates({
            fromCurrency: this.fromCurrency,
            targetCurrencies: this.selectedCurrencies
        })
        .then(result => {
            if (result) {
                this.isLoaded = true;
                this.exchangeRates = result;
                this.error = null;
            } else {
                this.exchangeRates = {};
                this.error = 'No exchange rates found for selected currencies.';
            }
        })
        .catch(error => {
            this.exchangeRates = {};
            this.error = 'Error fetching exchange rates.';
            console.error('Error fetching exchange rates:', error);
        });
    }
}