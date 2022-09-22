import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'model/stepper_model.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stepper Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final platform = const MethodChannel('flutter.stepper/stepper');
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getDataFromNative(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Stepper(
                type: StepperType.vertical,
                physics: const ScrollPhysics(),
                currentStep: _currentStep,
                onStepTapped: _onStepTapped,
                onStepContinue: _onStepContinue,
                onStepCancel: _onStepCancel,
                controlsBuilder: (context, details) {
                  return Row(
                    children: [
                      details.stepIndex < 2
                          ? ElevatedButton(
                              onPressed: _onStepContinue,
                              child: const Text('Continue'),
                            )
                          : ElevatedButton(
                              onPressed: _onStepContinue,
                              child: const Text('Finish'),
                            ),
                      const SizedBox(width: 8.0),
                      TextButton(
                        onPressed: _onStepCancel,
                        child: const Text('Back'),
                      ),
                    ],
                  );
                },
                steps: snapshot.data!.mapIndexed((index, e) {
                  return Step(
                    title: Text(e.title),
                    content: Text(e.content),
                    subtitle: index == 2 ? const Text('Last Step') : null,
                    isActive: _currentStep >= 0,
                    state: _currentStep >= index
                        ? StepState.complete
                        : StepState.disabled,
                  );
                }).toList());
          } else {
            return const Center(child: Text('No data found'));
          }
        },
      ),
    );
  }

  void _onStepTapped(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  void _onStepContinue() {
    _currentStep < 2
        ? setState(() {
            _currentStep += 1;
          })
        : null;
  }

  void _onStepCancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  Future<List<StepperModel>> getDataFromNative() async {
    List<StepperModel> steppers = [];
    Map<String, String>? data =
        await platform.invokeMapMethod('getStepperContent');
    data?.forEach(
      (key, value) {
        steppers.add(
          StepperModel(title: key, content: value),
        );
      },
    );

    // return Future.value(steppers);
    return steppers;
  }
}
