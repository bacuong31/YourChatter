import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
class PayMentActivity extends StatefulWidget {
  final String planName;
  final int amount;
  final String nameService;

  const PayMentActivity({Key key, this.planName, this.amount, this.nameService}) : super(key: key);
  @override
  _PayMentActivityState createState() => _PayMentActivityState(this.planName,this.amount, this.nameService);
}

class _PayMentActivityState extends State<PayMentActivity> {
  final String planName;
  final int amount;
  final String nameService;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  _PayMentActivityState(this.planName, this.amount, this.nameService);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[appPrimaryColor, appPrimaryColor],
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Thanh toán"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: appPrimaryColor),

                ),
                child: Column(
                  children: [
                    Text("Thông tin thanh toán", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    buildEnableFocusTextField("Họ tên",
                        "Nhập họ tên", nameController),
                    buildEnableFocusTextField("Địa chỉ",
                        "Nhập địa chỉ", addressController),
                    buildNumberTextField("Số điện thoại", "Nhập số điện thoại", phoneNumberController),
                    buildEnableFocusTextField("Email",
                        "Nhập email", emailController),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: appPrimaryColor),

                ),
                child: Container(
                  margin: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Thanh toán",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Expanded(child: SizedBox()),
                          Text(
                            "1",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            nameService,
                            style: TextStyle(
                                fontSize: 16,
                            ),
                          ),
                          Expanded(child: SizedBox()),
                          Text(
                            amount.toString() + " đ",
                            style: TextStyle(
                                fontSize: 16,

                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20,),
                      Divider(
                        height: 1.5,
                        color: Colors.black,
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Tổng",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Expanded(child: SizedBox()),
                          Text(
                            amount.toString() + " đ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                    ],

                  ),
                ),
              ),
              SizedBox(height: 20,),
              Center(
                child: GestureDetector(
                  onTap: (){

                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: appPrimaryColor
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(child: Text("Thanh toán", style: TextStyle(fontSize: 16, color: Colors.white),)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );

  }
  Widget buildEnableFocusTextField(
      String label, String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 16,
            color: Colors.grey.withOpacity(0.3),
          )),
    );

  }
  Widget buildNumberTextField(
      String label, String hint, TextEditingController controller) {
    return TextField(
      keyboardType: TextInputType.number,
      controller: controller,
      decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 16,
            color: Colors.grey.withOpacity(0.3),
          )),
    );

  }
}
