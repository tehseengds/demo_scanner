import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> _pictures = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff212121),
      appBar: AppBar(
        title: const Text('Scanner App Demo'),
        backgroundColor: const Color(0xff212121),
      ),
      floatingActionButton: ElevatedButton(
          onPressed: onPressed, child: const Text("Add Pictures")),
      body: SingleChildScrollView(
          child: Visibility(
        visible: _pictures.isEmpty ? false : true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "Scanned BOL",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xff5B70AB)),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.width * 0.34,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                  physics: const ScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: _pictures.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailScreen(url: _pictures[index]),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.34,
                                  child: Image.file(
                                    File(_pictures[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _pictures.removeAt(index);
                                    });
                                  },
                                  child: Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                    size: MediaQuery.of(context).size.width *
                                        0.06,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      )),
    );
  }

  void onPressed() async {
    List<String> pictures;
    try {
      pictures = await CunningDocumentScanner.getPictures() ?? [];
      if (!mounted) return;
      setState(() {
        _pictures += pictures;
      });
    } catch (exception) {
      // Handle exception here
    }
  }
}

class DetailScreen extends StatelessWidget {
  final dynamic url;
  const DetailScreen({required this.url, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xff212121)),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.file(
              File(url),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
