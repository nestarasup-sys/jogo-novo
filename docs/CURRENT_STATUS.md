# Situação atual — revisão da arquitetura

## Confirmado
- PR #1 (movimento) e PR #2 (animações oficiais da princesa) estão mesclados na branch `main`.
- A protagonista atual é aprovada para testes; seus sprites e lógica **não podem ser trocados involuntariamente**.
- O criador testou o protótipo original no Windows e relatou que funciona.
- Android foi adiado para a fase final.

## Em andamento
- O PR #3 (texturas e câmera sobre o construtor monolítico) **foi fechado sem merge**. Seus materiais continuam no histórico do Git; suas escolhas estéticas não são obrigatórias.
- Branch `refactor/modular-world-foundation` refatora os três ambientes para cenas independentes, cômodos componíveis, zoom unificado e componentes reusáveis.
- **Verificação automática aprovada:** [Godot Windows 4.7.2 / Actions](https://github.com/nestarasup-sys/jogo-novo/actions/runs/38216409346). A importação e os testes smoke da nova arquitetura passaram, incluindo movimento real, diagonais, colisões, links de salas e sprite da protagonista. **Ainda falta inspeção visual e controles manuais no Windows do criador.**

## Escopo de agora
Somente melhorar fundação para criar qualquer área/objeto sem retrabalho. Manter quarto, corredor, jardim, colisões, portas, interações e protagonista. Nenhum novo conteúdo narrativo, NPC, tempo, save ou plataforma.

## Próxima verificação
Executar smoke, importar no Godot, inspecionar janela e corrigir erros/ajustes em branch. Registrar resultado antes de merge. Futuras implementações seguem `docs/HOW_TO_EXTEND.md`.
