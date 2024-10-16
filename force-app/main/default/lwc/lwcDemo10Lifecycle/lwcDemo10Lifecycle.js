import { LightningElement } from 'lwc';

export default class LwcDemo10Lifecycle extends LightningElement {
    message = 'Hello';
    count = 0;

    handleClick(event){
        this.message = 'Updated Message';
        this.count = this.count + 1;
    }
    constructor(){
        super();
        console.log('Constructor is getting called');
    }
    connectedCallback(){
        console.log('Connected Callback is getting called');
    }
    renderedCallback(){
        console.log('Rendered Callback is getting called');
        if(this.count < 1000){
            this.count = this.count + 1;
        } //Do not update any property in rendered callback as it creates infinite loop
    }
    disconnectedCallback(){
        console.log('Disconnected Callback is getting called');
    }
}