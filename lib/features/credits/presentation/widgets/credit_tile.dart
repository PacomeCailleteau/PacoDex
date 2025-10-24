import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String url;

  const CreditTile({super.key, required this.title, required this.subtitle, required this.url});

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.open_in_new),
      onTap: () => _launchURL(url),
    );
  }
}
