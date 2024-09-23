import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignSelectionPage(),
    );
  }
}

class SignSelectionPage extends StatefulWidget {
  const SignSelectionPage({Key? key}) : super(key: key);

  @override
  _SignSelectionPageState createState() => _SignSelectionPageState();
}

class _SignSelectionPageState extends State<SignSelectionPage> {
  String player1Sign = 'X';
  String player2Sign = 'O';

  void startGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicTacToeGame(
          playerX: player1Sign,
          playerO: player2Sign,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.network(
              'https://wallpapercave.com/wp/wp2788060.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Tic Tac Toe Game',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Text('User 1:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio<String>(
                      value: 'X',
                      groupValue: player1Sign,
                      onChanged: (value) {
                        setState(() {
                          player1Sign = value!;
                          player2Sign = player1Sign == 'X' ? 'O' : 'X';
                        });
                      },
                    ),
                    const Text('X', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    Radio<String>(
                      value: 'O',
                      groupValue: player1Sign,
                      onChanged: (value) {
                        setState(() {
                          player1Sign = value!;
                          player2Sign = player1Sign == 'X' ? 'O' : 'X';
                        });
                      },
                    ),
                    const Text('O', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: startGame,
                  child: const Text('Start Game'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  final String playerX;
  final String playerO;

  const TicTacToeGame({Key? key, required this.playerX, required this.playerO}) : super(key: key);

  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  List<String> board = List.filled(9, '');
  String currentPlayer = '';
  String winner = '';
  String winnerName = '';

  @override
  void initState() {
    super.initState();
    currentPlayer = widget.playerX;
  }

  void resetGame() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Signs'),
          content: const Text('Please select your signs again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignSelectionPage()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void makeMove(int index) {
    if (board[index] == '' && winner == '') {
      setState(() {
        board[index] = currentPlayer;
        checkWinner();
        currentPlayer = currentPlayer == widget.playerX ? widget.playerO : widget.playerX;
      });
    }
  }

  void checkWinner() {
    const List<List<int>> winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var combination in winningCombinations) {
      if (board[combination[0]] != '' &&
          board[combination[0]] == board[combination[1]] &&
          board[combination[1]] == board[combination[2]]) {
        setState(() {
          winner = board[combination[0]];
          winnerName = winner == widget.playerX ? 'User 1' : 'User 2';
        });
        return;
      }
    }

    if (!board.contains('')) {
      setState(() {
        winner = 'Draw';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tic Tac Toe')),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.network(
              'https://wallpapercave.com/wp/wp2788060.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    winner.isNotEmpty ? (winner == 'Draw' ? 'play again!' : '$winnerName Wins!') : '${currentPlayer == widget.playerX ? 'User 1' : 'User 2'}\'s Turn',
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 300,
                    height: 300,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => makeMove(index),
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue, width: 2),
                            ),
                            child: Center(
                              child: Text(
                                board[index],
                                style: TextStyle(
                                  fontSize: 64,
                                  color: board[index] == widget.playerX ? Color.fromARGB(255, 11, 11, 11) : const Color.fromARGB(255, 254, 253, 253), // Shiny red for X, black for O
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (winner.isNotEmpty)
                    ElevatedButton(
                      onPressed: resetGame,
                      child: const Text('Reset Game'),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
