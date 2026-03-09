import 'package:flutter/material.dart';
import '../data/app_data.dart';

class AdminAgentPanel extends StatefulWidget {
  const AdminAgentPanel({super.key});

  @override
  State<AdminAgentPanel> createState() => _AdminAgentPanelState();
}

class _AdminAgentPanelState extends State<AdminAgentPanel> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(title: const Text("Admin Agent Approval")),

      body: ListView.builder(

        itemCount: AppData.agents.length,

        itemBuilder: (context,index){

          final agent = AppData.agents[index];

          return ListTile(

            title: Text(agent.name),

            subtitle: Text(agent.email),

            trailing: agent.approved
                ? const Icon(Icons.check,color: Colors.green)
                : ElevatedButton(

                    child: const Text("Approve"),

                    onPressed: (){

                      setState(() {

                        agent.approved = true;

                      });

                    },

                  ),

          );

        },

      ),

    );

  }
}