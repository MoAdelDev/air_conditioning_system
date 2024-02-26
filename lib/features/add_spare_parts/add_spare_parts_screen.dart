import 'package:air_conditioning_system/core/widgets/custom_button.dart';
import 'package:air_conditioning_system/core/widgets/custom_loading_indicator.dart';
import 'package:air_conditioning_system/core/widgets/custom_text_field.dart';
import 'package:air_conditioning_system/features/add_spare_parts/cubit/cubit/add_spare_parts_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddSparePartsScreen extends StatefulWidget {
  const AddSparePartsScreen({super.key});

  @override
  State<AddSparePartsScreen> createState() => _AddSparePartsScreenState();
}

class _AddSparePartsScreenState extends State<AddSparePartsScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddSparePartsCubit(),
      child: BlocConsumer<AddSparePartsCubit, AddSparePartsState>(
        listener: (context, state) {
          if (state is AddSparePartsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
              ),
            );
          } else if (state is AddSparePartsSuccess) {
            nameController.text = '';
            priceController.text = '';
            brandController.text = '';
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم الاضافة بنجاح'),
              ),
            );
          }
        },
        builder: (context, state) {
          AddSparePartsCubit cubit = context.read<AddSparePartsCubit>();
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('اضافة قطع غيار'),
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
                              hintText: 'أدخل اسم قطعة الغيار',
                              errorMsg: 'أدخل اسم قطعة الغيار',
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            CustomTextField(
                              controller: priceController,
                              hintText: 'أدخل سعر قطعة الغيار',
                              errorMsg: 'أدخل سعر قطعة الغيار',
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            CustomTextField(
                              controller: brandController,
                              hintText: 'أدخل اسم البراند',
                              errorMsg: 'أدخل اسم البراند ',
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: state is AddSparePartsLoading
                                  ? const Center(
                                      child: CustomLoadingIndicator(),
                                    )
                                  : CustomButton(
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          cubit.addSparePart(
                                            name: nameController.text,
                                            price: priceController.text,
                                            brandName: brandController.text,
                                          );
                                        }
                                      },
                                      text: 'إضافة قطعة الغيار',
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
