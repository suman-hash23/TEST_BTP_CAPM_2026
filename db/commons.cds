namespace anubhav.common;
using { Currency  } from '@sap/cds/common';

//similar to data element
type Guid : String(32);
//domain fixed values
type Gender : String(1) enum {
    male = 'M';
    female = 'F';
    undisclosed = 'U';
}

//reference field for quantity and currency
//@ -- annotations that have special significance in CAPM
type AmountT : Decimal(10,2) @(
    Semantic.amount.currencyCode : 'CURRENCY_code'
);


//custom structure(aspect)
//when we refer afield type that refer to another entity - that entity has a key e.g
//in this example Currency has a key code
//The column name of this structure will be COLUMN_key = CURRENCY_code 
aspect Amount{
    CURRENCY : Currency @(title : '{i18n>CURRENCY}');
    GROSS_AMOUNT : AmountT @(title : '{i18n>GROSS_AMOUNT}');
    NET_AMOUNT : AmountT @(title : '{i18n>NET_AMOUNT}');
    TAX_AMOUNT : AmountT @(title : '{i18n>TAX_AMOUNT}');
}

//to validate 
    type PhoneNumber : String(30) @assert.format : '^[6-9]\d{9}$';
    type Email : String(250) //@assert.format : '^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$';