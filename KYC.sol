pragma solidity ^0.4.17;

contract KYC{

	/*isKYCApproved
		0: not approved
		1: approved
		2: submmited for approval
	*/

	struct UserInfo{
		string fullname;
		string emailid;
		string mobileno;
		uint isKYCApproved;
	}
	struct OrgInfo{
		string orgname;
		bool isKYCApprover;
	}

	mapping (address => UserInfo) UserMapping;
	mapping (address => OrgInfo) OrgMapping;
	mapping (address => address []) PendingKYCMapping;

	function owner() public returns(address){
		returns msg.sender;
	}

	function viewUserInfo(address userhash) public returns(string fullname, string emailid, string mobileno, uint isKYCApproved){
		return (UserMapping[userhash].fullname, UserMapping[userhash].emailid, UserMapping[userhash].mobileno, UserMapping[userhash].isKYCApproved);
	}
	function viewPendingKYCApprovalAddress(address orghash, uint index) public returns(address pendingAddress){
		return PendingKYCMapping[orghash][index];
	}
	function viewPendingKYCRequests(address orghash) public returns(address []){
		//used by vendors to see the remaining KYC's to be approved.
		return PendingKYCMapping[orghash];
	}
	function viewOrgInfo(address orghash) public returns(string orgname, bool isKYCApprover){
		return (OrgMapping[orghash].orgname, OrgMapping[orghash].isKYCApprover);
	}
	function CheckKYCApprovalStatus(address userhash) public returns(uint){
		return UserMapping[userhash].isKYCApproved;
	}
	function AddOrgInfo(string orgname, address orghash) public {
		OrgMapping[orghash].orgname = orgname;
		OrgMapping[orghash].isKYCApprover = false;
	}
	function AddUserInfo(address userhash, string fullname, string emailid, string mobileno) public {
		UserMapping[userhash].fullname = fullname;
		UserMapping[userhash].emailid = emailid;
		UserMapping[userhash].mobileno = mobileno;
		UserMapping[userhash].isKYCApproved = 0;
	}
	function ApproveOrgForKYC(address orghash) public{
		OrgMapping[orghash].isKYCApprover = true;
	}
	function ChangeKYCApprovalStatus(address userhash, address orghash, uint isApproved) public {
		UserMapping[userhash].isKYCApproved = isApproved;

		for(uint i = 0; i < PendingKYCMapping[orghash].length; i++){
			if(PendingKYCMapping[orghash][i] == userhash){
				delete PendingKYCMapping[orghash][i];
				break;
			}
		}
		
	}
	function RequestApproveKYC(address orghash, address userhash) public {
		UserMapping[userhash].isKYCApproved = 2;
		PendingKYCMapping[orghash].push(userhash);
	}

}
