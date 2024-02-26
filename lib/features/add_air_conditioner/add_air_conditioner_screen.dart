import 'package:air_conditioning_system/core/widgets/custom_button.dart';
import 'package:air_conditioning_system/core/widgets/custom_loading_indicator.dart';
import 'package:air_conditioning_system/core/widgets/custom_text_field.dart';
import 'package:air_conditioning_system/features/add_air_conditioner/cubit/cubit/add_air_conditioner_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAirConditionerScreen extends StatefulWidget {
  const AddAirConditionerScreen({super.key});

  @override
  State<AddAirConditionerScreen> createState() =>
      _AddAirConditionerScreenState();
}

class _AddAirConditionerScreenState extends State<AddAirConditionerScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddAirConsditionerCubit(),
      child: BlocConsumer<AddAirConsditionerCubit, AddAirConditionerState>(
        listener: (context, state) {
          if (state is AddAirConditionerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
              ),
            );
          } else if (state is AddAirConditionerSuccess) {
            nameController.text = '';
            priceController.text = '';
            capacityController.text = '';
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم الاضافة بنجاح'),
              ),
            );
          }
        },
        builder: (context, state) {
          AddAirConsditionerCubit cubit =
              context.read<AddAirConsditionerCubit>();
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('اضافة تكييف'),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => cubit.uploadImage(),
                      child: Container(
                        width: double.infinity,
                        height: 300.0,
                        color: Colors.grey.shade400,
                        child: cubit.imageFile == null
                            ? Icon(
                                Icons.image,
                                size: 100.0,
                                color: Colors.grey.shade800,
                              )
                            : Image.file(
                                cubit.imageFile!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: nameController,
                              hintText: 'أدخل اسم التكييف',
                              errorMsg: 'أدخل اسم التكييف',
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            CustomTextField(
                              controller: priceController,
                              hintText: 'أدخل سعر التكييف',
                              errorMsg: 'أدخل سعر التكييف',
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            CustomTextField(
                              controller: capacityController,
                              hintText: 'أدخل سعة التكييف',
                              errorMsg: 'أدخل سعة التكييف',
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: state is AddAirConditionerLoading
                                  ? const Center(
                                      child: CustomLoadingIndicator(),
                                    )
                                  : CustomButton(
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          cubit.addAirConditioner(
                                            name: nameController.text,
                                            price: priceController.text,
                                            capacity: capacityController.text,
                                          );
                                        }
                                      },
                                      text: 'إضافة التكييف',
                                    ),
                            )
                          ],
                        ),
                      ),
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
