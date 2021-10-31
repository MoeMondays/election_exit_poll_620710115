import 'package:election_exit_poll_620710115/services/api.dart';
import 'package:election_exit_poll_620710115/services/candidate_score.dart';
import 'package:flutter/material.dart';

class CandidatesResult extends StatefulWidget {
  static const routeName = "/result";

  const CandidatesResult({Key? key}) : super(key: key);

  @override
  State<CandidatesResult> createState() => _CandidatesResultState();
}

class _CandidatesResultState extends State<CandidatesResult> {
  Future<List<CandidatesScore>>? _candidates;

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
          Text("RESULT", style: TextStyle(fontSize: 30, color: Colors.white),),
        ],
      ),
    );
  }

  _buildCandidates(){
    return Expanded(
      child: FutureBuilder<List<CandidatesScore>>(
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
                CandidatesScore item = snapshot.data![index];

                return Card(
                  color: Colors.white.withOpacity(0.8),
                  margin: const EdgeInsets.all(8),
                  child: InkWell(
                    onTap: (){

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
                        Expanded(
                          child: Text("${item.title}${item.firstName} ${item.lastName}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text("${item.score}",
                            style: const TextStyle(fontSize: 16),
                          ),
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

  Future<List<CandidatesScore>> _loadCandidates() async{
    List list = await Api().fetch("exit_poll/result");
    var candidatesScore = list.map((item) => CandidatesScore.fromJson(item)).toList();
    return candidatesScore;
  }
}
