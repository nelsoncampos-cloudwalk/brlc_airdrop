import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:web3dart/web3dart.dart';

import '../../../proxys/erc20/brlc/brlc_proxy.dart';

part 'balance_cubit.freezed.dart';
part 'balance_state.dart';

class BalanceCubit extends Cubit<BalanceState> {
  final Credentials credentials;
  final BrlcProxy brlcProxy;
  BalanceCubit({
    required this.credentials,
    required this.brlcProxy,
  }) : super(const BalanceState.initial());

  Future<void> balanceOfWallet() async {
    try {
      emit(const BalanceState.loading());
      final account = await credentials.extractAddress();
      final currentBalance = await brlcProxy.balanceOf(
        address: account.hex,
      );
      final symbol = await brlcProxy.symbol();
      emit(
        BalanceState.success(
          balance: currentBalance,
          symbol: symbol,
        ),
      );
    } catch (e) {
      emit(const BalanceState.error());
    }
  }
}
