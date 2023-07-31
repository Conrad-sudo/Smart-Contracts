# CrowdFunding
- The Admin will start a campaign for CrowdFunding with a specific monetary goal and
deadline.
- Contributors will contribute to that project by sending ETH.
The admin has to create a Spending Request to spend money for the campaign.
Once the spending request was created, the Contributors can start voting for that
specific Spending Request.
- If more than 50% of the total contributors voted for that request, then the admin would
have the permission to spend the amount specified in the spending request.
- The power is moved from the campaign's admin to those that donated money.
The contributors can request a refund if the monetary goal was not reached within the
deadline.






# Auction
## Decentralized Auction like an eBay alternative;
- The Auction has an owner (the person who sells a good or service), a start and an end
date;
- The owner can cancel the auction if there is an emergency or can finalize the auction
after its end time;
- People are sending ETH by calling a function called placeBid). The sender's address
and the value sent to the auction will be stored in mapping variable called bids;
- Users are incentivized to bid the maximum they're willing to pay, but they are not bound
to that full amount, but rather to the previous highest bid plus an increment. The
contract will automatically bid up to a given amount;
- The highestBindingBid is the selling price and the highest Bidder the person who won
the auction;
- After the auction ends the owner gets the highestBindingBid and everybody else
withdraws their own amount








# erc20TokenICO
## ICO smart contract for a fully ERC-20 compliant token

- The ICO will be a Smart Contract that accepts ETH in exchange for our own token named
ARKCoin (ARK);
- The Cryptos token is a fully compliant ERC20 token and will be generated at the ICO time;
- Investors will send ETH to the ICO contract's address and in return, they'll get an amount of
Cryptos;
- There will be a deposit address (EOA account) that automatically receives the ETH sent to
the ICO contract;

- ARK token price in wei is: 1ARK = 0.01Eth = 10**15 wei, 1 Eth = 1000 ARK);
- The minimum investment is 0.01 ETH and the maximum investment is 5 ETH:

- The ICO Hardcap is 300 ETH;
- The ICO will have an admin that specifies when the ICO starts and ends:
- The ICO ends when the Hardcap or the end time is reached (whichever comes first):
The ARK token will be tradable only after a specific time set by the admin:

●In case of an emergency the admin could stop the ICO and could also change the deposit
address in case it gets compromised;
●The ICO can be in one of the following states: beforeStart, running, afterEnd, halted;
● A possibility to burn the tokens that were not sold in the ICO;
● After an investment in the ICO the Invest event will be emitted
● Token Contract Address (Rinkeby Testnet): 0x4abcc547b3d00ce9be2fc0c23771ea9f7e54b2cb





