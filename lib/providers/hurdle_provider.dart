import 'dart:math';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart' as words;
import 'package:world_hurdle_puzzle/models/wordle.dart';

class HurdleProvider extends ChangeNotifier {
  final random = Random.secure();
  List<String> totalWorlds = [];
  List<String> rowInputs = [];
  List<String> excludedLetters = [];
  List<Wordle> hurdleBoard = [];
  String targetWord = '';
  int count = 0;
  final lettersPerRow = 5;
  int index = 0;
  bool wins = false;
  final totalAttempts = 6;
  int attempts = 0;

  bool get checkForAnswer => rowInputs.length == lettersPerRow;

  bool get isAValidWord => totalWorlds.contains(rowInputs.join('').toLowerCase());

  bool get noAttemptsLeft => attempts == totalAttempts;

  /// In line 28 we create a list of words with 5 characters from the english_words package.
  init() {
    totalWorlds = words.all.where((element) => element.length == 5).toList();
    generateBoard();
    generateRandomWord();
  }

  ///hurdle board will be populated with 30 empty strings.
  generateBoard() {
    hurdleBoard = List.generate(30, (index) => Wordle(letter: ''));
  }
  ///a word from totalWords is generated for the game.
  generateRandomWord() {
    targetWord = totalWorlds[random.nextInt(totalWorlds.length)].toUpperCase();
    //print(targetWord);
    }


  inputLetter(String letter) {
    if(count < lettersPerRow) {
    count++;
    rowInputs.add(letter);
    hurdleBoard[index] = Wordle(letter: letter);
    index++;
    //print(rowInputs);
    notifyListeners();
    }
  }

  void deleteLetter() {
    if(rowInputs.isNotEmpty) {
      rowInputs.removeAt(rowInputs.length - 1);
      //print(rowInputs);
    }
    if(count > 0) {
      hurdleBoard[index - 1] = Wordle(letter: '');
      count--;
      index--;
    }
    notifyListeners();
  }

  void checkAnswer() {
    final input = rowInputs.join('');
    if(targetWord == input) {
      wins = true;
    } else {
      _markLetterOnBoard();
      if(attempts < totalAttempts) {
        _goToNextRow();
      }
    }
  }

  void _markLetterOnBoard() {
    for(int i = 0; i < hurdleBoard.length; i++) {
      if(hurdleBoard[i].letter.isNotEmpty && targetWord.contains(hurdleBoard[i].letter)) {
        hurdleBoard[i].existsInTarget = true;
      } else if(hurdleBoard[i].letter.isNotEmpty && !targetWord.contains(hurdleBoard[i].letter)) {
        hurdleBoard[i].doesNotExistInTarget = true;
        excludedLetters.add(hurdleBoard[i].letter);
      }
    }
    notifyListeners();
  }

  void _goToNextRow() {
    attempts++;
    count = 0;
    rowInputs.clear();
  }

  reset() {
    count = 0;
    index = 0;
    rowInputs.clear();
    hurdleBoard.clear();
    excludedLetters.clear();
    attempts = 0;
    wins = false;
    targetWord = '';
    generateBoard();
    generateRandomWord();
    notifyListeners();
  }
}

