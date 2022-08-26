import '../../proxys/custom/rewarder/rewarder_proxy.dart';
import '../../proxys/custom/rewarder/service/brlcRewarder.g.dart';
import '../cubit/transfer/transfer_cubit.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'dart:js' as js;

import '../cubit/balance/balance_cubit.dart';
import '../cubit/wallets/wallets_cubit.dart';

class RewardPage extends StatefulWidget {
  const RewardPage({Key? key}) : super(key: key);

  @override
  State<RewardPage> createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  late final WalletsCubit walletCubit;
  final brlcRewarderProxy = BrlcRewarderProxy(
    brlcRewarder: BrlcRewarder(
      address: EthereumAddress.fromHex(
        '0xb5baDc16Bc2ed49F831c1Fb9f15BefA3DFCd82Bb',
      ),
      client: Web3Client('https://rpc.testnet.cloudwalk.io', Client()),
      chainId: 2008,
    ),
  );

  @override
  void initState() {
    walletCubit = WalletsCubit(
      brlcRewarderProxy: brlcRewarderProxy,
    );

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await walletCubit.loadWallet();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<WalletsCubit, WalletsState>(
        bloc: walletCubit,
        listener: (context, state) {},
        builder: (context, state) {
          return state.maybeWhen(
            success: (wallet) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      'Rewarder Wallet: $wallet',
                      style: context.typography.bodyRegular,
                    ),
                  ),
                  const SizedBox(height: 48),
                  _Balance(brlcRewarderProxy: brlcRewarderProxy),
                  const SizedBox(height: 48),
                  _Send(brlcRewarderProxy: brlcRewarderProxy),
                ],
              );
            },
            orElse: () => const Text('Loading'),
          );
        },
      ),
    );
  }
}

class _Send extends StatefulWidget {
  final BrlcRewarderProxy brlcRewarderProxy;
  const _Send({
    Key? key,
    required this.brlcRewarderProxy,
  }) : super(key: key);

  @override
  State<_Send> createState() => __SendState();
}

class __SendState extends State<_Send> {
  final addressController = TextEditingController();
  late final TransferCubit transferCubit;

  @override
  void initState() {
    transferCubit = TransferCubit(
      brlcRewarderProxy: widget.brlcRewarderProxy,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            width: 300,
            child: InfiniteTextField(
              controller: addressController,
              keyboardType: TextInputType.number,
              label: "Sua carteira",
            ),
          ),
        ),
        const SizedBox(height: 48),
        InfiniteButton(
          isExpanded: false,
          onTap: () async {
            await transferCubit.transfer(
              address: addressController.text,
              amount: 100,
            );
          },
          label: "Regastar",
        ),
        BlocBuilder<TransferCubit, TransferState>(
          bloc: transferCubit,
          builder: (context, state) {
            return state.maybeWhen(
              success: (tx) => GestureDetector(
                onTap: () => js.context.callMethod(
                  'open',
                  ['https://explorer.testnet.cloudwalk.io/tx/$tx'],
                ),
                child: Text(
                  "https://explorer.testnet.cloudwalk.io/tx/$tx",
                  style: context.typography.bodyRegular.copyWith(
                    color: kColorBrandPrimary,
                  ),
                ),
              ),
              error: (e) => Text(e),
              loading: () => const Text("Loading"),
              orElse: SizedBox.shrink,
            );
          },
        )
      ],
    );
  }
}

class _Balance extends StatefulWidget {
  final BrlcRewarderProxy brlcRewarderProxy;
  const _Balance({
    Key? key,
    required this.brlcRewarderProxy,
  }) : super(key: key);

  @override
  State<_Balance> createState() => __BalanceState();
}

class __BalanceState extends State<_Balance> {
  late final BalanceCubit balanceCubit;

  @override
  void initState() {
    balanceCubit = BalanceCubit(
      brlcRewarderProxy: widget.brlcRewarderProxy,
    );

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await balanceCubit.balanceOfWallet();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BalanceCubit, BalanceState>(
      bloc: balanceCubit,
      builder: (context, state) {
        return state.maybeWhen(
          success: (symbol, balance) => Text(
            '$symbol balance: $balance',
            style: context.typography.bodyRegular,
          ),
          error: () => Text(
            'Error to load the balance',
            style: context.typography.bodyRegular,
          ),
          orElse: () => Text(
            'Loading Balance',
            style: context.typography.bodyRegular,
          ),
        );
      },
    );
  }
}
