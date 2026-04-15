using { anubhav.cds as spiderman} from '../db/CDSviews';

service POAnalytics @(path: 'POAnalytics'){

    entity PurchaseAnalytics as projection on spiderman.cdsviews.POWorklist{
        *
    };

//As we see it not possible to use template to create fiori ALP app using CAP entity
//it is now expecting an aggregation entity - SUM,MIN,MAX,COUNT
//These annotations are crucial for fiori tools to properly recognize  and support ALP
    annotate POAnalytics.PurchaseAnalytics with @(
        Aggregation.ApplySupported:{
            Transformations : [
                'aggregate',
                'identity',
                'topcount',
                'bottomcount',
                'concat',
                'groupby',
                'filter',
                'expand',
                'search'
            ],
            GroupableProperties : [
                CompanyName,
                Description,
                CurrencyCode,
                Country
            ],
            AggregatableProperties : [
                {
                    $Type : 'Aggregation.AggregatablePropertyType',
                    Property : GrossAmount,
                },
            ],

        },
        Analytics : { 
            AggregatedProperty #GrossAmount : {
                $Type : 'Analytics.AggregatedPropertyType',
                Name : 'GrossAmount',
                AggregationMethod : 'sum',
                AggregatableProperty : GrossAmount,
                @Common.Label : 'Total purchase'
            },
         },
    );

    //Block-3 visual filter - where user gets a chart and filter bar to filter data
    //presentation variant  and value list , and chart annotation block
        annotate POAnalytics.PurchaseAnalytics with @( 
        UI.Chart #spiderman: {
            $Type : 'UI.ChartDefinitionType',
            ChartType : #Bar,
            Title : 'Filter by country',
            Dimensions : [Country],
            DimensionAttributes : [
                {
                    $Type : 'UI.ChartDimensionAttributeType',
                    Dimension : Country,
                    Role : #Category
                },              

            ],
            DynamicMeasures : [
                ![@Analytics.AggregatedProperty#GrossAmount]
            ],
            MeasureAttributes : [
                {
                    $Type : 'UI.ChartMeasureAttributeType',
                    DynamicMeasure : ![@Analytics.AggregatedProperty#GrossAmount],
                    Role : #Axis1
                },
            ],
            
        },

   //initially when UI loads , wheather we can show chart on the screen or not  
   UI.PresentationVariant #pvSpiderman : {
     $Type : 'UI.PresentationVariantType',
     Visualizations : [
        '@UI.Chart#spiderman',
     ]
   } 
    ){
       Country @Common : { 
        ValueList #vlCountry: {
            $Type : 'Common.ValueListType',
            CollectionPath : 'PurchaseAnalytics',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : Country,
                    ValueListProperty : 'Country',
                },
            ],
            PresentationVariantQualifier : 'pvSpiderman',
        },
     } 
 };
        
    annotate POAnalytics.PurchaseAnalytics with @( 
        UI.Chart : {
            $Type : 'UI.ChartDefinitionType',
            ChartType : #Column,
            Title : 'Total Purchase by company',
            Dimensions : [CompanyName],
            DimensionAttributes : [
                {
                    $Type : 'UI.ChartDimensionAttributeType',
                    Dimension : CompanyName,
                    Role : #Category
                },
                {
                    $Type : 'UI.ChartDimensionAttributeType',
                    Dimension : Country,
                    Role : #Series
                },                

            ],
            DynamicMeasures : [
                ![@Analytics.AggregatedProperty#GrossAmount]
            ],
            MeasureAttributes : [
                {
                    $Type : 'UI.ChartMeasureAttributeType',
                    DynamicMeasure : ![@Analytics.AggregatedProperty#GrossAmount],
                    Role : #Axis1
                },
            ],
            
        },
   //initially when UI loads , wheather we can show chart on the screen or not  
   UI.PresentationVariant : {
     $Type : 'UI.PresentationVariantType',
     Visualizations : [
        '@UI.Chart',
     ]
   } 
    );
    
//it will add selection fields and table cloumns
    annotate POAnalytics.PurchaseAnalytics with @(
        UI: {
            SelectionFields  : [
                PurchaseOrder,
                CompanyName,
                CurrencyCode,
                Description,
                Country
            ],
            LineItem  : [
                {
                    $Type : 'UI.DataField',
                    Value : PurchaseOrder,
                },
                {
                    $Type : 'UI.DataField',
                    Value : ItemPosition,
                },
                {
                    $Type : 'UI.DataField',
                    Value : CompanyName,
                },
                {
                    $Type : 'UI.DataField',
                    Value : GrossAmount,
                },
                {
                    $Type : 'UI.DataField',
                    Value :  CurrencyCode,
                },
                {
                    $Type : 'UI.DataField',
                    Value : Description,
                },
                {
                    $Type : 'UI.DataField',
                    Value : OverallStatus,
                },
                {
                    $Type : 'UI.DataField',
                    Value : Country,
                },
            ],
        }
    ) ;
    

}    