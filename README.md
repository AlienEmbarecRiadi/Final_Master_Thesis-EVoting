# Web application for organizing elections based on the blockchain

Hello everyone,

This repository contains my Master's Thesis. It consists of a web application for blockchain based voting.

The frontend has been developed in _React_ and _MaterialUI_. The backend has been developed in _Node.js_.

The interaction with the blockchain is done with _Truffle_ (compilation and deployment of contracts developed using _Solidity_) and Ganache (free _Ethereum_ accounts wallet).

To launch the application locally, the following steps have to be taken:

1. Create an account on _Firebase_ and initialize the authentication service and another real-time database service.

2. Create an `.env` file in the frontend with the following fields:
   '''
   REACT_APP_API_URL=""
   REACT_APP_FIREBASE_API_KEY=""
   REACT_APP_FIREBASE_AUTH_DOMAIN=""
   '''
   In the first field you have to declare the backend URL (`http://localhost:5000`), in the second field specify the Firebase API key.

   In the third field specify the name of the authentication domain provided by Firebase.

   Then make sure that the current path points to the frontend directory. First run `npm install` and then `npm start`.

   In order to launch the frontend, the backend server must be started first.

3. Create an `.env` file in the backend with the following fields:
   '''
   URL="..."
   MNEMONIC="...."
   DATABASE="..."
   '''
   In `URL` you have to write the address of the blockchain node used to validate transactions. In `MNEMONIC` you have to specify the security string of your wallet in Ganache.

   In `DATABASE` you have to declare the URL of the relational database created in _Firebase_.

4. Download the `service-account.json` file from your Firebase account and place it in the backend directory.

   Go to the backend directory, set up the dependencies with `npm install` and launch the application with `npm start`.
