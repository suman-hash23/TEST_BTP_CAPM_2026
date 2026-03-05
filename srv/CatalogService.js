const cds = require('@sap/cds')

module.exports = class CatalogService extends cds.ApplicationService { init() {

  const { EmployeeSet, ProductSet, BusinessPartnerSet, AddressSet, PurchaseOrderSet, PurchaseItemsSet } = cds.entities('CatalogService')

  this.before (['CREATE', 'UPDATE'], EmployeeSet, async (req) => {
    console.log('Before CREATE/UPDATE EmployeeSet', req.data)
   //get the employee salary info
    let SalaryAmount = parseFloat(req.data.salaryAmount);
    if(SalaryAmount > 1000000){
      //contaminate the incoming request, so capm will know something is wrong in your green box
      req.error( 500 , "Hey Amigo!! check the salary , none of employee got a million")
    }

  })
  this.after ('READ', EmployeeSet, async (employeeSet, req) => {
    console.log('After READ EmployeeSet', employeeSet)
  })
  this.before (['CREATE', 'UPDATE'], ProductSet, async (req) => {
    console.log('Before CREATE/UPDATE ProductSet', req.data)
  })
  this.after ('READ', ProductSet, async (productSet, req) => {
    console.log('After READ ProductSet', productSet)
  })
  this.before (['CREATE', 'UPDATE'], BusinessPartnerSet, async (req) => {
    console.log('Before CREATE/UPDATE BusinessPartnerSet', req.data)
  })
  this.after ('READ', BusinessPartnerSet, async (businessPartnerSet, req) => {
    console.log('After READ BusinessPartnerSet', businessPartnerSet)
  })
  this.before (['CREATE', 'UPDATE'], AddressSet, async (req) => {
    console.log('Before CREATE/UPDATE AddressSet', req.data)
  })
  this.after ('READ', AddressSet, async (addressSet, req) => {
    console.log('After READ AddressSet', addressSet)
  })
  this.before (['CREATE', 'UPDATE'], PurchaseOrderSet, async (req) => {
    console.log('Before CREATE/UPDATE PurchaseOrderSet', req.data)
  })
  this.after ('READ', PurchaseOrderSet, async (purchaseOrderSet, req) => {
    console.log('After READ PurchaseOrderSet', purchaseOrderSet)
    for( let index = 0; index < purchaseOrderSet.length; index++ ){
      const element = purchaseOrderSet[index];
      if(!element.Note){
      element.NOTE = 'Not Found'
      }
    }
  })
  this.before (['CREATE', 'UPDATE'], PurchaseItemsSet, async (req) => {
    console.log('Before CREATE/UPDATE PurchaseItemsSet', req.data)
  })
  this.after ('READ', PurchaseItemsSet, async (purchaseItemsSet, req) => {
    console.log('After READ PurchaseItemsSet', purchaseItemsSet)
  })
//Implementation for order defaults
this.on('getDefaultValue', async(req,res)=>{
   return {
      OVERALL_STATUS : 'N',
      LIFECYCLE_STATUS : 'N'
   }
});
  //generic handler to support my function implementation - always return data, GET  
  this.on('getLargestOrder', async(req,res)=>{
    try {
      const tx = cds.tx(req);
      //use CDS QL to make call to DB - select * upto 3 rows
      const reply = await tx.read(PurchaseOrderSet).orderBy({
        "GROSS_AMOUNT" : "desc"
      }).limit(3);

      return reply;

    } catch (error) {
      req.error(500, "some error occured :" + error.toString());
    }
  })


  //implementation of action -- create, update data in server
  this.on('boost', async(req) => {
    try {
      //extract the primary key  JSON - NODE_KEY: key value
      const primaryKey = req.params[0];
      //start a transaction to db
      const tx = cds.tx(req);

      //CDS query language to update gross amount by +20000
      await tx.update(PurchaseOrderSet).with({
        GROSS_AMOUNT : { '+=' : 20000 },
        NOTE: 'Boosted!'
      }).where(primaryKey);
      //read the record and send in out
      return await tx.read(PurchaseOrderSet).where(primaryKey);
    } catch (error) {
      
    }
  });
  return super.init()
}}
