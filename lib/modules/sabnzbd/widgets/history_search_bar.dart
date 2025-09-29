import 'package:flutter/material.dart';
import 'package:thriftwood/core.dart';
import 'package:thriftwood/modules/sabnzbd.dart';

class SABnzbdHistorySearchBar extends StatefulWidget {
  final ScrollController scrollController;

  const SABnzbdHistorySearchBar({super.key, required this.scrollController});

  @override
  State<SABnzbdHistorySearchBar> createState() => _State();
}

class _State extends State<SABnzbdHistorySearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = context.read<SABnzbdState>().historySearchFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Consumer<SABnzbdState>(
            builder: (context, state, _) => LunaTextInputBar(
              controller: _controller,
              scrollController: widget.scrollController,
              autofocus: false,
              onChanged: (value) =>
                  context.read<SABnzbdState>().historySearchFilter = value,
              margin: EdgeInsets.zero,
            ),
          ),
        ),
        SABnzbdHistoryHideButton(controller: widget.scrollController),
      ],
    );
  }
}
