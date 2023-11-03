import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:walletconnect_dart_v2_i/apis/core/relay_client/relay_client.dart';
import 'package:walletconnect_dart_v2_i/walletconnect_dart_v2_i.dart';

import '../shared/shared_test_utils.dart';
import '../shared/shared_test_utils.mocks.dart';

void main() {
  group('Core throws errors', () {
    test('on start if there is no internet connection', () async {
      final MockWebSocketHandler mockWebSocketHandler = MockWebSocketHandler();
      when(mockWebSocketHandler.connect()).thenThrow(const WalletConnectError(
        code: -1,
        message: 'No internet connection: test',
      ));

      ICore core = Core(
        projectId: 'abc',
      );
      core.relayClient = RelayClient(
        core: core,
        messageTracker: getMessageTracker(core: core),
        topicMap: getTopicMap(core: core),
        socketHandler: mockWebSocketHandler,
      );
      int errorCount = 0;
      core.relayClient.onRelayClientError.subscribe((args) {
        errorCount++;
        expect(args!.error.message, 'No internet connection: test');
      });

      await core.start();
      expect(errorCount, 2);
      expect(core.relayUrl, WalletConnectConstants.DEFAULT_RELAY_URL);

      verifyInOrder([
        mockWebSocketHandler.setup(
          url: argThat(
            contains(
              WalletConnectConstants.DEFAULT_RELAY_URL,
            ),
            named: 'url',
          ),
        ),
        mockWebSocketHandler.connect(),
        mockWebSocketHandler.setup(
          url: argThat(
            contains(
              WalletConnectConstants.FALLBACK_RELAY_URL,
            ),
            named: 'url',
          ),
        ),
        mockWebSocketHandler.connect(),
      ]);

      core.relayClient.onRelayClientError.unsubscribeAll();

      const testRelayUrl = 'wss://relay.test.com';
      core = Core(
        projectId: 'abc',
        relayUrl: testRelayUrl,
      );
      core.relayClient = RelayClient(
        core: core,
        messageTracker: getMessageTracker(core: core),
        topicMap: getTopicMap(core: core),
        socketHandler: mockWebSocketHandler,
      );
      errorCount = 0;
      core.relayClient.onRelayClientError.subscribe((args) {
        errorCount++;
        expect(args!.error.message, 'No internet connection: test');
      });

      await core.start();

      // Check that setup was called once for custom URL
      verify(
        mockWebSocketHandler.setup(
          url: argThat(
            contains(testRelayUrl),
            named: 'url',
          ),
        ),
      ).called(1);
      verify(mockWebSocketHandler.connect()).called(1);
      expect(errorCount, 1);
      expect(core.relayUrl, testRelayUrl);
    });
  });
}
