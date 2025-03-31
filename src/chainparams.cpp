// Copyright (c) 2010 Satoshi Nakamoto
// Copyright (c) 2009-2015 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#include "chainparams.h"
#include "consensus/merkle.h"
#include "tinyformat.h"
#include "util.h"
#include "utilstrencodings.h"
#include <assert.h>
#include <boost/assign/list_of.hpp>
#include "chainparamsseeds.h"

static CBlock CreateGenesisBlock(const char* pszTimestamp, const CScript& genesisOutputScript, uint32_t nTime, uint32_t nNonce, uint32_t nBits, int32_t nVersion, const CAmount& genesisReward)
{
    CMutableTransaction txNew;
    txNew.nVersion = 1;
    txNew.vin.resize(1);
    txNew.vout.resize(1);
    txNew.vin[0].scriptSig = CScript() << 486604799 << CScriptNum(4) << std::vector<unsigned char>((const unsigned char*)pszTimestamp, (const unsigned char*)pszTimestamp + strlen(pszTimestamp));
    txNew.vout[0].nValue = genesisReward;
    txNew.vout[0].scriptPubKey = genesisOutputScript;

    CBlock genesis;
    genesis.nTime    = nTime;
    genesis.nBits    = nBits;
    genesis.nNonce   = nNonce;
    genesis.nVersion = nVersion;
    genesis.vtx.push_back(txNew);
    genesis.hashPrevBlock.SetNull();
    genesis.hashMerkleRoot = BlockMerkleRoot(genesis);
    return genesis;
}

static CBlock CreateGenesisBlock(uint32_t nTime, uint32_t nNonce, uint32_t nBits, int32_t nVersion, const CAmount& genesisReward)
{
    const char* pszTimestamp = "TRRXITTE BTC - 31/Mar/2025"; // Updated timestamp
    const CScript genesisOutputScript = CScript() << ParseHex("04678afdb0fe5548271967f1a67130b7105cd6a828e03909a67962e0ea1f61deb649f6bc3f4cef38c4f35504e51ec112de5c384df7ba0b8d578a4c702b6bf11d5f") << OP_CHECKSIG;
    return CreateGenesisBlock(pszTimestamp, genesisOutputScript, nTime, nNonce, nBits, nVersion, genesisReward);
}

/**
 * Main network (TRRXITTE BTC)
 */
class CMainParams : public CChainParams {
public:
    CMainParams() {
        strNetworkID = "main";
        consensus.nSubsidyHalvingInterval = 210000; // Halving every 210,000 blocks (adjust as needed)
        consensus.nMajorityEnforceBlockUpgrade = 750;
        consensus.nMajorityRejectBlockOutdated = 950;
        consensus.nMajorityWindow = 1000;
        consensus.BIP34Height = 0; // Enforce BIP34 from genesis
        consensus.BIP34Hash = uint256S("0x0000000000000000000000000000000000000000000000000000000000000000"); // Placeholder, updated below
        consensus.powLimit = uint256S("00000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"); // Easier initial difficulty
        consensus.nPowTargetTimespan = 14 * 24 * 60 * 60; // 2 weeks for difficulty adjustment
        consensus.nPowTargetSpacing = 10 * 60; // 10 minutes block time
        consensus.nSwitchHeight = 10000; // Optional: adjust if using dynamic spacing
        consensus.nNewPowTargetSpacing = 140; // Optional: adjust if using dynamic spacing
        consensus.fPowAllowMinDifficultyBlocks = false;
        consensus.fPowNoRetargeting = false;
        consensus.nRuleChangeActivationThreshold = 1916; // 95% of 2016
        consensus.nMinerConfirmationWindow = 2016;

        // BIP9 deployments (optional, adjust or remove)
        consensus.vDeployments[Consensus::DEPLOYMENT_TESTDUMMY].bit = 28;
        consensus.vDeployments[Consensus::DEPLOYMENT_TESTDUMMY].nStartTime = 1199145601; // January 1, 2008
        consensus.vDeployments[Consensus::DEPLOYMENT_TESTDUMMY].nTimeout = 1230767999; // December 31, 2008

        consensus.vDeployments[Consensus::DEPLOYMENT_CSV].bit = 0;
        consensus.vDeployments[Consensus::DEPLOYMENT_CSV].nStartTime = 1738032253; // January 28, 2025
        consensus.vDeployments[Consensus::DEPLOYMENT_CSV].nTimeout = 1769568253; // January 28, 2026

        consensus.vDeployments[Consensus::DEPLOYMENT_SEGWIT].bit = 1;
        consensus.vDeployments[Consensus::DEPLOYMENT_SEGWIT].nStartTime = 1746057600; // March 31, 2025
        consensus.vDeployments[Consensus::DEPLOYMENT_SEGWIT].nTimeout = 1777593600; // March 31, 2026

        consensus.nMinimumChainWork = uint256S("0x00"); // Reset for new chain
        consensus.pownewlimit = uint256S("0000000000000023CA7500000000000000000000000000000000000000000000"); // Adjust if needed

        // Unique network magic bytes
        pchMessageStart[0] = 0xf1;
        pchMessageStart[1] = 0xa2;
        pchMessageStart[2] = 0xb3;
        pchMessageStart[3] = 0xc4;
        nDefaultPort = 55553; // New P2P port
        nPruneAfterHeight = 1000;

        // New genesis block
        genesis = CreateGenesisBlock(1746057600, 123723, 0x1e0ffff0, 1, 50 * COIN); // Timestamp: March 31, 2025
        consensus.hashGenesisBlock = genesis.GetHash();
        assert(consensus.hashGenesisBlock == uint256S("0x00000d8810c36c9a0a5ab63a3b824c99f6cb1864e082578691fcc31f16522166"));
        assert(genesis.hashMerkleRoot == uint256S("0x8bae0c69ee37acb691c9a7dcb25496858b5a8c08dea826b4e4f83888f5f2f827"));

        // Seed nodes (update with your own if desired)
        vSeeds.push_back(CDNSSeedData("seed-one.btc.trrxitte.com", "seed-two.btc.trrxitte.com"));

        // Address prefixes (unique from Bitcoin)
        base58Prefixes[PUBKEY_ADDRESS] = std::vector<unsigned char>(1, 48); // 'M'
        base58Prefixes[SCRIPT_ADDRESS] = std::vector<unsigned char>(1, 50); // 'N'
        base58Prefixes[SECRET_KEY] = std::vector<unsigned char>(1, 176); // 'X'
        base58Prefixes[EXT_PUBLIC_KEY] = boost::assign::list_of(0x04)(0x88)(0xB2)(0x1E).convert_to_container<std::vector<unsigned char> >();
        base58Prefixes[EXT_SECRET_KEY] = boost::assign::list_of(0x04)(0x88)(0xAD)(0xE4).convert_to_container<std::vector<unsigned char> >();

        vFixedSeeds.clear(); // No fixed seeds initially

        fMiningRequiresPeers = true;
        fDefaultConsistencyChecks = false;
        fRequireStandard = true;
        fMineBlocksOnDemand = false;
        fTestnetToBeDeprecatedFieldRPC = false;
    }

};
class CTestNetParams : public CChainParams {
    public:
        CTestNetParams() {
            // Testnet-specific parameters
        }
    };
    

    class CRegTestParams : public CChainParams {
        public:
            CRegTestParams() {
                strNetworkID = "regtest";
                consensus.nSubsidyHalvingInterval = 150;
                consensus.nMajorityEnforceBlockUpgrade = 750;
                consensus.nMajorityRejectBlockOutdated = 950;
                consensus.nMajorityWindow = 1000;
                consensus.BIP34Height = -1; // BIP34 has not necessarily activated on regtest
                consensus.BIP34Hash = uint256();
                consensus.powLimit = uint256S("7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
                consensus.nPowTargetTimespan = 14 * 24 * 60 * 60; // two weeks
                consensus.nPowTargetSpacing = 10 * 60;
                consensus.fPowAllowMinDifficultyBlocks = true;
                consensus.fPowNoRetargeting = true;
                consensus.nRuleChangeActivationThreshold = 108; // 75% for testchains
                consensus.nMinerConfirmationWindow = 144; // Faster than normal for regtest (144 instead of 2016)
                consensus.vDeployments[Consensus::DEPLOYMENT_TESTDUMMY].bit = 28;
                consensus.vDeployments[Consensus::DEPLOYMENT_TESTDUMMY].nStartTime = 0;
                consensus.vDeployments[Consensus::DEPLOYMENT_TESTDUMMY].nTimeout = 999999999999ULL;
                consensus.vDeployments[Consensus::DEPLOYMENT_CSV].bit = 0;
                consensus.vDeployments[Consensus::DEPLOYMENT_CSV].nStartTime = 0;
                consensus.vDeployments[Consensus::DEPLOYMENT_CSV].nTimeout = 999999999999ULL;
                consensus.vDeployments[Consensus::DEPLOYMENT_SEGWIT].bit = 1;
                consensus.vDeployments[Consensus::DEPLOYMENT_SEGWIT].nStartTime = 0;
                consensus.vDeployments[Consensus::DEPLOYMENT_SEGWIT].nTimeout = 999999999999ULL;
        
                // The best chain should have at least this much work.
                consensus.nMinimumChainWork = uint256S("0x00");
        
                pchMessageStart[0] = 0xfa;
                pchMessageStart[1] = 0xbf;
                pchMessageStart[2] = 0xb5;
                pchMessageStart[3] = 0xda;
                nDefaultPort = 18444;
                nPruneAfterHeight = 1000;
        
                genesis = CreateGenesisBlock(1296688602, 2, 0x207fffff, 1, 50 * COIN);
                consensus.hashGenesisBlock = genesis.GetHash();

        
                vFixedSeeds.clear(); //!< Regtest mode doesn't have any fixed seeds.
                vSeeds.clear();      //!< Regtest mode doesn't have any DNS seeds.
        
                fMiningRequiresPeers = false;
                fDefaultConsistencyChecks = true;
                fRequireStandard = false;
                fMineBlocksOnDemand = true;
                fTestnetToBeDeprecatedFieldRPC = false;
        
                checkpointData = (CCheckpointData){
                    boost::assign::map_list_of
                    ( 0, uint256S("0f9188f13cb7b2c71f2a335e3a4fc328bf5beb436012afca590b1a11466e2206")),
                    0,
                    0,
                    0
                };
                base58Prefixes[PUBKEY_ADDRESS] = std::vector<unsigned char>(1,111);
                base58Prefixes[SCRIPT_ADDRESS] = std::vector<unsigned char>(1,196);
                base58Prefixes[SECRET_KEY] =     std::vector<unsigned char>(1,239);
                base58Prefixes[EXT_PUBLIC_KEY] = boost::assign::list_of(0x04)(0x35)(0x87)(0xCF).convert_to_container<std::vector<unsigned char> >();
                base58Prefixes[EXT_SECRET_KEY] = boost::assign::list_of(0x04)(0x35)(0x83)(0x94).convert_to_container<std::vector<unsigned char> >();
            }
        
            void UpdateBIP9Parameters(Consensus::DeploymentPos d, int64_t nStartTime, int64_t nTimeout)
            {
                consensus.vDeployments[d].nStartTime = nStartTime;
                consensus.vDeployments[d].nTimeout = nTimeout;
            }
        };

// Static instances of the chain parameters
static CMainParams mainParams;
static CTestNetParams testNetParams;
static CRegTestParams regTestParams;

// Declare pCurrentParams as a global pointer
static CChainParams *pCurrentParams = nullptr;

const CChainParams &Params() {
    assert(pCurrentParams);
    return *pCurrentParams;
}

CChainParams& Params(const std::string& chain)
{
    if (chain == CBaseChainParams::MAIN)
        return mainParams;
    else if (chain == CBaseChainParams::TESTNET)
        return testNetParams;
    else if (chain == CBaseChainParams::REGTEST)
        return regTestParams;
    else
        throw std::runtime_error(strprintf("%s: Unknown chain %s.", __func__, chain));
}

void SelectParams(const std::string& network)
{
    SelectBaseParams(network);
    pCurrentParams = &Params(network);
}

void UpdateRegtestBIP9Parameters(Consensus::DeploymentPos d, int64_t nStartTime, int64_t nTimeout)
{
    regTestParams.UpdateBIP9Parameters(d, nStartTime, nTimeout);
}