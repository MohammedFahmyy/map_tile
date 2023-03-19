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
  var formKey = GlobalKey<FormState>();

  RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var password2Controller = TextEditingController();
    var fNameController = TextEditingController();
    var lNameController = TextEditingController();
    var phoneController = TextEditingController();
    return BlocProvider(
        create: (context) => MapRegisterCubit(),
        child: BlocConsumer<MapRegisterCubit, MapRegisterStates>(
          listener: (context, state) {
            if (state is MapCreateUserSuccessState) {
              showToast(
                  message: "Registerd Successfully", state: ToastState.SUCCESS);
              navigateAndFinish(context, LoginScreen());
            }
            if (state is MapRegisterErrorState) {
              showToast(message: state.error, state: ToastState.ERROR);
            }
            if (state is MapCheckPhoneSuccessState) {
              MapRegisterCubit.get(context).userRegister(
                fname: fNameController.text,
                lname: lNameController.text,
                email: emailController.text,
                phone: phoneController.text,
                password: passwordController.text,
              );
            }
            if (state is MapCheckPhoneErrorState) {
              showToast(message: state.error, state: ToastState.ERROR);
            }
          },
          builder: (context, state) {
            return Scaffold(
              body: Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(35),
                    width: double.maxFinite,
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
                                  TEController: fNameController,
                                  validator: (value) {
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
                                  TEController: lNameController,
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
                            TEController: emailController,
                            prefixIcon: const Icon(Icons.email_outlined),
                            validator: (value) {
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
                            TEController: passwordController,
                            isPassword: true,
                            validator: (value) {
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
                            TEController: password2Controller,
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password is too short";
                              } else if (value != passwordController.text) {
                                print(value);
                                print(passwordController.text);
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
                          ConditionalBuilder(
                            condition:
                                !MapRegisterCubit.get(context).processing,
                            builder: (context) {
                              return defaultButton(
                                background: secondarySwatch,
                                height: 50,
                                text: "Register",
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    MapRegisterCubit.get(context)
                                        .chechPhone(phoneController.text);
                                  }
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
