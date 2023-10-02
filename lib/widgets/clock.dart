import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class MyClock extends StatelessWidget {
  const MyClock({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        return Text(
          DateFormat('dd MMMM yyyy, HH:mm:ss').format(
            DateTime.now(),
          ),
        );
      },
    );
  }
}
