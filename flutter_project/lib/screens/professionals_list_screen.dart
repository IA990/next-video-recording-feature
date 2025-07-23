import 'package:flutter/material.dart';
import '../models/professional.dart';
import '../widgets/professional_card.dart';
import '../services/api_service.dart';

class ProfessionalsListScreen extends StatefulWidget {
  const ProfessionalsListScreen({Key? key}) : super(key: key);

  @override
  State<ProfessionalsListScreen> createState() => _ProfessionalsListScreenState();
}

class _ProfessionalsListScreenState extends State<ProfessionalsListScreen> {
  late Future<List<Professional>> _futureProfessionals;

  @override
  void initState() {
    super.initState();
    _futureProfessionals = ApiService.fetchProfessionals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Professionals'),
      ),
      body: FutureBuilder<List<Professional>>(
        future: _futureProfessionals,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No professionals found.'));
          } else {
            final professionals = snapshot.data!;
            return ListView.builder(
              itemCount: professionals.length,
              itemBuilder: (context, index) {
                return ProfessionalCard(professional: professionals[index]);
              },
            );
          }
        },
      ),
    );
  }
}
