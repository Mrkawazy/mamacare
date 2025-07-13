class AppConstants {
  static const String appName = 'MamaCare Zimbabwe';
  static const String appVersion = '1.0.0';
  
  // Zimbabwe provinces
  static const List<String> provinces = [
    'Bulawayo',
    'Harare',
    'Manicaland',
    'Mashonaland Central',
    'Mashonaland East',
    'Mashonaland West',
    'Masvingo',
    'Matabeleland North',
    'Matabeleland South',
    'Midlands',
  ];

  // Zimbabwe vaccination schedule
  static const Map<String, String> vaccinationSchedule = {
    'At Birth': 'BCG, OPV-0',
    '6 Weeks': 'OPV-1, Pentavalent-1, PCV-1, Rota-1',
    '10 Weeks': 'OPV-2, Pentavalent-2, PCV-2, Rota-2',
    '14 Weeks': 'OPV-3, Pentavalent-3, PCV-3',
    '9 Months': 'Measles 1, Yellow Fever',
    '18 Months': 'Measles 2',
  };

  // Pregnancy milestones
  static const Map<int, String> pregnancyMilestones = {
    4: 'First antenatal visit',
    12: 'First trimester screening',
    20: 'Anatomy scan',
    24: 'Glucose screening',
    28: 'Rh factor test',
    36: 'Group B strep test',
  };

  // Supported languages
  static const List<String> languages = ['English', 'Shona', 'Ndebele'];
}