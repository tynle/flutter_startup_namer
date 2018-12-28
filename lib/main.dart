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
          child: RandomWords(),
        ),
      ),*/
      home: RandomWords(),
    );
  }
}

class RandomWordsState extends State<RandomWords> {
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _saved = new Set<WordPair>();
  final TextStyle _biggerFont = TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    //final wordPair = WordPair.random();
    //return Text(wordPair.asPascalCase);
    return Scaffold(
      appBar: AppBar(
        title: Text('Starup Name Generator'),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestion(),
    );
  }

  Widget _buildSuggestion() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if(i.isOdd) return Divider();
          final index = i ~/ 2;
          if(index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair)
  {
    final bool alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if(alreadySaved) _saved.remove(pair);
          else _saved.add(pair);
        });
      },
    );
  }

  /*void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
          builder: (BuildContext context) {
            final Iterable<ListTile> tiles = _saved.map(
                (WordPair pair) {
                  return new ListTile(
                    title: new Text(
                      pair.asPascalCase,
                      style: _biggerFont,
                    ),
                    trailing: new Icon(Icons.delete, color: Colors.blueGrey),
                    onTap: () {
                        _saved.remove(pair);
                        Navigator.of(context).pop();
                        _pushSaved();                    
                    } 
                  );
                },
            );
            final List<Widget> divided = ListTile.divideTiles(
                context: context,
                tiles: tiles,
            ).toList();

            return new Scaffold(
              appBar: new AppBar(
                title: const Text('Favorite suggestions'),
              ),
              body: new ListView(children: divided),
            );
          })
    );
  }*/
  void _pushSaved()  {
    Navigator.of(context).push(
      new MaterialPageRoute(builder: (BuildContext context){
        final Widget favor = _buildFavorPage(_saved);
        return new Scaffold(
          appBar: new AppBar(
            title: const Text('Saved suggestions'),
          ),
          body: favor,
        );
      })
    );
  }

  Widget _buildFavorPage(Set<WordPair> list) {
    return ListView.builder(itemBuilder: (context, i) {
          if(i.isOdd) return Divider();
          final index = i ~/ 2;
          if(index >= list.length) return Divider();
          return _buildFavorRow(list.elementAt(index));
        });
  }

  Widget _buildFavorRow(WordPair pair)
  {
    return ListTile(
      title: Text(pair.asPascalCase, style: _biggerFont),
      trailing: new Icon(Icons.delete, color: Colors.red),
      onTap: (){
        _saved.remove(pair);
        //_buildFavorPage(_saved);
        Navigator.of(context).pop();
        _pushSaved();
      },
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

