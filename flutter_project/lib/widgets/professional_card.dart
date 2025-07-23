import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/professional.dart';
import '../screens/professional_detail_screen.dart';

class ProfessionalCard extends StatelessWidget {
  final Professional professional;

  const ProfessionalCard({Key? key, required this.professional}) : super(key: key);

  void _callPhoneNumber(String phone) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      // Could show a snackbar or alert here
      debugPrint('Could not launch $phone');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(professional.photoUrl),
          radius: 30,
        ),
        title: Text(professional.name),
        subtitle: Text(professional.type),
        trailing: IconButton(
          icon: const Icon(Icons.call),
          onPressed: () => _callPhoneNumber(professional.phone),
          tooltip: 'Call',
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfessionalDetailScreen(professional: professional),
            ),
          );
        },
      ),
    );
  }
}
