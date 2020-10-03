import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:service_now/features/appointment/data/datasources/appointment_remote_data_source.dart';
import 'package:service_now/features/appointment/data/repositories/appointment_repository_impl.dart';
import 'package:service_now/features/appointment/domain/repositories/appointment_repository.dart';
import 'package:service_now/features/appointment/domain/usecases/get_business_by_category.dart';
import 'package:service_now/features/home/data/datasources/category_remote_data_source.dart';
import 'package:service_now/features/home/data/repositories/category_repository_impl.dart';
import 'package:service_now/features/home/domain/repositories/category_repository.dart';
import 'package:service_now/features/home/domain/usecases/update_local_category.dart';
import 'package:service_now/features/home/presentation/bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/network_info.dart';
import 'features/appointment/presentation/bloc/bloc.dart';
import 'features/home/data/datasources/category_local_data_source.dart';
import 'features/home/domain/usecases/get_categories_by_user.dart';


final sl = GetIt.instance;

Future<void> init() async {
  // [ Blocs ]
  sl.registerFactory(
    () => CategoryBloc(
      categories: sl(),
      updateCategory: sl()
    )
  );

  sl.registerFactory(
    () => AppointmentBloc(
      business: sl()
    )
  );

  // [ Use cases ]
  sl.registerLazySingleton(() => GetCategoriesByUser(sl()));
  sl.registerLazySingleton(() => UpdateLocalCategory(sl()));

  sl.registerLazySingleton(() => GetBusinessByCategory(sl()));

  // [ Repository ]
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(
      networkInfo: sl(), 
      remoteDataSource: sl(), 
      localDataSource: sl()
    )
  );

  sl.registerLazySingleton<AppointmentRepository>(
    () => AppointmentRepositoryImpl(
      remoteDataSource: sl(), 
      networkInfo: sl()
    )
  );

  // [ Data sources ]
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(client: sl())
  );

  sl.registerLazySingleton<CategoryLocalDataSource>(
    () => CategoryLocalDataSourceImpl(sharedPreferences: sl())
  );

  sl.registerLazySingleton<AppointmentRemoteDataSource>(
    () => AppointmentRemoteDataSourceImpl(client: sl())
  );

  // [ Core ]
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // [ External ]
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());

}