import { LightningElement } from 'lwc';
import makeAPICall from '@salesforce/apex/PostalCodeAPIController.makeAPICall';
import getFullAddressforpostcode from '@salesforce/apex/PostalCodeAPIController.getFullAddressforpostcode';
export default class AddressLookup extends LightningElement {
    // Define component properties
    address = [];
    selectedAddress;
    addressDetail = {};
    city;
    country;
    district;

    // Getter to check if address details are available
    get hasAddressDetails() {
        return (this.address !== null && this.address.length);
    }

     // Method to handle change in the search input
    handleChange(event){
        event.preventDefault();
        let searchText = event.target.value;
        if(searchText){
            this.getAddressRecommendations(searchText);
        }else{
            this.address = [];
        }           
    }

    // Method to fetch address recommendations from backend
    getAddressRecommendations(searchText){
        makeAPICall({postcode:searchText})
        .then(response =>{
            
            this.address = response;
        }).catch(error => {
        })
    }

     // Method to reset address fields
    resetAddress(){
        this.city = '';
        this.country = '';
        this.district = '';
    }

     // Method to handle selection of an address recommendation
    handleAddressRecommendationSelect(event){
        event.preventDefault();
        let id = event.currentTarget.dataset.value;
        this.address = [];
        this.resetAddress();
         
        getFullAddressforpostcode({id:id})
        .then(response=>{
            let currentaddress = response && response.length > 0 ? response[0] : {};
            if (currentaddress.hasOwnProperty('country')) {
                this.country = currentaddress.country;
            }
            if (currentaddress.hasOwnProperty('district')) {
                this.district = currentaddress.district;
            } 
            if (currentaddress.hasOwnProperty('town_or_city')) {
                this.city = currentaddress.town_or_city;
            }       
        
    })
    .catch(error => {
      
    });
}
}