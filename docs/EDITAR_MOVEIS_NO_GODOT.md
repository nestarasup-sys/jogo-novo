# Editar móveis do quarto na Godot

Abra `scenes/rooms/bedroom.tscn` e expanda `WorldSpace/Furniture` na árvore da cena.

- Selecione o móvel (por exemplo, `Bed`) na árvore e arraste no viewport para mover arte e colisão juntas.
- Selecione o filho `Visual` e arraste para reposicionar somente o desenho.
- Selecione `Footprint` para ajustar a colisão separadamente; `footprint_size` no móvel redimensiona essa forma.
- No nó do móvel, use `art_texture`, `art_size` e `art_offset` no Inspector para trocar e alinhar a imagem.

Decorações também têm `Footprint`, mas vêm com `is_solid = false`, então não bloqueiam a protagonista.
