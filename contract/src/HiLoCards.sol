pragma solidity ^0.8.25;

import {HiLoBase} from "./HiLoBase.sol";

contract HiLoCards is HiLoBase {
    struct Card {
        uint8 suit;
        uint8 rank;
    }

    uint128 public constant CARD_MULTIPLIER_SCALE = 10;
    uint8 public constant N_RANKS = 13;
    uint8 public constant N_SUITS = 4;

    // values from https://wizardofodds.com/games/draw-hi-lo/
    uint128[] public CARD_MULTIPLIERS = [
        10,
        11,
        12,
        13,
        14,
        15,
        18,
        20,
        30,
        30,
        50,
        120,
        0
    ];

    Card public latestCard;

    constructor(
        uint256 _nRounds,
        uint128 _startingChips
    )
        HiLoBase(
            _nRounds,
            _startingChips,
            CARD_MULTIPLIERS,
            CARD_MULTIPLIER_SCALE
        )
    {}

    function sampleNextMark() public override returns (uint8) {
        Card memory nextCard = draw();
        latestCard = nextCard;
        return nextCard.rank;
    }

    function draw() public view returns (Card memory) {
        uint256 rand = uint256(blockhash(block.number - 1));
        uint8 cardIdx = uint8(rand % (N_SUITS * N_RANKS));
        return
            Card({
                suit: cardIdx / N_RANKS,
                rank: cardIdx % N_RANKS
            });
    }
}
