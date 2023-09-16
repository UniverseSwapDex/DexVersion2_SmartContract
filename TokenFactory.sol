// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface ISimpleToken {
    function initialize(
        string memory _name,
        string memory _symbol,
        uint8 __decimals,
        uint256 _totalSupply
    ) external payable;
}

interface IStandardToken {
    function initialize(
        string memory _name,
        string memory _symbol,
        uint8 __decimals,
        uint256 _totalSupply,
        uint256 _maxWallet,
        uint256 _maxTransactionAmount,
        address[3] memory _accounts,
        bool _isMarketingFeeBaseToken,
        uint16[4] memory _fees
    ) external payable;
}

interface IReflectionToken {
    function initialize(
        string memory __name,
        string memory __symbol,
        uint8 __decimals,
        uint256 _totalSupply,
        uint256 _maxWallet,
        uint256 _maxTransactionAmount,
        address[3] memory _accounts,
        bool _isMarketingFeeBaseToken,
        uint16[6] memory _fees
    ) external payable;
}

interface IDividendToken {
    function initialize(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        uint256 totalSupply_,
        uint256 _maxWallet,
        uint256 _maxTransactionAmount,
        address[5] memory addrs, // reward, router, marketing wallet, lp wallet, dividendTracker, base Token
        uint16[6] memory feeSettings, // rewards, liquidity, marketing
        uint256 minimumTokenBalanceForDividends_,
        uint8 _tokenForMarketingFee
    ) external payable;
}

interface ISimpleTokenWithAntiBot {
    function initialize(
        string memory _name,
        string memory _symbol,
        uint8 __decimals,
        uint256 _totalSupply,
        address _gemAntiBot
    ) external payable;
}

interface IStandardTokenWithAntiBot {
    function initialize(
        string memory _name,
        string memory _symbol,
        uint8 __decimals,
        uint256 _totalSupply,
        uint256 _maxWallet,
        uint256 _maxTransactionAmount,
        address[3] memory _accounts,
        bool _isMarketingFeeBaseToken,
        uint16[4] memory _fees,
        address _gemAntiBot
    ) external payable;
}

interface IReflectionTokenWithAntiBot {
    function initialize(
        string memory __name,
        string memory __symbol,
        uint8 __decimals,
        uint256 _totalSupply,
        uint256 _maxWallet,
        uint256 _maxTransactionAmount,
        address[3] memory _accounts,
        bool _isMarketingFeeBaseToken,
        uint16[6] memory _fees,
        address _gemAntiBot
    ) external payable;
}

interface IDividendTokenWithAntiBot {
    function initialize(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        uint256 totalSupply_,
        uint256 _maxWallet,
        uint256 _maxTransactionAmount,
        address[5] memory addrs, // reward, router, marketing wallet, lp wallet, dividendTracker, base Token
        uint16[6] memory feeSettings, // rewards, liquidity, marketing
        uint256 minimumTokenBalanceForDividends_,
        uint8 _tokenForMarketingFee,
        address _gemAntiBot
    ) external payable;
}

contract TokenFactory is Ownable {
    using Counters for Counters.Counter;

    enum TokenType {
        SIMPLE,
        STANDARD,
        REFELCTION,
        DIVIDEND,
        SIMPLE_ANTIBOT,
        STANDARD_ANTIBOT,
        REFELCTION_ANTIBOT,
        DIVIDEND_ANTIBOT
    }

    struct Token {
        address tokenAddress;
        TokenType tokenType;
    }

    Counters.Counter private tokenCounter;
    mapping(uint256 => Token) public tokens;

    address[8] implementations = [
        0xE3d694B37eebb3A5420394c75872063D253C09D0, //SimpleToken 0x2D4e185705B18CC9D492615669B36b2A33ef25ac
        0xE3d694B37eebb3A5420394c75872063D253C09D0, //StandartToken 0x26aF384B916E360A37169F98Cc7274ddE9473e9D
        0xE3d694B37eebb3A5420394c75872063D253C09D0, //ReflectionToken 0x634cF84509036adc78d77F7c384e303ae6595880
        0xE3d694B37eebb3A5420394c75872063D253C09D0, //DividendToken 0x924f3557B07638f6c5a99bE324c0311180B6590C
        0xE3d694B37eebb3A5420394c75872063D253C09D0, //SimpleTokenWithAntiBot 0xB6638f233d5E96EE09F284B3f0c22473242b504D
        0xE3d694B37eebb3A5420394c75872063D253C09D0, //StandardTokenWithAntiBot 0x321809d47492AeDeD0E139C48215eB9F52D2778b
        0xE3d694B37eebb3A5420394c75872063D253C09D0, //ReflectionTokenWithAntiBot 0xabF4D024BB6120fbD40c9f3e230658D2B6d18bC5
        0xE3d694B37eebb3A5420394c75872063D253C09D0 //DividendTokenWithAntiBot 0x0025a166a534C2093f6aC1C1890cd80e3d6Cff15
    ];

    uint256[4] fees = [0.1 ether, 0.1 ether, 0.1 ether, 0.1 ether];

    constructor() {}

    function createSimpleToken(
        string memory _name,
        string memory _symbol,
        uint8 __decimals,
        uint256 _totalSupply
    ) external payable {
        require(msg.value >= fees[0], "createSimpleToken::Fee is not enough");
        address newToken = Clones.clone(implementations[0]);
        ISimpleToken(newToken).initialize{value: msg.value}(
            _name,
            _symbol,
            __decimals,
            _totalSupply
        );
        uint256 counter = tokenCounter.current();
        tokens[counter].tokenAddress = newToken;
        tokens[counter].tokenType = TokenType.SIMPLE;
        tokenCounter.increment();
    }

    function createStandardToken(
        string memory _name,
        string memory _symbol,
        uint8 __decimals,
        uint256 _totalSupply,
        uint256 _maxWallet,
        uint256 _maxTransactionAmount,
        address[3] memory _accounts,
        bool _isMarketingFeeBaseToken,
        uint16[4] memory _fees
    ) external payable {
        require(msg.value >= fees[1], "createStandardToken::Fee is not enough");
        address newToken = Clones.clone(implementations[1]);
        IStandardToken(newToken).initialize{value: msg.value}(
            _name,
            _symbol,
            __decimals,
            _totalSupply,
            _maxWallet,
            _maxTransactionAmount,
            _accounts,
            _isMarketingFeeBaseToken,
            _fees
        );
        uint256 counter = tokenCounter.current();
        tokens[counter].tokenAddress = newToken;
        tokens[counter].tokenType = TokenType.STANDARD;
        tokenCounter.increment();
    }

    function createReflectionToken(
        string memory __name,
        string memory __symbol,
        uint8 __decimals,
        uint256 _totalSupply,
        uint256 _maxWallet,
        uint256 _maxTransactionAmount,
        address[3] memory _accounts,
        bool _isMarketingFeeBaseToken,
        uint16[6] memory _fees
    ) external payable {
        require(
            msg.value >= fees[2],
            "createReflectionToken::Fee is not enough"
        );
        address newToken = Clones.clone(implementations[2]);
        IReflectionToken(newToken).initialize{value: msg.value}(
            __name,
            __symbol,
            __decimals,
            _totalSupply,
            _maxWallet,
            _maxTransactionAmount,
            _accounts,
            _isMarketingFeeBaseToken,
            _fees
        );
        uint256 counter = tokenCounter.current();
        tokens[counter].tokenAddress = newToken;
        tokens[counter].tokenType = TokenType.REFELCTION;
        tokenCounter.increment();
    }

    function createDividendToken(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        uint256 totalSupply_,
        uint256 _maxWallet,
        uint256 _maxTransactionAmount,
        address[5] memory addrs, // reward, router, marketing wallet, lp wallet, dividendTracker, base Token
        uint16[6] memory feeSettings, // rewards, liquidity, marketing
        uint256 minimumTokenBalanceForDividends_,
        uint8 _tokenForMarketingFee
    ) external payable {
        require(msg.value >= fees[3], "createDividendToken::Fee is not enough");
        address newToken = Clones.clone(implementations[3]);
        IDividendToken(newToken).initialize{value: msg.value}(
            name_,
            symbol_,
            decimals_,
            totalSupply_,
            _maxWallet,
            _maxTransactionAmount,
            addrs, // reward, router, marketing wallet, lp wallet, dividendTracker, base Token
            feeSettings, // rewards, liquidity, marketing
            minimumTokenBalanceForDividends_,
            _tokenForMarketingFee
        );
        uint256 counter = tokenCounter.current();
        tokens[counter].tokenAddress = newToken;
        tokens[counter].tokenType = TokenType.DIVIDEND;
        tokenCounter.increment();
    }

    function createSimpleTokenWithAntiBot(
        string memory _name,
        string memory _symbol,
        uint8 __decimals,
        uint256 _totalSupply,
        address _gemAntiBot
    ) external payable {
        require(msg.value >= fees[0], "createSimpleToken::Fee is not enough");
        address newToken = Clones.clone(implementations[4]);
        ISimpleTokenWithAntiBot(newToken).initialize{value: msg.value}(
            _name,
            _symbol,
            __decimals,
            _totalSupply,
            _gemAntiBot
        );
        uint256 counter = tokenCounter.current();
        tokens[counter].tokenAddress = newToken;
        tokens[counter].tokenType = TokenType.SIMPLE_ANTIBOT;
        tokenCounter.increment();
    }

    function createStandardTokenWithAntiBot(
        string memory _name,
        string memory _symbol,
        uint8 __decimals,
        uint256 _totalSupply,
        uint256 _maxWallet,
        uint256 _maxTransactionAmount,
        address[3] memory _accounts,
        bool _isMarketingFeeBaseToken,
        uint16[4] memory _fees,
        address _gemAntiBot
    ) external payable {
        require(msg.value >= fees[1], "createStandardToken::Fee is not enough");
        address newToken = Clones.clone(implementations[5]);
        IStandardTokenWithAntiBot(newToken).initialize{value: msg.value}(
            _name,
            _symbol,
            __decimals,
            _totalSupply,
            _maxWallet,
            _maxTransactionAmount,
            _accounts,
            _isMarketingFeeBaseToken,
            _fees,
            _gemAntiBot
        );
        uint256 counter = tokenCounter.current();
        tokens[counter].tokenAddress = newToken;
        tokens[counter].tokenType = TokenType.STANDARD_ANTIBOT;
        tokenCounter.increment();
    }

    function createReflectionTokenWithAntiBot(
        string memory __name,
        string memory __symbol,
        uint8 __decimals,
        uint256 _totalSupply,
        uint256 _maxWallet,
        uint256 _maxTransactionAmount,
        address[3] memory _accounts,
        bool _isMarketingFeeBaseToken,
        uint16[6] memory _fees,
        address _gemAntiBot
    ) external payable {
        require(
            msg.value >= fees[2],
            "createReflectionToken::Fee is not enough"
        );
        address newToken = Clones.clone(implementations[6]);
        IReflectionTokenWithAntiBot(newToken).initialize{value: msg.value}(
            __name,
            __symbol,
            __decimals,
            _totalSupply,
            _maxWallet,
            _maxTransactionAmount,
            _accounts,
            _isMarketingFeeBaseToken,
            _fees,
            _gemAntiBot
        );
        uint256 counter = tokenCounter.current();
        tokens[counter].tokenAddress = newToken;
        tokens[counter].tokenType = TokenType.REFELCTION_ANTIBOT;
        tokenCounter.increment();
    }

    function createDividendTokenWithAntiBot(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        uint256 totalSupply_,
        uint256 _maxWallet,
        uint256 _maxTransactionAmount,
        address[5] memory addrs, // reward, router, marketing wallet, lp wallet, dividendTracker, base Token
        uint16[6] memory feeSettings, // rewards, liquidity, marketing
        uint256 minimumTokenBalanceForDividends_,
        uint8 _tokenForMarketingFee,
        address _gemAntiBot
    ) external payable {
        require(msg.value >= fees[3], "createDividendToken::Fee is not enough");
        address newToken = Clones.clone(implementations[7]);
        IDividendTokenWithAntiBot(newToken).initialize{value: msg.value}(
            name_,
            symbol_,
            decimals_,
            totalSupply_,
            _maxWallet,
            _maxTransactionAmount,
            addrs, // reward, router, marketing wallet, lp wallet, dividendTracker, base Token
            feeSettings, // rewards, liquidity, marketing
            minimumTokenBalanceForDividends_,
            _tokenForMarketingFee,
            _gemAntiBot
        );
        uint256 counter = tokenCounter.current();
        tokens[counter].tokenAddress = newToken;
        tokens[counter].tokenType = TokenType.DIVIDEND_ANTIBOT;
        tokenCounter.increment();
    }

    function getAllTokens() external view returns (Token[] memory) {
        Token[] memory _tokens = new Token[](tokenCounter.current());
        for (uint256 i = 0; i < tokenCounter.current(); i++) {
            _tokens[i].tokenAddress = tokens[i].tokenAddress;
            _tokens[i].tokenType = tokens[i].tokenType;
        }
        return _tokens;
    }

    receive() external payable {}
}