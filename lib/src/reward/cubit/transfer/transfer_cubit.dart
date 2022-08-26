import 'package:brlc_airdrop/src/proxys/custom/rewarder/rewarder_proxy.dart';

import '../../../proxys/custom/rewarder/service/brlcRewarder.g.dart';
import '../../../proxys/erc20/brlc/brlc_proxy.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

part 'transfer_cubit.freezed.dart';
part 'transfer_state.dart';

class TransferCubit extends Cubit<TransferState> {
  final BrlcRewarderProxy brlcRewarderProxy;

  TransferCubit({
    required this.brlcRewarderProxy,
  }) : super(const TransferState.initial());

  Future<void> transfer({
    required String address,
    required double amount,
  }) async {
    try {
      emit(const TransferState.loading());

      final credentials = EthPrivateKey.fromInt(BigInt.from(420));

      final tx = await brlcRewarderProxy.reward(
        address: address,
        credentials: credentials,
      );

      emit(TransferState.success(tx: tx));
    } catch (e) {
      print(e);
      emit(const TransferState.error(message: 'Something goes wrong'));
    }
  }
}
