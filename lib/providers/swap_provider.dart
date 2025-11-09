import 'package:flutter/material.dart';
import '../models/swap_offer.dart';
import '../models/swap_history.dart';
import '../services/swap_service.dart';

class SwapProvider with ChangeNotifier {
  final SwapService _swapService = SwapService();

  List<SwapOffer> _receivedOffers = [];
  List<SwapOffer> _sentOffers = [];
  List<SwapHistoryItem> _swapHistory = [];
  bool _isLoading = false;
  String? _error;

  List<SwapOffer> get receivedOffers => _receivedOffers;
  List<SwapOffer> get sentOffers => _sentOffers;
  List<SwapHistoryItem> get swapHistory => _swapHistory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Listen to received offers
  void listenToReceivedOffers(String userId) {
    _swapService
        .getReceivedOffers(userId)
        .listen(
          (offers) {
            _receivedOffers = offers;
            notifyListeners();
          },
          onError: (error) {
            _error = error.toString();
            notifyListeners();
          },
        );
  }

  // Listen to sent offers
  void listenToSentOffers(String userId) {
    _swapService
        .getSentOffers(userId)
        .listen(
          (offers) {
            _sentOffers = offers;
            notifyListeners();
          },
          onError: (error) {
            _error = error.toString();
            notifyListeners();
          },
        );
  }

  // Listen to swap history
  void listenToSwapHistory(String userId) {
    _swapService
        .getUserSwapHistory(userId)
        .listen(
          (history) {
            _swapHistory = history;
            notifyListeners();
          },
          onError: (error) {
            _error = error.toString();
            notifyListeners();
          },
        );
  }

  // Create swap offer
  Future<String?> createSwapOffer({
    required String requestedBookId,
    required String requestedBookTitle,
    required String offeredBookId,
    required String offeredBookTitle,
    required String requesterId,
    required String requesterName,
    required String ownerId,
    required String ownerName,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _swapService.createSwapOffer(
        requestedBookId: requestedBookId,
        requestedBookTitle: requestedBookTitle,
        offeredBookId: offeredBookId,
        offeredBookTitle: offeredBookTitle,
        requesterId: requesterId,
        requesterName: requesterName,
        ownerId: ownerId,
        ownerName: ownerName,
      );
      return null; // Success
    } catch (e) {
      _error = e.toString();
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update offer status
  Future<String?> updateOfferStatus({
    required String offerId,
    required String status,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _swapService.updateOfferStatus(offerId, status);
      return null; // Success
    } catch (e) {
      _error = e.toString();
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
