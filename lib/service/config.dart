class Config {
  static Uri user_profile = Uri.parse('https://graph.microsoft.com/v1.0/me/');
  //static Uri user_profile_by_id = Uri.parse('https://graph.microsoft.com/v1.0/me/');
  //static Uri profile_img = Uri.parse('https://graph.microsoft.com/v1.0/me/photo/\$value');
  static Uri taskList = Uri.parse('https://graph.microsoft.com/v1.0/me/todo/lists');
  //static String user_profile_ = 'https://graph.microsoft.com/v1.0/me/';
  //static String profile_img_ = 'https://graph.microsoft.com/v1.0/me/photo/\$value';
}

String BASEURL = "https://track.smart-tech.melbourne/";

class URLHelper {
  //static String get_org = BASEURL + "init";
  static String create_log = BASEURL + "create_log";
  static String create_customer = BASEURL + "org_insert_android";

  //static String open_session = BASEURL + "alreadyExist";
  static String break_toggle = BASEURL + "break_toggle";
  //static String user_login = BASEURL + "user_login";
  static String endSession = BASEURL + "endSession";
}
