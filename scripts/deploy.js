const main = async () => {
    const gameContractFactory = await hre.ethers.getContractFactory('EpicGame');
    const gameContract = await gameContractFactory.deploy(
    ["Blue Eyes White Dragon", "Dragon Master Knight", "Neo Blue-Eyes Ultimate Dragon"],  // Names
    ["https://i.imgur.com/UjpSSWM.png", // Images
    "https://i.imgur.com/ETjta66.png", 
    "https://i.imgur.com/HwHFnuF.png"],
    [3000, 5000, 3800],                    // HP values
    [2500, 5000, 4500]                       // Attack damage values);
    );
                     
    await gameContract.deployed();
    console.log("Contract deployed to:", gameContract.address);

    let trxn;
   
    trxn = await gameContract.mintCharacterNFT(0);
    await trxn.wait();
    console.log("Minted NFT #1");
  
    trxn = await gameContract.mintCharacterNFT(1);
    await trxn.wait();
    console.log("Minted NFT #2");
  
    trxn = await gameContract.mintCharacterNFT(2);
    await trxn.wait();
    console.log("Minted NFT #3");
  
    // trxn = await gameContract.mintCharacterNFT(3);
    // await txn.wait();
    // console.log("Minted NFT #4");
  
  };
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
  
  runMain();
  