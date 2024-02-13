pragma solidity ^0.8.0;

contract Helloworld {
    string name;

    function setUserName(string memory userName) public {
        name = userName;
    }

    function printMessage() public returns(string memory) {
        bytes memory concat_strings;
        concat_strings = abi.encodePacked("Hello ");
        concat_strings = abi.encodePacked(concat_strings, name);
        concat_strings = abi.encodePacked(concat_strings, "!");
        string memory message = string(concat_strings);

        return message;

    }
}