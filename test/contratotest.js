const contratotest = artifacts.require("contratotest");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("contratotest", function (/* accounts */) {
  it("should assert true", async function () {
    await contratotest.deployed();
    return assert.isTrue(true);
  });
});
