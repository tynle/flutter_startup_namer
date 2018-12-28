import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /*title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Center(
          child: Text('hello world'),
        ),
      ),*/
      home: SuggestionPage(),
    );
  }
}


class SuggestionPage extends StatefulWidget {
  @override
  SuggestionState createState() => SuggestionState();
}

class FavoritePage extends StatefulWidget {
  
  const FavoritePage(this._favorList);

  final Set<WordPair> _favorList;
  
  @override
  FavoriteState createState() => FavoriteState(_favorList);
}

class SuggestionState extends State<SuggestionPage> {
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _favorNames = new Set<WordPair>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suggestion Names'),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.list), onPressed: _gotoFavorPage,)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      itemBuilder: (context, i) {
        if(i.isOdd) return Divider();
        int index = i ~/ 2;
        if(index >= _suggestions.length)
        {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildSuggestionRow(_suggestions[index]);
      },
    );
  }

  Widget _buildSuggestionRow(WordPair pair)
  {
    final bool favor = _favorNames.contains(pair);
    return ListTile(
      title: new Text(pair.asPascalCase),
      trailing: new Icon(Icons.favorite, color: favor ? Colors.red : null,),
      onTap: () {
        setState(() {
                  if (favor) _favorNames.remove(pair);
                  else _favorNames.add(pair);
                });
      },
    );
  }

  void _gotoFavorPage()
  {
    if(_favorNames.isNotEmpty)
      Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritePage(_favorNames)));
  }
}

class FavoriteState extends State<FavoritePage> {

  FavoriteState(this._favorList);
  final Set<WordPair> _favorList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Names'),
      ),
      body: _buildFavorPage(),
    );
  }

  Widget _buildFavorPage() {
    return ListView.builder(
      itemBuilder: (context, i) {
        if(i.isOdd) return Divider();
        int index = i ~/ 2;        
        return _buildFavorRow(_favorList.elementAt(index));
      },
      itemCount: _favorList.length * 2,
    );
  }

  Widget _buildFavorRow(WordPair pair)
  {
    return ListTile(
      title: new Text(pair.asPascalCase),
      trailing: new Icon(Icons.delete, color: Colors.blueGrey),
      onTap: () {
        setState(() {
                  _favorList.remove(pair);
                  if(_favorList.isEmpty) Navigator.pop(context);                 
                });
      },
    );
  }

  
}

