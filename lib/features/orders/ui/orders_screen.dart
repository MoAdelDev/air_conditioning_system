import 'package:air_conditioning_system/core/widgets/custom_loading_indicator.dart';
import 'package:air_conditioning_system/features/order/data/order_model.dart';
import 'package:air_conditioning_system/features/orders/cubit/orders_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrdersCubit()..getOrders(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('الطلبات'),
          ),
          body: BlocBuilder<OrdersCubit, OrdersState>(
            builder: (context, state) {
              OrdersCubit cubit = context.read<OrdersCubit>();
              return Container(
                color: Colors.grey[300],
                child: ListView.separated(
                  itemCount: cubit.orders.length,
                  itemBuilder: (context, index) {
                    OrderModel orderModel = cubit.orders[index];
                    return Card(
                      shadowColor: Colors.white,
                      surfaceTintColor: Colors.white,
                      child: Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: orderModel.image,
                            width: 100.0,
                            height: 100.0,
                            placeholder: (context, url) => const Center(
                              child: CustomLoadingIndicator(),
                            ),
                            errorWidget: (context, url, error) => const Center(
                              child: CustomLoadingIndicator(),
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  orderModel.name,
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'الكمية : ${orderModel.amount}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const Text(
                                      '  .  ',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                    Text(
                                      '${orderModel.totalPrice} جم',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red[900],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      orderModel.userName,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const Text(
                                      '  .  ',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                    Expanded(
                                      child: Text(
                                        orderModel.address,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'طريقة الدفع : ${orderModel.paymentMethod}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10.0,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
