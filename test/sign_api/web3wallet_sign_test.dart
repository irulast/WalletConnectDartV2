import 'package:logger/logger.dart';
import 'package:walletconnect_dart_v2_i/walletconnect_dart_v2_i.dart';

import '../shared/shared_test_utils.dart';
import '../shared/shared_test_values.dart';
import 'tests/sign_common.dart';

void main() {
  signEngineTests(
    context: 'Web3App/Wallet',
    clientACreator: (PairingMetadata metadata) async =>
        await Web3App.createInstance(
      projectId: TEST_PROJECT_ID,
      relayUrl: TEST_RELAY_URL,
      metadata: metadata,
      logLevel: LogLevel.info,
      httpClient: getHttpWrapper(),
    ),
    clientBCreator: (PairingMetadata metadata) async =>
        await Web3Wallet.createInstance(
      projectId: TEST_PROJECT_ID,
      relayUrl: TEST_RELAY_URL,
      metadata: metadata,
      logLevel: LogLevel.info,
      httpClient: getHttpWrapper(),
    ),
  );
}
