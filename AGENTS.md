# Instruções para qualquer agente que alterar este jogo

## Decisões imutáveis até orientação do diretor criativo
- **Protagonista já aprovada:** preservar sprites e animações em `assets/characters/princess` e `scripts/player.gd`.
- Godot 4.7.2 e GDScript; **Windows primeiro**, Android ao final.
- Protagonista princesa imperial; **lore/roteiro/romances canônicos ainda NÃO definidos**.
- Primeiro cenário: quarto → corredor → jardim, incluindo caminho inverso.
- O criador não programa; as implementações do repositório ficam sob responsabilidade do assistente/agentes autorizados. Não exigir edição manual de código pelo usuário.
- Não assumir que texturas ou móveis provisórios são arte definitiva.

## Regras obrigatórias de arquitetura
1. Ler `README.md`, `docs/ARCHITECTURE.md`, `docs/HOW_TO_EXTEND.md`, `docs/DECISIONS.md`.
2. Não colocar lógica de mapas, móveis, interações e desenho num mesmo script.
3. Cada ambiente é uma `.tscn` contendo `Visual`, `WorldSpace/Furniture`, `Interactions`, `Spawns`.
4. Novos ambientes: adicionar entrada no `data/room_catalog.json`; **não** escrever novos if/else no `game.gd`.
5. Novos móveis: criar nós `StaticBody2D` com `furniture.gd`; arte e colisão configuradas separadamente.
6. Novas interações: nós `Marker2D` usando `interaction_point.gd`, sem scripts por porta.
7. A câmera aplica zoom visual uniforme (padrão 1.30), sem redimensionar o mundo físico; HUD não segue o zoom.
8. Mantenha a princesa e móveis sob `WorldSpace` com Y-sort ativo.
9. Sem dependências externas, serviços ou autoloads vazios, assets não licenciados, scripts monolíticos e efeitos narrativos arbitrários.
10. IDs de mapa e spawn estáveis; documentar migração se forem alterados quando existir save.
11. Colisões seguem footprint, não tamanho completo da ilustração.
12. A cada alteração, executar importação, smoke e inspeção visual no Windows. Dizer quais testes **não** foram executados.
13. Não começar sistema de NPCs, economia, cartas, roupas, diálogos completos, romantização ou Android sem escopo explícito.

## Trabalho atual
O [PR #4](https://github.com/nestarasup-sys/jogo-novo/pull/4) integrou a arquitetura modular à `main`. O PR anterior das texturas (#3) foi fechado sem merge. **Não restaure `prototype_map.gd` nem reconstrua objetos em funções monolíticas.**

## Como entregar
Informe arquivos mudados, motivos, testes executados e falhas, regressões, limitações e recomendação de merge. Um teste headless não equivale a jogabilidade inspecionada na janela Windows.
