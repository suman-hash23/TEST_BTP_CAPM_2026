using CatalogService as service from '../../srv/CatalogService';

annotate service.PurchaseOrderSet with @(
//ADD fields for filtering the data
  UI.SelectionFields: [
      PO_ID,
      PARTNER_GUID.COMPANY_NAME,
      PARTNER_GUID.ADDRESS_GUID.COUNTRY,
      GROSS_AMOUNT,
      OVERALL_STATUS
  ],

  //add fields for table columns
  UI.LineItem: [
    {
        $Type : 'UI.DataField',
        Value : PO_ID,
    },
    {
        $Type : 'UI.DataField',
        Value : PARTNER_GUID.COMPANY_NAME,
    },
    {
        $Type : 'UI.DataField',
        Value : PARTNER_GUID.ADDRESS_GUID.COUNTRY,
    },
    {
        $Type : 'UI.DataField',
        Value : GROSS_AMOUNT,
    },
    {
        $Type : 'UI.DataFieldForAction',
        Action : 'CatalogService.boost',
        Label : 'boost',
        Inline : true,
    },
    {
        $Type : 'UI.DataField',
        Value : OVERALL_STATUS,
        Criticality : IconColour,
    },
  ],

  UI.HeaderInfo:{
     //Title for first screen
     TypeName : 'PurchaseOrder',
     TypeNamePlural : 'PurchaseOrders',
     //Title for second screen
     Title : {Value: PO_ID},
     Description : {Value: PARTNER_GUID.COMPANY_NAME},
     ImageUrl : 'https://yt3.googleusercontent.com/bDPjjcxymXP6PGdXVx_wNAeX9ZANW4-7qeeaccErodOpZ_paGZMTNIcZAKxN0SOtUs2KmgBwXCk=s900-c-k-c0x00ffffff-no-rj'
  },
  //Add tab strips to object page
  UI.Facets:[
  {
      $Type : 'UI.CollectionFacet',
      Label : 'General Information',
      Facets : [
         {
             Label : 'Basic Info',
             $Type : 'UI.ReferenceFacet',
             Target : '@UI.Identification',
         },
         {
             Label : 'Pricing Details',
             $Type : 'UI.ReferenceFacet',
             Target : '@UI.FieldGroup#Spiderman',
         },
         {
             Label : 'Additional Data',
             $Type : 'UI.ReferenceFacet',
             Target : '@UI.FieldGroup#Superman',
         },
      ]
  },
  {
      $Type : 'UI.ReferenceFacet',
      Label : 'Items',
      Target : 'Items/@UI.LineItem',
  },
  ],

  //default block which is always and always ONE - identification
  //Contains the group of fields
  UI.Identification: [
      {
          $Type : 'UI.DataField',
          Value : PO_ID,
      },
      {
          $Type : 'UI.DataField',
          Value : PARTNER_GUID_NODE_KEY,
      },
      {
          $Type : 'UI.DataField',
          Value : NOTE,
      },

  ],
  UI.FieldGroup #Spiderman:{
    Data : [
        {
            $Type : 'UI.DataField',
            Value : GROSS_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : NET_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : TAX_AMOUNT,
        },
    ],
  },
  //FieldGroup for status data
  //To avoid system getting confused with duplicate annotations we use identifier #
  UI.FieldGroup #Superman:{
     Data : [
        {
            $Type : 'UI.DataField',
            Value : CURRENCY_code,
        },
        {
            $Type : 'UI.DataField',
            Value : OVERALL_STATUS,
        },
        {
            $Type : 'UI.DataField',
            Value : LIFECYCLE_STATUS,
        },
     ],
  },
);

annotate service.PurchaseItemsSet with @(
    UI.HeaderInfo:{
     //Title for first screen
     TypeName : 'PO Item',
     TypeNamePlural : 'PurchaseOrdersItems',
     //Title for second screen
     Title : {Value: PO_ITEM_POS},
     Description : {Value: PRODUCT_GUID.DESCRIPTION},
     ImageUrl : 'https://yt3.googleusercontent.com/bDPjjcxymXP6PGdXVx_wNAeX9ZANW4-7qeeaccErodOpZ_paGZMTNIcZAKxN0SOtUs2KmgBwXCk=s900-c-k-c0x00ffffff-no-rj'
  },
    UI.LineItem: [
       {
           $Type : 'UI.DataField',
           Value : PO_ITEM_POS,
       },
       {
           $Type : 'UI.DataField',
           Value : PRODUCT_GUID_NODE_KEY,
       },
       {
           $Type : 'UI.DataField',
           Value : GROSS_AMOUNT,
       },
       {
           $Type : 'UI.DataField',
           Value : NET_AMOUNT,
       },
       {
           $Type : 'UI.DataField',
           Value : TAX_AMOUNT,
       },
    ],
    UI.Facets : [
       {
           $Type : 'UI.ReferenceFacet',
           Label : 'Item details',
           Target : '@UI.Identification',
       },
    ],
    UI.Identification :[
        {
            $Type : 'UI.DataField',
            Value : PO_ITEM_POS
        },
        {
            $Type : 'UI.DataField',
            Value : PRODUCT_GUID_NODE_KEY,
        },
        {
            $Type : 'UI.DataField',
            Value : GROSS_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : NET_AMOUNT
        },
        {
            $Type : 'UI.DataField',
            Value : TAX_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : CURRENCY_code,
        },
    ]

);

//Annotate a field to get its meaningfull text
annotate service.PurchaseOrderSet with{
    @(
        Common.Text: OverallStatus,
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'StatusCode',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : OVERALL_STATUS,
                    ValueListProperty : 'code',
                },
            ],
            Label : 'Status',
        },
        Common.ValueListWithFixedValues : true,
    )
    OVERALL_STATUS;
    @Common.Text: NOTE
    PO_ID;
    @Common.Text: PARTNER_GUID.COMPANY_NAME
    //To get only text values
   // @Common : { TextArrangement : #TextOnly, }
   @ValueList.entity : service.BusinessPartnerSet
    PARTNER_GUID;
};

//Annotate a field to get its meaningfull text
annotate service.PurchaseItemsSet with{
    @Common.Text: PRODUCT_GUID.DESCRIPTION
    //To get only text values
   // @Common : { TextArrangement : #TextOnly, }
   @ValueList.entity : service.ProductSet
    PRODUCT_GUID;
};


//Design valuehelp in CAPM for partnerguid  and productguid
@cds.odata.valuelist
annotate service.BusinessPartnerSet with @(
    UI.Identification:[
        {
            $Type : 'UI.DataField',
            Value : COMPANY_NAME,
        },
    ]
) ;

@cds.odata.valuelist
annotate service.ProductSet with @(
    UI.Identification:[
        {
            $Type : 'UI.DataField',
            Value : DESCRIPTION,
        },
    ]
) ;

annotate service.StatusCode with {
    code @Common.Text : value
};

