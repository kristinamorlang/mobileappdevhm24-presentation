import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Shader Example')),
        body: const ShaderExample(),
      ),
    );
  }
}

class ShaderExample extends StatefulWidget {
  const ShaderExample({super.key});

  @override
  _ShaderExampleState createState() => _ShaderExampleState();
}

class _ShaderExampleState extends State<ShaderExample> with SingleTickerProviderStateMixin {
  late FragmentProgram _program;   //shader programm
  late Ticker _ticker;             //animation and time control
  double _time = 0.0;              //current time for animation
  bool _isShaderLoaded = false;    //charging status

  @override
  void initState() {
    super.initState();
    _loadShader();
    _ticker = Ticker((elapsed) {
      setState(() {
        _time = elapsed.inMilliseconds / 1000.0; //seconds
      });
    });
    _ticker.start();
  }

  Future<void> _loadShader() async {
    _program = await FragmentProgram.fromAsset('shaders/example1.frag');
    setState(() {
      _isShaderLoaded = true;
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isShaderLoaded) {
      return const Center(child: CircularProgressIndicator());
    }


return Stack(
      children: [
        CustomPaint(
          size: Size.infinite,
          painter: ShaderPainter(_program, _time),
        ),
        Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const Text(
              'Shader Demo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ShaderPainter extends CustomPainter {
  final FragmentProgram program;
  final double time;

  ShaderPainter(this.program, this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final shader = program.fragmentShader();
    shader.setFloat(0, time);          // u_time
    shader.setFloat(1, size.width);    // u_resolution.x 
    shader.setFloat(2, size.height);   // u_resolution.y 

    //shader over entire page
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; //for animation repaint all the time
  }
}
