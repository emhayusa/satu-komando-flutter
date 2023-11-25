import 'package:flutter/material.dart';
import 'package:kjm_security/widgets/satpam/list_box.dart';
import 'package:kjm_security/widgets/satpam/list_sampah.dart';
import 'package:kjm_security/widgets/satpam/list_task.dart';

class WorkingInstruction extends StatefulWidget {
  const WorkingInstruction({super.key});

  @override
  State<WorkingInstruction> createState() => _WorkingInstructionState();
}

class _WorkingInstructionState extends State<WorkingInstruction> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Working Instruction'),
          centerTitle: true,
        ),
        body: GridView.builder(
          itemCount: 3,
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          itemBuilder: (context, index) {
            late String title;
            late IconData icon;
            late VoidCallback onTap;

            switch (index) {
              case 0:
                title = "Pengecekan Sampah";
                icon = Icons.landslide;
                onTap = () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListSampah()),
                  );
                };
                break;
              case 1:
                title = "Inbound";
                icon = Icons.fire_truck;
                onTap = () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListBox()),
                  );
                };
                break;
              case 2:
                title = "Outbound";
                icon = Icons.fact_check;
                onTap = () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListTask()),
                  );
                };
                break;
            }

            return Material(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(9),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(9),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(icon, size: 50),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
