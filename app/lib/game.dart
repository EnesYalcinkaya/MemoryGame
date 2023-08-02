import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

void main() {
  runApp(MaterialApp(
    home: Game(),
  ));
}

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  List<String> imageList = [
    "images/1.jpg",
    "images/2.jpg",
    "images/3.jpg",
    "images/4.jpg",
    "images/5.jpg",
    "images/6.jpg",
    "images/1.jpg",
    "images/2.jpg",
    "images/3.jpg",
    "images/4.jpg",
    "images/5.jpg",
    "images/6.jpg",
  ];

  bool controlCard = true;
  int score = 0;
  String selected1 = '';
  String selected2 = '';
  int firstIndex = -1;
  int secondIndex = -1;
  List<int> closeFlippedList = [];
  bool resetActive = false;
  List<GlobalKey<FlipCardState>> cardKeyList = [];
  List<bool> isFlipped = List.generate(12, (_) => false);
  bool isResetting = false;

  void _incrementScore() {
    setState(() {
      if (score < 100) {
        score += 20;
      }
    });
  }

  void _resetGame() {
    if (isResetting) return;

    imageList.shuffle();
    setState(() {
      score = 0;
      selected1 = '';
      selected2 = '';
      isResetting = true;

      closeFlippedList = [];
      for (var element in cardKeyList) {
        if ((element.currentState?.isFront == false)) {
          element.currentState?.toggleCard();
        }
      }
      for (int i = 0; i < isFlipped.length; i++) {
        isFlipped[i] = false;
      }
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isResetting = false;
      });
    });
  }

  void _checkForMatch(int index) {
    if (selected1 == '') {
      setState(() {
        selected1 = imageList[index];
        firstIndex = index;
        if (!resetActive) {
          isFlipped[firstIndex] = true;
          resetActive = false;
        }
      });
    } else if (selected1 != '' && selected2 == '') {
      if (!resetActive) {
        for (int i = 0; i < isFlipped.length; i++) {
          isFlipped[i] = true;
        }
      }
      setState(() {
        resetActive = false;
        selected2 = imageList[index];
        secondIndex = index;
      });

      if (selected1 == selected2) {
        debugPrint('Eşleşti');
        selected1 = '';
        selected2 = '';
        closeFlippedList.add(firstIndex);
        closeFlippedList.add(secondIndex);
        firstIndex = -1;
        secondIndex = -1;
        for (int i = 0; i < isFlipped.length; i++) {
          if (!closeFlippedList.contains(i)) {
            isFlipped[i] = false;
          }
        }
        _incrementScore();
      } else if (selected1 != selected2) {
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            if (!(cardKeyList[firstIndex].currentState?.isFront ?? false)) {
              cardKeyList[firstIndex].currentState?.toggleCard();
              cardKeyList[secondIndex].currentState?.toggleCard();
              for (int i = 0; i < isFlipped.length; i++) {
                if (!closeFlippedList.contains(i)) {
                  isFlipped[i] = false;
                }
              }
            }

            firstIndex = -1;
            secondIndex = -1;
            selected1 = '';
            selected2 = '';
          });
        });
        debugPrint('Eşleşmedi');
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('🧠   Memory Game   🧠'),
        backgroundColor: Colors.black,
      ),
      body: Card(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 100 / 200,
          ),
          itemCount: imageList.length,
          itemBuilder: (BuildContext context, int index) {
            String img = imageList[index];
            GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
            cardKeyList.add(cardKey);
            return myCardWidget(index, img);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetGame,
        backgroundColor: Colors.black,
        child: const Icon(Icons.refresh),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget myCardWidget(int index, String img) {
    return FlipCard(
      key: cardKeyList[index],
      onFlipDone: (value) {},
      onFlip: () {
        _checkForMatch(index);
      },
      flipOnTouch: !isFlipped[index],
      front: Card(
        child: Container(
          child: Image.asset('images/7.jpg', fit: BoxFit.cover),
        ),
      ),
      back: Card(
        child: Container(
          child: Image.asset(img),
        ),
      ),
    );
  }

  Widget buildBottomNavigationBar() {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          'Skor: $score',
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
