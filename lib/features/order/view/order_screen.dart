import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:grocery_app/core/routes/app_router.dart';
import 'package:grocery_app/core/utils/constants/styles/app_color_styles.dart';
import 'package:grocery_app/core/utils/constants/styles/app_text_style.dart';
import 'package:grocery_app/features/order/viewModel/order_viem_model.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderViemModel>(
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(title: const Text("Orders"), centerTitle: true),
        body: viewModel.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(12),
                itemCount: viewModel.orders.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => GoRouter.of(context).push(
                      AppRouteName.orderDetails,
                      extra: viewModel.orders[index].id,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.primaryLight,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primaryLight,
                          radius: 45,
                          child: Icon(
                            FontAwesomeIcons.bagShopping,
                            color: AppColors.primary,
                          ),
                        ),
                        title: Text(
                          "Order ID: ${viewModel.orders[index].orderNumber}",
                          style: AppStyles.textBold15,
                        ),
                        subtitle: Text(
                          "Date: ${viewModel.orders[index].createdAt.toString().substring(0, 10)}",
                          style: AppStyles.textMedium12,
                        ),
                        trailing: Text(
                          viewModel.orders[index].status!,
                          style: AppStyles.textBold15,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
