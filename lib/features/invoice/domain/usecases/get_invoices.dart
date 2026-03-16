import 'package:dartz/dartz.dart';
import 'package:echoemaar_commerce/core/error/failures.dart';
import 'package:echoemaar_commerce/core/usecases/usecase.dart';
import 'package:echoemaar_commerce/features/invoice/domain/entities/invoice.dart';
import 'package:echoemaar_commerce/features/invoice/domain/repositories/invoice_repository.dart';

class GetInvoices implements UseCase<List<Invoice>, NoParams> {
  final InvoiceRepository repository;
  
  GetInvoices(this.repository);
  
  @override
  Future<Either<Failure, List<Invoice>>> call(NoParams params) async {
    return await repository.getInvoices(
     
    );
  }
}