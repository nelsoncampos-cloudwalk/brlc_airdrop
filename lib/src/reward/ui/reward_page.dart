import 'package:brlc_airdrop/src/reward/cubit/transfer/transfer_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

import 'dart:js' as js;

import '../../proxys/erc20/brlc/brlc_proxy.dart';
import '../../proxys/erc20/brlc/service/brlc.g.dart';
import '../cubit/balance/balance_cubit.dart';
import '../cubit/wallets/wallets_cubit.dart';

class RewardPage extends StatefulWidget {
  const RewardPage({Key? key}) : super(key: key);

  @override
  State<RewardPage> createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  final brlcProxy = BrlcProxy(
    brlc: Brlc(
      address: EthereumAddress.fromHex(
        '0xA9a55a81a4C085EC0C31585Aed4cFB09D78dfD53',
      ),
      client: Web3Client('https://rpc.services.mainnet.cloudwalk.io', Client()),
      chainId: 2009,
    ),
  );
  final walletCubit = WalletsCubit();

  @override
  void initState() {
    walletCubit.loadWallet();
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
                  Center(child: Text('Rewarder Wallet: ${wallet.address.hex}')),
                  const SizedBox(height: 48),
                  _Balance(brlcProxy: brlcProxy, wallet: wallet),
                  const SizedBox(height: 48),
                  _Send(brlcProxy: brlcProxy, wallet: wallet),
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
  final Credentials wallet;
  final BrlcProxy brlcProxy;
  const _Send({
    Key? key,
    required this.wallet,
    required this.brlcProxy,
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
      credentials: widget.wallet,
      brlcProxy: widget.brlcProxy,
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
            child: TextField(
              controller: addressController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                label: const Text(
                  'To',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 48),
        FloatingActionButton(
          onPressed: () async {
            await transferCubit.transfer(
              address: addressController.text,
              amount: 1.5,
            );
          },
          child: const Icon(CupertinoIcons.checkmark_alt),
        ),
        BlocBuilder<TransferCubit, TransferState>(
          bloc: transferCubit,
          builder: (context, state) {
            return state.maybeWhen(
              success: (tx) => GestureDetector(
                onTap: () => js.context.callMethod(
                  'open',
                  ['https://explorer.mainnet.cloudwalk.io/tx/$tx'],
                ),
                child: Text(
                  "https://explorer.mainnet.cloudwalk.io/tx/$tx",
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
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
  final Credentials wallet;
  final BrlcProxy brlcProxy;
  const _Balance({
    Key? key,
    required this.brlcProxy,
    required this.wallet,
  }) : super(key: key);

  @override
  State<_Balance> createState() => __BalanceState();
}

class __BalanceState extends State<_Balance> {
  late final BalanceCubit balanceCubit;

  @override
  void initState() {
    balanceCubit = BalanceCubit(
      credentials: widget.wallet,
      brlcProxy: widget.brlcProxy,
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
          ),
          error: () => const Text('Error to load the balance'),
          orElse: () => const Text('Loading Balance'),
        );
      },
    );
  }
}
