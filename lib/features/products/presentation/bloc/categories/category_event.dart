part of 'category_bloc.dart';


abstract class CategoryEvent extends Equatable {
   CategoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategorisEvent extends CategoryEvent {

   LoadCategorisEvent();

  @override
  List<Object> get props => [];
}