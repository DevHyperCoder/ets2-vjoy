# ETS2 Virtual Joystick

I play ETS2, (Euro Truck Simulator 2) and I don't have a controller. So I made
a virtual controller setup for my phone using [Flutter](https://flutter.dev/)
and python.

Find the interesting parts:
1. Main entry point of the app: [`lib/main.dart`](./lib/main.dart)
2. Main entry point of the backend: [`backend/main.py`](./backend/main.py)

# WARNING:
This is **NOT** production-ready software. This was built in a day just to
allow me to play the game a bit more comfortably. Feature requests are unlikely
to be merged in.

# How it works ?
The flutter app and the python backend communicate using websockets. I use
[](https://github.com/yannbouteiller/vgamepad/) for the emulation of
the joystick (currently a XBox 360 controller)

Each time a input changes on the app (ex: if you move the joysticks or click a
button), the app sends a message to the backend, which then uses the `vgamepad`
library to emulate the joystick. 

Tested on Android + Linux.

# How to run ?

> NOTE: The frontend app needs a bit of customisation features (such as the
> websocket URL and accent colors). For now you need to manually set the URL of
> the backend in the ./lib/main.dart file
> 
> ```dart
> const websocketUrl = 'ws://HOSTNAME:8000/ets2';
> ```

where host name is the IP address at which you can reach the backend (both
devices need to be on the same network)


```console
flutter run

# backend
cd backend/
pip install -r requirements.txt
uvicorn main:app --reload --host 0.0.0.0
```

Licensed under the MIT License


