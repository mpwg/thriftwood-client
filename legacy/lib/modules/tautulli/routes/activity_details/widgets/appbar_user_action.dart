import 'package:thriftwood/utils/collection_utils.dart';
import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/tautulli.dart';
import 'package:thriftwood/router/routes/tautulli.dart';

class TautulliActivityDetailsUserAction extends StatelessWidget {
  final int sessionKey;

  const TautulliActivityDetailsUserAction({Key? key, required this.sessionKey})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.select<TautulliState, Future<TautulliActivity?>>(
        (state) => state.activity!,
      ),
      builder: (context, AsyncSnapshot<TautulliActivity?> snapshot) {
        if (snapshot.hasError) return Container();
        if (snapshot.hasData) {
          TautulliSession? session = snapshot.data!.sessions!.firstWhereOrNull(
            (element) => element.sessionKey == sessionKey,
          );
          if (session != null)
            return LunaIconButton(
              icon: Icons.person_rounded,
              onPressed: () async => _onPressed(context, session.userId!),
            );
        }
        return Container();
      },
    );
  }

  void _onPressed(BuildContext context, int userId) {
    TautulliRoutes.USER_DETAILS.go(params: {'user': userId.toString()});
  }
}
