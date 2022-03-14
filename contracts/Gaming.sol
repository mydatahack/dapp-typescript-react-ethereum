pragma solidity >=0.5.16;

contract Gaming {
    /* Our Online gaming contract */
    address owner;
    bool public online;


    struct Player {
        uint wins;
        uint losses;
    }

    mapping (address => Player) public players;
    
    constructor() public payable {
        owner = msg.sender;
        online = true;
    }

    modifier isOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    event GameFunded(address funder, uint amount);
    event PlayerWon(address player, uint amount, uint mysteryNumber, uint displayedNumber);
    event PlayerLost(address player, uint amount, uint mysteryNumber, uint displayedNumber);

    function mysteryNumber() internal view returns (uint) {
        uint randomNumber = uint(blockhash(block.number-1))%10 + 1;
        return randomNumber;
    }

    function determineWinner(uint number, uint display, bool guess) public pure returns (bool) {
        if (guess == true && number > display) {
            return true;
        } else if (guess == true && number < display) {
            return false;
        } else if (guess == false && number > display) {
            return false;
        } else if (guess == false && number < display) {
            return true;
        }
    }

    function winOrLose(uint display, bool guess) external payable returns (bool, uint) {
        /* Use true for a higher guess, false for a lower guess */
        require(online == true, "The game is online");
        require(msg.sender.balance > msg.value, "Insufficient funds");
        uint mysteryNumber_ = mysteryNumber();
        bool isWinner = determineWinner(mysteryNumber_, display, guess);
        Player storage player = players[msg.sender];
        if (isWinner == true) {
            player.wins += 1;
            // return the amount wagered plus the ether sent with the transaction
            msg.sender.transfer(msg.value * 2);
            emit PlayerWon(msg.sender, msg.value, mysteryNumber_, display);
            return (true, mysteryNumber_);
        } else if (isWinner == false) {
            player.losses += 1;
            emit PlayerLost(msg.sender, msg.value, mysteryNumber_, display);
            return (false, mysteryNumber_);
        }
    }

    function withdrawFunds() public isOwner {
        msg.sender.transfer(address(this).balance);
    }

    function fundGame() public isOwner payable {
        emit GameFunded(msg.sender, msg.value);
    }

    function() external payable {
    }
}
