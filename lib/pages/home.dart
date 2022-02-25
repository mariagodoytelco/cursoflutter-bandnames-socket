import 'package:band_names/models/band.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import '../services/socket_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    SocketService socketService =
        Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', _handleActiveBands);
    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    SocketService socketService =
        Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  List<Band> bands = [];

  @override
  Widget build(BuildContext context) {
    SocketService socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BandNames', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: (socketService.serverStatus == ServerStatus.Online)
                ? const Icon(Icons.check_circle, color: Colors.blue)
                : const Icon(Icons.offline_bolt, color: Colors.red),
          )
        ],
      ),
      body: Column(children: [
        _showGraph(),
        Expanded(
          child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (_, i) => _bandTitle(bands[i])),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
    );
  }

  Widget _bandTitle(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => socketService.emit('delete-band', {'id': band.id}),
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
        trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20.0)),
        onTap: () => socketService.socket.emit('vote-band', {'id': band.id}),
      ),
    );
  }

  addNewBand() {
    final textController = TextEditingController();

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('New band name: '),
              content: TextField(
                controller: textController,
              ),
              actions: [
                MaterialButton(
                  child: const Text('add'),
                  elevation: 5,
                  textColor: Colors.blue,
                  onPressed: () => addBandToList(textController.text),
                )
              ],
            ));
  }

  addBandToList(String name) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    if (name.length > 1) {
      socketService.socket.emit('add-band', {'name': name});
    }
    Navigator.pop(context);
  }

  _showGraph() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    if (socketService.serverStatus == ServerStatus.Online) {
      Map<String, double> dataMap = {};
      for (Band band in bands) {
        dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
      }

      final List<Color> colorList = [
        Colors.cyan.shade100,
        Colors.cyan.shade200,
        Colors.purple.shade100,
        Colors.purple.shade200,
        Colors.green.shade100,
        Colors.green.shade200,
        Colors.amber.shade100,
        Colors.amber.shade200
      ];

      return Container(
        margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        width: double.infinity,
        height: 200.0,
        child: PieChart(
          dataMap: dataMap,
          animationDuration: const Duration(milliseconds: 800),
          colorList: colorList,
          initialAngleInDegree: 0,
          ringStrokeWidth: 35,
          chartType: ChartType.ring,
          legendOptions: const LegendOptions(
            showLegendsInRow: false,
            legendPosition: LegendPosition.right,
            showLegends: true,
            legendShape: BoxShape.circle,
            legendTextStyle: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
              backgroundColor: Colors.transparent
            ),
          ),
          chartValuesOptions: const ChartValuesOptions(
            showChartValueBackground: false,
            showChartValues: true,
            showChartValuesInPercentage: true,
            showChartValuesOutside: false,
            chartValueStyle: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
            decimalPlaces: 0,
        ),
        ),
      );
    } else {
      return Container();
    }
  }
}
