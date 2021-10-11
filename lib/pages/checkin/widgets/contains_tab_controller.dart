import 'package:flutter/material.dart';

// ignore: must_be_immutable, camel_case_types
class contains_tab_controller extends StatelessWidget {
  contains_tab_controller({this.result});
  contains_tab_bar result;

  tabMaker() {
    List<Tab> tabs = [];
    ;
    for (var i = 0; i < result.tab.length; i++) {
      tabs.add(Tab(
        icon: result.tab[i].icon,
        text: result.tab[i].text,
      ));
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: result.numtab,
        child: Scaffold(
          body: TabBarView(
              children: List<Widget>.generate(
            result.wid.length,
            (int index) {
              return result.wid[index];
            },
          )),
          backgroundColor: result.bgcolor,
          bottomNavigationBar: TabBar(
            tabs: List<Tab>.generate(result.tab.length, (int index) {
              return result.tab[index];
            }),
          ),
        ));
  }
}

// ignore: camel_case_types
class contains_tab_bar {
  contains_tab_bar({this.wid, this.tab, this.bgcolor, this.numtab});
  List<Widget> wid;
  List<Tab> tab;
  Color bgcolor;
  int numtab;

  factory contains_tab_bar.set(
          List<Widget> wid, List<Tab> tab, Color bgcolor, int numtab) =>
      contains_tab_bar(wid: wid, tab: tab, bgcolor: bgcolor, numtab: numtab);
}
