
// Repository Implementation
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:echoemaar_commerce/core/error/failures.dart';
import 'package:echoemaar_commerce/core/network/network_info.dart';
import 'package:echoemaar_commerce/features/invoice/data/datasources/invoice_remote_datasource.dart';
import 'package:echoemaar_commerce/features/invoice/domain/entities/invoice.dart';
import 'package:echoemaar_commerce/features/invoice/domain/repositories/invoice_repository.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  InvoiceRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<Invoice>>> getInvoices() async {
    if (await networkInfo.isConnected) {
      try {
        
        final models = await remoteDataSource.getInvoices();
         log('NO PROMBLEM ');
        return Right(models.map((m) => m.toEntity()).toList());
      } catch (e) {
        log(e.toString());
        return Left(ServerFailure(e.toString()));
      }
    }
    return const Left(NetworkFailure(''));
  }
}