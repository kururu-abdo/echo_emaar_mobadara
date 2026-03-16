
import 'package:echoemaar_commerce/core/usecases/usecase.dart';
import 'package:echoemaar_commerce/features/products/domain/entities/category.dart';
import 'package:echoemaar_commerce/features/products/domain/usecases/get_categories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'category_state.dart';
part 'category_event.dart';
class CategoryBloc
    extends Bloc<CategoryEvent, CategoryState> {

 final GetCategories getCategories;


 CategoryBloc({
    required this.getCategories,
    // required this.getRelatedProducts,
    // required this.getProductVariants,
  }) : super(CategoryStateInitial()) {
    on<LoadCategorisEvent>(_onLoad);

  }

 Future<void> _onLoad(
    LoadCategorisEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryStateLoading());

    final result =
        await getCategories(NoParams());

    result.fold(
      (failure) => emit(CategoryStateError(failure.message)),
      (categories) {
        emit(CategoryStateLoaded(categories: categories));
        // kick off secondary loads
        // add(LoadRelatedProductsEvent(event.productId));
        // add(LoadProductVariantsEvent(event.productId));
      },
    );
  }

    }