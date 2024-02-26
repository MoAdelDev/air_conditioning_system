import 'package:air_conditioning_system/core/widgets/custom_button.dart';
import 'package:air_conditioning_system/core/widgets/custom_loading_indicator.dart';
import 'package:air_conditioning_system/core/widgets/custom_text_field.dart';
import 'package:air_conditioning_system/features/add_air_conditioner/data/air_conditioner_model.dart';
import 'package:air_conditioning_system/features/add_spare_parts/data/spare_part_model.dart';
import 'package:air_conditioning_system/features/order/logic/cubit/order_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderScreen extends StatefulWidget {
  final AirConditionerModel? airConditionerModel;
  final SparePartModel? sparePartModel;

  const OrderScreen({
    super.key,
    this.airConditionerModel,
    this.sparePartModel,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isVisa = false;
  double totalPrice = 0.0;
  bool isAirCondtioner() => widget.airConditionerModel != null;
  @override
  void initState() {
    super.initState();
    if (isAirCondtioner()) {
      totalPrice = double.parse(widget.airConditionerModel!.price);
    } else {
      totalPrice = double.parse(widget.sparePartModel!.price);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderCubit(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('شراء التكييف'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    imageUrl: isAirCondtioner()
                        ? widget.airConditionerModel!.image
                        : widget.sparePartModel!.image,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CustomLoadingIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    isAirCondtioner()
                        ? widget.airConditionerModel!.name
                        : widget.sparePartModel!.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        '${isAirCondtioner() ? widget.airConditionerModel!.price : widget.sparePartModel!.price} جم',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const Text(
                        '  .  ',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        isAirCondtioner()
                            ? '${widget.airConditionerModel!.capacity} حصان'
                            : 'ماركة ${widget.sparePartModel!.brandName}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  CustomTextField(
                    controller: addressController,
                    hintText: 'عنوان الشحن',
                    errorMsg: 'أدخل عنوان الشحن',
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  CustomTextField(
                    controller: amountController,
                    hintText: 'الكمية',
                    errorMsg: 'أدخل الكمية',
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onChange: (value) {
                      setState(() {
                        if (isAirCondtioner()) {
                          totalPrice = double.parse(value) *
                              double.parse(widget.airConditionerModel!.price);
                        } else {
                          totalPrice = double.parse(value) *
                              double.parse(widget.sparePartModel!.price);
                        }
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    'طريقة الدفع',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                            value: false,
                            title: const Text('الدفع عند الإستلام'),
                            groupValue: isVisa,
                            activeColor: Colors.blue,
                            onChanged: (value) {
                              setState(() {
                                isVisa = false;
                              });
                            }),
                      ),
                      Expanded(
                        child: RadioListTile(
                            value: true,
                            title: const Text('بطاقة الدغع'),
                            groupValue: isVisa,
                            onChanged: (value) {
                              setState(() {
                                isVisa = true;
                              });
                            }),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: BlocConsumer<OrderCubit, OrderState>(
                      listener: (context, state) {
                        if (state is OrderSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('تم الطلب بنجاح'),
                            ),
                          );
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        }
                        if (state is OrderFailed) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is OrderLoading) {
                          return const CustomLoadingIndicator();
                        }
                        return CustomButton(
                          onPressed: () => context.read<OrderCubit>().order(
                                name: isAirCondtioner()
                                    ? widget.airConditionerModel!.name
                                    : widget.sparePartModel!.name,
                                image: isAirCondtioner()
                                    ? widget.airConditionerModel!.image
                                    : widget.sparePartModel!.image,
                                storeId: isAirCondtioner()
                                    ? widget.airConditionerModel!.storeId
                                    : widget.sparePartModel!.storeId,
                                totalPrice: totalPrice.toString(),
                                amount: amountController.text,
                                address: addressController.text,
                                isVisa: isVisa,
                              ),
                          text: 'دفع ${totalPrice.toString()} جم',
                        );
                      },
                    ),
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
