![BountyHUB Token](./assets/bountyhub-logo.png "BountyHUB Token")

# BountyHUB Token contract

## Ditails

* _Standard_                                                                            : [TRC20](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md)
* _[Name](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#name)_            : BountyHUBToken
* _[Ticker](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#symbol)_        : BHT
* _[Decimals](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#decimals)_    : 18
* _Emission_                                                                            : Mintable
* _Tokens locked_                                                                       : Yes
* _Total supply_                                                                        : 1 000 000 000

## Distribution

* _Platform Launch_      : 1 %
* _Marketing & Airdrops_ : 4 %
* _Team_                 : 10 %
* _Foundation_           : 15 %
* _Launchpad Sale_       : 17 %
* _Ecosystem_            : 18 %
* _Platform Rewards_     : 35 %

## Overview

Contract structure:

* BountyHUBToken.sol - Main token contract
* TokenTimelock.sol - Token timelock contract
* Configurator.sol - Deployment contract

Flatten:

* BountyHUB.sol - Flattened smart contracts from the Configurator.sol

## Mainnet Environment

**Note:** [See .env file](./.env)
```
# BountyHUB Deployment account
TRONBOX_FROM=""
TRONBOX_PRIVATE_KEY=""

# Token
BOUNTYHUB_TOKEN_NAME="BountyHUBToken"
BOUNTYHUB_TOKEN_SYMBOL="BHT"
BOUNTYHUB_TOKEN_DECIMALS=18
# Without decimals
BOUNTYHUB_TOKEN_CAP=1000000000;

# 2020-01-01T12:00:00.000Z
BOUNTYHUB_TIMELOCK_START_DATE=1577880000

# 180 * 86400 (180 days)
BOUNTYHUB_TIMELOCK_PERIOD=15552000

BOUNTYHUB_TEAM_TIMELOCK_COUNT=6
BOUNTYHUB_FOUNDATION_TIMELOCK_COUNT=2


# TBsBU9XvaM1hE2bHnGDSW3XtsqnuWXZHqb
BOUNTYHUB_PLATFORM_LAUNCH_FUND="4114cc79e54e7783dc6517d77d41e39366fa8a1306"

# TZHyTM6Yu7FffJfrj7dxtFM9Aymy3pTCYQ
BOUNTYHUB_MARKETING_AND_AIRDROPS_FUND="41ffd77cf038fbea2fb654366afacf46c296191121"

# TYccHxN5UhvY3sN2aSAdTCGYbrYDBiSfZe
BOUNTYHUB_TEAM_FUND="41f86599b68421fe90649a67a90ca72064e71bf309"

# TUSjEWdEvCHU2UEX7LLrycZZ8oXyuFBuFV
BOUNTYHUB_FOUNDATION_FUND="41caa6bb3efe024f699b405d238cdcbe8f98b554fd"

# TBF7nW7Vs4q2fUmm73SZDSr3KaqioSQnxE
BOUNTYHUB_LAUNCHPAD_SALE_FUND="410dfa6d3a21cd67e09c73530f625425d0a14e7384"

# TCRbqyMKioeKrfhm86RFp3XT9eT1p2Qvaa
BOUNTYHUB_ECOSYSTEM_FUND="411aee229e5f3202eba758cce9e96429f09f56ca45"

# TEXpw8VHtQa97THLXG5y1q3D2A55hB8w8d
BOUNTYHUB_PLATFORM_REWARDS_FUND="41320bcf03b21e20dd55b1219b9fe1f72bdccd2405"


# (BountyHUB Manager account) TL7yfU3c1FG8ZY6TeTf9qHLuLnaK3dyJro
BOUNTYHUB_MANAGER="416f59de1f638087c640a424d41022da79e852a75e"

```

## Run

**Note:** Set TRONBOX_FROM & TRONBOX_PRIVATE_KEY ([.env file](./.env))

```
$ git clone https://github.com/bountyhubio/bountyhub.git
$ cd bountyhub
# Populate TRONBOX_FROM & TRONBOX_PRIVATE_KEY for .env
$ . .env && tronbox console --network mainnet
> migrate --reset
```

## Deployment

```
==================================================================================
Deployment summary:
==================================================================================

Team:
--------------------------------------------------------------
  Timelock address: 4193fc857f334e4073489c836798c202538209f943 (100000000 BHT)
     Token address: 414106bba560eda894a51c4c9e804642aeb1e5524d
     Owner address: 416f59de1f638087c640a424d41022da79e852a75e
      Fund address: 41f86599b68421fe90649a67a90ca72064e71bf309
  Vesting period [ISO 8601]: not started yet
  --------------------------


Foundation:
--------------------------------------------------------------
  Timelock address: 4192ead51de30f28592fe0132d8cabf88121e585ae (150000000 BHT)
     Token address: 414106bba560eda894a51c4c9e804642aeb1e5524d
     Owner address: 416f59de1f638087c640a424d41022da79e852a75e
      Fund address: 41caa6bb3efe024f699b405d238cdcbe8f98b554fd
  Vesting period [ISO 8601]: not started yet
  --------------------------


Funds/Pools:
------------------------------------------------------------------
  Platform Launch:      4114cc79e54e7783dc6517d77d41e39366fa8a1306 (10000000 BHT)
  Marketing & Airdrops: 41ffd77cf038fbea2fb654366afacf46c296191121 (40000000 BHT)
  Team:                 41f86599b68421fe90649a67a90ca72064e71bf309 (0 BHT)
  Foundation:           41caa6bb3efe024f699b405d238cdcbe8f98b554fd (0 BHT)
  Launchpad Sale:       410dfa6d3a21cd67e09c73530f625425d0a14e7384 (170000000 BHT)
  Ecosystem:            411aee229e5f3202eba758cce9e96429f09f56ca45 (180000000 BHT)
  Platform Rewards:     41320bcf03b21e20dd55b1219b9fe1f72bdccd2405 (350000000 BHT)


Token:
-----------------------------------------------------
  Address: 414106bba560eda894a51c4c9e804642aeb1e5524d
    Owner: 416f59de1f638087c640a424d41022da79e852a75e
   Supply: 1000000000 BHT
      Cap: 1000000000 BHT

Manager:
-------------------------------------------------------
  Address: : 416f59de1f638087c640a424d41022da79e852a75e

==================================================================================
```

## Interaction list
* [BountyHUB Token](https://tronsmartcontract.space/#/interact/TFu2zLw5TR5mHs7sa9ECSrm7ZWwQvQ5kMS)
* [Team Timelock](https://tronsmartcontract.space/#/interact/TPTgqktexNSVe5Y6DZz4zhjz8pd3oSRAcM)
* [Foundation Timelock](https://tronsmartcontract.space/#/interact/TPN2yWjgTRhzizRLqRtwf1dtPqKMCV8WnB)

## Tronscan list
* [BountyHUB Token](https://tronscan.org/#/contract/TFu2zLw5TR5mHs7sa9ECSrm7ZWwQvQ5kMS)
* [Team Timelock](https://tronscan.org/#/contract/TPTgqktexNSVe5Y6DZz4zhjz8pd3oSRAcM)
* [Foundation Timelock](https://tronscan.org/#/contract/TPN2yWjgTRhzizRLqRtwf1dtPqKMCV8WnB)

## Mainnet address list

| Fund                 | Address                                     |
| ---------------------| --------------------------------------------|
| Platform launch      | 4114cc79e54e7783dc6517d77d41e39366fa8a1306  |
|                      | TBsBU9XvaM1hE2bHnGDSW3XtsqnuWXZHqb          |
| Marketing & Airdrops | 41ffd77cf038fbea2fb654366afacf46c296191121  |
|                      | TZHyTM6Yu7FffJfrj7dxtFM9Aymy3pTCYQ          |
| Team                 | 41f86599b68421fe90649a67a90ca72064e71bf309  |
|                      | TYccHxN5UhvY3sN2aSAdTCGYbrYDBiSfZe          |
| Foundation           | 41caa6bb3efe024f699b405d238cdcbe8f98b554fd  |
|                      | TUSjEWdEvCHU2UEX7LLrycZZ8oXyuFBuFV          |
| Launchpad sale       | 410dfa6d3a21cd67e09c73530f625425d0a14e7384  |
|                      | TBF7nW7Vs4q2fUmm73SZDSr3KaqioSQnxE          |
| Ecosystem            | 411aee229e5f3202eba758cce9e96429f09f56ca45  |
|                      | TCRbqyMKioeKrfhm86RFp3XT9eT1p2Qvaa          |
| Platform rewards     | 41320bcf03b21e20dd55b1219b9fe1f72bdccd2405  |
|                      | TEXpw8VHtQa97THLXG5y1q3D2A55hB8w8d          |

| Timelock             | Address                                     |
| ---------------------| --------------------------------------------|
| Team                 | 4193fc857f334e4073489c836798c202538209f943  |
|                      | TPTgqktexNSVe5Y6DZz4zhjz8pd3oSRAcM          |
| Foundation           | 4192ead51de30f28592fe0132d8cabf88121e585ae  |
|                      | TPN2yWjgTRhzizRLqRtwf1dtPqKMCV8WnB          |

|                      | Address                                     |
| ---------------------| --------------------------------------------|
| Manager              | 416f59de1f638087c640a424d41022da79e852a75e  |
|                      | TL7yfU3c1FG8ZY6TeTf9qHLuLnaK3dyJro          |

| Token                | Address                                     |
| ---------------------| --------------------------------------------|
| BHT                  | 414106bba560eda894a51c4c9e804642aeb1e5524d  |
|                      | TFu2zLw5TR5mHs7sa9ECSrm7ZWwQvQ5kMS          |

## Vesting periods

### Team
3 years / in equal portions every 6 months

### Foundation
After 1 year every 6 month


# Token Timelock contract

## Ditails

* _Beneficiary_ : beneficiary of tokens after they are released (pool/fund wallet)
* _Start time_ : timestamp when token release is enabled
* _Period_ : the duration of each period
* _Count_ : number of stages
* _Calendar_ : list of stages

## Vesting periods

### Team
* _Beneficiary_ : TYccHxN5UhvY3sN2aSAdTCGYbrYDBiSfZe
* _Start time_ : ?
* _Period_ : 180 days
* _Count_ : 6

### Foundation
* _Beneficiary_ : TUSjEWdEvCHU2UEX7LLrycZZ8oXyuFBuFV
* _Start time_ : ?
* _Period_ : 180 days
* _Count_ : 2

#### How to start

To start vesting tokens, it's need to call the **startOn()** function with **start time** (Unix epoch format without milliseconds).

#### How to realese

To transfer tokens to the beneficiary, it's need to call the **release()** function.
