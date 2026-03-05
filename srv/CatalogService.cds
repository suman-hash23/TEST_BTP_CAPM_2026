//consume reference of DB tables
using { anubhav.db.master , anubhav.db.transaction } from '../db/datamodel';

service CatalogService @(path : 'CatalogService', requires : 'authenticated-user') {

//Entity - representation of an end point of data to perform CURDQ operations
    entity EmployeeSet @(restrict :[
                        {grant : ['READ'], to: 'Viewer',
                        //row level security
                        where :'bankName = $user.spiderman'},
                        {grant : ['WRITE','DELETE'], to: 'Editor'}
                      ])
                       as projection on master.employees;
    entity ProductSet as projection on master.product;
    entity BusinessPartnerSet as projection on master.businesspartner;
    entity AddressSet as projection on master.address;
    @readonly
    entity StatusCode as projection on master.StatusCode;
    //@Capabilities : { Deletable : false }
    entity PurchaseOrderSet @(
                      restrict :[
                        {grant : ['READ'], to: 'Viewer'},
                        {grant : ['WRITE','DELETE'], to: 'Editor'}
                      ],
                      odata.draft.enabled: true,
                      Common.DefaultValuesFunction: 'getDefaultValue') as projection on transaction.purchaseorder{
        //CDS expression language
        *,
        case OVERALL_STATUS
        when 'P' then 'Pending'
        when 'A' then 'Approved'
        when 'X' then 'Rejected'
        when 'D' then 'Delivered'
        else 'unknown'
        end as OverallStatus: String(10),

         case OVERALL_STATUS
        when 'P' then '2'
        when 'A' then '3'
        when 'X' then '1'
        when 'D' then '3'
        else 'unknown'
        end as IconColour: String(10),
    }
    actions{
    //the system will pass the PO primary key - NODE_KEY automatically to input
    //Side Effect - a trigger to my action leads to a change of my field value in data
    //This force framework to make a GET call after action is triggered
    //_anubhav is a variable that will contain updated data coming from backend
    @cds.odata.bindingparameter.name: '_anubhav'
    @Common.SideEffects : {
        TargetProperties : ['_anubhav/GROSS_AMOUNT']
    }
    action boost() returns PurchaseOrderSet
    };
    entity PurchaseItemsSet as projection on transaction.poitems;

//non instance bound because they are not connected to any entity
    function getLargestOrder() returns array of  PurchaseOrderSet;
    function getDefaultValue() returns PurchaseOrderSet;


}