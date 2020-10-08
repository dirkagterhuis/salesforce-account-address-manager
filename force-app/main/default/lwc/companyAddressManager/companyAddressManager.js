import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getNLastCreatedAccountsWithoutAddress from '@salesforce/apex/CompanyAddressManagerController.getNLastCreatedAccountsWithoutAddress';
import getNLastModifiedAccountsWithAddress from '@salesforce/apex/CompanyAddressManagerController.getNLastModifiedAccountsWithAddress';
import searchAddressForAccount from '@salesforce/apex/CompanyAddressManagerController.searchAddressForAccount';

const columns = [
    { label: 'Company Name', fieldName: 'Name', sortable: true },
    { label: 'Phone Number', fieldName: 'Phone', type: 'phone', sortable: true },
    { label: 'Street', fieldName: 'BillingStreet', sortable: true},
    { label: 'Postal Code', fieldName: 'BillingPostalCode', sortable: true},
    { label: 'City', fieldName: 'BillingCity', sortable: true},
    { label: 'Country', fieldName: 'BillingCountry', sortable: true}
];
const columnsWithGetAddressButton = [
    ...columns,
    {
        type: 'button',
        typeAttributes: {
            label: 'Get Address',
            name: 'getAddress',
            title: 'Get address for this company based on the company name',
            value: 'getAddress',
        }
    },
];

export default class CompanyAddressManager extends LightningElement {
    @api maxNumberOfAccountsWithoutAddress;
    @api maxNumberOfAccountsWithAddress;
    @track dataWithAddress;
    @track dataWithoutAddress;
    data = [];
    columns = columns;
    columnsWithGetAddressButton = columnsWithGetAddressButton;

    async connectedCallback() {
        const dataWithoutAddress = await getNLastCreatedAccountsWithoutAddress({
            recordLimit: this.maxNumberOfAccountsWithoutAddress
        });
        this.dataWithoutAddress = dataWithoutAddress;
        const dataWithAddress = await getNLastModifiedAccountsWithAddress({
            recordLimit: this.maxNumberOfAccountsWithAddress
        });
        this.dataWithAddress = dataWithAddress;
    }

    async callRowAction(event) {
        const recordId = event.detail.row.Id;
        const companyName = event.detail.row.Name;
        if (event.detail.action.name === 'getAddress') {
            searchAddressForAccount({
                recordId: recordId,
                accountName: companyName
            })
            .then(result => {
                let variantType = 'success';
                if (result !== 'Success') {
                    variantType = 'warning';
                }
                const evt = new ShowToastEvent({
                    title: result,
                    variant: variantType,
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
                this.connectedCallback();
            })
            .catch(error => {
                const evt = new ShowToastEvent({
                    title: 'Application Error',
                    message: error.body.message,
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
            });
        }
    }
}