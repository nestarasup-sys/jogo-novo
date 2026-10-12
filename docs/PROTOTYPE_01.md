# Especificação: Protótipo 0.1 (vertical slice)

## Objetivo
Provar que **exploração livre + capítulos condicionais + romance com consequências** funcionam numa experiência curta e persistente. Não é a versão final.

## Conteúdo
- 3 mapas: casa, praça e escola, com colisão e passagens.
- 1 protagonista com nome escolhido.
- 3 NPCs, sendo Lia a rota demonstrativa; outros dois com diálogos/rotinas simples.
- Dia e períodos manhã, tarde e noite; avanço controlado por interação/descanso.
- 1 capítulo com apresentação, conflito e duas resoluções alternativas.
- Menu Novo Jogo/Continuar/Sair.
- Diálogo com retrato provisório, escolha e efeitos de afinidade/confiança/romance/conflito.
- Persistência e load com posição, flags, escolhas e progresso.
- Input teclado e touch paisagem, UI legível em diferentes proporções.

## História demonstrativa (rascunho)
Lia frequenta a praça e lida com uma situação pessoal. Jogador a conhece, pode ganhar confiança, descobre um segredo e escolhe como agir num confronto. Resoluções alternativas: confiança reconstruída ou distanciamento. **Não é roteiro final.**

## Critérios de aceite
- Novo Jogo inicia sem erro; 3 mapas conectados; paredes respeitadas.
- Cada NPC troca de localização nos períodos configurados.
- Ler diálogo pausa movimento/tempo, mas não trava UI.
- Duas escolhas com consequências persistentes levam a resoluções distintas.
- Capítulo não avança apenas ao dormir nem bloqueia permanentemente caso encontro opcional passe.
- Mesmo efeito não aplica duas vezes após fechar/reabrir.
- Save/load reconstitui progresso e posição.
- Build Windows abre e é testado; APK Android horizontal abre e é testado em aparelho real (exigir validação humana).
- Relatório explícito dos testes executados e pendências.

## Não escopo
Simulação detalhada em minutos, estações, multiplayer, combate, agricultura, pesca e comércio complexo.

## Marcos
M1 estrutura e movimento; M2 mapas e interações; M3 relógio e rotinas; M4 diálogos e eventos; M5 relacionamentos e capítulos; M6 saves; M7 interface mobile/exportação; M8 testes e polimento.
