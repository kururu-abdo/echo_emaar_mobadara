// Abstractions
import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:echoemaar_commerce/config/constants/api_constants.dart';
import 'package:echoemaar_commerce/config/constants/app_constants.dart';
import 'package:echoemaar_commerce/core/error/%20exceptions.dart';
import 'package:echoemaar_commerce/core/error/failures.dart';
import 'package:echoemaar_commerce/core/network/network_info.dart';
import 'package:echoemaar_commerce/core/network/odoo_http_client.dart';
import 'package:echoemaar_commerce/features/invoice/data/models/invoice_model.dart';
import 'package:echoemaar_commerce/features/invoice/domain/entities/invoice.dart';

abstract class InvoiceRemoteDataSource {
  Future<List<InvoiceModel>> getInvoices();
}



// Remote Data Source Implementation
class InvoiceRemoteDataSourceImpl implements InvoiceRemoteDataSource {
  final OdooHttpClient apiClient;
  InvoiceRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<InvoiceModel>> getInvoices() async {
    final response = await apiClient.restPost(ApiConstants.invoicesEndpoint , body: {});
     
      return( response['result']['invoices'] as List).map((item) => InvoiceModel.fromJson(item)).toList();
   
  }
}
