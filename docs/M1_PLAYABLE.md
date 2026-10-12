# Primeiro protótipo de controles — status: código escrito, execução pendente

## Layout pedido pelo criador
A princesa está no **quarto perto da entrada do palácio** (conveniência do protótipo, não lore). A porta inferior do quarto leva ao **mini corredor**. A porta **inferior** do corredor leva ao **jardim**. Retornos sempre possíveis.

```
           [ QUARTO ]
              ↓ ↑
       [ MINI CORREDOR ]
              ↓ ↑
           [ JARDIM ]
```

## Implementação disponível para testar
- `scenes/maps/bedroom.tscn`, `corridor.tscn`, `garden.tscn`.
- `scripts/player.gd`: `CharacterBody2D`, 8 direções, `move_and_slide()`, colisão circular.
- `scripts/prototype_map.gd`: cenário geometricamente desenhado (placeholders), paredes/móveis com colisão, portas e pontos de interação.
- `scripts/game.gd`: coordenação de cena, entradas e saídas, input do teclado e interação por proximidade.
- `scripts/prototype_hud.gd`: indicador de ambiente, dicas e pop-up descritivo de objetos.
- `scripts/mobile_controls.gd`: 4 botões direcionais + ação multitouch para celular; F2 alterna visualização no PC.
- `tests/smoke.gd`: teste headless de existência das cenas, grafo de portas e limites de spawn.

**Sem arte definitiva, NPCs, romance, calendário, salvar/carregar, diálogos ramificados ou lore.** Cama, escrivaninha, quadro e fonte exibem apenas textos de interação.

## Controles
- PC: **WASD ou setas** para andar, **E, espaço ou Enter** para interagir, **Esc** para fechar texto, **F2** para visualizar botões mobile.
- Android: controles direcionais virtuais + botão **A** para interagir/fechar.
- O jogo não atravessa portas automaticamente: aproxime-se e use ação, como qualquer objeto interativo.
- Movimento fica bloqueado ao abrir texto de inspeção.

## Como rodar com Codex/Godot
1. Instalar **Godot 4.7.2** como versão-alvo (conferir compatibilidade da instalação).
2. Clonar o repositório e abrir `project.godot`.
3. Apertar **F5**; personagem começa no quarto. Testar ida e volta até o jardim.
4. Importação headless: `godot --headless --path . --import`.
5. Smoke test: `godot --headless --path . --script res://tests/smoke.gd`.
6. PC: validar colisões, distância de interação, UI e transições.
7. Android: só depois, configurar export templates/SDK e testar em aparelho físico com tela horizontal.

## O que o Codex deve fazer primeiro
**Não implemente features novas**. Rode import/smoke, corrija erros de parser/runtime, teste percurso quarto→corredor→jardim→corredor→quarto e ajuste problemas de controles/colisão. Faça um PR pequeno com relatório e prints quando possível.

## Limitação atual
Não foi possível executar Godot ou exportar builds no ambiente de autoria. **O código foi criado e enviado ao GitHub, mas não é correto afirmar que já foi compilado ou jogado**. O teste smoke também está escrito, mas não executado.
