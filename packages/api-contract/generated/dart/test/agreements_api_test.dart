import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for AgreementsApi
void main() {
  final instance = MateryalphApiClient().getAgreementsApi();

  group(AgreementsApi, () {
    //Future<AgreementListEnvelope> listCurrentAgreements() async
    test('test listCurrentAgreements', () async {
      // TODO
    });

  });
}
