import 'package:logger/logger.dart';
import 'package:walletconnect_dart_v2_i/walletconnect_dart_v2_i.dart';

import '../shared/shared_test_utils.dart';
import '../shared/shared_test_values.dart';
import 'tests/sign_common.dart';
import 'utils/sign_client_test_wrapper.dart';

void main() {
  signEngineTests(
    context: 'SignClient',
    clientACreator: (PairingMetadata metadata) async =>
        await SignClientTestWrapper.createInstance(
      projectId: TEST_PROJECT_ID,
      relayUrl: TEST_RELAY_URL,
      metadata: metadata,
      logLevel: Level.info,
      httpClient: getHttpWrapper(),
    ),
    clientBCreator: (PairingMetadata metadata) async =>
        await SignClientTestWrapper.createInstance(
      projectId: TEST_PROJECT_ID,
      relayUrl: TEST_RELAY_URL,
      metadata: metadata,
      logLevel: Level.info,
      httpClient: getHttpWrapper(),
    ),
  );
}
