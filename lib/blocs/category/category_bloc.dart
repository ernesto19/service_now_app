import 'package:bloc/bloc.dart';
import 'package:service_now/models/category.dart';
import 'category_state.dart';
import 'category_events.dart';
import '../../resources/repository.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  Repository _repository = Repository();

  CategoryBloc() {
    add(CheckDbEvent());
  }
  
  @override
  CategoryState get initialState => CategoryState.initialState;

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    if (event is CheckDbEvent) {
      yield* this._mapCheckDb(event);
    }
  }

  Stream<CategoryState> _mapCheckDb(CheckDbEvent event) async* {
    await Future.delayed(Duration(seconds: 2));
      yield this.state.copyWith(status: CategoryStatus.loading);

      // llamar a api
      // si la respuesta es correcta: yield this.state.copyWith(status: RequestStatus.ready);
      final CategoryResponse serviceResponse = await _repository.getCategories();

      // List<Service> services = List();
      // services.add(Service(id: 1, name: 'Beauty Salon', poster: 'assets/images/beauty_salon.jpeg'));
      // services.add(Service(id: 2, name: 'Barber', poster: 'assets/images/barber.jpg'));
      // services.add(Service(id: 3, name: 'Tire Shop', poster: 'assets/images/tire_shop.jpg'));

      yield this.state.copyWith(status: CategoryStatus.ready, services: serviceResponse.data);

      // yield this.state.copyWith(status: RequestStatus.error);
  }
}