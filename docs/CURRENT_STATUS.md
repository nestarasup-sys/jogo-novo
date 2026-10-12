# Estado consolidado — 12/10/2026

Este é o ponto de entrada para qualquer assistente ou Codex. Em caso de conflito, priorize as decisões mais recentes registradas aqui e em `docs/DECISIONS.md`, sem assumir que propostas viraram tarefas aprovadas.

## Situação verificada no GitHub
- Branch principal: `main`.
- O PR [#1](https://github.com/nestarasup-sys/jogo-novo/pull/1) **foi mesclado em 12/10/2026**, commit `5f6d5dfc8f0bc6a38ca1b439370d5481ba2a7ea9`.
- A árvore da `main` contém o protótipo Godot: `scenes/maps/bedroom.tscn`, `corridor.tscn`, `garden.tscn`, scripts de movimentação, HUD, interação e `tests/smoke.gd`.
- Conforme o relatório do PR, importação, inicialização e smoke tests passaram no Godot 4.7.2. O criador confirmou que o protótipo funciona no Windows. Esta atualização documental não executou testes novamente.
- Não existe demo de romance, capítulo ou rotina de NPCs. Não afirmar que existe.
- Android é objetivo posterior; **prioridade de desenvolvimento atual é Windows**.

## Escopo aprovado atualmente
Manter e melhorar o protótipo **quarto da princesa → mini corredor → jardim**, com controles, colisões, portas e interação. O quarto é posicionado perto da entrada do palácio **somente por conveniência do protótipo**. A porta inferior do corredor sai para o jardim, e a superior leva de volta ao quarto.

Não iniciar NPCs, calendário, diálogo complexo, romance, capítulos ou história por iniciativa própria. Propor a próxima tarefa e obter escopo do criador.

## Visão de longo prazo — não é autorização de implementação
Jogo 2D top-down de fantasia imperial, protagonista princesa imperial, exploração livre com tempo em dias e capítulos desbloqueados por condições; relacionamentos profundos, conflitos e possíveis finais alternativos. Windows primeiro; Android horizontal ao fim do desenvolvimento. História, elenco, lore, romances concretos e arte final ainda não foram definidos.

## Índice
- [Decisões e separação entre aprovado/proposto/adiado](DECISIONS.md)
- [Design geral](GAME_DESIGN.md)
- [Mecânicas](GAMEPLAY_SYSTEMS.md)
- [Estrutura provisória do palácio](PALACE_WORLD.md)
- [Arquitetura futura](ARCHITECTURE.md)
- [Conteúdo narrativo futuro](CONTENT_SCHEMA.md)
- [Proposta do vertical slice narrativo](PROTOTYPE_01.md)
- [Marco de protótipo já jogável](M1_PLAYABLE.md)
- [Roadmap](ROADMAP.md)
- [Banco de ideias não aprovadas](IDEAS_BACKLOG.md)
- [Plano de testes](TEST_PLAN.md)

## Regras para colaboração
O criador define direção criativa e prioridades. ChatGPT ajuda a planejar e revisar. Codex implementa, testa e relata limitações. Distinguir sempre decisões aprovadas, propostas e exemplos; não transformar ideias em lore canônica. Não apagar código funcional só para reorganizar pastas.
