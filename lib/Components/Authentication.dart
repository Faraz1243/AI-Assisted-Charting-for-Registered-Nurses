import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

var lst = [
  const Icon(Icons.edit_attributes, color: Colors.white54,),
  const Icon(Icons.edit_attributes, color: Colors.white54,),
  const Icon(Icons.edit_attributes, color: Colors.white54,),
  const Icon(Icons.edit_attributes, color: Colors.white54,),
  const Icon(Icons.edit_attributes, color: Colors.white54,),
  const Icon(Icons.edit_attributes, color: Colors.white54,),
];

var circle = const Icon(Icons.circle, color: Colors.white,);
var slide = const Icon(Icons.edit_attributes, color: Colors.white54,);
int digits = 0;
int pin = 0;

// int height = MediaQuery.

void buttonPress(int n){
  if(digits<6) {
    lst[digits] = circle;
    digits++;
    pin = (pin * 10) + n;
    if(digits==6){
      // check pin
      if (kDebugMode) {
        print('pin : $pin');
        print('hello');
      }
    }
  }


  print('digits: ${digits}');
  print('pin : ${pin}');
}
void backspace(){
  if (digits>0){
    lst[digits-1] = slide;
    digits--;
    pin = pin~/10;
  }

  if (kDebugMode) {
    print('digits: $digits');
    print('pin : $pin');
  }

}


class Authentication extends StatefulWidget {
  Authentication({super.key, required this.title});
  final String title;
  @override
  State<Authentication> createState() => _AuthenticationState();
}
class _AuthenticationState extends State<Authentication> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        color: Colors.blue,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Expanded(
              flex: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'AI Assisted Charting',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sans',
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  lst[0],
                  lst[1],
                  lst[2],
                  lst[3],
                  lst[4],
                  lst[5],
                ],
              ),
            ),

            const SizedBox(height: 10,),
            Expanded(
              flex: 1,
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'Sans',
                ),
              ),
            ),
            // add a grid for keypad
            Expanded(
              flex: 26,
              child: GridView.count(
                crossAxisCount: 3,
                children: [
                  TextButton(
                    onPressed: (){
                      setState(() {
                        buttonPress(1);
                      });
                    },
                    child: const Text(
                      '1',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Sans',
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        buttonPress(2);
                      });
                    },
                    child: const Text(
                      '2',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Sans',
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      setState(() {
                        buttonPress(3);
                      });
                    },
                    child: const Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Sans',
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      setState(() {
                        buttonPress(4);
                      });
                    },
                    child: const Text(
                      '4',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Sans',
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      setState(() {
                        buttonPress(5);
                      });
                    },
                    child: const Text(
                      '5',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Sans',
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      setState(() {
                        buttonPress(6);
                      });
                    },
                    child: const Text(
                      '6',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Sans',
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      setState(() {
                        buttonPress(7);
                      });
                    },
                    child: const Text(
                      '7',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Sans',
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      setState(() {
                        buttonPress(8);
                      });
                    },
                    child: const Text(
                      '8',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Sans',
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      setState(() {
                        buttonPress(9);
                      });
                    },
                    child: const Text(
                      '9',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Sans',
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: (){},
                    child: const Text(
                      '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Sans',
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.pushReplacementNamed(context, '/homeNavigation');
                      setState(() {
                        buttonPress(0);
                      });
                    },
                    child: const Text(
                      '0',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Sans',
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      setState(() {
                        backspace();
                      });
                    },
                    child: const Icon(
                      Icons.backspace_outlined,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}