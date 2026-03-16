import 'dart:developer';

import 'package:echoemaar_commerce/core/usecases/usecase.dart';
import 'package:echoemaar_commerce/features/checkout/data/models/address_model.dart';
import 'package:echoemaar_commerce/features/checkout/data/models/country_model.dart';
import 'package:echoemaar_commerce/features/checkout/data/models/country_state_model.dart';
import 'package:echoemaar_commerce/features/checkout/domain/entities/country.dart';
import 'package:echoemaar_commerce/features/checkout/domain/entities/shipping_address.dart';
import 'package:echoemaar_commerce/features/checkout/domain/usecases/add_address.dart';
import 'package:echoemaar_commerce/features/checkout/domain/usecases/get_addresses.dart';
import 'package:echoemaar_commerce/features/checkout/domain/usecases/get_countries.dart';
import 'package:echoemaar_commerce/features/checkout/domain/usecases/get_country_states.dart';
import 'package:flutter/material.dart';

class CheckoutProvider extends ChangeNotifier {
final GetCountries getCountries;
final GetCountryStates getCountryStates;
final GetShippingAddresses getShippingAddresses;
final AddShippingAddress addShippingAddress;

  CheckoutProvider({ required this.getCountries, required this.getCountryStates, required this.getShippingAddresses, required this.addShippingAddress});

  // State variables
  List<CountryModel> countries = [];
  List<CountryStateModel> states = [];
  List<ShippingAddressModel> savedAddresses = [];
  
  bool isLoading = false;
  String? errorMessage;




CountryModel? selectedCountry;
  CountryStateModel? selectedState;

  bool isStatesLoading = false;
// 1. Set Country and trigger State loading
  Future<void> selectCountry(CountryModel? country) async {
    if (country == null || country.id == selectedCountry?.id) return;

    selectedCountry = country;
    selectedState = null; // Reset state when country changes
    states = []; // Clear current states list
    
    notifyListeners();

    // Automatically fetch states for the new country
    await getStates(country.id);
  }

  // 2. Set State
  void selectState(CountryStateModel? state) {
    selectedState = state;
    notifyListeners();
  }





  // ── 1. Get Countries ──────────────────────────────────────────────
  Future<void> fetchCountries() async {
    isLoading = true;
    notifyListeners();

    final result = await getCountries(NoParams());
    result.fold(
      (failure) => errorMessage = failure.message,
      (data) => countries = data as List<CountryModel>,
    );

    isLoading = false;
    notifyListeners();
  }

  // ── 2. Get States by Country ID ───────────────────────────────────
  Future<void> getStates(int countryId) async {
    states = []; // Clear previous states while loading
    isLoading = true;
    notifyListeners();

    final result = await getCountryStates(countryId);
    result.fold(
      (failure) => errorMessage = failure.message,
      (data) => states = data as List<CountryStateModel>,
    );

    isLoading = false;
    notifyListeners();
  }

  // ── 3. Save New Address ──────────────────────────────────────────
  Future<bool> saveAddress(ShippingAddress address) async {
    isLoading = true;
    notifyListeners();

    final result = await addShippingAddress( AddShippingAddressParams(
      address
    ));
    bool success = false;
    
    result.fold(
      (failure) => errorMessage = failure.message,
      (newAddress) {
        savedAddresses.insert(0, newAddress as ShippingAddressModel ); // Add to the top of the list
        success = true;
      },
    );

    isLoading = false;
    notifyListeners();
    return success;
  }





  // ── 4. Get Saved Addresses ────────────────────────────────────────
  Future<void> fetchAddresses() async {
    isLoading = true;
    notifyListeners();

    final result = await getShippingAddresses(NoParams());
    result.fold(
      (failure) => errorMessage = failure.message,
      (data) => savedAddresses = data as List<ShippingAddressModel>,
    );

    isLoading = false;
    notifyListeners();
  }
}