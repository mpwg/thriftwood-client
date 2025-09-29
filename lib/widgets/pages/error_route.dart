import 'package:flutter/material.dart';
import 'package:thriftwood/widgets/ui.dart';

class ErrorRoutePage extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Exception? exception;

  ErrorRoutePage({super.key, this.exception});

  @override
  Widget build(BuildContext context) {
    return LunaScaffold(
      scaffoldKey: _scaffoldKey,
      appBar: LunaAppBar(title: 'thriftwood', scrollControllers: const []),
      body: LunaMessage.goBack(
        context: context,
        text: exception?.toString() ?? '404: Not Found',
      ),
    );
  }
}
