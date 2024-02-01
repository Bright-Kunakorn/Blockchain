// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Twitter {

    uint constant MAX_TWEET_LENGTH =280;
    struct tweet {
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }

    mapping(address => tweet[]) public tweets;

    function getLength(string memory str) public  pure returns (uint256){
        return  bytes(str).length;
    }
    function createTweet(string memory text) public {
        require(getLength(text) <= MAX_TWEET_LENGTH,"Your tweet too long");
        tweet memory newTweet = tweet({
            author: msg.sender,
            content: text,
            timestamp: block.timestamp,
            likes: 0 
        });
        tweets[msg.sender].push(newTweet);
    }

    function getAllTweets(address _owner) public view returns (tweet[] memory) {
        return tweets[_owner];
    }
}
