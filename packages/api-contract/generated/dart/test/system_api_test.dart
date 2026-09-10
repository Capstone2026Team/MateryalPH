import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for SystemApi
void main() {
  final instance = MateryalphApiClient().getSystemApi();

  group(SystemApi, () {
    //Future<HealthEnvelope> getApiHealth() async
    test('test getApiHealth', () async {
      // TODO
    });

  });
}
