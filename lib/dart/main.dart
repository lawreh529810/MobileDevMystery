import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CardOrganizerApp());
}

class CardOrganizerApp extends StatelessWidget {
  const CardOrganizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Organizer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FolderListScreen(),
    );
  }
}

// Folder Model
class Folder {
  final int id;
  final String folderName;
  final int timestamp;

  Folder({
    required this.id,
    required this.folderName,
    required this.timestamp,
  });

  // Convert a Folder into a Map for SQLite storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'folderName': folderName,
      'timestamp': timestamp,
    };
  }
}

// PlayingCard Model
class PlayingCard {
  final int id;
  final String name;
  final String suit;
  final String imageURL;
  final int folderID;

  PlayingCard({
    required this.id,
    required this.name,
    required this.suit,
    required this.imageURL,
    required this.folderID,
  });

  // Convert a PlayingCard into a Map for SQLite storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'suit': suit,
      'imageURL': imageURL,
      'folderID': folderID,
    };
  }
}

// Folder List Screen
class FolderListScreen extends StatefulWidget {
  @override
  _FolderListScreenState createState() => _FolderListScreenState();
}

class _FolderListScreenState extends State<FolderListScreen> {
  List<Folder> folders = [];

  @override
  void initState() {
    super.initState();
    _loadFolders();
  }

  Future<void> _loadFolders() async {
    final Database db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query('folders');
    setState(() {
      folders = List.generate(maps.length, (i) {
        return Folder(
          id: maps[i]['id'],
          folderName: maps[i]['folderName'],
          timestamp: maps[i]['timestamp'],
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Organizer'),
      ),
      body: ListView.builder(
        itemCount: folders.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(folders[index].folderName),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CardListScreen(folder: folders[index]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          // Add a new folder
          await DatabaseHelper.instance.insert('folders', {
            'folderName': 'New Folder',
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          });
          _loadFolders(); // Reload the list after adding
        },
      ),
    );
  }
}

// Card List Screen
class CardListScreen extends StatefulWidget {
  final Folder folder;

  const CardListScreen({super.key, required this.folder});

  @override
  // ignore: library_private_types_in_public_api
  _CardListScreenState createState() => _CardListScreenState();
}

class _CardListScreenState extends State<CardListScreen> {
  List<PlayingCard> cards = [];

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final Database db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'cards',
      where: 'folderID = ?',
      whereArgs: [widget.folder.id],
    );
    setState(() {
      cards = List.generate(maps.length, (i) {
        return PlayingCard(
          id: maps[i]['id'],
          name: maps[i]['name'],
          suit: maps[i]['suit'],
          imageURL: maps[i]['imageURL'],
          folderID: maps[i]['folderID'],
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folder.folderName),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
        ),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                Image.network(cards[index].imageURL),
                Text(cards[index].name),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    // Delete card
                    await DatabaseHelper.instance.delete(cards[index].id);
                    _loadCards(); // Reload the cards after deletion
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          // Add a new card
          await DatabaseHelper.instance.insert('cards', {
            'name': 'Ace of Spades',
            'suit': 'Spades',
            'imageURL': 'https://example.com/image.jpg',
            'folderID': widget.folder.id,
          });
          _loadCards(); // Reload the list after adding
        },
      ),
    );
  }
}

