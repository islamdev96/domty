// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  final String websiteUrl = 'https://islam.islamglab.com/';
  final String phoneNumber = '201030406057';
  final String email = 'islamsayedglab@gmail.com';

  const AboutUsPage({super.key});

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchWhatsApp(String phone) async {
    String url = 'https://wa.me/$phone';
    _launchURL(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('من نحن'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            const Text(
              'مرحبًا بكم في تطبيقنا!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'نحن ملتزمون بتقديم أفضل الخدمات لعملائنا. لمزيد من المعلومات، يرجى زيارة موقعنا الشخصي.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _launchURL(websiteUrl),
              child: const Text('زيارة الموقع الشخصي'),
            ),
            const SizedBox(height: 20),
            const Text(
              'للتواصل معنا، يرجى الاتصال بنا على الرقم التالي:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            SelectableText(
              phoneNumber,
              style: const TextStyle(fontSize: 18, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _launchWhatsApp(phoneNumber),
              child: const Text('الاتصال بنا عبر واتساب'),
            ),
            const SizedBox(height: 20),
            const Text(
              'أو يمكنك إرسال بريد إلكتروني لنا على:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            SelectableText(
              email,
              style: const TextStyle(fontSize: 18, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            const Text(
              'إليك صورة من داخل التطبيق:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Center(
              child: Image.asset('assets/images/1.png'),
            ),
          ],
        ),
      ),
    );
  }
}
