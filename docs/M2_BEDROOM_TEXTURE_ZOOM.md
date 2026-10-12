# M2 visual mínimo — chão e parede do quarto + câmera 1.30×

**Estado:** código de renderização e zoom enviado ao GitHub. **Arquivos JPG binários e testes na Godot Windows ainda pendentes de integração pelo Codex.**

## Decisão de escopo
- Apenas **quarto** recebe chão/parede novos, a partir das imagens enviadas pelo criador.
- Não cortar nem posicionar móveis da sheet ainda.
- Não reimplementar movimento, animação, colisões, portas ou HUD.
- Corredor e jardim continuam com seus fundos de protótipo.
- Somente Windows; Android deixado para a etapa final.

## Zoom inteligente de 30%
`scripts/game.gd` cria um `Camera2D` como filho do personagem e define `zoom = Vector2(1.30, 1.30)`, com limites do mapa em 0..1280 (X) e 0..720 (Y). A câmera acompanha o jogador; isso amplia igualmente **protagonista, móveis, paredes e chão**, sem alterar movimentação, colisões, hitboxes, posições ou distâncias de interação. A HUD usa CanvasLayer e não acompanha o zoom. Trade-off: mostra cerca de 23% menos mundo em cada dimensão; por isso a câmera segue a princesa. Ajuste somente depois de testar visualmente.

## Assets preparados FORA do repositório nesta fase
O pacote `bedroom_textures_codex.zip`, fornecido junto do pedido ao Codex, inclui:
- `assets/environments/bedroom/floor_wood.jpg` (640 × 640): versão otimizada do chão fornecido pelo criador.
- `assets/environments/bedroom/wallpaper.jpg` (640 × 220): faixa superior recortada e otimizada da parede fornecida pelo criador.

**ATENÇÃO:** o Codex deve importar esses dois arquivos binários no Git. Eles ainda não foram publicados pelo assistente: conectores de conteúdo do GitHub não oferecem envio direto dos arquivos binários deste chat. `scripts/prototype_map.gd` verifica sua presença por `ResourceLoader.exists` e usa cores provisórias com aviso até a inclusão, para não quebrar o protótipo.

## Comportamento do renderizador
- A parede ocupa `y = 0..260` e o piso `y = 260..720` no quarto 1280 × 720.
- `draw_texture_rect(..., true)` repete as texturas com `texture_repeat` habilitado.
- Desenha um friso simples separando chão/parede.
- Desenha os antigos placeholders e suas colisões por cima; **a etapa atual não troca móveis**.

## Trabalho do Codex
1. Atualizar a branch desse PR e incluir os dois JPG do ZIP nos caminhos acima.
2. Abrir a Godot 4.7.2 Windows, importar os assets e corrigir parser/renderer se necessário.
3. Executar `tests/smoke.gd` (a verificação do zoom foi acrescentada).
4. Abrir a janela gráfica (não só headless), caminhar quarto→corredor→jardim→volta e inspecionar recorte do zoom, clipping, limites da câmera, legibilidade da parede e possíveis emendas dos JPGs.
5. Ajustar apenas parâmetros de zoom/faixa da parede e import settings se houver problemas comprovados; manter o zoom de 1.30 como meta inicial.
6. Registrar prints **reais da janela do jogo** e relatório: FPS, janela/resolução, Godot, resultados, limites e recomendações.
7. **Não iniciar recorte da sheet de móveis**, decoração adicional, NPCs, romance ou conteúdo novo.
8. Ao acabar, atualizar este PR. **Não mesclar sem revisão.**

## Critérios de aceite
- Quarto usa as duas texturas reais, sem imagens faltando/avisos.
- Móveis temporários e suas colisões permanecem exatamente funcionais.
- A princesa ampliada acompanha câmera sem atravessar portas/parede.
- HUD e mensagens não ficam 30% maiores.
- Corredor/jardim continuam funcionais e nenhum sprite/anim da princesa é alterado.
- Smoke passa; janela do jogo verificada com textura presente.
