class ApiConstants {
  static String baseUrl = "https://track.smart-tech.melbourne/";

  static String userProfile = "https://graph.microsoft.com/v1.0/me/";
  static String taskList = "https://graph.microsoft.com/v1.0/me/todo/lists";

  static String createLog = "${baseUrl}create_log";
  static String createCustomer = "${baseUrl}org_insert_android";
  static String openSession = "${baseUrl}alreadyExist";
  static String breakToggle = "${baseUrl}break_toggle";
  static String endSession = "${baseUrl}endSession";

  //Job service block
  static String getOrganization = "${baseUrl}init";
  static String getSites = "${baseUrl}getSite";
  static String fetchList = "${baseUrl}init";
  static String getSession = "${baseUrl}getSession";
}
