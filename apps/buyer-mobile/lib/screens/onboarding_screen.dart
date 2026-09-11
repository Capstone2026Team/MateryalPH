import 'package:flutter/material.dart';

import '../design_system/theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onComplete});

  final Future<void> Function() onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _pages = [
    (
      image: 'assets/onboarding/source-smart.png',
      title: 'Source Smart, Build Fast',
      body:
          'Discover hardware suppliers near your project site and explore your options for the next build.',
    ),
    (
      image: 'assets/onboarding/find-suppliers.png',
      title: 'Find Suppliers Near Your Site',
      body:
          'Compare eligible stores through map and list views, with clear supplier and distance information.',
    ),
    (
      image: 'assets/onboarding/plan-project.png',
      title: 'Plan Every Phase, Track Every Peso',
      body:
          'Organize project materials, quotations, orders, and budgets in one dependable workflow.',
    ),
  ];

  final PageController _controller = PageController();
  int _index = 0;
  bool _finishing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_index == _pages.length - 1) {
      setState(() => _finishing = true);
      await widget.onComplete();
      return;
    }

    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    await _controller.nextPage(
      duration: reduceMotion
          ? Duration.zero
          : const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 12, top: 4),
                child: TextButton(
                  onPressed: _finishing ? null : widget.onComplete,
                  child: const Text('Skip'),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (value) => setState(() => _index = value),
                itemBuilder: (context, index) {
                  final item = _pages[index];
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          child: Column(
                            children: [
                              SizedBox(
                                height: (constraints.maxHeight * .58).clamp(
                                  100.0,
                                  420.0,
                                ),
                                child: Image.asset(
                                  item.image,
                                  cacheWidth: 960,
                                  fit: BoxFit.contain,
                                  semanticLabel: item.title,
                                  filterQuality: FilterQuality.medium,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                item.title,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      height: 1.15,
                                    ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                item.body,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: BuyerTheme.muted,
                                      height: 1.5,
                                    ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Semantics(
              label: 'Onboarding page ${_index + 1} of ${_pages.length}',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (dot) => AnimatedContainer(
                    duration: MediaQuery.disableAnimationsOf(context)
                        ? Duration.zero
                        : const Duration(milliseconds: 180),
                    width: dot == _index ? 24 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: dot == _index
                          ? BuyerTheme.action
                          : BuyerTheme.border,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
              child: FilledButton(
                onPressed: _finishing ? null : _next,
                child: Text(
                  _finishing
                      ? 'Opening…'
                      : _index == _pages.length - 1
                      ? 'Get Started'
                      : 'Next',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
