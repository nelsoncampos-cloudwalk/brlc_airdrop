import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:brlc_airdrop/src/proxys/custom/rewarder/rewarder_proxy.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:web3dart/credentials.dart';

part 'wallets_cubit.freezed.dart';
part 'wallets_state.dart';

class WalletsCubit extends Cubit<WalletsState> {
  final BrlcRewarderProxy brlcRewarderProxy;
  WalletsCubit({
    required this.brlcRewarderProxy,
  }) : super(const WalletsState.initial());

  Future<void> loadWallet() async {
    emit(const WalletsState.loading());

    final wallet = await brlcRewarderProxy.address();

    emit(WalletsState.success(wallet: wallet));
  }
}
