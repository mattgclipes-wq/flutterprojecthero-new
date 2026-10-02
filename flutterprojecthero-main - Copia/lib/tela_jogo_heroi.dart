import 'package:flutter/material.dart';
import 'tela_de_gameplay_.dart';

class TelaJogoHeroi extends StatefulWidget {
  const TelaJogoHeroi({super.key});

  @override
  State<TelaJogoHeroi> createState() => TelaJogoHeroiState();
}

class TelaJogoHeroiState extends State<TelaJogoHeroi> {
  String nomeHeroi = "";
  String titulo = "";
  String classe = "";

  int vida = 0;
  int moedas = 0;
  int poder = 0;
  int inteligencia = 0;

  String urlImagem = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jogo dos Heróis")),

      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Selecione seu Herói",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => escolhaHeroi("Guerreiro"),
                    child: const Text("Guerreiro"),
                  ),

                  const SizedBox(width: 10),

                  ElevatedButton(
                    onPressed: () => escolhaHeroi("Ladino"),
                    child: const Text("Ladino"),
                  ),

                  const SizedBox(width: 10),

                  ElevatedButton(
                    onPressed: () => escolhaHeroi("Mago"),
                    child: const Text("Mago"),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              if (urlImagem.isNotEmpty)
                Image.asset(
                  urlImagem,
                  width: 200,
                  height: 250,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, size: 100);
                  },
                ),

              const SizedBox(height: 20),

              if (nomeHeroi.isNotEmpty)
                Card(
                  elevation: 5,
                  color: Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          "Nome: $nomeHeroi",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "Título: $titulo",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "Classe: $classe",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Divider(),

                        Text(
                          "❤️ Vida: $vida",
                          style: const TextStyle(fontSize: 18),
                        ),

                        Text(
                          "💰 Moedas: $moedas",
                          style: const TextStyle(fontSize: 18),
                        ),

                        Text(
                          "⚔️ Poder: $poder",
                          style: const TextStyle(fontSize: 18),
                        ),

                        Text(
                          "🧠 Inteligência: $inteligencia",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: nomeHeroi.isEmpty
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TelaDeGameplay(
                              heroi: nomeHeroi,
                              imagem: urlImagem,
                              vida: vida,
                              moedas: moedas,
                              poder: poder,
                              inteligencia: inteligencia,
                            ),
                          ),
                        );
                      },
                child: const Text("Selecionar", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void escolhaHeroi(String tipoHeroi) {
    setState(() {
      if (tipoHeroi == "Guerreiro") {
        classe = "Guerreiro";
        nomeHeroi = "Aldric";
        titulo = "O Cavaleiro de Ferro";
        vida = 180;
        moedas = 350;
        poder = 90;
        inteligencia = 45;
        urlImagem = "assets/guerreiro_sem_fundo_transparente.png";
      } else if (tipoHeroi == "Ladino") {
        classe = "Ladino";
        nomeHeroi = "Kael";
        titulo = "A Sombra Silenciosa";
        vida = 100;
        moedas = 750;
        poder = 110;
        inteligencia = 80;
        urlImagem = "assets/ladino_sem_fundo_transparente.png";
      } else if (tipoHeroi == "Mago") {
        classe = "Mago";
        nomeHeroi = "Eldrin";
        titulo = "O Mestre Arcano";
        vida = 75;
        moedas = 500;
        poder = 130;
        inteligencia = 150;
        urlImagem = "assets/necromante_sem_fundo_transparente.png";
      }
    });
  }
}
