import 'package:brlc_airdrop/src/proxys/custom/custom_rewarder_interface.dart';
import 'package:brlc_airdrop/src/proxys/custom/rewarder/service/brlcRewarder.g.dart';
import 'package:web3dart/web3dart.dart';
import '../../../extensions/big_int_divisor_ext.dart';

class BrlcRewarderProxy implements CustomRewarder {
  final BrlcRewarder brlcRewarder;
  BrlcRewarderProxy({required this.brlcRewarder});

  @override
  Future<String> address() async {
    final address = await brlcRewarder.getRewarderWallet();
    return address.hex;
  }

  @override
  Future<double> balance() async {
    final bigBalance = await brlcRewarder.getRewarderBalance();
    return bigBalance.toDoubleWithDivsior();
  }

  @override
  Future<String> reward({
    required String address,
    required Credentials credentials,
  }) async {
    final reciver = EthereumAddress.fromHex(address);
    return await brlcRewarder.reward(
      reciver,
      credentials: credentials,
    );
  }
}
