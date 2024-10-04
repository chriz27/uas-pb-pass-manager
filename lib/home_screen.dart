import 'package:flutter/material.dart';
import 'package:save_password/db_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _allData = [];

  bool _isLoading = true;
// MUAT ULANG DATA
  void _refreshData() async {
    final data = await SQLHelper.getData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();

  }

// TAMBAH DATA
  Future<void> _addData() async {
    await SQLHelper.createData(_titleControler.text, _usernameControler.text, _passControler.text, _descControler.text);
    _refreshData();
  }

// UBAH DATA
  Future<void> _updateData(int id) async{
    await SQLHelper.updateData(id, _titleControler.text, _usernameControler.text, _passControler.text, _descControler.text);
    _refreshData();
  }

// HAPUS DATA
  void _deleteData(int id) async{
    await SQLHelper.deleteData(id);
    ScaffoldMessenger.of(context)
    .showSnackBar(const SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text("Berhasil di hapus!"),
    ));
    _refreshData();
  }


  final TextEditingController _titleControler = TextEditingController();
  final TextEditingController _usernameControler = TextEditingController();
  final TextEditingController _passControler = TextEditingController();
  final TextEditingController _descControler = TextEditingController();
  
  void showBottomSheet (int? id) async{


    
    if(id != null) {
      final existingData =
        _allData.firstWhere((element)=>element['id']==id);
      _titleControler.text = existingData['title'];
      _usernameControler.text = existingData['username'];
      _passControler.text = existingData['password'];
      _descControler.text = existingData['desc'];
    }

    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 30, 
          left: 15, 
          right: 15, 
          bottom: MediaQuery.of(context).viewInsets.bottom + 50,
          ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: _titleControler,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Nama Sosmed",
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _usernameControler,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "email/username",
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _passControler,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Password",
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _descControler,
            maxLines: 4,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Description",
            ),
          ),
          SizedBox(height: 20),

          Center(
            child: ElevatedButton(
              onPressed: () async {
                if (id == null){
                  await _addData();
                }
                if (id != null){
                  await _updateData(id);
              }

              _titleControler.text = "";
              _usernameControler.text = "";
              _passControler.text = "";
              _descControler.text = "";

// HIDEN BOTTOM SHEET
                Navigator.of(context).pop();
                print("Data berhasil ditambahkan");
              },
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Text(
                  id == null ? "Simpan" : "Simpan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            ), 
          ), // child: child),
        ],
      ),
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECEAF4),
      appBar: AppBar(
        title: Text("Pencatatan Password"),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
            itemCount: _allData.length,
              itemBuilder: (context, index) => Card(
                margin: EdgeInsets.all(15),
                child: ListTile(
                  title: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      _allData[index]['title'],
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  subtitle: Text(_allData[index]['desc']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: (){
                          showBottomSheet(_allData[index]['id']);
                        }, 
                        icon: Icon(
                          Icons.edit,
                          color: Colors.indigo,
                        ),),
                      IconButton(
                        onPressed: (){
                          _deleteData(_allData[index]['id']);
                        }, 
                        icon: Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),),
                    ],
                  ),
              ),
          ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => showBottomSheet(null),
            child: Icon(Icons.add),
        ),
    );
    
  }
}