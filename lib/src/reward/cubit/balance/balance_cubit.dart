import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:web3dart/web3dart.dart';

import '../../../proxys/custom/rewarder/rewarder_proxy.dart';
import '../../../proxys/custom/rewarder/service/brlcRewarder.g.dart';
import '../../../proxys/erc20/brlc/brlc_proxy.dart';
import 'package:http/http.dart';

part 'balance_cubit.freezed.dart';
part 'balance_state.dart';

class BalanceCubit extends Cubit<BalanceState> {
  final BrlcRewarderProxy brlcRewarderProxy;

  BalanceCubit({
    required this.brlcRewarderProxy,
  }) : super(const BalanceState.initial());

  Future<void> balanceOfWallet() async {
    try {
      emit(const BalanceState.loading());

      final currentBalance = await brlcRewarderProxy.balance();

      emit(
        BalanceState.success(
          balance: currentBalance,
          symbol: "BRLC",
        ),
      );
    } catch (e) {
      emit(const BalanceState.error());
    }
  }
}
