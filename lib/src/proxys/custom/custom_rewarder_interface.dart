import 'package:web3dart/web3dart.dart';

abstract class CustomRewarder {
  Future<String> address();

  Future<double> balance();

  Future<String> reward({
    required String address,
    required Credentials credentials,
  });
}
