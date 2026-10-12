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

Importação, execução headless e smoke estão validados localmente. Não afirmar validação de interface em janela, build Android ou aparelho físico até executar esses testes. O relatório acima distingue os resultados automáticos do que ainda depende de hardware.
