// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../../modules/favoritos/favoritos_page.dart';
import '../../modules/historico/historico_page.dart';
import '../../modules/home/home_page.dart';
import '../../widgets/theme_config.dart';

// ignore: must_be_immutable
class GerenciaPages extends StatefulWidget {
  const GerenciaPages({super.key});

  @override
  _GerenciaPagesState createState() => _GerenciaPagesState();
}

class _GerenciaPagesState extends State<GerenciaPages>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeConfig.primaryColor,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10.0),
          child: TabBar(
            labelPadding: EdgeInsets.zero,
            dividerColor: ThemeConfig.secondaryColor,
            indicator: UnderlineTabIndicator(
              borderSide:
                  const BorderSide(width: 3, color: ThemeConfig.primaryColor),
              borderRadius: BorderRadius.circular(5),
            ),
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 5,
            controller: _tabController,
            tabs: const [
              CustomTab(text: 'Home'),
              CustomTab(text: 'Historico'),
              CustomTab(text: 'Favoritos'),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            const Divider(
              height: 1.5,
              color: ThemeConfig.buttonColor,
            ),
            Expanded(
              child: Container(
                color: ThemeConfig.backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      KeepAliveWrapper(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: HomePage(),
                        ),
                      ),
                      KeepAliveWrapper(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: HistoricoPage(),
                        ),
                      ),
                      KeepAliveWrapper(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: FavoritosPage(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTab extends StatelessWidget {
  final String text;

  const CustomTab({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }
}

class KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const KeepAliveWrapper({super.key, required this.child});

  @override
  __KeepAliveWrapperState createState() => __KeepAliveWrapperState();
}

class __KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
