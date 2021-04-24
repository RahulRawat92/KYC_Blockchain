Creation and Verification of KYC over Blockchain
Phase 2 details: 
 

For this phase, you need to add a KYC request struct and edit the customer & bank structs as following: 

 

Customer:

Username of the customer - Username is Provided by the Customer and is used to track the customer details. This is unique for a customer. Datatype - string
Customer data - This is the customer's data or identification documents provided by the Customer. This is unique for a customer. Datatype - string
kycStatus- This is the status of the kyc request. If the number of upvotes/downvotes meet the required conditions, set kycStatus to true otherwise false. Datatype boolean
Downvotes - This is the number of downvotes received from other banks over the Customer data. Datatype - unsigned Integer
Upvotes - This is the number of upvotes received from other banks over the Customer data. Datatype - unsigned Integer
Bank - This is a unique address of the bank that validated the customer account. Datatype - address
 

Banks (Organization):

Name - This variable specifies the name of the bank/organisation.

Datatype - string

ethAddress - This variable specifies the unique Ethereum address of the bank/organisation

Datatype - address

Report- This is the the number of reports against this bank done by other banks in the network.

Datatype - unsigned integer

KYC_count - These are the number of KYC requests initiated by the bank/organisation.

Datatype - unsigned integer

kycPermission - This is a boolean to hold status of bank. If set to false bank cannot upvote/downvote any more customers.

regNumber - This is the registration number for the bank. This is unique.

Datatype - string

 

KYC Request: 

The Smart Contract will contain a KYC request from the Bank, which will be initiated for a customer. This request will have the following data associated with it:

UserName - Username will be used to map the KYC request with the customer data. A person has a unique username but she can have multiple KYC requests with that username.

Datatype - string

BankAddress - Bank address here is a unique account address for the bank, which can be used to track the bank.

Datatype - address

Customer data - This is the customer's data or identification documents provided by the Customer. This is unique for each request.

Datatype - string

 

Use Case:
If the user accepts to share data, following steps will take place

A bank will check Blockchain to fetch the hash of the customer data and use the hash to fetch the actual customer data from a secure storage.

Any bank can raise the kyc request of the customer given that the customer has provided additional information for the same to the bank.

A bank will update the KYC data if required.

If data is not already present with the Smart Contract then the bank will create a new request to add the KYC of the customer.

Banks will additionally provide upvote/downvote over the user data for KYC
Banks can also report the other banks for security and authenticity of the banks in the network.



 

Bank Interface:
Following are the functions that you need to write in your smart contract. These are the functions that a bank can call.

Add Request - This function is used to add the KYC request to the requests list. If kycPermission is set to false bank won’t be allowed to add requests for any customer. 

Parameters - Customer name as a string and hash of the customer data as a string.

Add Customer - This function will add a customer to the customer list. If IsAllowed is false then don't process the request. 

Parameter - Customer name as a string and data of the customer data as a string.

Remove Request - This function will remove the request from the requests list.

Parameters - Customer name as string and hash of the customer data as a string.

Remove Customer - This function will remove the customer from the customer list. Remove the kyc requests of that customer too. Only the bank which added the customer can remove him.

Parameters - Customer name as string.

View Customer - This function allows a bank to view details of a customer.

Parameters - Customer name as string.

Return - Customer name and data as string.

Upvote customers - This function allows a bank to cast an upvote for a customer. This vote from a bank means that it accepts the customer details as well acknowledge the KYC process done by some bank on the customer. 

Parameters - Customer name as string.

Downvote customers - This function allows a bank to cast an downvote for a customer. This vote from a bank means that it does not accept the customer details.

Parameters - Customer name as string.

Modify Customer - This function allows a bank to modify a customer's data. This will remove the customer from the kyc request list and set the number of downvote and upvote to zero. 

Parameters - Customer username and data as string.

Get Bank Reports- This function is used to fetch bank reports from the smart contract. 

Parameters - Bank address is passed as address to fetch bank ratings.

Return - Integer number of reports against the bank.

Get Customer Status - This function is used to fetch customer kyc status from the smart contract. If true then the customer is verified.

Parameters - Customer username as a string.

Return - Boolean 

View Bank Details (Unique Identifier for the Bank) - This function is used to fetch the bank details.

Parameters - Bank address is passed to the function.

Return - The return type of this function will be of type Bank.

 

Admin Interface
Below are the functions specific to admin.

Add Bank - This function is used by the admin to add a bank to the KYC Contract. You need to verify if the user trying to call this function is admin or not.

Parameters - Bank name as string, bank address as address and bank registration number as string are passed to the function “Add Bank”. Set number of reports initially to zero and kyc permission as allowed/true.

Modify bank kycPermission - This function can only be used by the admin to change the status of kycPermission of any of the banks at any point of the time.

Parameters -Bank address 

Remove Bank - This function is used by the admin to remove a bank from the KYC Contract.  You need to verify if the user trying to call this function is admin or not.

Parameters -Bank address as address is passed to the function “Remove Bank.”

 

Smart Contract Flow
 Bank collects the information for the KYC from Customer.

The information collected includes User Name and Customer data which is the hash link for the data present at a secure storage. This username is unique for each customer. 

A bank creates the request for submission which is stored in the smart contract.

A bank then verifies the customer KYC data which is then added to the customer list.

Other banks can get the customer information from the customer list.

Other banks can also provide upvotes/downvotes on customer data, to showcase the authenticity of the data. If the number of upvotes is greater than the number of downvotes then the kysStatus of that customer is set to true. If a customer gets downvoted by one third of the bank's kycStatus is changed to false even if the number of upvotes is more than downvotes. For such a logic there should be a minimum of 5 or 10 banks in the network.

Banks can also report other banks if they find the bank to be corrupt and it is  verifying false customers. Such corrupted banks then will be banned from upvoting/downvoting further . If more than one third of the total banks in the network report against a certain bank then the bank will be banned(i.e. Set kycPermission to false of that corrupt bank.)

 

Points to remember while writing smart contract:

Make use of constructors and modifiers in the code. For eg. use constructor to set msg.sender as admin  while deploying smart contract and modifier to restrict the use of admin functionalities.

Implement some mathematical logic to assess whether a bank is faulty or not. For ex. Use the number of reports against each bank. If reports exceed more than half(or one third) of the total banks present in the network, set kycPermission to false or if the customer verified by a bank gets more than a threshold number of downvotes then the bank gets banned from doing any further KYC. For such a system to work there should be a certain minimum number of banks in the network.

You need to add certain checks from your side to optimise the smart contract such as check whether the customer exists before addKycrequest.

Only valid banks should be allowed to add/modify/remove customers.

Try to avoid use of arrays to store data. Use mappings instead. Avoid use of any loops in the code.


Deployment of Smart Contract on Private Network
Phase 3 details: 

In this phase, we would go into building a private ethereum chain and running the smart contract over it. This simulation will actually help you see the complete industry-specific project related to Ethereum. This will also help you learn how to set up a chain and deploy smart contracts over the same. Many industries require you to set up such solutions. For example, if you want to do a patient record sharing smart contract between multiple hospitals. You can use this as a reference to build such solutions.

 

Flow for Deployment
Initialize truffle for creation of the folder structure to work with Smart Contracts

Truffle is a Solidity Framework and IDE, which is used to compile, deploy and test your Smart contract. To start off, you need to create a truffle project first. The command given here will help you create the folder structure:

Truffle init
 

 

Once initialization operation is completed, you'll now have a project structure with the following items:

contracts/ - This is the directory for storing Solidity contracts.

migrations/ - This is the directory for scriptable deployment files which in turn are javascript files used for deploying contracts over the Ethereum network.

test/ - This is the directory for storing the test files which are used for testing your application and contracts. These are based on Mocha or Chai frameworks.

Truffle.js - This is the truffle configuration file where you will provide your network details.

 

Create KYC Smart Contract with the truffle suite
You have already created the smart contract in phase 2. We will use the same smart contract in phase 3. You can create a file under contracts folder, name it KYC.sol and copy the contract to that file.

 

Note:  .sol is the extension used for the solidity files, which are understandable by truffle suit.

 

You need to configure the truffle migrations to deploy the solidity code to a private blockchain. A sample migration file for KYC Contract will look like this:

 

Filename: 2_kyc_migration.js

var KYCContract = artifacts.require("KYCContract");

module.exports = function(deployer) {
  // deployment steps
  deployer.deploy(KYCContract);
};
 

 

If you notice here, the filename is prefixed with a number and suffixed by a description. The numbered prefix is required in order to record whether the migration ran successfully. The suffix is purely for human readability.

 

There are few things to consider here:

Artifacts.require - This will tell truffle which contract we are working with.

Module.exports - This is where we tell truffle to deploy the contract.

Deployer - This is used to stage deployment tasks.

 

Update the truffle task runner with account and network details
After setting up the contract, you need to configure the truffle configuration for deployment on the private Ethereum chain. Your configuration file is called truffle-config.js and is located at the root of your project directory. 

 

A sample configuration for the Blockchain will look like this:

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1", // Match your private chain IP
      port: 8545, // Match your private chain port
      network_id: "2019" // Match you private chain network id
    }
  }
};
 

There are few things to consider here too:

Host - This is the IP address for the node which is running the private blockchain. If you are deploying smart contract from the same node, then you can use “127.0.0.1”, which diverts to the localhost. You can specify the host in your private chain by using:

geth --rpcaddr value
If you don’t specify anything then the default is taken as localhost.

Port - This is the port number which your private blockchain is utilizing. You can specify the port in your private chain by using:

geth --rpcport value
If you don’t specify anything then the default port is taken as “8545”.

Network ID - This is the network id supplied as an integer which is used by your private blockchain. You can specify the network id in your private chain by using the following command:

geth --networkid value
There are many network ids which are reserved for pre-existent chains. Make sure you provide the network id, as the default network id is taken as “1”, which will connect your solution with the Ethereum Mainnet.

 

Apart from this we can also provide the Ethereum compiler version for solidity in the “truffle.js” file. To add the compiler version, you need to add the following details in the module.exports under truffle.js:

compilers: {
   solc: {
     version: <string>

}

}
 

Compile the smart contract using truffle
Once you are ready with all the artifacts, you can now deploy the contract over the private Ethereum chain. But before that you need to compile the KYC contract. To compile the contract, change to the root of the directory where the project is located and then type the following command in the terminal:

truffle compile
When this command is executed for the first time, all the contracts under “contracts” folder are compiled. Upon subsequent runs, Truffle only compiles the contracts that are changed since the last compile.

 

Deploy on the private ethereum blockchain
The deployment of KYC Smart contract happens through the migrate command. To run the KYC migration, run the following:

truffle migrate
This will run all migration files located within your project's migrations directory. If you have already run the migration command before and are running it again then truffle migrate will start execution from the last migration that was run thereby running only newly created migration files. If no new migration files exist, truffle migrate won't perform any action at all.

 

Once the Smart Contract is deployed, we can use the geth command line to execute the functions in the smart contract and simulate the KYC process over Blockchain.
