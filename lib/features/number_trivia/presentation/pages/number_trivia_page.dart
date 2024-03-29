import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_archicture/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:flutter_clean_archicture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_clean_archicture/features/number_trivia/presentation/widgets/widgets.dart';

import '../../../../injection_container.dart';

class NumberTriviaPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Number Trivia"),
      ),
      body: _bodyBuilder(),
    );
  }

  SingleChildScrollView _bodyBuilder() {
    return SingleChildScrollView(
      child: BlocProvider(
        builder: (_) => sl<NumberTriviaBloc>(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 10.0),
                BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                    builder: (context, state) {
                  if (state is Empty) {
                    return MessageDisplay(
                      message: "Start Searching!",
                    );
                  } else if (state is Loading) {
                    return LoadingWeight();
                  } else if (state is Loaded) {
                    return TriviaDisplay(
                      numberTrivia: state.trivia,
                    );
                  } else if (state is Error) {
                    return MessageDisplay(
                      message: state.message,
                    );
                  } else {
                    return null;
                  }
                }),
                SizedBox(height: 20.0),
                TriviaControls()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

