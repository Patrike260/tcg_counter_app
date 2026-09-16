import 'package:url_launcher/url_launcher.dart';

String? normalizeDeckListUrl(String? raw) {
  var value = raw?.trim() ?? '';
  if (value.isEmpty) return null;
  if (value.startsWith('http://') || value.startsWith('https://')) {
    return value;
  }
  return 'https://$value';
}

Uri? parseDeckListUri(String? raw) {
  final normalized = normalizeDeckListUrl(raw);
  if (normalized == null) return null;
  final uri = Uri.tryParse(normalized);
  if (uri == null || uri.host.isEmpty) return null;
  if (uri.scheme != 'http' && uri.scheme != 'https') return null;
  return uri;
}

Future<bool> openDeckListUrl(String? raw) async {
  final uri = parseDeckListUri(raw);
  if (uri == null) return false;
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}
