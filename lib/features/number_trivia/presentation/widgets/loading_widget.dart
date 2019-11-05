import 'package:flutter/material.dart';

class LoadingWeight extends StatelessWidget {
  const LoadingWeight({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
