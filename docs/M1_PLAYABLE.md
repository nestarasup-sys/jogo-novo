# Primeiro protótipo de controles — validação local concluída; Android físico pendente

## Layout pedido pelo criador
A princesa está no **quarto perto da entrada do palácio** (conveniência do protótipo, não lore). A porta inferior do quarto leva ao **mini corredor**. A porta **inferior** do corredor leva ao **jardim**. Retornos sempre possíveis.

```
           [ QUARTO ]
              ↓ ↑
       [ MINI CORREDOR ]
              ↓ ↑
           [ JARDIM ]
```

## Implementação validada localmente
- `scenes/maps/bedroom.tscn`, `corridor.tscn`, `garden.tscn`.
- `scripts/player.gd`: `CharacterBody2D`, 8 direções, `move_and_slide()`, colisão circular.
- `scripts/prototype_map.gd`: cenário geometricamente desenhado (placeholders), paredes/móveis com colisão, portas e pontos de interação.
- `scripts/game.gd`: coordenação de cena, entradas e saídas, input do teclado e interação por proximidade.
- `scripts/prototype_hud.gd`: indicador de ambiente, dicas e pop-up descritivo de objetos.
- `scripts/mobile_controls.gd`: 4 botões direcionais + ação multitouch para celular; F2 alterna visualização no PC.
- `tests/smoke.gd`: teste headless de existência das cenas, grafo de portas e limites de spawn.

O smoke foi ampliado para exercitar o protótipo em execução, sem adicionar sistemas ou conteúdo fora do escopo.

## Integração da protagonista — 12/10/2026

- Sprites oficiais copiados para `assets/characters/princess/` e carregados em `AnimatedSprite2D` com `SpriteFrames`.
- `idle` mantém a pose parada; `walk` usa `walk_01 → walk_02 → walk_03 → walk_02` em loop a 7 FPS; `blink` e `look_back` retornam à pose parada ao terminar.
- Enquanto está parada, um temporizador aleatório de 3–6 segundos escolhe uma expressão; piscar tem prioridade de 85%. Movimentar cancela a expressão pendente e retorna imediatamente a `idle` ao soltar o controle.
- Os sprites direcionais específicos ainda não existem. O protótipo usa a caminhada genérica nos oito sentidos e só espelha horizontalmente para a esquerda; não gira nem inverte verticalmente o desenho. O código aceita futuramente animações `walk_up`, `walk_down`, `walk_left` e `walk_right` quando houver quadros próprios.
- Escala aplicada: 150 px para a altura total do quadro de 505 px (escala aproximada de 0,297). O conteúdo visível fica perto de 144 px; a base do quadro coincide com a origem do jogador. A sombra segue essa origem e a colisão continua com raio de 16 px nos pés.
- Filtragem linear preserva o tratamento ilustrado. Uma leve contaminação verde nas bordas semitransparentes foi removida dos canais verdes dos PNGs; alfa, canais vermelho/azul e áreas opacas foram preservados.

### Validação das animações

Ambiente: Windows, Godot 4.7.2, projeto importado pelo editor headless e renderer Compatibility/OpenGL no AMD Radeon RX 7600.

- `tests/smoke.gd`: passou com as verificações anteriores de movimentação, colisões, interações e portas, mais sequências/loop/FPS das animações, alinhamento dos pés, escala, filtro, colisão, retorno de blink/look_back e início de expressão aleatória.
- Cena principal executada com renderer gráfico por 120 frames: iniciou e encerrou sem erro.
- Captura de viewport produzida pelo renderer real e inspecionada: protagonista visível no quarto, transparência limpa e escala/alinhamento coerentes. Isso confirma a renderização da pose parada; não equivale a uma sessão manual de teclado.
- A janela gráfica interativa e teclado físico não foram controlados neste ambiente. O smoke exercita os estados e entradas simuladas, mas caminhar visualmente por cada sala continua recomendado no Windows.
- A tarefa não incluiu Android; nenhum aparelho físico foi testado. As pendências gerais de exportação e teste Android continuam abaixo.

**Sem arte definitiva, NPCs, romance, calendário, salvar/carregar, diálogos ramificados ou lore.** Cama, escrivaninha, quadro e fonte exibem apenas textos de interação.

## Controles
- PC: **WASD ou setas** para andar, **E, espaço ou Enter** para interagir, **Esc** para fechar texto, **F2** para visualizar botões mobile.
- Android: controles direcionais virtuais + botão **A** para interagir/fechar.
- O jogo não atravessa portas automaticamente: aproxime-se e use ação, como qualquer objeto interativo.
- Movimento fica bloqueado ao abrir texto de inspeção.

## Resultado dos testes locais

Ambiente: Windows, Godot **4.7.2.stable.official.ed1daf0bf**, runner headless.

- Importação do projeto/editor headless: passou.
- Cena principal por 120 frames: iniciou sem erro de parser ou runtime.
- `tests/smoke.gd`: passou. Cobre spawn no quarto, movimento em eixo, diagonal normalizada, colisão com escrivaninha e limite do mapa, alcance/seleção de interação, abertura/fechamento de janela por ação e Escape, bloqueio e retorno do movimento, quarto → corredor → jardim → corredor → quarto, spawns de portas, dois toques direcionais simultâneos e botão A para abrir/fechar uma interação.
- Os toques foram simulados em um viewport de 1280×720. Isso valida o encaminhamento do `TouchScreenButton` no runner; não substitui a verificação de sensibilidade, legibilidade ou áreas seguras em tela real.
- Não foi feita inspeção visual manual da janela do jogo nem teste com teclado físico. A cena e as ações foram executadas pelo runner headless.

## Reproduzir

Com Godot 4.7.2 disponível como `godot` no terminal, na pasta do projeto:

```powershell
godot --headless --path . --editor --quit
godot --headless --path . --quit-after 120
godot --headless --path . --script res://tests/smoke.gd
```

O último comando deve terminar com `PASS: cena inicial, 8 direções, colisões, proximidade, janelas, portas e multitouch`.

## Testes pendentes em aparelho Android físico

Este ambiente não tem `adb`, Android SDK nem templates de exportação Godot 4.7.2 configurados. APK, instalação e aparelho físico **não foram testados**. Depois de configurar a exportação Android, validar em tela horizontal:

1. Se os quatro direcionais e A aparecem, permanecem legíveis e não ficam sob recortes, barras do sistema ou áreas inseguras; repetir em proporções de tela diferentes.
2. Toque contínuo em cada direção, diagonais com dois dedos, soltar cada dedo e usar A sem deixar movimento preso.
3. Movimento e colisão com móveis/paredes, interação apenas por proximidade, abertura/fechamento do painel por A e retomada do movimento.
4. Percurso quarto → corredor → jardim e retorno até o quarto usando apenas toque.
5. Resposta visual dos botões pressionados, legibilidade do painel e estabilidade ao pausar/retomar o app.

## Próximo passo autorizado

Permanece somente validar este protótipo inicial. Não adicionar NPCs, história, romance, inventário, relógio ou mapas. Os itens Android acima são QA do mesmo recorte.

## Limitação atual

Importação, execução headless, smoke e uma captura visual do renderer estão validados localmente. Não afirmar teste manual de controles em janela, build Android ou aparelho físico; esses itens ainda dependem de interação/hardware.
