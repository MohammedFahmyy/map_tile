import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:map_tile/modules/login/login_screen.dart';
import 'package:map_tile/modules/register/cubit/cubit.dart';
import 'package:map_tile/modules/register/cubit/states.dart';
import 'package:map_tile/shared/components/components.dart';
import 'package:map_tile/shared/styles/colors.dart';

class RegisterScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // Text Fields Controllers
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var password2Controller = TextEditingController();
    var fNameController = TextEditingController();
    var lNameController = TextEditingController();
    var phoneController = TextEditingController();
    // Register Cubit Creation
    return BlocProvider(
        create: (context) => MapRegisterCubit(),
        child: BlocConsumer<MapRegisterCubit, MapRegisterStates>(
          // Using the Register Bloc
          listener: (context, state) {
            // Listen to state
            if (state is MapCreateUserSuccessState) {
              // In case of success (Show Message and Navigate to Login)
              showToast(
                  message: "Registerd Successfully", state: ToastState.SUCCESS);
              navigateAndFinish(context, LoginScreen());
            }
            if (state is MapRegisterErrorState) {
              // If error, show error message
              showToast(message: state.error, state: ToastState.ERROR);
            }
            // Checking if the phone number is unique and create user
            if (state is MapCheckPhoneSuccessState) {
              MapRegisterCubit.get(context).userRegister(
                fname: fNameController.text,
                lname: lNameController.text,
                email: emailController.text,
                phone: phoneController.text,
                password: passwordController.text,
              );
            }
            // If Phone isn't unique show message
            if (state is MapCheckPhoneErrorState) {
              showToast(message: state.error, state: ToastState.ERROR);
            }
          },
          builder: (context, state) {
            return Scaffold(
              body: Center(
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
                            "Register",
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
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: defaultTextFormField(
                                  text: "First Name",
                                  tEController: fNameController,
                                  validator: (value) {
                                    // Check First name validity
                                    if (value == null || value.isEmpty) {
                                      return "First Name can't be empty";
                                    }
                                    return null;
                                  },
                                  onChange: (value) {
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: defaultTextFormField(
                                  text: "Last Name",
                                  tEController: lNameController,
                                  // Check Last name validity
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Last Name can't be empty";
                                    }
                                    return null;
                                  },
                                  onChange: (value) {
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
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
                          IntlPhoneField(
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                            ),
                            initialCountryCode: 'FR',
                            controller: phoneController,
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          defaultTextFormField(
                            prefixIcon: const Icon(Icons.lock_outline),
                            text: "Password",
                            tEController: passwordController,
                            isPassword: true,
                            validator: (value) {
                              // Check Password name validity
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
                            height: 20,
                          ),
                          defaultTextFormField(
                            prefixIcon: const Icon(Icons.lock_outline),
                            text: "Confirm Password",
                            tEController: password2Controller,
                            isPassword: true,
                            validator: (value) {
                              // Check Password name validity
                              if (value == null || value.isEmpty) {
                                return "Password is too short";
                              // Check Passwords are the same
                              } else if (value != passwordController.text) {
                                return "Passwords don't match";
                              }
                              return null;
                            },
                            onChange: (value) {
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          // To Create Loading Indicator while processing
                          ConditionalBuilder(
                            condition:
                                !MapRegisterCubit.get(context).processing,
                            builder: (context) {
                              return defaultButton(
                                background: secondarySwatch,
                                height: 50,
                                text: "Register",
                                function: () {
                                  // If Everything is Valid, Check If phone is unique
                                  if (formKey.currentState!.validate()) {
                                    MapRegisterCubit.get(context)
                                        .chechPhone(phoneController.text);
                                  }
                                  // Auto close Keyboard
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                              );
                            },
                            fallback: (context) => const Center(
                                child: CircularProgressIndicator()),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}
