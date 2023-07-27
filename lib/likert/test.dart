import 'package:flutter/material.dart';

class LikertResponse extends StatelessWidget {
  const LikertResponse(
      {super.key,
      required this.groupValue,
      required this.value,
      required this.onPressed});
  final int? groupValue;
  final int value;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: (groupValue == value)
          ? const ButtonStyle(
              shape: MaterialStatePropertyAll(CircleBorder()),
              minimumSize: MaterialStatePropertyAll(Size.fromRadius(25)))
          : const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.white),
              shape: MaterialStatePropertyAll(
                  CircleBorder(side: BorderSide(color: Colors.black26))),
              minimumSize: MaterialStatePropertyAll(Size.fromRadius(25))),
      child: Text(
        value.toString(),
        style: (groupValue == value)
            ? const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)
            : const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 18),
      ),
    );
  }
}

class LikertResponseSet extends StatelessWidget {
  const LikertResponseSet(
      {super.key, required this.value, required this.onChange});
  final int? value;
  final ValueChanged<int> onChange;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      ...List.generate(5, (index) => index + 1)
          .map((index) => [
                LikertResponse(
                  groupValue: value,
                  value: index,
                  onPressed: () {
                    onChange(index);
                  },
                ),
                const SizedBox(
                  width: 15.0,
                )
              ])
          .expand(
            (element) => element,
          ),
    ]);
  }
}

class LikertTestScreen extends StatefulWidget {
  const LikertTestScreen(
      {super.key, required this.questions, required this.onSubmit});

  final List<String> questions;
  final Function(List<int>) onSubmit;

  @override
  State<LikertTestScreen> createState() => _LikertTestScreenState();
}

class _LikertTestScreenState extends State<LikertTestScreen> {
  int questionIndex = 0;
  int? currentResponse;

  List<int> responses = List.empty();

  double getProgress() {
    return questionIndex / widget.questions.length;
  }

  void handleChangeResponse(int value) {
    setState(() {
      currentResponse = value;
    });
  }

  void handleSubmit() {
    widget.onSubmit([...responses, currentResponse!]);
  }

  void handleSaveAndNext() {
    setState(() {
      responses = [...responses, currentResponse!];
      currentResponse = null;

      questionIndex += 1;
    });
  }

  void handleClickNext() {
    if (questionIndex + 1 == widget.questions.length) {
      handleSubmit();
    } else {
      handleSaveAndNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsetsDirectional.all(40),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: getProgress(),
                    minHeight: 20.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.questions[questionIndex],
                          style: const TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 30),
                      LikertResponseSet(
                          value: currentResponse,
                          onChange: handleChangeResponse)
                    ],
                  ),
                  ElevatedButton(
                    onPressed: currentResponse != null ? handleClickNext : null,
                    child: const Text("Next"),
                  )
                ])));
  }
}
