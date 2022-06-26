import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter_ml_audio_to_text/Screens/output_screen.dart';
import 'package:flutter_ml_audio_to_text/constants/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: K.appTitle,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Audio to Text'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<XFile> _list = [];

  bool _dragging = false;
  Offset? offset;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Column(

        children:[
          DropTarget(
            onDragDone: (detail) async {
              setState(() {
                _list.addAll(detail.files);
              });
              debugPrint('onDragDone:');
              for (final file in detail.files) {
                debugPrint('  ${file.path} ${file.name}'
                    '  ${await file.lastModified()}'
              '  ${await file.length()}'
              '  ${file.mimeType}');
            }
            },
            onDragEntered: (detail) {
              setState(() {
                _dragging = true;
                offset = detail.localPosition;
              });
            },
            onDragUpdated: (details){
              setState(() {
                offset = details.localPosition;
              });
            },
            onDragExited: (detail) {
              setState(() {
                _dragging = false;
                offset = null;
              });
            },
            child: Container(
              height: 400,
              width: 800,
              color: _dragging ? Colors.blue.withOpacity(0.4) : Colors.black26,
              child: Stack(
                children: [
                  if (_list.isEmpty)
                    const Center(child: Text("Drag and Drop here"))
                  else
                    Text(_list.map((e) => e.path).join("\n")),
                  if (offset != null)
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        '$offset',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    )
                ],
              ),
            ),
          ),
          
          Text("List of Files: $_list"),



          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const OutputScreen()))
                }, child: const Text("Submit")),
              ),
            ],
          )
        ],
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
