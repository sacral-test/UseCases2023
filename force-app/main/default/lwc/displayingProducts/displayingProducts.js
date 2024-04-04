import { LightningElement,wire } from 'lwc';
import getProducts from '@salesforce/apex/ProductController.getProducts';
import updateSalesPrices from '@salesforce/apex/ProductController.updateSalesPrices';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import ProfileName from '@salesforce/schema/User.Profile.Name';
import Id from '@salesforce/user/Id';
import Toast_SUCCESS from '@salesforce/label/c.Success';
import Toast_ERROR from '@salesforce/label/c.Error';
import Toast_Success_Message from '@salesforce/label/c.Success_Message';
import Toast_Error_Message from '@salesforce/label/c.Error_Message';
import Toast_Price_Error_Message from '@salesforce/label/c.Price_Error_Message';
import Toast_Edit_Error_Message from '@salesforce/label/c.Edit_Error_Message';
import label_Adminprofile from '@salesforce/label/c.Edit_Admin_Access';
import {refreshApex} from '@salesforce/apex';
const columns1 = [
    {label:'Product Name', fieldName: 'Name', type:'text'},
    {label:'Sales Price', fieldName: 'UnitPrice', type:'text', editable:true}
    
 ];

 const columns2 = [
    {label:'Product Name', fieldName: 'Name', type:'text'},
    {label:'Sales Price', fieldName: 'UnitPrice', type:'text',editable:true}
    
 ];

export default class DisplayingProducts extends LightningElement {
   
    columns;
    data= [];
    savedraftvalues = [];
    OpportunityLineItem = [];
    userProfileName;
    isAdmin = false;
    error;
    userId = Id;
    productdata1 = [];

   @wire(getRecord, { recordId: Id, fields: [ProfileName] })
    userDetails({ error, data }) {
        if (error) {
            this.error = error;
        } else if (data) {
            if (data.fields.Profile.value != null) {
                this.userProfileName = data.fields.Profile.value.fields.Name.value;
                if(label_Adminprofile.includes(this.userProfileName)){
                    this.isAdmin = true;
                    this.columns = columns2;
                }else{
                    this.columns = columns1;
                }
            }
        }
    }

    // geting the products data
   @wire(getProducts)
   wiredproducts(result){
    this.productdata1 = result; 
    if(result.error){  
        this.data = undefined;
        this.error = result.error;
        
    }
    if(result.data){
        this.OpportunityLineItem = result.data;
    }
   }

handleSave(event) {
    const updatesalespricefield = event.detail.draftValues;
    // validating the sales prices on products
    if (this.isAdmin && this.validateSalesPrice(updatesalespricefield)) {
        console.log('updatesalespricefield'+updatesalespricefield);
        updateSalesPrices({ productdata: updatesalespricefield })
            .then((result) => {
                this.savedraftvalues = [];
                this.showToast(Toast_SUCCESS,Toast_Success_Message,Toast_SUCCESS);
                refreshApex(this.productdata1);
                         
            })
            .catch((error) => {
                this.showToast(Toast_ERROR,Toast_Error_Message,Toast_ERROR);
            });
    } 
    else if(!this.isAdmin){
        
        this.showToast(Toast_ERROR,Toast_Edit_Error_Message,Toast_ERROR)
    }
    else  {
        this.savedraftvalues = [];
        this.showToast(Toast_ERROR,Toast_Price_Error_Message,Toast_ERROR);
    }
}

// this method validate the Sales Prices can not enter more than 1000
validateSalesPrice(draftValues) {
    for (let k = 0; k < draftValues.length; k++) {
        if (draftValues[k].UnitPrice > 1000) {
            return false;  
        }
    }
    return true; 
}

// displaying the tosat messages 
showToast(title, message, variant) {
    const toastEvent = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant,
    });
    this.dispatchEvent(toastEvent);
}

}