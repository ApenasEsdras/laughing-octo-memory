import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../core/service/data_json.dart';
import 'detalhes_das_frases.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _pageSize = 20;
  late Map<String, int> _words;
  late List<String> _filteredWords;
  final PagingController<int, String> _pagingController =
      PagingController(firstPageKey: 0);

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadWords();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String searchText = _searchController.text.toLowerCase();
    setState(() {
      _filteredWords = _words.keys.where((word) => word.toLowerCase().contains(searchText)).toList();
    });
    _pagingController.itemList = [];
    _pagingController.refresh();
  }

  Future<void> _loadWords() async {
    _words = await loadWordsFromJson();
    _filteredWords = _words.keys.toList();
    setState(() {});
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final start = pageKey * _pageSize;
      final end = (pageKey + 1) * _pageSize;
      final newItems = _filteredWords.sublist(start, end < _filteredWords.length ? end : _filteredWords.length);

      if (newItems.isNotEmpty) {
        final isLastPage = newItems.length < _pageSize;
        if (isLastPage) {
          _pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          _pagingController.appendPage(newItems, nextPageKey);
        }
      } else {
        _pagingController.appendLastPage([]);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Digite para filtrar as palavras...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              ),
              onChanged: (value) {
                _onSearchChanged();
              },
            ),
          ),
          Expanded(
            child: PagedListView<int, String>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<String>(
                itemBuilder: (context, word, index) => ListTile(
                  title: Text(word),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WordDetailScreen(word: word),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
