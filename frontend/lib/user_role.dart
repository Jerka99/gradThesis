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
