import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:service_now/features/appointment/data/datasources/appointment_remote_data_source.dart';
import 'package:service_now/features/appointment/data/repositories/appointment_repository_impl.dart';
import 'package:service_now/features/appointment/domain/repositories/appointment_repository.dart';
import 'package:service_now/features/appointment/domain/usecases/get_business_by_category.dart';
import 'package:service_now/features/appointment/domain/usecases/get_comments_by_business.dart';
import 'package:service_now/features/appointment/domain/usecases/get_galleries_by_business.dart';
import 'package:service_now/features/home/data/datasources/category_remote_data_source.dart';
import 'package:service_now/features/home/data/repositories/category_repository_impl.dart';
import 'package:service_now/features/home/domain/repositories/category_repository.dart';
import 'package:service_now/features/home/domain/usecases/update_local_category.dart';
import 'package:service_now/features/home/presentation/bloc/bloc.dart';
import 'package:service_now/features/login/data/datasources/login_remote_data_source.dart';
import 'package:service_now/features/login/data/repositories/login_repository_impl.dart';
import 'package:service_now/features/login/domain/repositories/login_repository.dart';
import 'package:service_now/features/login/domain/usecases/registration.dart';
import 'package:service_now/features/login/presentation/bloc/pages/login/login_bloc.dart';
import 'package:service_now/features/login/presentation/bloc/pages/sign_up/bloc.dart';
import 'package:service_now/features/professional/data/datasources/professional_remote_data_source.dart';
import 'package:service_now/features/professional/data/repositories/professional_repository_impl.dart';
import 'package:service_now/features/professional/domain/repositories/professional_repository.dart';
import 'package:service_now/features/professional/domain/usecases/get_business_by_professional.dart';
import 'package:service_now/features/professional/domain/usecases/get_services_by_professional.dart';
import 'package:service_now/features/professional/domain/usecases/update_business_status_by_professional.dart';
import 'package:service_now/features/professional/presentation/bloc/pages/business_register/professional_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/network_info.dart';
import 'features/appointment/presentation/bloc/bloc.dart';
import 'features/home/data/datasources/category_local_data_source.dart';
import 'features/home/domain/usecases/get_categories_by_user.dart';
import 'features/login/domain/usecases/authentication.dart';
import 'features/login/domain/usecases/authentication_by_facebook.dart';
import 'features/professional/domain/usecases/get_create_service_form.dart';
import 'features/professional/domain/usecases/get_industries.dart';
import 'features/professional/domain/usecases/register_business_by_professional.dart';
import 'features/professional/domain/usecases/register_service_by_professional.dart';


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
      business: sl(),
      galleries: sl(),
      comments: sl()
    )
  );

  sl.registerFactory(
    () => LoginBloc(
      login: sl(),
      loginFB: sl()
    )
  );

  sl.registerFactory(
    () => SignUpBloc(
      signin: sl()
    )
  );

  sl.registerFactory(
    () => ProfessionalBloc(
      business: sl(),
      services: sl(),
      industries: sl(),
      registerBusiness: sl(),
      createServiceForm: sl(),
      registerService: sl(),
      updateBusiness: sl()
    )
  );


  // [ Use cases ]
  sl.registerLazySingleton(() => GetCategoriesByUser(sl()));
  sl.registerLazySingleton(() => UpdateLocalCategory(sl()));

  sl.registerLazySingleton(() => GetBusinessByCategory(sl()));
  sl.registerLazySingleton(() => GetGalleriesByBusiness(sl()));
  sl.registerLazySingleton(() => GetCommentsByBusiness(sl()));

  sl.registerLazySingleton(() => Authentication(sl()));
  sl.registerLazySingleton(() => AuthenticationByFacebook(sl()));
  sl.registerLazySingleton(() => Registration(sl()));

  sl.registerLazySingleton(() => GetProfessionalBusinessByProfessional(sl()));
  sl.registerLazySingleton(() => GetProfessionalServicesByProfessional(sl()));
  sl.registerLazySingleton(() => GetIndustries(sl()));
  sl.registerLazySingleton(() => RegisterBusinessByProfessional(sl()));
  sl.registerLazySingleton(() => GetCreateServiceForm(sl()));
  sl.registerLazySingleton(() => RegisterServiceByProfessional(sl()));
  sl.registerLazySingleton(() => UpdateBusinessByProfessional(sl()));

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

  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(
      remoteDataSource: sl(), 
      networkInfo: sl()
    )
  );

  sl.registerLazySingleton<ProfessionalRepository>(
    () => ProfessionalRepositoryImpl(
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

  sl.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSourceImpl(client: sl())
  );

  sl.registerLazySingleton<ProfessionalRemoteDataSource>(
    () => ProfessionalRemoteDataSourceImpl(client: sl())
  );

  // [ Core ]
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // [ External ]
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());

}