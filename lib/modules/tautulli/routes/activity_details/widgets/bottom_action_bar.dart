import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/tautulli.dart';

class TautulliActivityDetailsBottomActionBar extends StatelessWidget {
  final int sessionKey;

  const TautulliActivityDetailsBottomActionBar({
    Key? key,
    required this.sessionKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.select((TautulliState state) => state.activity),
      builder: (context, AsyncSnapshot<TautulliActivity?> snapshot) {
        if (snapshot.hasError) return Container(height: 0.0);
        if (snapshot.hasData) {
          TautulliSession? session = snapshot.data!.sessions!.firstWhereOrNull(
            (element) => element.sessionKey == sessionKey,
          );
          if (session != null)
            return LunaBottomActionBar(
              actions: [
                LunaButton.text(
                  text: 'tautulli.TerminateSession'.tr(),
                  icon: Icons.close_rounded,
                  color: LunaColours.red,
                  onTap: () async {
                    (bool, String) _result = await TautulliDialogs()
                        .terminateSession(context);
                    if (_result.$1)
                      TautulliAPIHelper()
                          .terminateSession(
                            context: context,
                            session: session,
                            terminationMessage: _result.$2,
                          )
                          .then((value) {
                            if (value) Navigator.of(context).pop();
                          });
                  },
                ),
              ],
            );
        }
        return Container(height: 0.0);
      },
    );
  }
}
