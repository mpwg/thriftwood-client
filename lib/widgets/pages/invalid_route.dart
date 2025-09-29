import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';

class InvalidRoutePage extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final String? title;
  final String? message;
  final Exception? exception;

  InvalidRoutePage({super.key, this.title, this.message, this.exception});

  @override
  Widget build(BuildContext context) {
    return LunaScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: LunaAppBar(
        title: title ?? 'thriftwood',
        scrollControllers: const [],
      ),
      body: LunaMessage.goBack(
        context: context,
        text: exception?.toString() ?? message ?? '404: Not Found',
      ),
    );
  }
}
