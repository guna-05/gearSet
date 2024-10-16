import { LightningElement } from 'lwc';
import getContactDetails from '@salesforce/apex/EvaluationGetContactByAccount.getContactDetails';

export default class EvaluationContactDetailsByAccount extends LightningElement {

    accId = '001ak00000K9LITAA3';
    conData = [];

    connectedCallback(){
        getContactDetails({accountId : this.accId}).then(data=> {
            this.conData = data;
        }).catch(error=>{
            alert('error');
        })
    }
    
}