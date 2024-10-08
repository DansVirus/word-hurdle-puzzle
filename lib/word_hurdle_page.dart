import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_hurdle_puzzle/helper_functions.dart';
import 'package:world_hurdle_puzzle/keyboard_view.dart';
import 'package:world_hurdle_puzzle/providers/hurdle_provider.dart';
import 'package:world_hurdle_puzzle/sound_player.dart';
import 'package:world_hurdle_puzzle/wordle_view.dart';

class WordHurdlePage extends StatefulWidget {
  const WordHurdlePage({super.key});

  @override
  State<WordHurdlePage> createState() => _WordHurdlePageState();
}

class _WordHurdlePageState extends State<WordHurdlePage> {
  @override
  void didChangeDependencies() {
    Provider.of<HurdleProvider>(context, listen: false).init();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Hurdle'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.90,
                child: Consumer<HurdleProvider>(
                  builder: (context, provider, child) => GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                    ),
                    itemCount: provider.hurdleBoard.length,
                    itemBuilder: (context, index) {
                      final wordle = provider.hurdleBoard[index];
                      return WordleView(wordle: wordle);
                    },
                  ),
                ),
              ),
            ),
            Consumer<HurdleProvider>(
              builder: (context, provider, child) => KeyboardView(
                excludedLetters: provider.excludedLetters,
                onPressed: (value) {
                  provider.inputLetter(value);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<HurdleProvider>(
                builder: (context, provider, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        provider.deleteLetter();
                      },
                      child: const Text('DELETE'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _handleInput(provider);
                      },
                      child: const Text('SUBMIT'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _handleInput(HurdleProvider provider) {
    SoundPlayer youWin = SoundPlayer();
    SoundPlayer youLost = SoundPlayer();
    if (!provider.isAValidWord) {
      showMsg(context, 'Not a word in dictionary');
      return;
    }
    if (provider.checkForAnswer) {
      provider.checkAnswer();
    }
    if (provider.wins) {
      youWin.playSound('sounds/you_win.wav');
      showResult(
        context: context,
        title: 'You Win!!!',
        body: 'The word was ${provider.targetWord}',
        onPlayAgain: () {
          Navigator.pop(context);
          provider.reset();
        },
        onCancel: () {
          Navigator.pop(context);
        },
      );
    } else if (provider.noAttemptsLeft) {
      youLost.playSound('sounds/you_lost.mp3');
      showResult(
        context: context,
        title: 'Sorry, you lost!',
        body: 'The word was ${provider.targetWord}',
        onPlayAgain: () {
          Navigator.pop(context);
          provider.reset();
        },
        onCancel: () {
          Navigator.pop(context);
        },
      );
    }
  }
}
