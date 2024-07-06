import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../core/service/data_json.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _pageSize = 20;
  late Map<String, int> _words;
  final PagingController<int, String> _pagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _loadWords();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _loadWords() async {
    _words = await loadWordsFromJson();
    setState(() {});
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final keys = _words.keys.toList();
      final start = pageKey;
      final end = pageKey + _pageSize;
      final newItems = keys.sublist(start, end < keys.length ? end : keys.length);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word List'),
      ),
      body: PagedListView<int, String>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<String>(
          itemBuilder: (context, word, index) => ListTile(
            title: Text(word),
            onTap: () {
              // Navegar para a tela de detalhes da palavra
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
