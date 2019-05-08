![BountyHUB Token](./assets/bountyhub-logo.png "BountyHUB Token")

# BountyHUB Token contract

## Ditails

* _Standard_                                                                            : [TRC20](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md)
* _[Name](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#name)_            : BountyHUB Token
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
* _Beneficiary_ : ?
* _Start time_ : ?
* _Period_ : 180 days
* _Count_ : 6

### Foundation
* _Beneficiary_ : ?
* _Start time_ : ?
* _Period_ : 180 days
* _Count_ : 2

#### How to realese

To transfer tokens to the beneficiary, it's need to call the **release()** function.
