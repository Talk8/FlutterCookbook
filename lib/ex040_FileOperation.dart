import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

///该代码参考path_provide给的示例实现,对应99，100章回的内容
class ExFileStored extends StatefulWidget {
  const ExFileStored({Key? key}) : super(key: key);

  @override
  State<ExFileStored> createState() => _ExFileStoredState();
}

class _ExFileStoredState extends State<ExFileStored> {
  ///获取文件路径,对应目录只适应于Android，IOS没有验证
  ///对应目录：data/user/0/package_name/cache
  Future<Directory?>? _tempDirectory;
  ///对应目录：data/user/0/package_name/files
  Future<Directory?>? _appSupportDirectory;
  Future<Directory?>? _appLibraryDirectory;
  ///对应目录：data/user/0/package_name/app_flutter
  Future<Directory?>? _appDocumentsDirectory;
  ///对应目录：storage/emulated/0/Android/data/package_name/files
  Future<Directory?>? _externalDocumentsDirectory;
  ///对应目录：storage/emulated/0/Android/data/package_name/files
  Future<List<Directory>?>? _externalStorageDirectories;
  ///对应目录：storage/emulated/0/Android/data/package_name/cache
  Future<List<Directory>?>? _externalCacheDirectories;
  Future<Directory?>? _downloadsDirectory;

  Widget _buildDirectory(BuildContext context,AsyncSnapshot<Directory?> snapshot) {
    Text text = const Text('');
    if(snapshot.connectionState == ConnectionState.done) {
      if(snapshot.hasError) {
        text = Text('Error: ${snapshot.error}');
      }else if (snapshot.hasData) {
        text = Text('Path: ${snapshot.data?.path}');
      }else {
        text = const Text('Path unavailable');
      }
    }

    ///占用太多位置导致空间不够用，因此减小空间
    // return Padding(padding: const EdgeInsets.all(2),child:text,);
    return Padding(padding: const EdgeInsets.only(top: 2),child:text,);
  }


  Widget _buildDirectories(BuildContext context,AsyncSnapshot<List<Directory>?> snapshot) {
    Text text = const Text('');
    if(snapshot.connectionState == ConnectionState.done) {
      if(snapshot.hasError) {
        text = Text('Error: ${snapshot.error}');
      }else if (snapshot.hasData) {
        final String combined = snapshot.data!.map((Directory d) => d.path).join(',');
        text = Text('Path: $combined');
      }else {
        text = const Text('Path unavailable');
      }
    }

    // return Padding(padding: const EdgeInsets.all(16),child:text,);
    return Padding(padding: const EdgeInsets.only(top: 2),child:text,);
  }

  void _requestTempDirectory() {
    setState(() {
      _tempDirectory = getTemporaryDirectory();
    });
  }

  void _requestAppSupportDirectory() {
    setState(() {
      _appSupportDirectory = getApplicationSupportDirectory();
    });
  }

  ///Android不支持该目录
  void _requestAppLibraryDirectory() {
    setState(() {
      _appLibraryDirectory = getLibraryDirectory();
    });
  }

  void _requestDocumentsDirectory() {
    setState(() {
      _appDocumentsDirectory = getApplicationDocumentsDirectory();
    });
  }

  void _requestExternalStorageDirectory() {
    setState(() {
      _externalDocumentsDirectory = getExternalStorageDirectory();
    });
  }

  void _requestExternalStorageDirectories() {
    setState(() {
      _externalStorageDirectories = getExternalStorageDirectories();
    });
  }

  void _requestExternalCacheDirectories() {
    setState(() {
      _externalCacheDirectories = getExternalCacheDirectories();
    });
  }

  ///Android不支持该目录
  void _requestDownloadsDirectory() {
    setState(() {
      _downloadsDirectory = getDownloadsDirectory();
    });
  }

  /// 创建文件
  Future<File> get _createFile async {
    ///先获取directory，然后再从directory中获取绝对路径
    final localDirectory = await getExternalStorageDirectory();
    return File('${localDirectory?.path}/test_file.txt');
  }

  /// 向文件中写入内容
  Future<File> _writeContentToFile(String data) async {
    final file = await _createFile;
    return file.writeAsString(data);
  }

  /// 从文件中读取内容
  Future<String> _readContentFromFile() async {
    try {
      final file = await _createFile;
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return exception
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example of File Stored'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:<Widget> [
          ElevatedButton(
              onPressed: _requestTempDirectory,
              child: const Text(' 1 -> Get temporary directory')),
          ///本质上是一个Text组件，因为builder返回了该组件
          FutureBuilder<Directory?>(
            future:_tempDirectory,
            builder: _buildDirectory,),
          ElevatedButton(
              onPressed: _requestAppSupportDirectory,
              child: const Text(' 2 -> Get App Support directory')),
          FutureBuilder<Directory?>(
            future:_appSupportDirectory,
            builder: _buildDirectory,),
          ElevatedButton(
              onPressed: _requestAppLibraryDirectory,
              child: const Text(' 3 -> Get App library directory')),
          FutureBuilder<Directory?>(
            future:_appLibraryDirectory,
            builder: _buildDirectory,),
          ElevatedButton(
              onPressed: _requestDocumentsDirectory,
              child: const Text(' 4 -> Get documents directory')),
          FutureBuilder<Directory?>(
            future:_appDocumentsDirectory,
            builder: _buildDirectory,),
          ElevatedButton(
              onPressed: _requestExternalStorageDirectory,
              child: const Text(' 5 -> Get external documents directory')),
          FutureBuilder<Directory?>(
            future:_externalDocumentsDirectory,
            builder: _buildDirectory,),
          ElevatedButton(
              onPressed: _requestExternalStorageDirectories,
              child: const Text(' 6 -> Get external storage directories')),
          FutureBuilder<List<Directory>?>(
            future:_externalStorageDirectories,
            builder: _buildDirectories,),
          ElevatedButton(
              onPressed: _requestExternalCacheDirectories,
              child: const Text(' 7 -> Get external cache directories')),
          FutureBuilder<List<Directory>?>(
            future:_externalCacheDirectories,
            builder: _buildDirectories,),
          ElevatedButton(
              onPressed: _requestDownloadsDirectory,
              child: const Text(' 8 -> Get downloads directory')),
          FutureBuilder<Directory?>(
            future:_downloadsDirectory,
            builder: _buildDirectory,),
          ElevatedButton(
              onPressed:() {
                String temp_data = 'test data';
                _createFile;
                debugPrint('write data:\'$temp_data \'to file');
                _writeContentToFile(temp_data);
                _readContentFromFile().then((value) => print("get data:\'$value\'from file"));
              },
              child: const Text('Write and Read File')),
        ],
      ),
    );
  }
}
