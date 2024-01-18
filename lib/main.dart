import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Add authentication logic here
                    // For simplicity, we print the email and password
                    print('Email: ${_emailController.text}');
                    print('Password: ${_passwordController.text}');
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CountdownTimerPage()));
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  List<String> userList = ["User Name", "Arrival time", "Current time"];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('main page'),
          backgroundColor: Color.fromARGB(255, 60, 144, 190),
          leading: IconButton(
              onPressed: () => {Navigator.pop(context)},
              icon: Icon(Icons.arrow_back_ios_new)),
        ),
        body: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    ListTile(title: Text(userList[index] + ":")),
                // Builds 1000 ListTiles
                childCount: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CountdownTimerPage extends StatefulWidget {
  @override
  _CountdownTimerPageState createState() => _CountdownTimerPageState();
}

class _CountdownTimerPageState extends State<CountdownTimerPage> {
  Timer? _timer;
  int _remainingSeconds;
  int _remainingMinutes;
  Timer? _callTimer;

  _CountdownTimerPageState({int startSeconds = 3})
      : _remainingSeconds = startSeconds,
        _remainingMinutes = 00;

  void _startCountdown() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (Timer timer) {
      if (_remainingSeconds <= 0) {
        setState(() {
          if (_remainingMinutes <= 0) {
            _showDialogExample(context, timer);
            _startCallTimer();
            //timer.cancel();
          } else {
            _remainingMinutes--;
            _remainingSeconds = 59;
          }
        });
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  void _addTime() {
    setState(() {
      // Add desired amount of time when OK is pressed (e.g., 5 seconds)
      _remainingSeconds += 5;
    });
  }

  void _startCallTimer() {
    const fiveMinute = Duration(seconds: 5); //改五分鐘
    _callTimer = Timer.periodic(fiveMinute, (Timer callTimer) {});
  }

  //通知？？
  void _showDialogExample(BuildContext context, Timer timer) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('time up'),
        content: const Text('Do you want to add time?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => {
              _addTime(),
              Navigator.pop(context, 'YES'),
            },
            child: const Text('YES'),
          ),
          TextButton(
            onPressed: () => {
              timer.cancel(),
              Navigator.pop(context, 'Cancel'),
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simple Countdown Timer')),
      body: Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(
            Icons.timer,
            size: 50,
            color: Colors.blue,
          ),
          Text(
            '$_remainingMinutes' + ':' + '$_remainingSeconds',
            style: TextStyle(fontSize: 48),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startCountdown,
        tooltip: 'Start Countdown',
        child: Icon(Icons.timer),
      ),
    );
  }
}
