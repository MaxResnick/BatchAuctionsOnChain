// This is pseudcode, not meant to actually work 

struct order{ //tuple with order size (amount) and slippage tolerance (slippageTolerance)
int256 amount,
int256 slippageTolerance
}

struct AuctionState{
int256 aggregateOrder,
order buyOrders[], ##sorted priorityQue
order sellOrders[] ##sorted priorityQue
}

function submitOrder(Order order){
if (order.amount > 0 ){ // buy order
		Auctionstate.aggregateOrder += order.amount;
		buyOrders.push(order); // needs to push to the right spot
}
else if (order.amount < 0){// sell order
	Auctionstate.aggregateOrder += order.amount;
		sellOrders.push(order); // needs to push to the right spot
	}
}

#called on first interaction within a block
function resolveAuction(Auctionstate){
    while true{// will always terminate since there are only a finite number of orders
        //orders are perfectly matched so no need to trade with the AMM
	    if (AuctionState.aggregateOrder == 0){
		    clearMarket(previousPrice);
        }
	    else if (AuctionState.aggregateOrder > 0){// more buy demand than sell demand
		    //set slippage tolerance to leading slippage tolerance  in buy order que
            slippageTolerance = buyOrders[0].slippageTolerance;
            try{// try executing the order with the least tollerant slippage
                marketPrice = executeOrder(AuctionState.aggregateOrder,slippageTolerance);
                clearMarket(marketprice);
            }
            catch{// if it doesnt work we have to remove the order from the que
                aggregateOrder -= buyOrders[0].amount;// decrement aggregate order
                buyOrders[0].removeFromQue()// remove the order from the que
                resetAuctionState();
                break;
            }
    }
        else { // more sell demand than buy demand
            //set slippage tolerance to leading slippage tolerance  in sell order que
            slippageTolerance = sellOrders[0].slippageTolerance;
            try{
                marketPrice = executeOrder(AuctionState.aggregateOrder,slippageTolerance);
                clearMarket(marketprice);
                resetAuctionState();
                break;
            }
            catch{
                aggregateOrder -= sellOrders[0].amount;// decrement aggregate order
                sellOrders[0].removeFromQue()// remove the order from the que
            }
        }	
    }
}
 
function clearMarket(uint256 price, AuctionState){
    // each buy order recieves amount of the token and loses price*amount of the numeraire
    // each sell order recieves amount*price of the numeraire and loses amount of the token
}
