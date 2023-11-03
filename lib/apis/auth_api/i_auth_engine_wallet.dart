import 'package:event/event.dart';
import 'package:walletconnect_dart_v2_i/apis/auth_api/i_auth_engine_common.dart';
import 'package:walletconnect_dart_v2_i/apis/auth_api/models/auth_client_events.dart';
import 'package:walletconnect_dart_v2_i/apis/auth_api/models/auth_client_models.dart';
import 'package:walletconnect_dart_v2_i/apis/core/store/i_generic_store.dart';
import 'package:walletconnect_dart_v2_i/apis/models/basic_models.dart';

abstract class IAuthEngineWallet extends IAuthEngineCommon {
  abstract final Event<AuthRequest> onAuthRequest;

  abstract final IGenericStore<PendingAuthRequest> authRequests;

  /// respond wallet authentication
  Future<void> respondAuthRequest({
    required int id,
    required String iss,
    CacaoSignature? signature,
    WalletConnectError? error,
  });

  // query all pending requests
  Map<int, PendingAuthRequest> getPendingAuthRequests();
}
