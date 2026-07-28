import 'package:flutter/material.dart';
import '../../models/person.dart';
import '../../theme/typography.dart';

class PetDetailScreen extends StatelessWidget {
  final Person pet;
  const PetDetailScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pet.displayName)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Text('🐾', style: TextStyle(fontSize: 28)),
            title: Text(pet.species ?? 'Pet'),
            subtitle: Text(pet.breed ?? 'Add breed in settings'),
          ),
          const Divider(),
          Text('Vet & care', style: BethTypography.subheading),
          const ListTile(
            title: Text('Vet contact'),
            subtitle: Text('Coming soon'),
          ),
          const ListTile(
            title: Text('Vaccinations'),
            subtitle: Text('Coming soon'),
          ),
        ],
      ),
    );
  }
}
