// Global instance for easy access of translation
class AppStrings {
  // Private constructor to prevent instantiation
  AppStrings._();

  // App
  static const String appTitle = 'Absences';

  // Absences Page
  static const String absencesTitle = 'Absences';
  static const String absencesRecords = 'Absences Records';
  static const String totalAbsences = 'Total Absences';
  static const String noAbsencesFound = 'No Absences found';
  static const String noAbsencesFoundDesc =
      "Nothing in the Box. We couldn't find what\n you are searching for. Try a different\n keyword?";
  static const String absencesError = 'A Small Issue';
  static const String absencesErrorDesc =
      "Oops! We're tangled. The results you are\n looking for doesn't exist. Our friend here\n got stuck in the yarn.";
  static const String loadMore = 'Load More';
  static const String name = 'Name';
  static const String member = 'Member';
  static const String type = 'Type';
  static const String period = 'Period';
  static const String status = 'Status';
  static const String actions = 'Actions';

  // Filter
  static const String filterTitle = 'Filter Absences';
  static const String absenceType = 'Absence Type';
  static const String statusType = 'Status Type';
  static const String selectAll = 'Select All';
  static const String clearFilters = 'Clear Filters';
  static const String fromDate = 'From Date';
  static const String toDate = 'To Date';
  static const String selectDate = 'Select Date';
  static const String dateRange = 'Date Range';

  // Absence Types
  static const String vacation = 'Vacation';
  static const String sickness = 'Sickness';

  // Absence Status
  static const String requested = 'Requested';
  static const String confirmed = 'Confirmed';
  static const String rejected = 'Rejected';

  // Notes
  static const String memberNote = '"Member Note';
  static const String admitterNote = '"Admitter Note';

  // Helper methods for dynamic strings
  static String totalAbsencesCount(int count) => 'Total Absences: $count';
  static String showResultsCount(String count) => 'Show $count Results';
  static String errorMessage(String message) => 'Error: $message';
}

// Global alias for shorter access
typedef Strings = AppStrings;
