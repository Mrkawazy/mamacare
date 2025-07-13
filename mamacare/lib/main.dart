import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mamacare/screens/auth/login_screen.dart';
import 'package:mamacare/utils/theme.dart';
import 'models/user.dart';
import 'models/pregnancy.dart';
import 'models/child.dart';
import 'models/health_education.dart';
import 'models/health_facility.dart';
import 'models/emergency.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(PregnancyAdapter());
  Hive.registerAdapter(ChildAdapter());
  Hive.registerAdapter(HealthEducationAdapter());
  Hive.registerAdapter(HealthFacilityAdapter());
  Hive.registerAdapter(EmergencyAdapter());
  
  // Open Hive boxes
  await Hive.openBox<User>('users');
  await Hive.openBox<Pregnancy>('pregnancies');
  await Hive.openBox<Child>('children');
  await Hive.openBox<HealthEducation>('healthEducation');
  await Hive.openBox<HealthFacility>('healthFacilities');
  await Hive.openBox<Emergency>('emergencies');
  await Hive.openBox('settings');
  
  // Initialize notification service
  await NotificationService().initialize();
  
  // Add Zimbabwe-specific sample data
  await _initializeZimbabweData();
  
  runApp(const MamaCareApp());
}

Future<void> _initializeZimbabweData() async {
  final healthEduBox = Hive.box<HealthEducation>('healthEducation');
  final facilitiesBox = Hive.box<HealthFacility>('healthFacilities');
  final emergenciesBox = Hive.box<Emergency>('emergencies');
  final usersBox = Hive.box<User>('users');

  // Add Zimbabwean health education if empty
  if (healthEduBox.isEmpty) {
    await healthEduBox.addAll([
      HealthEducation(
        id: '1',
        title: 'Prenatal Care in Zimbabwe',
        category: 'Pregnancy',
        content: '• Register at clinic before 12 weeks\n• Attend all antenatal visits\n• Take iron and folic acid supplements\n• Sleep under mosquito net\n• Know danger signs (bleeding, severe headache)',
        imageUrl: '',
        createdAt: DateTime.now(),
      ),
      HealthEducation(
        id: '2',
        title: 'Exclusive Breastfeeding',
        category: 'Postnatal',
        content: '• Breastfeed within 1 hour of birth\n• Only breastmilk for first 6 months\n• Feed on demand day and night\n• Continue breastfeeding for 2 years+\n• Get support from clinics if difficulties',
        imageUrl: '',
        createdAt: DateTime.now(),
      ),
      HealthEducation(
        id: '3',
        title: 'Childhood Vaccinations',
        category: 'Child Health',
        content: '• BCG at birth\n• Polio drops at 6, 10, 14 weeks\n• Pentavalent vaccine at 6, 10, 14 weeks\n• Measles vaccine at 9 months\n• Vitamin A supplements every 6 months',
        imageUrl: '',
        createdAt: DateTime.now(),
      ),
    ]);
  }

  // Add Zimbabwean health facilities if empty
  if (facilitiesBox.isEmpty) {
    await facilitiesBox.addAll([
      HealthFacility(
        id: '1',
        name: 'Parirenyatwa Group of Hospitals',
        type: 'Central Hospital',
        latitude: -17.7842,
        longitude: 31.0424,
        address: 'Mazoe Street, Harare',
        phone: '+263242707211',
        services: ['Emergency', 'Maternity', 'Pediatrics', 'Surgery'],
      ),
      HealthFacility(
        id: '2',
        name: 'Harare Central Hospital',
        type: 'Central Hospital',
        latitude: -17.8276,
        longitude: 31.0534,
        address: 'Corner Borrowdale & Mazoe Street, Harare',
        phone: '+263242795181',
        services: ['Emergency', 'Maternity', 'ICU'],
      ),
      HealthFacility(
        id: '3',
        name: 'Chitungwiza Central Hospital',
        type: 'District Hospital',
        latitude: -18.0034,
        longitude: 31.0757,
        address: 'St Mary\'s, Chitungwiza',
        phone: '+263242292000',
        services: ['Maternity', 'Pediatrics', 'HIV Care'],
      ),
      HealthFacility(
        id: '4',
        name: 'Mpilo Central Hospital',
        type: 'Central Hospital',
        latitude: -20.1550,
        longitude: 28.5837,
        address: 'Corner 12th Ave & Fort Street, Bulawayo',
        phone: '+26329276631',
        services: ['Emergency', 'Maternity', 'Oncology'],
      ),
    ]);
  }

  // Add Zimbabwe emergency contacts if empty
  if (emergenciesBox.isEmpty) {
    await emergenciesBox.addAll([
      Emergency(
        id: '1',
        name: 'National Ambulance',
        phone: '994',
        type: 'Ambulance',
      ),
      Emergency(
        id: '2',
        name: 'Police Emergency',
        phone: '995',
        type: 'Police',
      ),
      Emergency(
        id: '3',
        name: 'Civil Protection Unit',
        phone: '996',
        type: 'Disaster',
      ),
      Emergency(
        id: '4',
        name: 'Childline Zimbabwe',
        phone: '116',
        type: 'Child Protection',
      ),
    ]);
  }

  // Add default admin and superuser accounts if empty
  if (usersBox.isEmpty) {
    await usersBox.addAll([
      User(
        id: 'super1',
        name: 'Super User',
        email: 'super@mamacare.co.zw',
        phone: '+263772000001',
        password: 'Super@123',
        role: UserRole.superuser,
        createdAt: DateTime.now(),
      ),
      User(
        id: 'admin1',
        name: 'Admin User',
        email: 'admin@mamacare.co.zw',
        phone: '+263772000002',
        password: 'Admin@123',
        role: UserRole.admin,
        createdAt: DateTime.now(),
        createdBy: 'super1',
      ),
    ]);
  }
}

class MamaCareApp extends StatelessWidget {
  const MamaCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MamaCare Zimbabwe',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const LoginScreen(),
    );
  }
}