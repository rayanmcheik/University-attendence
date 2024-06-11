import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String title;
  final IconData iconn;
  final bool t;
  const Input(
      {super.key,
      required this.controller,
      required this.obscureText,
      required this.title,
      required this.iconn,
      required this.t});

  @override
  State<Input> createState() => _InputtState();
}

class _InputtState extends State<Input> {
  bool hide = true;
  void initState() {
    super.initState();
    hide = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:10,left:16,right:16,bottom: 10),
      child: TextField(
        style: TextStyle(color: const Color.fromARGB(255, 8, 8, 8)),
        
        
        controller: widget.controller,
        obscureText: hide,
        onChanged: (value) {
          setState(() {
            widget.controller.text = value;
          });
        },
        decoration: InputDecoration(
            suffixIcon: widget.obscureText == true
                ? InkWell(
                    onTap: () {
                      setState(() {
                        hide = !hide;
                      });
                    },
                    child: Icon(hide == true
                        ? Icons.visibility_off
                        : Icons.visibility_rounded),
                  )
                : null,
             prefixIcon: Icon(widget.iconn),
            label: Text(
              widget.title,
              style: TextStyle(color: Color.fromARGB(255, 26, 26, 26)),
            ),
            errorStyle: TextStyle(color: Colors.red),
            errorText: widget.t ? "Enter proper info" : null,
            
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
            
            ),
      ),
    );
  }
}