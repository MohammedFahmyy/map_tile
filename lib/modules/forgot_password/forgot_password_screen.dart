import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_tile/modules/forgot_password/cubit/cubit.dart';
import 'package:map_tile/modules/forgot_password/cubit/states.dart';
import 'package:map_tile/shared/components/components.dart';

import '../../shared/styles/colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    var eController = TextEditingController();
    return BlocProvider(
      create: (context) => ForgotPasswordCubit(),
      child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ForgotPasswordCubit.get(context);
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Enter your e-mail and a verification link will be sent to you",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[700],
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    defaultTextFormField(
                      text: "E-mail Address",
                      TEController: eController,
                      validator: (validator) {
                        return "";
                      },
                      onChange: (value) {
                        return null;
                      },
                      prefixIcon: const Icon(Icons.email),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ConditionalBuilder(
                      condition: !cubit.loading,
                      builder: (context) {
                        return defaultButton(
                          background: secondarySwatch,
                          height: 50,
                          text: "Reset",
                          function: () {
                            cubit.toggleLoading();
                            FirebaseAuth.instance
                                .sendPasswordResetEmail(email: eController.text)
                                .then((value) {
                              showToast(
                                  message: "Check Your E-mail",
                                  state: ToastState.SUCCESS);
                              cubit.toggleLoading();
                              Navigator.pop(context);
                            }).catchError((onError) {
                              showToast(
                                  message: onError.toString(),
                                  state: ToastState.ERROR);
                                  cubit.toggleLoading();
                            });

                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                        );
                      },
                      fallback: (context) =>
                          const Center(child: CircularProgressIndicator()),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
