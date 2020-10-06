import { LightningElement, api, track } from 'lwc';
import getNLastModifiedAccountsWithAddress from '@salesforce/apex/CompanyAddressManagerController.getNLastModifiedAccountsWithAddress';
import getNLastCreatedAccountsWithoutAddress from '@salesforce/apex/CompanyAddressManagerController.getNLastCreatedAccountsWithoutAddress';

const columnsWithAddress = [
  { label: 'Company Name', fieldName: 'Name', sortable: true },
  { label: 'Phone Number', fieldName: 'Phone', type: 'phone', sortable: true },
  { label: 'Street', fieldName: 'BillingStreet', sortable: true},
  { label: 'Postal Code', fieldName: 'BillingPostalCode', sortable: true},
  { label: 'City', fieldName: 'BillingCity', sortable: true},
  { label: 'Country', fieldName: 'BillingCountry', sortable: true}
];
const columnsWithoutAddress = [...columnsWithAddress, { label: 'Get Address', fieldName: 'TEST' }];

export default class CompanyAddressManager extends LightningElement {
  @api maxNumberOfAccountsWithAddress;
  @api maxNumberOfAccountsWithoutAddress;
  @track dataWithAddress;
  @track dataWithoutAddress;

  data = [];
  columnsWithAddress = columnsWithAddress;
  columnsWithoutAddress = columnsWithoutAddress;

  async connectedCallback() {
    const dataWithAddress = await getNLastModifiedAccountsWithAddress({ recordLimit: this.maxNumberOfAccountsWithAddress });
    this.dataWithAddress = dataWithAddress;
    const dataWitoutAddress = await getNLastCreatedAccountsWithoutAddress({ recordLimit: this.maxNumberOfAccountsWithoutAddress });
    this.dataWithoutAddress = dataWitoutAddress;
  }
}