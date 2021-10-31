import 'package:election_exit_poll_620710115/pages/candidates_result.dart';
import 'package:election_exit_poll_620710115/services/api.dart';
import 'package:election_exit_poll_620710115/services/candidates_list.dart';
import 'package:flutter/material.dart';

class CandidatesPage extends StatefulWidget {
  static const routeName = "/home";

  const CandidatesPage({Key? key}) : super(key: key);

  @override
  _CandidatesPageState createState() => _CandidatesPageState();
}

class _CandidatesPageState extends State<CandidatesPage> {
  Future<List<CandidatesList>>? _candidates;

  @override
  void initState() {
    super.initState();

    _candidates = _loadCandidates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.fill,
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildLogo(),
              _buildDetail(),
              _buildCandidates(),
              _buildButton(),
            ]
          ),
        ),
      ),
    );
  }

  _buildLogo(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Image.asset("assets/images/vote_hand.png", height: 100,),
          const Text("EXIT POLL", style: TextStyle(fontSize: 20, color: Colors.white),),
        ],
      ),
    );
  }

  _buildDetail(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: const [
          Text("เลือกตั้ง อบต.", style: TextStyle(fontSize: 20, color: Colors.white),),
          SizedBox(height: 10,),
          Text("รายชื่อผู้สมัครรับเลือกตั้ง", style: TextStyle(fontSize: 16, color: Colors.white),),
          Text("นายกองค์การบริหารส่วนตำบลเขาพระ", style: TextStyle(fontSize: 16, color: Colors.white),),
          Text("อำเภอเมืองนครนายก จังหวัดนครนายก", style: TextStyle(fontSize: 16, color: Colors.white),),
        ],
      ),
    );
  }

  _buildCandidates(){
    return Expanded(
      child: FutureBuilder<List<CandidatesList>>(
        future: _candidates,
        builder: (context, snapshot){
          if(snapshot.connectionState != ConnectionState.done){
            return const Center(child: CircularProgressIndicator(),);
          }

          if(snapshot.hasError){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("ERROR: ${snapshot.error}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: (){
                      setState(() {
                        _candidates = _loadCandidates();
                      });
                    },
                    child: const Text("RETRY"),
                  ),
                ],
              ),
            );
          }

          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index){
                CandidatesList item = snapshot.data![index];

                return Card(
                  color: Colors.white.withOpacity(0.8),
                  margin: const EdgeInsets.all(8),
                  child: InkWell(
                    onTap: (){
                      _handleClick(index+1);
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                            ),
                            child: Center(
                              child: Text("${item.number}",
                                style: const TextStyle(
                                    fontSize: 30,
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text("${item.title}${item.firstName} ${item.lastName}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  _handleClick(int input) async{
    var score = await Api().submit("exit_poll", {"candidateNumber": input});

    return showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text("SUCCESS"),
          content: Text("บันทึกข้อมูลสำเร็จ ${score.toString()}"),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            )
          ],
        );
      },
    );
  }

  _buildButton(){
    return ElevatedButton(
      onPressed: (){
        Navigator.pushNamed(context, CandidatesResult.routeName);
      },
      child: const Text("ดูผล"),
    );
  }

  Future<List<CandidatesList>> _loadCandidates() async{
    List list = await Api().fetch("exit_poll");
    var candidatesList = list.map((item) => CandidatesList.fromJson(item)).toList();
    return candidatesList;
  }
}
