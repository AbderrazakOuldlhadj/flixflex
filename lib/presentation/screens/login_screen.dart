import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:movie_app/utils/constants.dart';
import 'package:movie_app/utils/strings.dart';

import '../../bloc/login/login_cubit.dart';
import '../../bloc/login/login_states.dart';
import '../components/components.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = "/login";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (ctx, state) {
          if (state is RegisterErrorState) {
            showToast(state.error);
          }
          if (state is LoginErrorState) {
            showToast(state.error);
          }
          if (state is RegisterSuccessState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          }
          if (state is LoginSuccessState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          }
        },
        builder: (ctx, state) {
          LoginCubit cubit = LoginCubit.get(ctx);
          return Scaffold(
            appBar: AppBar(),
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Image.asset(
                            appIcon,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(cubit.isLogin ? "Login" : "Register",
                            style: titleTextStyle),
                        const SizedBox(height: 20),
                        Text(
                          "${cubit.isLogin ? AppStrings.kLogin : AppStrings.kRegister} ${AppStrings.knowToChillWithTheNewestMovies}",
                          style: subTitleTextStyle,
                        ),
                        const SizedBox(height: 40),
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: primaryColor,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.email_outlined,
                                    color: Colors.grey,
                                  ),
                                  hintText: AppStrings.kEmailAddress,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: primaryColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty || !value.contains("@")) {
                                    return AppStrings.kInvalidEmail;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: passwordController,
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: primaryColor,
                                obscureText: cubit.isObscure,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.lock_outline,
                                    color: Colors.grey,
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () =>
                                        cubit.setObscure(!cubit.isObscure),
                                    child: Icon(
                                      cubit.isObscure
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  hintText: AppStrings.kPassword,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: primaryColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.length < 6) {
                                    return AppStrings.kpasswordMustHave6Characters;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              InkWell(
                                child: state is! LoginLoadState
                                    ? Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Text(
                                            cubit.isLogin
                                                ? AppStrings.kLogin
                                                : AppStrings.kRegister,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        ),
                                      )
                                    : const CircularProgressIndicator(
                                        color: primaryColor,
                                      ),
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    if (cubit.isLogin) {
                                      cubit.userLogin(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );
                                    } else {
                                      cubit.userRegister(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              !cubit.isLogin
                                  ? AppStrings.kDontHaveAnAccount
                                  : AppStrings.kIAlreadyHaveAnAccount,
                              style: const TextStyle(fontSize: 16),
                            ),
                            InkWell(
                              onTap: () => cubit.toggleLoginRegister(),
                              child: Text(
                                !cubit.isLogin ? " ${AppStrings.kLogin}" : " ${AppStrings.kRegister}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
