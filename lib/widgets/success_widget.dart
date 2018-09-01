import 'package:flutter/material.dart';
import 'package:wikigame/api/wiki_article.dart';

class SuccessWidget extends StatelessWidget {
  final List<WikiArticle> clickedLinks;

  const SuccessWidget({this.clickedLinks});

  @override
  Widget build(BuildContext context) {
    var text = Text("Glückwunsch, du hast das Ziel in ${clickedLinks.length-1} Zügen erreicht!");
    var list = ListView.builder(
      itemCount: clickedLinks.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: text,
          );
        }

        return Text(clickedLinks[index].title, style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold));
      }
    );

    return list;
  }
}