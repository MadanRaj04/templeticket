import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';

class SendTokensPage extends StatelessWidget {
  final String privateKey;
  final TextEditingController recipientController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  SendTokensPage({Key? key, required this.privateKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Tokens'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Recipient Address:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '0xac8be70072e9b3948c9007024e530c12da2b103b',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Amount:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '0.0005',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String recipient =
                    '0xac8be70072e9b3948c9007024e530c12da2b103b';
                double amount = 0.0005;
                BigInt bigIntValue = BigInt.from(amount * pow(10, 18));
                print(bigIntValue);
                EtherAmount ethAmount =
                EtherAmount.fromBigInt(EtherUnit.wei, bigIntValue);
                print(ethAmount);
                // Convert the amount to EtherAmount
                sendTransaction(recipient, ethAmount);
              },
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }

  void sendTransaction(String receiver, EtherAmount txValue) async {
    var apiUrl =
        "https://eth-sepolia.g.alchemy.com/v2/r7WNKg9L2sXc9GOhk4LCHJy4ZxcrQU4C"; // Replace with your API
    // Replace with your API
    var httpClient = http.Client();
    var ethClient = Web3Client(apiUrl, httpClient);

    EthPrivateKey credentials = EthPrivateKey.fromHex('0x' + privateKey);

    EtherAmount etherAmount = await ethClient.getBalance(credentials.address);
    EtherAmount gasPrice = await ethClient.getGasPrice();

    print(etherAmount);

    await ethClient.sendTransaction(
      credentials,
      Transaction(
        to: EthereumAddress.fromHex(receiver),
        gasPrice: gasPrice,
        maxGas: 100000,
        value: txValue,
      ),
      chainId: 11155111,
    );
  }
}
