import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:text_recognition/core/color.dart';
import 'package:text_recognition/dummy_data/bank_data.dart';
import 'package:text_recognition/screens/cameraScreen.dart';

class BankSearchScreen extends StatefulWidget {
  @override
  _BankSearchScreenState createState() => _BankSearchScreenState();
}

class _BankSearchScreenState extends State<BankSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _filteredItems = [];
  int? selectedBankId;

  @override
  void initState() {
    super.initState();
    _filteredItems = BanksData; // Initialize with all items
    _searchController
        .addListener(_filterList); // Listen to changes in the search field
  }

  void _filterList() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = BanksData.where(
              (item) => item['name']!.toString().toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterList);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Bank')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for specific Bank',
                labelStyle: const TextStyle(color: MyColor.grey),
                prefixIcon: const Icon(
                  Icons.search,
                  color: MyColor.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 2,
                            color: (selectedBankId != null &&
                                    selectedBankId ==
                                        _filteredItems[index]['id'])
                                ? MyColor.greenColor
                                : MyColor.grey),
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          selectedBankId = _filteredItems[index]['id'];
                        });
                      },
                      leading: SizedBox(
                        width: 40,
                        height: 50,
                        child: Image.asset(
                          _filteredItems[index]['image']!,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      title: Text(
                        _filteredItems[index]['name']!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: (selectedBankId != null &&
                              selectedBankId == _filteredItems[index]['id'])
                          ? SizedBox(
                              width: 30,
                              height: 40,
                              child: Image.asset(
                                'assets/images/check.png',
                                fit: BoxFit.cover,
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(332, 60),
                backgroundColor: Colors.deepPurpleAccent,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              onPressed: () async {
                WidgetsFlutterBinding.ensureInitialized();
                final cameras = await availableCameras();
                final firstCamera = cameras.first;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CameraScreen(camera: firstCamera)));
              },
              child: const Text(
                'Choose The Bank',
                style: TextStyle(
                  fontSize: 20,
                  color: MyColor.whiteColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
