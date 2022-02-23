import 'package:band_names/models/band.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'BTS', votes: 5),
    Band(id: '2', name: 'StrayKids', votes: 1),
    Band(id: '3', name: 'Seventeen', votes: 2),
    Band(id: '4', name: 'Got7', votes: 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BandNames',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (context, i) => _bandTitle(bands[i])),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
    );
  }

  Widget _bandTitle(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print('direction : $direction');
        print('band id : ${band.id}');
      },
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.only(left: 8.0),
        child: const Align(
            alignment: Alignment.centerLeft,
            child: Text('Delete Band', style: TextStyle(color: Colors.white))),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text(
          '${band.votes}',
          style: const TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }

  addNewBand() {
    final textController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('New band name: '),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                child: const Text('add'),
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () {
                  addBandToList(textController.text);
                },
              )
            ],
          );
        });
  }

  addBandToList(String name) {
    if (name.length > 1) {
      bands.add(Band(id: '${bands.length + 1}', name: name, votes: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }
}
