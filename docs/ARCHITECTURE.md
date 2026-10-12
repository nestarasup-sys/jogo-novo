# Arquitetura v2 — fundação modular implementada em branch de revisão

## Por que mudou
O protótipo inicial criava tudo num `prototype_map.gd`, incluindo pisos, objetos, paredes, colisões e rotas. Esse design não escala. A nova base é orientada a **cenas reutilizáveis com componentes independentes**.

## Dependências (fluxo real)
```text
scenes/main.tscn → game.gd (coordenação)
  ├─ room_catalog.gd → data/room_catalog.json → scenes/rooms/*.tscn
  │     ├─ room.gd (ID, limites e API de interação)
  │     ├─ room_surface.gd (arte do fundo)
  │     ├─ WorldSpace (Y-sort)
  │     │     ├─ Furniture → furniture.gd (arte, footprint, colisão)
  │     │     └─ Player → player.gd (reparentado pelo GameRoot)
  │     ├─ Interactions → interaction_point.gd (dados da ação)
  │     └─ Spawns → Marker2D (pontos de entrada)
  ├─ Player (mesmo objeto persistente entre salas)
  │     └─ Camera2D → world_camera.gd
  └─ HUD (CanvasLayer, escala independente do zoom)
```

## Contratos estáveis
### Catálogo
JSON schema_version=1. Contém `start_room`, `start_spawn` e `rooms` (`room_id: res://scenes/rooms/<name>.tscn`). A classe `room_catalog.gd` valida a presença dos arquivos e resolve PackedScenes. Sem carregar código da internet ou `eval`.

### Room
Cada cena tem `room_id`, `room_title`, `room_size` e nós nomeados `Visual`, `WorldSpace/Furniture`, `Interactions`, `Spawns`. A sala expõe `get_spawn(id)` e `nearest_interaction(position)`. Colisões de paredes externas são construídas pelo componente `room.gd`; a composição interna é editável como nós.

### InteractionPoint
`interaction_type` ∈ `inspect`, `door`; `action_label`; `interaction_radius`; `message` ou `destination_room` + `destination_spawn`. As interações são **dados**, executados apenas por um roteador explícito em `game.gd`. Adicionar um novo tipo requer implementação e teste no roteador — não executar GDScript arbitrário do conteúdo.

### Furniture
`art_texture` (opcional), `art_size`, `art_offset` definem o visual. `footprint_size` define colisão. `is_solid` desliga colisão para tapetes/decorativos. Substituir arte ou mover nós não altera a lógica de interação nem a câmera.

### Câmera
`world_zoom` é escala de renderização (padrão 1.30), com limite atualizado a cada ambiente. Uma única câmera persistente é filha do jogador, e o HUD fica em CanvasLayer separado. Não multiplicar escalas de sprites/objetos para dar zoom.

### World lifecycle
O GameRoot valida cena e spawn antes de substituir a sala, adiciona a nova sala, **reparenta a princesa para o WorldSpace**, posiciona spawn, libera sala anterior e atualiza HUD/câmera. O ator mantém animação e controles, mesmo após transições.

## O que NÃO está implementado
Sistema de diálogo ramificado, save/load, horários, NPCs, reputação, combate, quests ou Android. Módulos futuros só serão escritos quando houver regra aprovada e um teste jogável. Evitar "arquitetura completa" de classes sem função.

## Testabilidade
`tests/smoke.gd` deve assegurar catálogo, cenas e spawns, transições, continuidade da protagonista, animação, interação e câmera. A importação e a inspeção em Godot 4.7.2 Windows são **obrigatórias antes de mesclar**. O repositório não possui teste de engine executado por este assistente nesta refatoração.

## Decisão de migração
`scenes/maps/*.tscn` e `scripts/prototype_map.gd` eram protótipos, substituídos por `scenes/rooms/*.tscn` e componentes. Não depender do formato antigo em novo código. O histórico do Git permite restauração.
