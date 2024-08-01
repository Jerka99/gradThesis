enum UserRole {
  admin,
  driver,
  customer,
}


  UserRole? userRoleFromJson(String? role) {
    switch (role) {
      case "ADMIN":
        return UserRole.admin;
      case "DRIVER":
        return UserRole.driver;
      case "CUSTOMER":
        return UserRole.customer;
      default:
        return null;
    }
  }

Map<String, String>? userRoleToJson(UserRole? role) {
  return {"name": role.toString().split('.').last.toUpperCase()};
}

