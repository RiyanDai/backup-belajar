sealed class PageConfiguration {
  const PageConfiguration();

  factory PageConfiguration.splash() = SplashPageConfiguration;
  factory PageConfiguration.login() = LoginPageConfiguration;
  factory PageConfiguration.register() = RegisterPageConfiguration;
  factory PageConfiguration.home() = HomePageConfiguration;
  factory PageConfiguration.detail(String id) = DetailStoryPageConfiguration;
  factory PageConfiguration.addStory() = AddStoryPageConfiguration;
  factory PageConfiguration.locationPicker() = LocationPickerPageConfiguration;
  factory PageConfiguration.mapDetail(String id) = MapDetailPageConfiguration;
}

class SplashPageConfiguration extends PageConfiguration {
  const SplashPageConfiguration();
}

class LoginPageConfiguration extends PageConfiguration {
  const LoginPageConfiguration();
}

class RegisterPageConfiguration extends PageConfiguration {
  const RegisterPageConfiguration();
}

class HomePageConfiguration extends PageConfiguration {
  const HomePageConfiguration();
}

class DetailStoryPageConfiguration extends PageConfiguration {
  final String id;
  const DetailStoryPageConfiguration(this.id);
}

class AddStoryPageConfiguration extends PageConfiguration {
  const AddStoryPageConfiguration();
}

class LocationPickerPageConfiguration extends PageConfiguration {
  const LocationPickerPageConfiguration();
}

class MapDetailPageConfiguration extends PageConfiguration {
  final String id;
  const MapDetailPageConfiguration(this.id);
}

