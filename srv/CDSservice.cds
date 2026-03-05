using { anubhav.cds } from '../db/CDSviews';

service CDSservice @(path: 'CDSservice'){

    entity ProductSet as projection on cds.cdsviews.ProductView{
        *,
        //NEVER PERSISTENT INNDB
        virtual soldCount: Int16
    };
    entity ItemSet as projection on cds.cdsviews.ItemView;
}
