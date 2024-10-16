import { LightningElement } from 'lwc';

export default class LwcDemo1HelloWorld extends LightningElement {
    
    clicked = false;
    handleClick(event){
        this.clicked = true;
    }    
}