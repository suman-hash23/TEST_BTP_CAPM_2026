//Implementation file of .js with same name
//DPC_EXT class 
const cds = require('@sap/cds')

module.exports = class MyService extends cds.ApplicationService { init() {

  this.on ('anubhav', async (req) => {
    console.log('On anubhav', req.data)
    let myName = req.data.name;
    return `Welcome to CAP server Hello ${myName} how are you today`;
  })
//calling parent class constructor
  return super.init()
}}
