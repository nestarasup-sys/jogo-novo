# Editar móveis do quarto na Godot

Abra `scenes/rooms/bedroom.tscn` e expanda `WorldSpace/Furniture` na árvore da cena.

- Selecione o móvel (por exemplo, `Bed`) na árvore e arraste no viewport para mover arte e colisão juntas.
- Selecione o filho `Visual` e arraste para reposicionar somente o desenho. Com esse nó selecionado, o Inspector também mostra `art_texture`, `art_size` e `art_offset`; esses campos editam a arte do móvel pai.
- Para adicionar uma imagem, arraste o PNG da aba `FileSystem` para `art_texture` no Inspector, ou clique no campo e escolha o recurso. A textura aparecerá no viewport do editor.
- Selecione `Footprint` para ajustar a colisão separadamente; `footprint_size` no móvel redimensiona essa forma.
- No nó do móvel, use `footprint_size` para ajustar a colisão e `display_name`/`placeholder_color` para o placeholder, quando ainda não houver imagem.

Decorações também têm `Footprint`, mas vêm com `is_solid = false`, então não bloqueiam a protagonista.

## Sheet de móveis do quarto

O sheet original está em `assets/furniture/bedroom_furniture_sheet.png`; cada móvel foi recortado para um PNG independente com fundo transparente em `assets/furniture/`. A cena já atribui essas imagens à cama, penteadeira, guarda-roupa, escrivaninha, estante, poltrona e baú. Os placeholders visuais de tapete, porta decorativa, mesa lateral, espelho, vaso e quadro ficam ocultos enquanto não houver arte correspondente; os nós continuam na árvore e podem ser reativados no Inspector.

Para trocar ou reposicionar uma arte, selecione `WorldSpace/Furniture/<Móvel>/Visual`. O Inspector mantém `art_texture`, `art_size` e `art_offset` disponíveis nesse nó.
