import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:real_estate/theme/color.dart';
import 'package:real_estate/utils/globals.dart' as global;

class PolicyPage extends StatefulWidget {
  @override
  _PolicyPageState createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> {
  Future<void> _agreePolicy() async {
    Map<String, String> formData = {
      "phone": global.phone,
    };

    final response = await http.post(
        Uri.parse('https://properties-api.myspacetech.in/ver1/agreepolicy/'),
        body: formData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(alignment: Alignment.bottomCenter, children: [
      SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: Text(
              "Terms of Service",
              style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'RobotoSlab',
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus dictum at nunc condimentum placerat. Nullam vitae dignissim urna. Nullam volutpat mauris enim, eget imperdiet ligula finibus vel. Integer vel enim accumsan, imperdiet magna sit amet, semper justo. Nulla facilisis diam in euismod gravida. Maecenas tincidunt nulla vitae luctus gravida. Nam fermentum neque a posuere tincidunt. Suspendisse risus ante, finibus quis tincidunt ac, ullamcorper vel mauris. Nulla dictum semper est. Nullam mollis, leo at tristique varius, purus urna pretium est, vitae venenatis mi nunc pharetra leo.",
              style: TextStyle(
                fontSize: 17.5,
                height: 1.3,
                fontFamily: 'RobotoSlab',
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: Text(
              "Cras nunc lorem, fermentum ac massa et, porta placerat ipsum. Etiam tempor suscipit lorem eleifend sagittis. Nullam laoreet nunc ac justo posuere, in auctor augue molestie. Maecenas tristique consequat magna non consectetur. Vestibulum volutpat nunc ut sapien cursus, eget elementum orci egestas. Quisque fermentum congue volutpat. Nunc ante ipsum, mattis ut enim at, ornare ullamcorper nisi. Ut sit amet neque eget mauris lobortis consectetur. Nam eu iaculis tellus. Vivamus pellentesque elementum urna id feugiat. Donec id semper ex, ac feugiat magna. Duis semper luctus tempor. Nunc vulputate non velit ut interdum. Donec ultricies efficitur hendrerit. Etiam malesuada nec neque quis fermentum.",
              style: TextStyle(
                fontSize: 17.5,
                height: 1.3,
                fontFamily: 'RobotoSlab',
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      )),
      if (!global.policyAgree)
        Container(
          width: MediaQuery.of(context).size.width,
          height: 120,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white24, Colors.white60, Colors.white],
                  stops: [0, 0.1, 0.3])),
          child: Column(children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        shadowColor: Colors.black.withOpacity(0.4),
                        padding: const EdgeInsets.all(5)),
                    onPressed: () {
                      _agreePolicy();
                      global.policyAgree = true;
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'I accept',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  )),
                  const SizedBox(width: 20),
                  Expanded(
                      child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary.withOpacity(0.05),
                        elevation: 10, //elevation of button
                        shape: RoundedRectangleBorder(
                            //to set border radius to button
                            borderRadius: BorderRadius.circular(5)),
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.all(
                            5) //content padding inside button
                        ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'I decline',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ))
                ],
              ),
            ),
          ]),
        )
    ]));
  }
}
