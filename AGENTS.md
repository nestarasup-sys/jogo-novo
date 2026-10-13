# Instruções para agentes (versão editor-first)

## Fonte de verdade
Ler `README.md`, `docs/ARCHITECTURE.md`, `docs/EDITOR_WORKFLOW.md`, `docs/HOW_TO_EXTEND.md` e `docs/CURRENT_STATUS.md`.

## Obrigatório
- Godot 4.7.2; desenvolver e validar **Windows primeiro**; Android na fase final.
- Protagonista imperial e seis PNGs oficiais **não podem ser substituídos** sem aprovação.
- Quarto, corredor e jardim seguem como áreas iniciais. **Sem lore, romance, NPCs, calendário ou outras regiões agora**.
- Priorizar cenas editáveis de verdade: fundo, móveis, marcas de interação, colisões, personagem e HUD **visíveis no editor**.
- Cenas `scenes/rooms/*.tscn` contêm `Visual`, `Boundaries`, `WorldSpace/Furniture`, `Interactions` e `Spawns`.
- Desenho procedural via `@tool` só para pré-visualização; **não criar/free nós do editor dentro de `@tool`**.
- Toda forma de colisão é nó `CollisionShape2D` persistido em cena. `furniture.gd` pode ajustar o tamanho do nó existente.
- `scenes/actors/princess.tscn` contém o AnimatedSprite2D, SpriteFrames, FootCollisionShape2D e câmera. A lógica de movimento permanece em `scripts/player.gd`.
- `scenes/main.tscn` mostra prévia do quarto e princesa. `game.gd` controla trocas de ambientes em execução e **não recria sprite/câmera/HUD**.
- Fazer cada nova área como uma cena; registrar em `data/room_catalog.json`; cada novo móvel como componente independente e selecionável no Inspector.
- Nunca fazer `git reset --hard` ou remover arquivos locais sem checar as mudanças do usuário. Examinar alterações de `project.godot` e `.gd.uid` antes de versionar.
- Validar com importação `--editor --import`, `tests/smoke.gd` e visual/manual no editor Windows; não interpretar HEADLESS como teste visual.
- O PR #3 de JPGs está fechado sem merge e **não deve ser restaurado** por conta própria.

## Estado e entregas
O PR #5 foi integrado à main após testes automáticos Windows/Godot 4.7.2 aprovados. Ainda falta inspeção visual no editor local. Informar commits/PR, arquivos, testes realizados, limitações e riscos. Marcar falha mesmo que o processo retorne 0 se Godot escrever `ERROR:` ou `SCRIPT ERROR:`.
