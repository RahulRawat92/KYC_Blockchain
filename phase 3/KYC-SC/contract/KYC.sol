  
pragma solidity ^0.5.17;

contract KYCContract {

    //to store address of the user who deployed this smart contract
    address adminAddress;
    
    //to maintain a count of number of banks
    uint256 bankCount;

    constructor() public {
        adminAddress = msg.sender;
        bankCount = 10;
    }
    //  Struct Customer
    struct Customer { 
	    string uname;       //  uname - username of the customer   
	    string dataHash;    //  dataHash - customer data
	    bool kycStatus;     //  kycStatus given to customer given based on KYC completion
	    uint256 downvotes;  //  downvotes - number of downvotes recieved from banks
	    uint256 upvotes;    //  upvotes - number of upvotes recieved from banks
	    address bank;       //  bank - address of bank that validated the customer account
    }

    //  Struct Organisation
    struct Organisation {
	    string name;        //  name - name of the bank/organisation
	    address ethAddress; //  ethAddress - ethereum address of the bank/organisation
	    uint256 report;     //  report - number of reports against this bank done by other banks in the network
	    uint256 KYC_count;  //  KYC_count - number of KYCs verified by the bank/organisation
	    bool kycPermission; //  kycPermission  - status of bank
	    string regNumber;   //  regNumber - unique registration number for the bank
    }

    //  Struct Request
    struct Request {
	    string uname;            //  uname - username of the customer
	    address bankAddress;     //  bank - address of bank that validated the customer account
	    string customerDataHash; //  dataHash - customer data
    }

    // list of all customers
    Customer[] public allCustomers;

    // list of all Banks/Organisations
    mapping(address => Organisation) public allBanks;

    // list of all requests
    Request[] public allRequests;

    //modifier to check if the user performing the action is admin
    modifier onlyAdmin {
        require(
            adminAddress == msg.sender,
            "Only admin can perform this action"
        );
        _;
    }

    //modifier to check if the user performing the action is among the list of banks
    modifier onlyBank {
        require(
            stringsEqual(allBanks[msg.sender].name, "") == false,
            "Only a bank can perform this action, sender not among existing banks"
        );
        _;
    }

    /*
    function to add a bank to the blockchain
    onlyAdmin modifier to check if user is admin
    @param - name of bank,address of bank, registeration number of the bank
    @returns - "true" if bank was added successfully and "false" if bank could not be added as it is already present
    */
    function addBank(
        string memory name,
        address bankAddress,
        string memory bankRegNum
    ) public payable onlyAdmin returns (bool) {
        if (bankAddress == allBanks[bankAddress].ethAddress) {
            return false;
        } else {
            allBanks[bankAddress].ethAddress = bankAddress;
            allBanks[bankAddress].name = name;
            allBanks[bankAddress].regNumber = bankRegNum;
            allBanks[bankAddress].KYC_count = 0;
            allBanks[bankAddress].report = 0;
            allBanks[bankAddress].kycPermission = true;
            return true; 
        }
    }

    /*
    function to remove a bank from the list of banks
    modifier onlyAdmin to check if user calling the function is admin
    @param - storage address of the bank to be deleted from the list of banks
    @returns - "true" if bank is removed from the list and "false" if bank is not present in the list already
    */
    function removeBank(address bankAddress)
        public
        payable
        onlyAdmin
        returns (bool)
    {
        if (allBanks[bankAddress].ethAddress != 0x0000000000000000000000000000000000000000) {
            delete allBanks[bankAddress];
            return true;
        } else {
            return false;
        }
    }   
    
    /*
    function to change kycPermission status 
    modifier onlyAdmin to check if user calling the function is admin
    @param - storage address of the bank to be deleted from the list of banks
    @returns - "true" if bank status is changed and "false" if not 
    */
    function modifyKycPermission(address bankAddress)
        public
        payable
        onlyAdmin
        returns (bool)
    {
        if (bankAddress == allBanks[bankAddress].ethAddress) {
            allBanks[bankAddress].kycPermission = !allBanks[bankAddress].kycPermission;
            return true;
        } else {
            return false; 
        }
    }

    // function to add request for KYC
    // @Params - Username for the customer, bankAddress and customerDataHash
    // Function is made payable as banks need to provide some currency to start of the KYC
    //process
    //returns 0 when REQUEST cannot be added and 1 when REQUEST is added successfully
    function addRequest(string memory Uname, string memory customerDataHash)
        public
        payable
        onlyBank
        returns (uint256)
    {
        for (uint256 i = 0; i < allCustomers.length; ++i) {
            if ((stringsEqual(allCustomers[i].uname, Uname)) 
            && (stringsEqual(allCustomers[i].dataHash, customerDataHash)) 
            && (allBanks[msg.sender].kycPermission = true)) {
            allRequests.length++;
            allRequests[allRequests.length - 1] = Request(
                        Uname,
                        allBanks[msg.sender].ethAddress,
                        customerDataHash);
            return 1;
            }
        }
        return 0;
    }

    // function to remove request for KYC
    // @Params - Username for the customer
    // @return - This function returns 1 if removal is successful else this return 0 if the Username
    //for the customer is not found
    function removeRequest(string memory Uname, string memory customerDataHash)
        public
        payable
        onlyBank
        returns (int256)
    {
        
        for (uint256 i = 0; i < allRequests.length; ++i) {
            if (stringsEqual(allRequests[i].uname,Uname)&&stringsEqual(allRequests[i].customerDataHash,customerDataHash))
            {   for (uint256 j = i + 1; j < allRequests.length; ++j) {
                    allRequests[j - 1] = allRequests[j];
                }
                allRequests.length--;
                return 1;
            }
        }
        return 0;
    }


    // function to add a customer profile to the database
    // @params - Username and the hash of data for the customer are passed as
    //parameters
    // returns 1 if successful
    // returns 0 if unsuccessful
    function addCustomer(string memory Uname, string memory DataHash)
        public
        payable
        onlyBank
        returns (int256)
    {
        for (uint256 i = 0; i < allCustomers.length; ++i) {
            if (stringsEqual(allCustomers[i].uname, Uname) 
            && stringsEqual(allCustomers[i].dataHash, DataHash)) 
                return 0;
            }
        allCustomers.length++;
        allCustomers[allCustomers.length - 1] = Customer(
                    Uname,
                    DataHash,
                    false,
                    0,
                    0,
                    msg.sender);
        return 1;
    }

    // function to remove fraudulent customer profile from the database
    // @params - customer's username is passed as parameter
    // returns 1 if successful
    // returns 0 if customer profile not in database
    function removeCustomer(string memory Uname)
        public
        payable
        onlyBank
        returns (int256)
    {
        for (uint256 i = 0; i < allCustomers.length; ++i) {
            if (stringsEqual(allCustomers[i].uname, Uname) 
                && (allBanks[msg.sender].ethAddress == allCustomers[i].bank)) {
                for (uint256 j = i + 1; j < allCustomers.length; ++j) {
                    allCustomers[j - 1] = allCustomers[j];
                }
                allCustomers.length--;
                removeRequest(Uname, allCustomers[i].dataHash);
                return 1;
            }
        }
        return 0;
    }

    // function to modify a customer profile in database
    // @params - Customer username and datahash are passed as Parameters
    // returns 1 if successful
    // returns 0 if customer profile not in database
    function modifyCustomer(string memory Uname,string memory DataHash) 
    public payable onlyBank returns (uint256) {
            for (uint256 i = 0; i < allCustomers.length; ++i) {
                if (stringsEqual(allCustomers[i].uname, Uname)) {
                    allCustomers[i].dataHash = DataHash;
                    allCustomers[i].bank = msg.sender;
                    allCustomers[i].kycStatus = false;
                    allCustomers[i].upvotes = 0;
                    allCustomers[i].downvotes = 0;
                    removeRequest(Uname, DataHash);
                    return 1;
                }
            }
            return 0;
    }

    // function to return customer profile data
    // @params - Customer username is passed as the Parameters
    // @return - This function return the cutomer datahash if found, else this function returns an error
    //string.
    function viewCustomer(string memory Uname)
        public
        payable
        onlyBank
        returns (string memory)
    {
        for (uint256 i = 0; i < allCustomers.length; ++i) {
            if (stringsEqual(allCustomers[i].uname, Uname)) {
               return allCustomers[i].dataHash;
            }
        }
        return "Customer not found in database!";
    }


    /*function to upvote a customer and update its status
    Uname- its the customer name for whom upvote is done
    @return- it returns 1 if successfull and 0 if failure
    */
    function upvoteCustomer(string memory Uname)
        public
        payable
        onlyBank
        returns (uint256)
    {
        for (uint256 j = 0; j < allCustomers.length; ++j) {
            if (stringsEqual(allCustomers[j].uname, Uname) && 
            (allBanks[msg.sender].kycPermission == true)) {
                allCustomers[j].upvotes++;
                if ((allCustomers[j].upvotes > allCustomers[j].downvotes) && 
                   (allCustomers[j].downvotes < (bankCount / 3))) {
                    allCustomers[j].kycStatus = true;
                }
                return 1;
                }
            }
        return 0;
    }

     /*function to downvote a customer and update its status
    Uname- its the customer name for whom upvote is done
    @return- it returns 1 if successfull and 0 if failure
    */
    function downvoteCustomer(string memory Uname)
        public
        payable
        onlyBank
        returns (uint256)
    {
        for (uint256 j = 0; j < allCustomers.length; ++j) {
            if (stringsEqual(allCustomers[j].uname, Uname) && 
            (allBanks[msg.sender].kycPermission == true)) {
                allCustomers[j].downvotes++;
                if ((allCustomers[j].upvotes < allCustomers[j].downvotes) ||
                   (allCustomers[j].downvotes > (bankCount / 3))) {
                    allCustomers[j].kycStatus = false;
                }
                return 1;
                }
            }
        return 0;
    }

    /*
    function to get Customer status
    @param - username(Uname) of the customer to fetch rating
    @returns - boolean value
    */
    function getCustomerStatus(string memory Uname)
        public
        view
        onlyBank
        returns (bool)
    {
        for (uint256 i = 0; i < allCustomers.length; ++i) {
            if (stringsEqual(allCustomers[i].uname, Uname)) {
                return allCustomers[i].kycStatus;
            }
        }
    }
    /*
        function to upvote a bank by another bank
        @param- bankAddress, address of the bank to upvoteBank
        @return- "0" when upvote is successful and "1" when upvote is not possible if the bank has already voted or does not exist in the blockchain
    */
    function addBankReport(address bankAddress)
        public
        payable
        onlyBank
        returns (uint256)
    {
        address bank = allBanks[msg.sender].ethAddress;
        address receiverBank = allBanks[bankAddress].ethAddress;
        if (receiverBank == 0x0000000000000000000000000000000000000000 || receiverBank == bank) {
            return 1;
        }
        if (bank != 0x0000000000000000000000000000000000000000) {
            allBanks[receiverBank].report++;
            if (allBanks[receiverBank].report > (bankCount / 3)) {
                allBanks[receiverBank].kycPermission = false;
            }
            return 0;
        }
        return 1;
    }
    /*
    function to get Bank getBankReport
    @param - address of the bank as bankAddress
    @returns -  rating of the bank
    */
    function getBankReport(address bankAddress)
        public
        view
        onlyBank
        returns (uint256)
    {
            return allBanks[bankAddress].report;
    }

    /*
    event to display bank details
    */
    event bankDetails(
        string name,
        address ethAddress,
        uint256 KYC_count,
        string regNumber,
        uint256 report
    );

    /*
    function to get the bank details of a bank
    @param - address of bank is passed
    @returns - details of the bank whose address is passed
    */
    function getBankDetails(address bankAddress) public payable onlyBank {
            emit bankDetails(
                allBanks[bankAddress].name,
                allBanks[bankAddress].ethAddress,
                allBanks[bankAddress].KYC_count,
                allBanks[bankAddress].regNumber,
                allBanks[bankAddress].report
            );
    }
    // function to compare two string value
    // This is an internal fucntion to compare string values
    // @Params - String a and String b are passed as Parameters
    // @return - This function returns true if strings are matched and false if the strings are not
    //matching
    function stringsEqual(string storage _a, string memory _b)
        internal
        view
        returns (bool)
    {
        bytes storage a = bytes(_a);
        bytes memory b = bytes(_b);
        if (a.length != b.length) return false;
        // @todo unroll this loop
        for (uint256 i = 0; i < a.length; i++) {
            if (a[i] != b[i]) return false;
        }
        return true;
    }

}
