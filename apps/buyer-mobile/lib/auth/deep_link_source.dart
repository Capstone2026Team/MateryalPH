import 'package:app_links/app_links.dart';

abstract interface class DeepLinkSource {
  Future<Uri?> getInitialLink();

  Stream<Uri> get links;
}

final class AppLinksDeepLinkSource implements DeepLinkSource {
  AppLinksDeepLinkSource({AppLinks? appLinks})
    : _appLinks = appLinks ?? AppLinks();

  final AppLinks _appLinks;

  @override
  Future<Uri?> getInitialLink() => _appLinks.getInitialLink();

  @override
  Stream<Uri> get links => _appLinks.uriLinkStream;
}
