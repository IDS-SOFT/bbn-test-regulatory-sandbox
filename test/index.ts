import { expect } from "chai";
import { ethers } from "hardhat";

describe("RegulatorySandbox", function () {
    let RegulatorySandbox:any;
    let regulatorySandbox:any;
    let owner:any;
    let regulator:any;
    let regTechSolution:any;
    const sandboxName = "My Sandbox";

    beforeEach(async function () {
        [owner, regulator, regTechSolution] = await ethers.getSigners();

        RegulatorySandbox = await ethers.getContractFactory("RegulatorySandbox");
        regulatorySandbox = await RegulatorySandbox.deploy(
            sandboxName,
            regulator.address
        );
        await regulatorySandbox.deployed();
    });

    it("should allow the regulator to approve a RegTech solution", async function () {
        await expect(
            regulatorySandbox.connect(regulator).approveRegTechSolution(regTechSolution.address)
        ).to.emit(regulatorySandbox, "RegTechSolutionApproved").withArgs(regTechSolution.address);
        expect(await regulatorySandbox.regTechSolutions(regTechSolution.address)).to.be.true;
    });

    it("should allow the regulator to revoke approval for a RegTech solution", async function () {
        await regulatorySandbox.connect(regulator).approveRegTechSolution(regTechSolution.address);

        await expect(
            regulatorySandbox.connect(regulator).revokeRegTechSolution(regTechSolution.address)
        ).to.emit(regulatorySandbox, "RegTechSolutionRevoked").withArgs(regTechSolution.address);
        expect(await regulatorySandbox.regTechSolutions(regTechSolution.address)).to.be.false;
    });

    it("should allow the owner to close the sandbox", async function () {
        await regulatorySandbox.connect(owner).closeSandbox();
        expect(await regulatorySandbox.closed()).to.be.true;
    });

    it("should check compliance status of a RegTech solution", async function () {
        await regulatorySandbox.connect(regulator).approveRegTechSolution(regTechSolution.address);

        const isCompliant = await regulatorySandbox.checkCompliance(regTechSolution.address);
        expect(isCompliant).to.be.true;
    });
});
