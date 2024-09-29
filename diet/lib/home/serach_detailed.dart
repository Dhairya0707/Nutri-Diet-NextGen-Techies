import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

class IdeaGenerated extends StatefulWidget {
  final String data;
  const IdeaGenerated({super.key, required this.data});

  @override
  State<IdeaGenerated> createState() => _IdeaGeneratedState();
}

class _IdeaGeneratedState extends State<IdeaGenerated> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Result'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(child: MarkdownBlock(data: widget.data)),
      ),
    );
  }
}
