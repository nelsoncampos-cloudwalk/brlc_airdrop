import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:web3dart/credentials.dart';

part 'wallets_cubit.freezed.dart';
part 'wallets_state.dart';

class WalletsCubit extends Cubit<WalletsState> {
  WalletsCubit() : super(const WalletsState.initial());

  void loadWallet() {
    emit(const WalletsState.loading());

    final cred = EthPrivateKey.fromInt(BigInt.from(420));

    emit(WalletsState.success(wallet: cred));
  }
}
