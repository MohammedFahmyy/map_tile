import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:map_tile/modules/register/register_screen.dart';
import 'package:map_tile/shared/components/components.dart';
import 'package:map_tile/shared/styles/colors.dart';

class LoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    return Scaffold(
      body: Stack(
        children: [
          Center(
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
                        "Login",
                        style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                              color: Colors.black,
                            ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Login now and connect with friends",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[400],
                            ),
                      ),
                      const SizedBox(
                        height: 40,
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
                        suffixIcon: IconButton(
                            onPressed: (){},
                            icon: const Icon(Icons.remove_red_eye)),
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
                        height: 30,
                      ),
                      ConditionalBuilder(
                        condition: true,
                        builder: (context) {
                          return defaultButton(
                            background: secondarySwatch,
                            height: 50,
                            text: "Login",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
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
  }
}
