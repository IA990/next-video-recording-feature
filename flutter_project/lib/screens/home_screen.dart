import 'package:flutter/material.dart';
import 'video_recording_screen.dart';
import '../localization/app_localizations.dart';
import '../widgets/placeholder_widget.dart';
import 'professionals_list_screen.dart';
import 'map_screen.dart';
import 'add_professional_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.appTitle),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Text(loc.appTitle, style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text(loc.home),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: const Text('Professionals'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfessionalsListScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: const Text('Map'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: const Text('Add Professional'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddProfessionalScreen()),
                );
              },
            ),
            // Professional Dashboard menu item requires professional object, add when available
            // ListTile(
            //   leading: Icon(Icons.dashboard),
            //   title: const Text('Professional Dashboard'),
            //   onTap: () {
            //     Navigator.pop(context);
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => ProfessionalDashboardScreen(professional: /* pass professional object here */)),
            //     );
            //   },
            // ),
            // Add more menu items here
            ListTile(
              leading: Icon(Icons.videocam),
              title: const Text('Record a Video'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VideoRecordingScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: PlaceholderWidget(
            message: loc.welcomeMessage,
            icon: Icons.storefront_outlined,
          ),
        ),
      ),
    );
  }
}
