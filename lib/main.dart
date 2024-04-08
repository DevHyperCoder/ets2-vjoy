import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const websocketUrl = 'ws://192.168.18.33:8000/ets2';

void main() {
  runApp(const ETS2VirtualJoyApp());
}

class ETS2VirtualJoyApp extends StatelessWidget {
  const ETS2VirtualJoyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ETS2 Virtual Joystick',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const VirtualJoyPage(),
    );
  }
}

class VirtualJoyPage extends StatefulWidget {
  const VirtualJoyPage({super.key});

  @override
  State<VirtualJoyPage> createState() => _VirtualJoyPageState();
}

class _VirtualJoyPageState extends State<VirtualJoyPage> {
  final channel = WebSocketChannel.connect(
    Uri.parse(websocketUrl),
  );

  @override
  void initState() {
    super.initState();

    // Send ping every 1s. Without this, the websocket connection seems to drop constantly
    final _ = Timer.periodic(const Duration(seconds: 1), (_) {
      channel.sink.add(jsonEncode({"id": "ping"}));
    });
    channel.stream.listen((_) {});

    // Prefer landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    // Hide virtual nav and notification bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    ElevatedButton(
                        child: const Text("M/A"),
                        onPressed: () {
                          channel.sink.add(jsonEncode({"id": "m/a"}));
                        }),
                    Row(
                      children: [
                        ElevatedButton(
                          child: const Text("-"),
                          onPressed: () {
                            channel.sink.add(jsonEncode({"id": "gear-"}));
                          },
                        ),
                        ElevatedButton(
                          child: const Text("N"),
                          onPressed: () {
                            channel.sink.add(jsonEncode({"id": "gearN"}));
                          },
                        ),
                        ElevatedButton(
                          child: const Text("+"),
                          onPressed: () {
                            channel.sink.add(jsonEncode({"id": "gear+"}));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Joystick(
                  mode: JoystickMode.vertical,
                  listener: (details) {
                    channel.sink
                        .add(jsonEncode({"id": "gb", "val": details.y}));
                  },
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    child: const Text("Parking Brake"),
                    onPressed: () {
                      channel.sink.add(jsonEncode({"id": "parking-brake"}));
                    }),
                Row(
                  children: [
                    ElevatedButton(
                        child: const Text("Left"),
                        onPressed: () {
                          channel.sink.add(jsonEncode({"id": "left-turn"}));
                        }),
                    ElevatedButton(
                        child: const Text("Right"),
                        onPressed: () {
                          channel.sink.add(jsonEncode({"id": "right-turn"}));
                        }),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton(
                        child: const Text("Cr - "),
                        onPressed: () {
                          channel.sink.add(jsonEncode({"id": "cruise-decr"}));
                        }),
                    ElevatedButton(
                        child: const Text("Cr+"),
                        onPressed: () {
                          channel.sink.add(jsonEncode({"id": "cruise-incr"}));
                        }),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton(
                        child: const Text("Cr"),
                        onPressed: () {
                          channel.sink.add(jsonEncode({"id": "cruise"}));
                        }),
                    ElevatedButton(
                        child: const Text("Cr r"),
                        onPressed: () {
                          channel.sink
                              .add(jsonEncode({"id": "cruise-continue"}));
                        }),
                  ],
                ),
              ],
            ),
            Joystick(
              mode: JoystickMode.horizontal,
              listener: (details) {
                channel.sink.add(jsonEncode({"id": "steer", "val": details.x}));
              },
            ),
          ],
        ),
      ),
    );
  }
}
