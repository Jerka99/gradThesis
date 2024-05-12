enum UserRole {
  admin,
  driver,
  customer,
}


  UserRole? userRoleFromJson(String? role) {
    switch (role) {
      case "admin":
        return UserRole.admin;
      case "driver":
        return UserRole.driver;
      case "customer":
        return UserRole.customer;
      default:
        return null;
    }
  }
