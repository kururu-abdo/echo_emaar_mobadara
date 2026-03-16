import 'dart:convert';
import 'package:echoemaar_commerce/features/checkout/data/models/country_model.dart';
import 'package:echoemaar_commerce/features/checkout/data/models/country_state_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Import your models
// import 'path_to_models/country_model.dart';
// import 'path_to_models/country_state_model.dart';

class CheckoutLocalDatasource {
  final SharedPreferences sharedPreferences;

  CheckoutLocalDatasource({required this.sharedPreferences});

  static const String _countriesKey = 'CACHED_COUNTRIES';
  static const String _statesKey = 'CACHED_STATES';
static const String _statePrefix = 'CACHED_STATES_';
  // ── Countries Cache ───────────────────────────────────────────────

  Future<void> cacheCountries(List<CountryModel> countries) async {
    final List<String> jsonList = countries
        .map((country) => jsonEncode(country.toJson()))
        .toList();
    
    await sharedPreferences.setStringList(_countriesKey, jsonList);
  }

  List<CountryModel> getCachedCountries() {
    final jsonList = sharedPreferences.getStringList(_countriesKey);
    if (jsonList != null && jsonList.isNotEmpty) {
      return jsonList
          .map((item) => CountryModel.fromJson(jsonDecode(item)))
          .toList();
    }
    return [];
  }

  // ── States Cache ──────────────────────────────────────────────────

  Future<void> cacheStates(int countryId, List<CountryStateModel> states) async {
    final List<String> jsonList = states
        .map((state) => jsonEncode(state.toJson()))
        .toList();
    
    // Example Key: CACHED_STATES_188
    await sharedPreferences.setStringList('$_statePrefix$countryId', jsonList);
  }

  List<CountryStateModel> getCachedStates(int countryId) {
    final jsonList = sharedPreferences.getStringList('$_statePrefix$countryId');
    
    if (jsonList != null && jsonList.isNotEmpty) {
      return jsonList
          .map((item) => CountryStateModel.fromJson(jsonDecode(item)))
          .toList();
    }
    return [];
  }

  // ── Utility ───────────────────────────────────────────────────────

  Future<void> clearCache() async {
    await sharedPreferences.remove(_countriesKey);
    await sharedPreferences.remove(_statesKey);
  }
}