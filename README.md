# ADET-IoT-Data-Simulation-v2
# Smart Logistics Tracking System

**MO-IT148 | Blockchain and IoT Integration**

A blockchain-backed IoT tracking system that simulates sensor data from shipments in transit — temperature, humidity, and GPS — and stores it immutably on a local Ethereum blockchain (Ganache) via a custom Solidity smart contract. Data is retrieved, cleaned, and visualized to support real-time logistics monitoring.

> This repo supersedes an earlier, outdated version of this project. The old repo has been archived.

---

## Overview

Every reading simulates an IoT sensor attached to a package moving through a supply chain:

- **Temperature** — cold-chain monitoring (2–8°C range)
- **Humidity** — moisture-sensitive cargo monitoring
- **GPS** — location tracking (Philippines lat/long range)

Each record also carries a shipment `status` (`In Transit`, `Delayed`, `Delivered`) and a `package_id`. Readings are generated with randomized timestamps across a 10-day shipping window to simulate a realistic multi-day journey rather than a single point-in-time snapshot.

Once generated, records are written to a Solidity smart contract deployed on a local Ganache blockchain via Web3.py, then read back, merged with the original metadata, cleaned, and visualized.

---

## Project Structure

```
├── 01_IoT_Data_Generator.ipynb        # Generates simulated sensor data (CSV/JSON)
├── 02_Blockchain_Storage.ipynb        # Connects to Ganache, deploys/interacts with contract, stores records
├── 03_Data_Retrieval.ipynb            # Retrieves records from chain, merges with original CSV, cleans data
├── 04_Line_Plot_Visualization.ipynb   # Visualizes sensor trends over time (filterable by sensor type)
├── IoTDataStorage.sol                 # Solidity smart contract (deploy via Remix IDE)
├── logistics_iot_data.csv             # Raw generated sensor data
├── cleaned_iot_data.csv               # Final cleaned dataset (blockchain + original metadata merged)
└── README.md
```

---

## Tech Stack

| Layer | Tool |
|---|---|
| Data generation & cleaning | Python, pandas, numpy |
| Smart contract | Solidity, Remix IDE |
| Local blockchain | Ganache |
| Blockchain interaction | Web3.py |
| Visualization | Jupyter (matplotlib/seaborn), Tableau |

---

## Smart Contract: `IoTDataStorage.sol`

Key design decisions:

- **Dual timestamps** — each record stores both a `dataTimestamp` (the sensor-claimed reading time) and a `blockTimestamp` (the actual on-chain mining time, supplied automatically and unforgeable). Comparing the two allows detection of suspicious mismatches between claimed and recorded event times.
- **Access control** — only the contract owner (`onlyOwner` modifier) can write new records, preventing unauthorized parties from injecting fake shipment data.
- **Storage cap** — capped at 100 records (`MAX_ENTRIES`) for this demo scope.

```solidity
struct IoTData {
    uint256 dataTimestamp;   // sensor-generated timestamp
    uint256 blockTimestamp;  // when this record was actually mined on-chain
    string  deviceId;
    string  dataType;
    string  dataValue;
}
```

---

## How to Run

### Prerequisites
- Python 3.10+ with `pandas`, `numpy`, `web3`, `matplotlib`, `seaborn` installed
- [Ganache](https://archive.trufflesuite.com/ganache/) running locally at `http://127.0.0.1:7545`
- [Remix IDE](https://remix.ethereum.org/) for compiling/deploying the smart contract

### Steps

1. **Generate data** — run `01_IoT_Data_Generator.ipynb` end to end. Produces `logistics_iot_data.csv`.
2. **Deploy the contract** — open `IoTDataStorage.sol` in Remix, compile, and deploy to your running Ganache instance. Copy the deployed contract address.
3. **Update contract address** — paste the deployed address into the `contract_address` variable in both `02_Blockchain_Storage.ipynb` and `03_Data_Retrieval.ipynb`.
4. **Store data on-chain** — run `02_Blockchain_Storage.ipynb`. This sends each record as a transaction to the contract.
5. **Retrieve and clean data** — run `03_Data_Retrieval.ipynb`. Pulls records back from the chain, merges with original metadata, and saves `cleaned_iot_data.csv`.
6. **Visualize** — run `04_Line_Plot_Visualization.ipynb`, or import `cleaned_iot_data.csv` into Tableau for the interactive dashboard.

> **Note:** Since Ganache resets on workspace restart, and each new contract deployment gets a fresh address, re-run steps 2–5 in order any time you redeploy or restart your blockchain workspace.

---

## Key Learnings & Design Notes

- Blockchain guarantees **tamper-evidence after storage** — it does not guarantee sensor **accuracy before storage**. This distinction shaped several of our design choices (e.g. the dual-timestamp field) and is discussed further in our project presentation's ethics/sustainability sections.
- Real-world logistics deployments would pair this kind of system with redundant sensors and physical checkpoint audits, rather than relying on blockchain-recorded data alone.

---

## Migration Note

This project was previously hosted in an earlier repository that has since been superseded by this rebuild (updated data generation, smart contract, and retrieval/visualization pipeline). The old repo has been archived with a pointer to this one.
