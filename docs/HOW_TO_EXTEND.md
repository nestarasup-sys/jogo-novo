# Procedimentos de extensão — instruções para assistente/agentes

O dono do jogo não precisa codar nem decorar nomes. Este documento é um contrato técnico para manter o projeto fácil de expandir.

## 1. Nova área
1. Duplicar uma cena existente de `scenes/rooms/`.
2. Salvar como `scenes/rooms/<id>.tscn`, atualizar `room_id`, `room_title` e `room_size`.
3. Ajustar `Visual` (chão, parede, cores e texturas) no Inspector.
4. Mover/duplicar objetos de `WorldSpace/Furniture` e entradas de `Spawns`.
5. Adicionar portas em `Interactions` com `destination_room` e `destination_spawn`.
6. Adicionar registro de `id` → `res://scenes/rooms/<id>.tscn` em `data/room_catalog.json`.
7. Atualizar teste do grafo no `tests/smoke.gd` e validar volta e ida sem teleporte para colisões.

**Não editar `game.gd` para adicionar a nova área.**

## 2. Novo móvel ou objeto de decoração
1. Duplicar nó de `WorldSpace/Furniture` na cena.
2. Atribuir sprite PNG transparente em `art_texture`.
3. Ajustar `art_size` e `art_offset` para a base do móvel encostar visualmente no chão.
4. Configurar `footprint_size` pequeno e coerente com os pés/área ocupada do objeto; testar colisão com a princesa.
5. Tapete ou objeto atravessável: `is_solid = false`.
6. Para torná-lo examinável, adicionar um Marker2D com `interaction_point.gd` dentro de `Interactions`.

Sem recortes dependentes do código. Quando for o momento de integrar a sheet, recortar os móveis em PNGs e apontar `art_texture`. **Não recortar sheet agora**.

## 3. Trocar o piso e parede
- Ajustar `floor_texture` e `wall_texture` do nó `Visual` de qualquer área.
- Ajustar `wall_height` (0 para ambientes abertos) e cores alternativas se necessário.
- Não alterar física, cena principal ou código da princesa.
- Repetição de textura é realizada pelo componente, independente dos nós de móveis.

## 4. Trocar a escala de jogo
- Testar `world_zoom` na cena `Game`; padrão 1.30.
- Não multiplicar posições/colliders por 1.30. Não ampliar HUD.
- Conferir câmera contra limites do ambiente, inclusive proporções Windows mais largas.

## 5. Futuras mecânicas
Novo tipo de interação exige uma ação **explicitamente definida e testada** no roteador, em vez de permitir execução de código em arquivos de mapa. Sistemas mais complexos terão serviços quando suas regras forem definidas, mantendo nomes/contratos estáveis.

## 6. Validação
- Abrir projeto na Godot 4.7.2.
- `godot --headless --path . --import`
- `godot --headless --path . --script res://tests/smoke.gd`
- Inspecionar manualmente no Windows quarto → corredor → jardim → volta.
- Verificar escala, colisões, seleção de interação e renderização.
- Não alegar que o resultado está testado sem executar esses passos.
