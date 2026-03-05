const cds = require('@sap/cds')
const { SELECT } = require('@sap/cds/lib/ql/cds-ql')

module.exports = class CDSservice extends cds.ApplicationService { init() {

  const { ProductSet, ItemSet } = cds.entities('CDSservice')

  this.before (['CREATE', 'UPDATE'], ProductSet, async (req) => {
    console.log('Before CREATE/UPDATE ProductSet', req.data)
  })
  this.after ('READ', ProductSet, async (productSet, req) => {

    //setp-1 get all unique product ids
    let ids = productSet.map(p => p.ProductId);

    //CDS query language on item view and aggregate the data
    const orderCount = await SELECT.from(ItemSet) 
                       .columns('ProductId', {func : 'count', as: 'anubhav'})
                       .where({'ProductId': {in : ids}})
                       .groupBy('ProductId');
    
    for (let index = 0; index < productSet.length ; index++ ){
      const element = productSet[index];
      const foundRecord = orderCount.find(pc=>pc.ProductId === element.ProductId);
      element.soldCount = foundRecord ? foundRecord.anubhav : 0;
    }                   
  })
  this.before (['CREATE', 'UPDATE'], ItemSet, async (req) => {
    console.log('Before CREATE/UPDATE ItemSet', req.data)
  })
  this.after ('READ', ItemSet, async (itemSet, req) => {
    console.log('After READ ItemSet', itemSet)
  })


  return super.init()
}}
