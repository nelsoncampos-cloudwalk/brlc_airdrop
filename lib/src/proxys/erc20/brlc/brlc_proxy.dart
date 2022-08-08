import 'service/brlc.g.dart';
import '../erc20_standard.dart';
import '../../../extensions/big_int_divisor_ext.dart';
import 'package:web3dart/web3dart.dart';

class BrlcProxy implements Erc20Standard {
  final Brlc brlc;

  BrlcProxy({required this.brlc});

  @override
  Future<double> balanceOf({required String address}) async {
    final brlcBigInt = await brlc.balanceOf(EthereumAddress.fromHex(address));
    return brlcBigInt.toDoubleWithDivsior();
  }

  @override
  Future<String> transfer({
    required String from,
    required double amount,
    required Credentials credentials,
  }) async {
    final address = EthereumAddress.fromHex(from);
    final bigAmount = BigInt.from(amount * 1000000);
    return brlc.transfer(
      address,
      bigAmount,
      credentials: credentials,
    );
  }

  @override
  Future<double> decimals() async {
    final decimals = await brlc.decimals();
    return decimals.toDoubleWithDivsior();
  }

  @override
  Future<String> name() async {
    return brlc.name();
  }

  @override
  Future<String> symbol() {
    return brlc.symbol();
  }

  @override
  Future<double> totalSupply() async {
    final totalSuply = await brlc.totalSupply();
    return totalSuply.toDoubleWithDivsior();
  }
}
