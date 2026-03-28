class OnboardingModel {
  final String titleKey;
  final String subtitleKey;
  final String imageUrl;
  final String? badgeKey;

  OnboardingModel({
    required this.titleKey,
    required this.subtitleKey,
    required this.imageUrl,
    this.badgeKey,
  });
}