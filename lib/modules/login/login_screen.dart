import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_tile/layouts/home_layout/home_layout.dart';
import 'package:map_tile/modules/login/cubit/cubit.dart';
import 'package:map_tile/modules/login/cubit/states.dart';
import 'package:map_tile/modules/register/register_screen.dart';
import 'package:map_tile/shared/components/components.dart';
import 'package:map_tile/shared/networks/local/cache_helper.dart';
import 'package:map_tile/shared/styles/colors.dart';

import '../../shared/constants/constants.dart';
import '../forgot_password/forgot_password_screen.dart';

class LoginScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // Text Field Controllers
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    // Login Bloc Create
    return BlocProvider(
      create: (context) => MapLoginCubit(),
      child: BlocConsumer<MapLoginCubit, MapLoginStates>(
        listener: (context, state) async {
          // Once The Login Attempt Success
          // Save id to Cache then Go to Home
          if (state is MapLoginSuccessState) {
            CacheHelper.saveData(
              key: 'id',
              value: state.id,
            ).then((value) {
              if (true) {
                id = state.id;
                  navigateAndFinish(context, const HomeLayout());
              }
            });
            // In Case Error, Show Error Message
          } else if (state is MapLoginErrorState) {
            showToast(message: state.error, state: ToastState.ERROR);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                Center(
                  // Single child scroll view to prevent pixels error while writing
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(35),
                      width: double.maxFinite,
                      // Form To Check Validity of fields
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Login",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(
                                    color: Colors.black,
                                  ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Login now and connect with friends",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[400],
                                  ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            defaultTextFormField(
                              text: "E-mail Adress",
                              tEController: emailController,
                              prefixIcon: const Icon(Icons.email_outlined),
                              validator: (value) {
                                // Check E-mail validity
                                if (value == null || value.isEmpty) {
                                  return "Email Address can't be empty";
                                }
                                return null;
                              },
                              onChange: (value) {
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            defaultTextFormField(
                              suffixIcon: IconButton(
                                // Make Password Visible
                                  onPressed: () {
                                    MapLoginCubit.get(context)
                                        .togglePasswordVisibiltiy();
                                  },
                                  icon: const Icon(Icons.remove_red_eye)),
                              prefixIcon: const Icon(Icons.lock_outline),
                              text: "Password",
                              tEController: passwordController,
                              isPassword:
                                  MapLoginCubit.get(context).visiblePassword,
                              validator: (value) {
                                // Check Password Validity
                                if (value == null || value.isEmpty) {
                                  return "Password is too short";
                                }
                                return null;
                              },
                              onChange: (value) {
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  // Go to Reset Password
                                  onTap: () {
                                    navigateTo(
                                        context, const ForgotPasswordScreen());
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        color: primarySwatch,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            // Create Progress Indicator While processing
                            ConditionalBuilder(
                              condition: state is! MapLoginLoadingState,
                              builder: (context) {
                                return defaultButton(
                                  background: secondarySwatch,
                                  height: 50,
                                  text: "Login",
                                  function: () {
                                    MapLoginCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                );
                              },
                              fallback: (context) => const Center(
                                  child: CircularProgressIndicator()),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don't have an account?"),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  // Go to Register Screen
                                  onTap: () {
                                    navigateTo(context, RegisterScreen());
                                  },
                                  child: Text(
                                    "REGISTER",
                                    style: TextStyle(
                                        color: primarySwatch,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
