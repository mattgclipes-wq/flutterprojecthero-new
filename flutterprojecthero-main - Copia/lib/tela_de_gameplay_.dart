import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class TelaDeGameplay extends StatefulWidget {
  final String heroi;
  final String imagem;
  final int vida;
  final int moedas;
  final int poder;
  final int inteligencia;

  const TelaDeGameplay({
    super.key,
    required this.heroi,
    required this.imagem,
    required this.vida,
    required this.moedas,
    required this.poder,
    required this.inteligencia,
  });

  @override
  State<TelaDeGameplay> createState() => _TelaDeGameplayState();
}

class _TelaDeGameplayState extends State<TelaDeGameplay> {
  double posicaoHorizontal = 40;
  double posicaoVertical = 90;
  static const double tamanhoPocao = 55;
  static const double curaPocao = 25;

  bool viradoParaDireita = true;
  bool pulando = false;
  bool pocaoColetada = false;
  double vidaAtual = 0;
  double larguraTela = 0;
  final FocusNode _focusNode = FocusNode(debugLabel: 'Controles do jogo');
  Timer? _timerMovimento;
  bool esquerdaPressionada = false;
  bool direitaPressionada = false;
  static const double velocidade = 5;

  @override
  void initState() {
    super.initState();
    vidaAtual = widget.vida.toDouble();

    // Atualiza a posição continuamente enquanto uma seta estiver pressionada.
    _timerMovimento = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (!mounted || (!esquerdaPressionada && !direitaPressionada)) return;

      setState(() {
        if (esquerdaPressionada) {
          viradoParaDireita = false;
          posicaoHorizontal = (posicaoHorizontal - velocidade)
              .clamp(0.0, limiteHorizontal)
              .toDouble();
        }
        if (direitaPressionada) {
          viradoParaDireita = true;
          posicaoHorizontal = (posicaoHorizontal + velocidade)
              .clamp(0.0, limiteHorizontal)
              .toDouble();
        }
      });
      verificarColisaoComPocao();
    });
  }

  static const double larguraPersonagem = 150;

  double get limiteHorizontal =>
      (larguraTela - larguraPersonagem).clamp(0.0, double.infinity).toDouble();

  double get posicaoPocaoHorizontal => (larguraTela * 0.60)
      .clamp(0.0, (larguraTela - tamanhoPocao).clamp(0.0, double.infinity))
      .toDouble();

  void verificarColisaoComPocao() {
    // A poção é coletada quando o personagem chega perto dela.
    final posicaoPocao = posicaoPocaoHorizontal;
    final pertoNaHorizontal = (posicaoHorizontal - posicaoPocao).abs() < 100;
    final pertoNaVertical = (posicaoVertical - 90).abs() < 70;

    if (!pocaoColetada && pertoNaHorizontal && pertoNaVertical) {
      setState(() {
        pocaoColetada = true;
        vidaAtual += curaPocao;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você pegou uma poção e recuperou 25 pontos de vida!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void andarParaDireita() {
    setState(() {
      viradoParaDireita = true;
      posicaoHorizontal = (posicaoHorizontal + 40)
          .clamp(0.0, limiteHorizontal)
          .toDouble();
    });
    verificarColisaoComPocao();
  }

  void andarParaEsquerda() {
    setState(() {
      viradoParaDireita = false;
      posicaoHorizontal = (posicaoHorizontal - 40)
          .clamp(0.0, limiteHorizontal)
          .toDouble();
    });
    verificarColisaoComPocao();
  }

  Future<void> pular() async {
    if (pulando) return;
    setState(() => pulando = true);

    // O pulo sempre completa o arco, mesmo se a poção for coletada no ar.
    for (double altura = 100; altura <= 250; altura += 10) {
      await Future.delayed(const Duration(milliseconds: 10));
      if (!mounted) return;
      setState(() => posicaoVertical = altura);
      verificarColisaoComPocao();
    }

    for (double altura = 240; altura >= 90; altura -= 10) {
      await Future.delayed(const Duration(milliseconds: 10));
      if (!mounted) return;
      setState(() => posicaoVertical = altura);
      verificarColisaoComPocao();
    }

    if (!mounted) return;
    setState(() {
      posicaoVertical = 90;
      pulando = false;
    });
    verificarColisaoComPocao();
  }

  KeyEventResult _tratarTecla(FocusNode node, KeyEvent event) {
    final teclaEsquerda = event.logicalKey == LogicalKeyboardKey.arrowLeft;
    final teclaDireita = event.logicalKey == LogicalKeyboardKey.arrowRight;

    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      if (teclaEsquerda) {
        esquerdaPressionada = true;
        return KeyEventResult.handled;
      }
      if (teclaDireita) {
        direitaPressionada = true;
        return KeyEventResult.handled;
      }
      if (event is KeyDownEvent &&
          event.logicalKey == LogicalKeyboardKey.arrowUp) {
        if (!pulando) pular();
        return KeyEventResult.handled;
      }
    }

    if (event is KeyUpEvent) {
      if (teclaEsquerda) {
        esquerdaPressionada = false;
        return KeyEventResult.handled;
      }
      if (teclaDireita) {
        direitaPressionada = false;
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  @override
  void dispose() {
    _timerMovimento?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          larguraTela = constraints.maxWidth;
          return Focus(
            focusNode: _focusNode,
            autofocus: true,
            onKeyEvent: _tratarTecla,
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned.fill(
                  child: Image.network(
                    'https://t4.ftcdn.net/jpg/07/19/26/97/360_F_719269705_L0sglwWqLgB5qs8zM0X4geXGCimf57el.jpg',
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 20,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.heroi,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '❤️ Vida: ${vidaAtual.toInt()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '💰 Moedas: ${widget.moedas}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '⚔️ Poder: ${widget.poder}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '🧠 Inteligência: ${widget.inteligencia}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!pocaoColetada)
                  Positioned(
                    left: posicaoPocaoHorizontal,
                    bottom: 90,
                    child: IgnorePointer(
                      child: Image.asset(
                        'assets/pocao.png',
                        width: tamanhoPocao,
                        height: tamanhoPocao,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.local_drink,
                              size: tamanhoPocao,
                              color: Colors.redAccent,
                            ),
                      ),
                    ),
                  ),
                Positioned(
                  left: posicaoHorizontal,
                  bottom: posicaoVertical,
                  child: Transform.flip(
                    flipX: !viradoParaDireita,
                    // Mantém a altura original de 150 e a largura proporcional
                    // ao asset, como no código inicial do jogo.
                    child: Image.asset(
                      widget.imagem,
                      height: 150,
                      fit: BoxFit.fitHeight,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.broken_image,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 30,
                  child: ElevatedButton(
                    onPressed: andarParaEsquerda,
                    child: const Text('⬅', style: TextStyle(fontSize: 20)),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: pulando ? null : pular,
                      child: const Text('⬆', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  right: 30,
                  child: ElevatedButton(
                    onPressed: andarParaDireita,
                    child: const Text('➡', style: TextStyle(fontSize: 20)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
