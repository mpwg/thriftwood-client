import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/nzbget.dart';

class NZBGetHistorySearchBar extends StatefulWidget {
  final ScrollController scrollController;

  const NZBGetHistorySearchBar({super.key, required this.scrollController});

  @override
  State<NZBGetHistorySearchBar> createState() => _State();
}

class _State extends State<NZBGetHistorySearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = context.read<NZBGetState>().historySearchFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Consumer<NZBGetState>(
            builder: (context, state, _) => LunaTextInputBar(
              controller: _controller,
              scrollController: widget.scrollController,
              autofocus: false,
              onChanged: (value) =>
                  context.read<NZBGetState>().historySearchFilter = value,
              margin: EdgeInsets.zero,
            ),
          ),
        ),
        NZBGetHistoryHideButton(controller: widget.scrollController),
      ],
    );
  }
}
