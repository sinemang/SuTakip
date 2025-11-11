import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class WaterTrackerScreen extends StatefulWidget {
  final double dailyGoal; // Hesaplanan günlük hedef

  const WaterTrackerScreen({super.key, required this.dailyGoal});

  @override
  State<WaterTrackerScreen> createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen> with SingleTickerProviderStateMixin{

  late final AnimationController _controllerConfeti;
  double currentWater = 0; // Başlangıçta içilen su 0
  double cupAmount = 0.25; // Varsayılan bardak miktarı

  Artboard? _artboard;
  StateMachineController? _controller;

  SMINumber? _progressInput; // Rive float input


  @override
  void initState() {
    super.initState();
    _loadRive();
    _controllerConfeti =AnimationController(vsync: this,duration: const Duration(seconds: 5));
  }
  void dispose(){
    _controllerConfeti.dispose();
    super.dispose();
  }

  Future<void> _loadRive() async {
    // Rive paketini başlat (0.13.20 için gerekli)
    await RiveFile.initialize();

    final data = await rootBundle.load('assets/new.riv');
    final file = RiveFile.import(data);
    final artboard = file.mainArtboard;

    // State Machine Controller ekle
    final controller = StateMachineController.fromArtboard(
        artboard, 'State Machine');
    if (controller != null) {
      artboard.addController(controller);

      // Input'u safe şekilde al
      final input = controller.findInput<double>('Level') as SMINumber;
      input.value = 0;
      _progressInput = input;

      setState(() {
        _artboard = artboard;
        _controller = controller;
      });
    }
  }
  void _addWater() {
    setState(() {
      currentWater += cupAmount;
     // if (currentWater > widget.dailyGoal) currentWater = widget.dailyGoal;
      if(currentWater == widget.dailyGoal || currentWater >= widget.dailyGoal){
        var ticker =_controllerConfeti.forward();
      }
    });

    // Hedef seviye: içilen su / günlük hedef


    if (_progressInput != null && mounted) {

      _progressInput!.value = (currentWater / widget.dailyGoal)*100;
    }
  }

  void _switchCup() {
    setState(() {
      cupAmount = cupAmount == 0.25 ? 0.50 : 0.25;
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = currentWater / widget.dailyGoal;

    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.end,
            children: [ Text(
              '${currentWater.toStringAsFixed(2)} L / ${widget.dailyGoal.toStringAsFixed(2)} L',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.white ,// Material Grey 800,
                /*shadows: [
                          Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 1,
                            color: Colors.white70, // yumuşak beyaz yansıma
                          ),
                          Shadow(
                            offset: Offset(0, -1),
                            blurRadius: 1,
                            color: Colors.black26, // hafif derinlik
                          ),
                        ],*/
              ),
            ),
            ],)
            ,
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [GestureDetector(onTap:(){_addWater();},
                   child: Container(
                      width: 300,
                      height: 500,
                      color: Colors.grey[900],
                      child: _artboard == null
                          ? const SizedBox()
                          : Rive(
                        artboard: _artboard!,
                        fit: BoxFit.fill,
                      ),
                    ),),Lottie.asset('assets/animations/Confetti.json',repeat: false,fit: BoxFit.cover,controller: _controllerConfeti),

                    Positioned(
                      bottom: 150,
                      child: GestureDetector(
                        onTap: _addWater,
                        behavior: HitTestBehavior.translucent, // görünmez alanları da algılar
                        child: Column(
                          children: [
                            Opacity(
                              opacity: 0.8,
                              child: Shimmer.fromColors(
                                child: Icon(Icons.touch_app, color: Colors.grey, size: 34),
                                baseColor: Colors.black12,
                                highlightColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Tıkla!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black12,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Günlük Hedef'),
                Text('${widget.dailyGoal.toDouble().toStringAsFixed(2)} L'),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              color: Colors.blueAccent,
              backgroundColor: Colors.blue[200],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _switchCup,
              child: Text('Bardak değiştir: ${(cupAmount.toDouble()*1000).toStringAsFixed(0)} ml'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addWater,
        child: const Icon(Icons.local_drink),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.add), label: 'Anasayfa'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'İstatistikler'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Ayarlar'),
        ],
      ),
    );
  }
}
