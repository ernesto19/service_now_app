import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:service_now/features/appointment/data/datasources/appointment_remote_data_source.dart';
import 'package:service_now/features/appointment/data/repositories/appointment_repository_impl.dart';
import 'package:service_now/features/appointment/domain/repositories/appointment_repository.dart';
import 'package:service_now/features/appointment/domain/usecases/get_business_by_category.dart';
import 'package:service_now/features/appointment/domain/usecases/get_comments_by_business.dart';
import 'package:service_now/features/appointment/domain/usecases/get_galleries_by_business.dart';
import 'package:service_now/features/appointment/presentation/bloc/select_business/bloc.dart';
import 'package:service_now/features/home/data/datasources/home_remote_data_source.dart';
import 'package:service_now/features/home/data/repositories/home_repository_impl.dart';
import 'package:service_now/features/home/domain/repositories/home_repository.dart';
import 'package:service_now/features/home/domain/usecases/get_permissions_by_user.dart';
import 'package:service_now/features/home/domain/usecases/update_local_category.dart';
import 'package:service_now/features/home/presentation/bloc/bloc.dart';
import 'package:service_now/features/home/presentation/bloc/membership/bloc.dart';
import 'package:service_now/features/home/presentation/bloc/menu/menu_bloc.dart';
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
import 'features/appointment/domain/usecases/payment_services_by_user.dart';
import 'features/appointment/domain/usecases/request_business_by_user.dart';
import 'features/appointment/presentation/bloc/bloc.dart';
import 'features/appointment/presentation/bloc/payment_services/bloc.dart';
import 'features/home/data/datasources/home_local_data_source.dart';
import 'features/home/domain/usecases/acquire_membership_by_user.dart';
import 'features/home/domain/usecases/get_categories_by_user.dart';
import 'features/home/domain/usecases/get_membership_by_user.dart';
import 'features/home/domain/usecases/get_messages_by_user.dart';
import 'features/home/domain/usecases/log_out_by_user.dart';
import 'features/home/presentation/bloc/message/bloc.dart';
import 'features/login/domain/usecases/authentication.dart';
import 'features/login/domain/usecases/authentication_by_facebook.dart';
import 'features/professional/domain/usecases/delete_image_by_professional.dart';
import 'features/professional/domain/usecases/get_create_service_form.dart';
import 'features/professional/domain/usecases/get_industries.dart';
import 'features/professional/domain/usecases/register_business_by_professional.dart';
import 'features/professional/domain/usecases/register_service_by_professional.dart';
import 'features/professional/domain/usecases/request_response_by_professional.dart';
import 'features/professional/domain/usecases/update_business_by_professional.dart';
import 'features/professional/domain/usecases/update_service_by_professional.dart';
import 'features/professional/presentation/bloc/pages/gallery/bloc.dart';


final sl = GetIt.instance;

Future<void> init() async {
  // [ Blocs ]
  sl.registerFactory(
    () => HomeBloc(
      categories: sl(),
      updateCategory: sl()
    )
  );

  sl.registerFactory(
    () => MembershipBloc(
      acquireMembership: sl(),
      getMembership: sl()
    )
  );

  sl.registerFactory(
    () => MessageBloc(
      getMessages: sl()
    )
  );
  
  sl.registerFactory(
    () => MenuBloc(
      permissions: sl(),
      logOut: sl()
    )
  );

  sl.registerFactory(
    () => AppointmentBloc(
      business: sl(),
      galleries: sl(),
      comments: sl(),
      requestBusiness: sl()
    )
  );

  sl.registerFactory(
    () => SelectBusinessBloc(
      requestBusiness: sl()
    )
  );

  sl.registerFactory(
    () => PaymentServicesBloc(
      paymentServices: sl()
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
      updateBusiness: sl(),
      createServiceForm: sl(),
      registerService: sl(),
      updateService: sl(),
      updateBusinessStatus: sl(),
      responseRequest: sl(),
      deleteImage: sl()
    )
  );

  sl.registerFactory(
    () => GalleryBloc(
      deleteImage: sl()
    )
  );

  // [ Use cases ]
  sl.registerLazySingleton(() => GetCategoriesByUser(sl()));
  sl.registerLazySingleton(() => UpdateLocalCategory(sl()));
  sl.registerLazySingleton(() => AcquireMembershipByUser(sl()));
  sl.registerLazySingleton(() => GetPermissionsByUser(sl()));
  sl.registerLazySingleton(() => LogOutByUser(sl()));
  sl.registerLazySingleton(() => GetMessagesByUser(sl()));
  sl.registerLazySingleton(() => GetMembershipByUser(sl()));

  sl.registerLazySingleton(() => GetBusinessByCategory(sl()));
  sl.registerLazySingleton(() => GetGalleriesByBusiness(sl()));
  sl.registerLazySingleton(() => GetCommentsByBusiness(sl()));
  sl.registerLazySingleton(() => RequestBusinessByUser(sl()));
  sl.registerLazySingleton(() => PaymentServicesByUser(sl()));

  sl.registerLazySingleton(() => Authentication(sl()));
  sl.registerLazySingleton(() => AuthenticationByFacebook(sl()));
  sl.registerLazySingleton(() => Registration(sl()));

  sl.registerLazySingleton(() => GetProfessionalBusinessByProfessional(sl()));
  sl.registerLazySingleton(() => GetProfessionalServicesByProfessional(sl()));
  sl.registerLazySingleton(() => GetIndustries(sl()));
  sl.registerLazySingleton(() => RegisterBusinessByProfessional(sl()));
  sl.registerLazySingleton(() => UpdateBusinessByProfessional(sl()));
  sl.registerLazySingleton(() => GetCreateServiceForm(sl()));
  sl.registerLazySingleton(() => RegisterServiceByProfessional(sl()));
  sl.registerLazySingleton(() => UpdateServiceByProfessional(sl()));
  sl.registerLazySingleton(() => UpdateBusinessStatusByProfessional(sl()));
  sl.registerLazySingleton(() => RequestResponseByProfessional(sl()));

  sl.registerLazySingleton(() => DeleteImageByProfessional(sl()));

  // [ Repository ]
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
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
      localDataSource: sl(),
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
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(client: sl())
  );

  sl.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSourceImpl(sharedPreferences: sl())
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