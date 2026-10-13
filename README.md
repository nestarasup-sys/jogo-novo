> **Polimento M3 em revisão:** melhorias de HUD, layout temporário do quarto, saída e sombra; o tamanho da princesa e o zoom 1.30× estão preservados. Veja [M3_VISUAL_POLISH.md](docs/M3_VISUAL_POLISH.md). A alteração local da colisão norte feita pelo criador deve ser preservada ao sincronizar.\n\n# Jogo Novo — Fundação modular Godot 4.7.2

**Situação:** [PR #5 integrado à main](https://github.com/nestarasup-sys/jogo-novo/pull/5). Quarto, princesa, câmera, HUD, móveis, interações e colisões são componentes editáveis. Importação e smoke foram aprovados no [Windows/Godot 4.7.2](https://github.com/nestarasup-sys/jogo-novo/actions/runs/38335444897). Falta apenas inspeção visual/manual no editor do criador.

## Conceito (sem lore oficial)
RPG social 2D de fantasia imperial, protagonista princesa imperial. Primeiro desenvolvemos para **Windows**. Android fica para uma etapa final. A história e os personagens serão definidos pelo diretor criativo posteriormente.

## Experiência mínima atual
Três lugares conectados: quarto → mini corredor → jardim → retorno, com movimentação, colisões e interações. O foco agora é um **núcleo extensível** para futuras áreas, cenários, móveis e mecânicas, não um quarto decorado ou um sistema de romances prematuro.

[Guia de edição visual na Godot](docs/EDITOR_WORKFLOW.md) — mostra como posicionar móveis, paredes, portas e princesa diretamente no editor.\n\n## Onde mexer na estrutura
| Preciso mudar... | Local |
|---|---|
| Inserir uma nova área | `scenes/rooms/<id>.tscn` + `data/room_catalog.json` |
| Posicionar móveis | `WorldSpace/Furniture` na cena da área |
| Trocar a arte de um móvel | `art_texture` no componente `scripts/world/furniture.gd` |
| Trocar chão/parede | `Visual` com `scripts/world/room_surface.gd` |
| Adicionar porta ou examinável | `Interactions` com `scripts/world/interaction_point.gd` |
| Posicionar entrada de uma área | `Spawns` na cena da área |
| Zoom visual de todo o mundo | `world_zoom` em `scripts/game.gd` |
| Animações/colisão da princesa | `scripts/player.gd` (preservado) |
| Painel e dicas | `scripts/prototype_hud.gd` |

**Todos os móveis, portas, entradas e superfícies devem existir como nós/componentes em cenas, não como coordenadas de uma função gigante.**

## Estrutura
```text
scenes/
  main.tscn
  rooms/
    bedroom.tscn
    corridor.tscn
    garden.tscn
scripts/
  game.gd                 # instancia salas, personagem, câmera e HUD
  player.gd               # protagonista oficial, animação preservada
  prototype_hud.gd        # interface atual
  world/
    room_catalog.gd       # carrega catálogo externo
    room.gd               # limites, spawns e detecção de interação
    room_surface.gd       # piso/parede independentes de colisão
    furniture.gd          # móvel independente com arte e footprint
    interaction_point.gd  # inspeções/portas independentes
    world_camera.gd       # escala visual de mundo
data/
  room_catalog.json
assets/
  characters/princess/    # PNGs oficiais, não substituir
tests/
  smoke.gd
docs/
  ARCHITECTURE.md
  HOW_TO_EXTEND.md
  CURRENT_STATUS.md
```

## Execução e verificação (Windows)
Abra `project.godot` na Godot 4.7.2 e rode a cena principal. Alternativamente, use a instalação Godot configurada no `Jogar.bat`.

```powershell
godot --headless --path . --import
godot --headless --path . --script res://tests/smoke.gd
godot --path .
```

**Validação automática concluída:** Godot 4.7.2 no GitHub Actions Windows — importação e smoke (movimentação física, diagonais, colisões, animação, cenas/portas e zoom) passaram. [Resultado da execução](https://github.com/nestarasup-sys/jogo-novo/actions/runs/38216409346). **Ainda falta inspeção visual e teclado real no PC do criador.**

## Ordem de leitura para agentes
1. [AGENTS.md](AGENTS.md)
2. [Arquitetura atual](docs/ARCHITECTURE.md)
3. [Como ampliar sem retrabalho](docs/HOW_TO_EXTEND.md)
4. [Estado real](docs/CURRENT_STATUS.md)
5. [Decisões](docs/DECISIONS.md)
6. [Roadmap](docs/ROADMAP.md)

Arte de parede/chão e sheets de móveis são **substituíveis**; não ditam o modelo de jogo. Sem implementar lore, NPCs, romance, calendário, saves ou Android nesta etapa.
