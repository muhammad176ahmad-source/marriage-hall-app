import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GenericBookingScreen extends StatefulWidget {
  final String title;
  final List<Map<String,dynamic>> data;
  final String bgImage;

  const GenericBookingScreen({
    super.key,
    required this.title,
    required this.data,
    required this.bgImage
  });

  @override
  State<GenericBookingScreen> createState() => _GenericBookingScreenState();
}

class _GenericBookingScreenState extends State<GenericBookingScreen> with SingleTickerProviderStateMixin{
  String selectedCard = "";
  double scale = 1.0;

  double responsiveWidth(BuildContext context,double p) => MediaQuery.of(context).size.width*p;
  double responsiveHeight(BuildContext context,double p) => MediaQuery.of(context).size.height*p;
  double responsiveFont(BuildContext context,double p) => MediaQuery.of(context).size.width*(p/100);

  void _callAgent(String phone) async {
    final Uri url = Uri(scheme:'tel', path: phone);
    if(await canLaunchUrl(url)) await launchUrl(url);
  }

  Widget _buildCard(String title, IconData icon, Color color){
    return GestureDetector(
      onTap: ()=>setState(()=>selectedCard=title),
      onTapDown: (_) => setState(()=>scale=0.95),
      onTapUp: (_) => setState(()=>scale=1.0),
      onTapCancel: ()=>setState(()=>scale=1.0),
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds:100),
        child: Container(
          width: responsiveWidth(context,0.27),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow:[BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius:12, offset: Offset(0,8))]
          ),
          child: Column(
            children: [
              Icon(icon,color: color,size: responsiveFont(context,8)),
              SizedBox(height:10),
              Text(title,textAlign: TextAlign.center,style: TextStyle(fontSize: responsiveFont(context,4.2), fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataSection(){
    if(selectedCard==""){
      return Center(child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text("Select a card to view details", style: TextStyle(fontSize: responsiveFont(context,4), color: Colors.grey[600])),
      ));
    }

    if(selectedCard=="Hire Agent"){
      final agents = [
        {"name":"Ali Agent","phone":"03007777777"},
        {"name":"Sara Agent","phone":"03008888888"},
      ];
      return Column(
        children: agents.map((a)=>Card(
          margin: EdgeInsets.symmetric(vertical:6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 4,
          child: ListTile(
            leading: Icon(Icons.person,color: Colors.green),
            title: Text(a["name"]!),
            subtitle: Text("Phone: ${a['phone']}"),
            trailing: IconButton(
              icon: Icon(Icons.call,color: Colors.green),
              onPressed: ()=>_callAgent(a['phone']!),
            ),
          ),
        )).toList(),
      );
    }

    return Column(
      children: widget.data.map((d)=>Card(
        margin: EdgeInsets.symmetric(vertical:6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 4,
        child: ListTile(
          leading: Icon(Icons.book_online,color: selectedCard=="Direct Booking"?Colors.blue:Colors.orange),
          title: Text(d["name"]),
          subtitle: Text(d.containsKey("menu") ? "Menu: ${d['menu'].join(', ')}" :
                         d.containsKey("capacity") ? "Capacity: ${d['capacity']}" :
                         d.containsKey("rooms") ? "Rooms: ${d['rooms']}" : ""),
          trailing: selectedCard=="Direct Booking"?ElevatedButton(
            onPressed: ()=>ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${d['name']} booked successfully!"))
            ),
            child: const Text("Book"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ):null,
        ),
      )).toList(),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children:[
              Container(width: double.infinity,height: responsiveHeight(context,0.25),
                decoration: BoxDecoration(image: DecorationImage(image: AssetImage(widget.bgImage), fit: BoxFit.cover)),
              ),
              Container(width: double.infinity,height: responsiveHeight(context,0.25),
                decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.black.withOpacity(0.4), Colors.transparent], begin: Alignment.topCenter, end: Alignment.bottomCenter))
              ),
              Positioned(
                bottom:20,left:20,
                child: Text(widget.title, style: TextStyle(fontSize: responsiveFont(context,7), fontWeight: FontWeight.bold,color: Colors.white)),
              )
            ]
          ),
          SizedBox(height: responsiveHeight(context,0.02)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: responsiveWidth(context,0.05)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCard("Hire Agent", Icons.person_search, Colors.green),
                _buildCard("Direct Booking", Icons.book_online, Colors.blue),
                _buildCard("Available", Icons.info, Colors.orange),
              ],
            ),
          ),
          SizedBox(height: responsiveHeight(context,0.02)),
          Expanded(child: SingleChildScrollView(padding: EdgeInsets.symmetric(horizontal: responsiveWidth(context,0.05)), child: _buildDataSection())),
        ],
      ),
    );
  }
}