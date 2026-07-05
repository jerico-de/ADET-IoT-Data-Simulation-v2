// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ─────────────────────────────────────────────────────────────────────────────
// Smart Logistics Tracking System — IoT Data Storage Contract
// MO-IT148 | Blockchain and IoT Integration
// ─────────────────────────────────────────────────────────────────────────────

contract IoTDataStorage {

    // ── Data Structure ────────────────────────────────────────────────────────
    struct IoTData {
        uint256 dataTimestamp;   
        uint256 blockTimestamp;  
        string  deviceId;
        string  dataType;
        string  dataValue;
    }

    // ── State Variables ───────────────────────────────────────────────────────
    uint256 public constant MAX_ENTRIES = 100;
    IoTData[] public dataRecords;
    address  public owner;

    // ── Events ────────────────────────────────────────────────────────────────
    event DataStored(
        uint256 dataTimestamp,
        uint256 blockTimestamp,
        string  deviceId,
        string  dataType,
        string  dataValue
    );

    // ── Access Control ────────────────────────────────────────────────────────
    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    // ── Constructor ───────────────────────────────────────────────────────────
    constructor() {
        owner = msg.sender;
    }

    // ── Store IoT Data on Blockchain ──────────────────────────────────────────
    function storeData(
        uint256 _dataTimestamp,
        string memory _deviceId,
        string memory _dataType,
        string memory _dataValue
    ) public onlyOwner {
        require(dataRecords.length < MAX_ENTRIES, "Storage limit reached");
        dataRecords.push(IoTData(
            _dataTimestamp,
            block.timestamp,
            _deviceId,
            _dataType,
            _dataValue
        ));
        emit DataStored(_dataTimestamp, block.timestamp, _deviceId, _dataType, _dataValue);
    }

    // ── Get Total Number of Stored Records ────────────────────────────────────
    function getTotalRecords() public view returns (uint256) {
        return dataRecords.length;
    }

    // ── Retrieve a Record by Index ────────────────────────────────────────────
    function getRecord(uint256 index) public view returns (
        uint256, // dataTimestamp
        uint256, // blockTimestamp
        string memory,
        string memory,
        string memory
    ) {
        require(index < dataRecords.length, "Index out of bounds");
        IoTData memory record = dataRecords[index];
        return (
            record.dataTimestamp,
            record.blockTimestamp,
            record.deviceId,
            record.dataType,
            record.dataValue
        );
    }
}