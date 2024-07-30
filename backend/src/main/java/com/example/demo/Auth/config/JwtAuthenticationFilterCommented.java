//package com.example.demo.Auth.config;
//
//import com.example.demo.Auth.services.JwtService;
//import jakarta.servlet.FilterChain;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import lombok.AllArgsConstructor;
//import org.springframework.lang.NonNull;
//import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
//import org.springframework.security.core.Authentication;
//import org.springframework.security.core.context.SecurityContextHolder;
//import org.springframework.security.core.userdetails.UserDetails;
//import org.springframework.security.core.userdetails.UserDetailsService;
//import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
//import org.springframework.stereotype.Component;
//import org.springframework.web.filter.OncePerRequestFilter;
//import org.springframework.web.servlet.HandlerExceptionResolver;
//
//import java.io.IOException;
//
//@AllArgsConstructor
//@Component
//public class JwtAuthenticationFilterCommented extends OncePerRequestFilter {
//    private final HandlerExceptionResolver handlerExceptionResolver;
//
//    private final JwtService jwtService;
//    private final UserDetailsService userDetailsService;
//
//
////    For every request, we want to retrieve the JWT token in the header “Authorization”, and validate it:
////
////    If the token is invalid, reject the request if the token is invalid or continues otherwise.
////    If the token is valid, extract the username, find the related user in the database, and set it in the authentication context so you can access it in any application layer.
////    https://medium.com/@tericcabrel/implement-jwt-authentication-in-a-spring-boot-3-application-5839e4fd8fac
//    @Override
//    //The doFilterInternal method is an overridden method from the OncePerRequestFilter class
//    protected void doFilterInternal(
//            @NonNull HttpServletRequest request,
////            Represents the client's request to the server. It allows you to retrieve information from the request, such as headers, parameters, and body content
//            @NonNull HttpServletResponse response,
////            Represents the server’s response to the client. It allows you to modify the response before it is sent back to the client
//            @NonNull FilterChain filterChain
////            This is a chain of filters that can be used to process the request and response. After your filter performs its operations, it can pass the request and response along to the next filter in the chain using
//    ) throws ServletException, IOException {
//        final String authHeader = request.getHeader("Authorization");
//
//        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
//            filterChain.doFilter(request, response);
//            return;
//        }
//
//        try {
//            final String jwt = authHeader.substring(7);
//            final String userEmail = jwtService.extractUsername(jwt);
//            //IMPORTANT https://docs.spring.io/spring-security/reference/servlet/authentication/architecture.html#servlet-authentication-authentication
////At the heart of Spring Security’s authentication model is the SecurityContextHolder. It contains the SecurityContext.
//            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
////The SecurityContextHolder is where Spring Security stores the details of who is authenticated. Spring Security does not care how the SecurityContextHolder is populated. If it contains a value, it is used as the currently authenticated user.
//            if (userEmail != null && authentication == null) {
//                //this is related to
//                // @Bean
//                //    UserDetailsService userDetailsService() {
//                //        return username -> userRepository.findByEmail(username)
//                //                .orElseThrow(() -> new UsernameNotFoundException("User not found"));
//                //    }
//                UserDetails userDetails = this.userDetailsService.loadUserByUsername(userEmail);
//
//                if (jwtService.isTokenValid(jwt, userDetails)) {
//                    //Next, we create a new Authentication object via UsernamePasswordAuthenticationToken. Spring Security does not care what type of Authentication
//                    //https://docs.spring.io/spring-security/reference/servlet/authentication/architecture.html#servlet-authentication-authentication
//                    // implementation is set on the SecurityContext. This Authentication object is stored in the SecurityContext by SecurityContextHolder.
//                    UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
//                            userDetails,
//                            null,
//                            userDetails.getAuthorities()
//                    );
////It has a single responsibility to convert an instance of HttpServletRequest class into an instance of the WebAuthenticationDetails class. You can think of it as a simple converter.
//                    //https://stackoverflow.com/questions/69816689/what-does-webauthenticationdetailssource
//                    authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
//                    SecurityContextHolder.getContext().setAuthentication(authToken);
//                }
//            }
//
//            filterChain.doFilter(request, response);
//        } catch (Exception exception) {
//            handlerExceptionResolver.resolveException(request, response, null, exception);
////            A try-catch block wraps the logic and uses the HandlerExceptionResolver
////            to forward the error to the global exception handler. We will see how
////            it can be helpful to do the exception forwarding.
//        }
//    }
//}
