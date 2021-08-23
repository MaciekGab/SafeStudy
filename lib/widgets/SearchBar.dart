import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key key, @required this.onChanged, @required this.hintText}) : super(key: key);
  // final String text;
  final ValueChanged<String> onChanged;
  final String hintText;
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left:10.0,bottom: 5),
            alignment: Alignment.centerLeft,
            child: Text('Search:'),
          ),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: widget.hintText,
            ),
            onChanged: widget.onChanged,
          ),
        ],
      ),
    );
  }
}