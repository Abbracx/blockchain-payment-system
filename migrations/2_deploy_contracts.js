const UJToken = artifacts.require('UJToken.sol');
const PaymentProcessor = artifacts.require('PaymentProcessor.sol');


module.exports = async function (deployer, network, addresses) {
    const [admin,  payer, _] = addresses;

    if(network === 'develop' || network === 'development'){

        await deployer.deploy(UJToken); //sends the transaction
        if
        const ujtoken = await UJToken.deployed(); // waits for it to mined.

        /**
            *  Note: 1 UJToken = 1 * 10 ** 18 UJT wei
            *  Note: 10000 UJToken = 1 * 10 ** 22 UJT wei
         */
        await ujtoken.faucet(payer, web3.utils.toWei('10000')); //mints 10,000 token for the payer address

        await deployer.deploy(PaymentProcessor, bursary, ujtoken.address); // Ownwer of the smart contract is the scool bursary
    }else{

        const BURSARY_ADDRESS = '';
        const UJT_ADDRESS = '';


        await deployer.deploy(UJToken);
        const ujtoken = await UJToken.deployed();
        await deployer.deploy(PaymentProcessor, BURSARY_ADDRESS, ujtoken.address);

        // await deployer.deploy(PaymentProcessor, BURSARY_ADDRESS, UJT_ADDRESS);
    }

};
