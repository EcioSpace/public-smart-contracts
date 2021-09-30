const EcioWhitelist = artifacts.require("EcioWhitelist");
contract("EcioWhitelist", accounts => {
    it("Test Whitelist", async () => {

        await EcioWhitelist.deployed().then(async instance => {

            const contract_address = instance.address;
            const account_owner = accounts[0];
            const account_1st = accounts[1];
            const account_2nd = accounts[2];
            const account_3rd = accounts[3];
            const account_4th = accounts[4];
          
            //createActivity
            await instance.createActivity(5, 1632061726, 1732061726, true);

            //Register 1
            await instance.registerWhitelist(0, account_2nd, { from: account_1st });
            let hasRegsiter = await instance.hasRegister.call(0, account_1st);
            let referralScore = await instance.referralScore.call(0, account_2nd);
            assert.equal(hasRegsiter.valueOf(), true);
            assert.equal(referralScore.valueOf(), 1);

            //Register 2
            await instance.registerWhitelist(0, account_2nd, { from: account_2nd });
            hasRegsiter = await instance.hasRegister.call(0, account_2nd);
            referralScore = await instance.referralScore.call(0, account_2nd);
            assert.equal(hasRegsiter.valueOf(), true);
            assert.equal(referralScore.valueOf(), 2);

            //Register 3
            await instance.registerWhitelist(0, account_2nd, { from: account_3rd });
            hasRegsiter = await instance.hasRegister.call(0, account_3rd);
            referralScore = await instance.referralScore.call(0, account_2nd);
            assert.equal(hasRegsiter.valueOf(), true);
            assert.equal(referralScore.valueOf(), 3);

            //Register 4
            await instance.registerWhitelist(0, account_1st, { from: account_4th });
            hasRegsiter = await instance.hasRegister.call(0, account_4th);
            referralScore = await instance.referralScore.call(0, account_1st);
            assert.equal(hasRegsiter.valueOf(), true);
            assert.equal(referralScore.valueOf(), 1);


            const users = await instance.getAllRegister(0, { from: account_1st });
            assert.equal(users[1][0], account_1st);
            assert.equal(users[1][1], account_2nd);
            assert.equal(users[1][2], account_3rd);
            assert.equal(users[1][3], account_4th);

            assert.equal(users[0][0].valueOf(), 1);
            assert.equal(users[0][1].valueOf(), 3);
            assert.equal(users[0][2].valueOf(), 0);
            assert.equal(users[0][3].valueOf(), 0);

        })


    }
    );

});
