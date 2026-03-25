class AppUser {
  final String id, phone, name;
  final String? email, profileImageUrl;
  final String preferredLanguage;
  const AppUser({required this.id, required this.phone, required this.name, this.email, this.profileImageUrl, this.preferredLanguage = 'en'});
  AppUser copyWith({String? name, String? email, String? profileImageUrl, String? preferredLanguage}) =>
      AppUser(id: id, phone: phone, name: name??this.name, email: email??this.email, profileImageUrl: profileImageUrl??this.profileImageUrl, preferredLanguage: preferredLanguage??this.preferredLanguage);
}
