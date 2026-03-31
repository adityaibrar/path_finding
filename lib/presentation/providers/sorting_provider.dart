import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../domain/entities/sort_item.dart';
import '../../domain/repositories/sorting_repository.dart';
import '../../domain/usecases/run_sort_usecase.dart';
import '../../data/repositories_impl/sorting_repository_impl.dart';

class SortingProvider extends ChangeNotifier {
  final RunSortUseCase _useCase;
  List<SortItem> _array = [];
  bool _isRunning = false;
  SortAlgorithmType _selectedAlgorithm = SortAlgorithmType.bubble;
  
  // Default array count 40 (cukup padat dan sedap dipandang)
  final int _arrayLength = 40; 
  
  // Kecepatan animasi delay in ms
  final int _animationMs = 20;

  SortingProvider({RunSortUseCase? useCase}) 
    : _useCase = useCase ?? RunSortUseCase(SortingRepositoryImpl()) {
    generateRandomArray();
  }

  List<SortItem> get array => _array;
  bool get isRunning => _isRunning;
  SortAlgorithmType get selectedAlgorithm => _selectedAlgorithm;

  void setAlgorithm(SortAlgorithmType type) {
    if (_isRunning) return;
    _selectedAlgorithm = type;
    notifyListeners();
  }

  void generateRandomArray() {
    if (_isRunning) return;
    _array = [];
    final random = Random();
    for (int i = 0; i < _arrayLength; i++) {
      // Membatasi angka dari 10 sampai 100 untuk visualisasi heigh batang
      _array.add(SortItem(value: random.nextInt(90) + 10));
    }
    notifyListeners();
  }

  Future<void> executeAlgorithm() async {
    if (_isRunning) return;
    _isRunning = true;
    notifyListeners();

    final snapshots = _useCase.call(_array, _selectedAlgorithm);

    for (var snapshot in snapshots) {
      if (!_isRunning) break; 
      _array = snapshot;
      notifyListeners();
      await Future.delayed(Duration(milliseconds: _animationMs));
    }

    _isRunning = false;
    notifyListeners();
  }
}
