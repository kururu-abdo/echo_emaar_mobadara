import 'package:dartz/dartz.dart';
import 'package:echoemaar_commerce/core/error/failures.dart';
import 'package:echoemaar_commerce/features/invoice/domain/entities/invoice.dart';

abstract class InvoiceRepository {
  Future<Either<Failure, List<Invoice>>> getInvoices();
}