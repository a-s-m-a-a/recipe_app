import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class ReusedListTile extends StatefulWidget {
  final Widget page;
  final Text text;
  final Icon icon;
  final ZoomDrawerController controller;

  const ReusedListTile(
      {required this.text,
      required this.icon,
      required this.page,
      required this.controller,
      super.key});

  @override
  State<ReusedListTile> createState() => _ReusedListTileState();
}

class _ReusedListTileState extends State<ReusedListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        widget.controller.close?.call();
        Navigator.push(context, MaterialPageRoute(builder: (_) => widget.page));
      },
      leading: widget.icon,
      title: widget.text,
    );
  }
}
