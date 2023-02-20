import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:map_tile/shared/components/components.dart';
import 'package:map_tile/shared/styles/colors.dart';

class RegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var fNameController = TextEditingController();
    var lNameController = TextEditingController();
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
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
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
                    height: 30,
                  ),
                  ConditionalBuilder(
                    condition: true,
                    builder: (context) {
                      return defaultButton(
                        background: secondarySwatch,
                        height: 50,
                        text: "Register",
                        function: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                      );
                    },
                    fallback: (context) =>
                        const Center(child: CircularProgressIndicator()),
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
  }
}