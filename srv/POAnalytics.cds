using { anubhav.cds as spiderman} from '../db/CDSviews';

service POAnalytics @(path: 'POAnalytics'){

    entity PurchaseAnalytics as projection on spiderman.cdsviews.POWorklist{
        *
    };

}    