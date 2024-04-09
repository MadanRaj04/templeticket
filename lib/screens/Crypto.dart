import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';


class EncryptionPage extends StatefulWidget {
    @override
    _EncryptionPageState createState() => _EncryptionPageState();
}

class _EncryptionPageState extends State<EncryptionPage> {
    String encryptedText = '';
    String decryptedText = '';
    final TextEditingController _inputController = TextEditingController();

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('RSA Encryption Demo'),
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                                controller: _inputController,
                                decoration: InputDecoration(
                                    labelText: 'Enter text to encrypt',
                                    border: OutlineInputBorder(),
                                ),
                            ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: () {
                                encryptText(_inputController.text);
                            },
                            child: Text('Encrypt'),
                        ),
                        SizedBox(height: 20),
                        Text('Encrypted Text: $encryptedText'),
                        SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: () {
                                decryptText();
                            },
                            child: Text('Decrypt'),
                        ),
                        SizedBox(height: 20),
                        Text('Decrypted Text: $decryptedText'),
                    ],
                ),
            ),
        );
    }

    Future<void> encryptText(String text) async {
        try {
            final publicKey = await parseKeyFromFirebaseStoragepub<RSAPublicKey>();
            final privKey = await parseKeyFromFirebaseStoragepriv<RSAPrivateKey>();

            final encrypter = Encrypter(RSA(publicKey: publicKey, privateKey: privKey));

            final encrypted = encrypter.encrypt(text);

            setState(() {
                encryptedText = encrypted.base64;
            });
        } catch (e) {
            print('Encryption failed: $e');
        }
    }

    Future<void> decryptText() async {
        try {
            final publicKey = await parseKeyFromFirebaseStoragepub<RSAPublicKey>();
            final privKey = await parseKeyFromFirebaseStoragepriv<RSAPrivateKey>();

            final encrypter = Encrypter(RSA(publicKey: publicKey, privateKey: privKey));

            final decrypted = encrypter.decrypt(Encrypted.fromBase64(encryptedText));

            setState(() {
                decryptedText = decrypted;
            });
        } catch (e) {
            print('Decryption failed: $e');
        }
    }
}

Future<T?> parseKeyFromFirebaseStoragepub<T extends RSAAsymmetricKey>() async {
    try {
        final parser = RSAKeyParser();
        return parser.parse("""-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDAgEKKNfBmdpgA912Y7J3z2i4I
N4AMVmlx5VjXMQkBingCXN+nKHVOQAPiBbjW4iHMObHcIyzjzYMK49nZTb180uyV
LDaspg2NlKPJqoqn4qkrWGFidi7UkkH7rLA0ph64jwsPiz2f6DplHAORYElPokaz
uOmA/rOd9M9hR2LpOQIDAQAB
-----END PUBLIC KEY-----""") as T;
    } catch (e) {
        print('Error: $e');
        return null;
    }
}

Future<T?> parseKeyFromFirebaseStoragepriv<T extends RSAAsymmetricKey>() async {
    try {
        final parser = RSAKeyParser();
        return parser.parse("""-----BEGIN RSA PRIVATE KEY-----
MIICXQIBAAKBgQDAgEKKNfBmdpgA912Y7J3z2i4IN4AMVmlx5VjXMQkBingCXN+n
KHVOQAPiBbjW4iHMObHcIyzjzYMK49nZTb180uyVLDaspg2NlKPJqoqn4qkrWGFi
di7UkkH7rLA0ph64jwsPiz2f6DplHAORYElPokazuOmA/rOd9M9hR2LpOQIDAQAB
AoGAUr2OXCutBc2JrjiksVta1Pp9eKiqUCNANWVX1z7LWS80QAe9VfLs4NJhGOBO
v4X48vgFe9JetBeccKzY8S8Z93MEpIdQnNtkeOnhWVrdZTUegz9u3JNL6Q2H8QTt
fLegGTM4ZjHKJsJsUHn9Z2hNjfQhK9bjqpH44iWp5HnLrBECQQDoZI3lI5ts+M3B
l3+bFg+e0Wg9kJBSGSUZDIClDRm6hsUhkpXAyM8PFzRVAjhU8cboeCJPfSXlilEf
bP+FvRFVAkEA1A5OzPUqisd69h3BGinTvcd0dSiXvXC8KARIP0vrBoXisZa+fpPR
sCsGeqF5kFhgfv9OqOz3EeVZGO0N8MuIVQJAbN12L2p/zAu977u11oP+K0s0Busr
AJqw60wVE7zQWbX6sSCHMLmhbhNTu6L/mqNsp8hnYk9hKmeiWxNnnFIWxQJBAL7e
ZgVLg1BI/x96Zq5TCbifR+6QbAxi5akrOZBnmBNV/VcVtT8fdDUadQl6QH4xXiHR
UY7xQ+4CvrCV5t9fg8UCQQDcbi9uOy0Wpc+JtNbNv1qab3h5dna4VoGhe9g/6UG6
BuCWPemjOym9HhX6R4nZNNIA1gKmqL1mUbxp4v3K5tGD
-----END RSA PRIVATE KEY-----""") as T;
    } catch (e) {
        print('Error: $e');
        return null;
    }
}
