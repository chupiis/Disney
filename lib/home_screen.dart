import 'package:flutter/material.dart';
import 'character.dart';
import 'disney_service.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DisneyService service = DisneyService();
  late Future<List<DisneyCharacter>> characters;

  @override
  void initState() {
    super.initState();
    characters = service.fetchCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('✨ Disney Characters'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B0F1A), Color(0xFF111B2E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<DisneyCharacter>>(
          future: characters,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!;

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final character = data[index];

                  return TweenAnimationBuilder(
                    duration: Duration(milliseconds: 300 + index * 20),
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (context, double value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Card(
                      elevation: 6,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            character.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey,
                              child: const Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                        title: Text(
                          character.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DetailsScreen(character: character),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error loading characters'));
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}