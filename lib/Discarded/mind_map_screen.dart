// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
//
//
// class MindMapScreen extends StatefulWidget {
//   final String filePath;
//   MindMapScreen({this.filePath});
//
//   @override
//   _MindMapScreenState createState() => _MindMapScreenState();
// }
//
// class _MindMapScreenState extends State<MindMapScreen> {
//
//   File file;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     sendFile();
//   }
//
//   sendFile() async{
//     print(widget.filePath);
//     Directory directory = await getApplicationDocumentsDirectory();
//
//     final bytes = File(widget.filePath).openRead();
//     final socket = await Socket.connect('127.0.0.1', 8080);
//     await socket.addStream(bytes);
//     socket.listen(
//           (Uint8List data)  async{
//             setState((){
//
//               file = File('${directory.path}/newFile.jpg');
//
//             });
//             await file.writeAsBytes(data);
//       },
//       onError: (error) {
//         print(error);
//         socket.destroy();
//       },
//       onDone: () {
//         print('Server left.');
//         socket.destroy();
//       },
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black38,
//       body: file != null ? Center(child: InteractiveViewer(child: Image(image: FileImage(file))))
//             : Center(child: CircularProgressIndicator())
//
//       );
//
//       // FutureBuilder<File>(
//       //   future: NetworkService().sendFile(filePath: widget.filePath),
//       //   builder: (context, snapshot){
//       //
//       //     if (snapshot.hasData){
//       //
//       //       return InteractiveViewer(child: Image(
//       //         image: FileImage(snapshot.data),
//       //       ));
//       //     }else if (snapshot.hasError){
//       //
//       //       return Center(
//       //         child: Text('Poor Internet Connection!', style: TextStyle(color: Colors.white),),
//       //       );
//       //     }
//       //
//       //     return CircularProgressIndicator();
//       //   },
//       // ),
//     // );
//   }
// }
