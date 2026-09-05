
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'design_system/generated/color_tokens.dart';

void main() {
  runApp(const BuyerApp());
}

class BuyerApp extends StatelessWidget {
  const BuyerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buyer Mobile',
      theme: ThemeData(
        colorSchemeSeed: const Color(MateryalColorTokens.brandOrange500),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://10.0.2.2:8080/api/v1',
      ),
    ),
  );
  List<dynamic> products = [];
  String status = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final healthResponse = await _dio.get('/health');
      final productsResponse = await _dio.get('/products');

      setState(() {
        status = healthResponse.data['status'] ?? 'ok';
        products = productsResponse.data is List ? productsResponse.data : [];
      });
    } catch (error) {
      setState(() => status = 'API unavailable');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buyer Mobile App')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('API status: $status', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    child: ListTile(
                      title: Text(product['name'] ?? 'Unnamed product'),
                      subtitle: Text(product['description'] ?? ''),
                      trailing: Text('Stock: ${product['stock'] ?? 0}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
