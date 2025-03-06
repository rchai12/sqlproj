import 'package:flutter/material.dart';
import 'DatabaseHelper.dart';


final _databaseHelper = DatabaseHelper();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _databaseHelper.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Folders',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FoldersScreen(),
    );
  }
}

class FoldersScreen extends StatefulWidget {
  @override
  _FoldersScreenState createState() => _FoldersScreenState();
}

class _FoldersScreenState extends State<FoldersScreen> {
  List<Map<String, dynamic>> _folders = [];

  @override
  void initState() {
    super.initState();
    _loadFolders();
  }

  // Load the folders from the database
  Future<void> _loadFolders() async {
    List<Map<String, dynamic>> folders = await _databaseHelper.queryAllRows();
    setState(() {
      _folders = folders;
    });
    // Debug: Print the folders to verify
    print("Folders Loaded: $_folders");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Folders')),
      body: _folders.isEmpty
          ? Center(child: Text('No folders available'))
          : ListView.builder(
              itemCount: _folders.length,
              itemBuilder: (context, index) {
                var folder = _folders[index];
                return ListTile(
                  title: Text(folder['name']),
                  leading: Image.network(folder['folderImageUrl']),
                  onTap: () {
                    // Navigate to the CardsScreen with the folder data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CardsScreen(folderId: folder['id']),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class CardsScreen extends StatelessWidget {
  final int folderId;
  CardsScreen({required this.folderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cards in Folder')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _databaseHelper.query(folderId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No cards available.'));
          } else {
            var cards = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                var card = cards[index];
                return Card(
                  child: Column(
                    children: [
                      Image.network(card['imageUrl']),
                      Text(card['name']),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}