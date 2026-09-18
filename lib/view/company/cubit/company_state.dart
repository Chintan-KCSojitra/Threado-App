abstract class CompanyState {}

class CompanyStateData extends CompanyState {
  final String searchText;
  final String? errorMessage;

  CompanyStateData({this.searchText = '', this.errorMessage});

  CompanyStateData copyWith({
    String? searchText,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return CompanyStateData(
      searchText: searchText ?? this.searchText,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}

class CompanyInitialState extends CompanyStateData {}
