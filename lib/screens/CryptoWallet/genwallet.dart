import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:templeticketsystem/providers/wallet_provider.dart';
import 'package:templeticketsystem/utils/routes.dart';
import 'package:templeticketsystem/screens/CryptoWallet/login_page.dart';

class WalletApp extends StatelessWidget {
  const WalletApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Load the private key
    WalletProvider walletProvider = WalletProvider();
    walletProvider.loadPrivateKey();

    return ChangeNotifierProvider<WalletProvider>.value(
      value: walletProvider,
      child: MaterialApp(
        initialRoute: MyRoutes.loginRoute,
        routes: {
          MyRoutes.loginRoute: (context) => const LoginPage(),
        },
      ),
    );
  }
}


