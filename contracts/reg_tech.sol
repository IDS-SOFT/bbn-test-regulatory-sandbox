// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/******************************************************************************************* */
/* This is a comprehensive smart contract template which handles :
1. Regulatory sandbox design & implementation
2. Auditing and Reporting
3. Automatic compliance checks
*/

contract RegulatorySandbox is Ownable {
    using SafeMath for uint256;

    string public sandboxName;
    address public regulator;
    bool public closed;

    // Mapping to store RegTech solutions and their compliance status
    mapping(address => bool) public regTechSolutions;

    event RegTechSolutionApproved(address indexed solutionAddress);
    event RegTechSolutionRevoked(address indexed solutionAddress);
    event SandboxClosed();
    event CheckBalance(string text, uint amount);

    constructor(string memory _sandboxName, address _regulator) {
        sandboxName = _sandboxName;
        regulator = _regulator;
    }

    // Approve a RegTech solution for testing within the sandbox
    function approveRegTechSolution(address solutionAddress) external onlyRegulator {
        require(!closed, "Sandbox is closed");
        require(!regTechSolutions[solutionAddress], "Solution is already approved");
        regTechSolutions[solutionAddress] = true;
        emit RegTechSolutionApproved(solutionAddress);
    }

    // Revoke approval for a RegTech solution
    function revokeRegTechSolution(address solutionAddress) external onlyRegulator {
        require(!closed, "Sandbox is closed");
        require(regTechSolutions[solutionAddress], "Solution is not approved");
        regTechSolutions[solutionAddress] = false;
        emit RegTechSolutionRevoked(solutionAddress);
    }

    // Close the sandbox and prevent further approvals or revocations
    function closeSandbox() external onlyOwner {
        require(!closed, "Sandbox is already closed");
        closed = true;
        emit SandboxClosed();
    }

    // Check compliance of a RegTech solution
    function checkCompliance(address solutionAddress) external view returns (bool) {
        return regTechSolutions[solutionAddress];
    }

    // Function to audit and report compliance violations
    function auditAndReportCompliance(
        address solutionAddress,
        uint256 complianceViolationCount,
        string memory complianceReport
    ) external onlyRegulator {
        require(closed, "Sandbox is not closed");
        // Implement auditing and reporting logic
        // You can store compliance reports and violation counts for each solution
    }
    
    function getBalance(address user_account) external returns (uint){
    
       string memory data = "User Balance is : ";
       uint user_bal = user_account.balance;
       emit CheckBalance(data, user_bal );
       return (user_bal);

    }

    modifier onlyRegulator() {
        require(msg.sender == regulator, "Only the regulator can perform this action");
        _;
    }
}
